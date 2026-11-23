import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../api/catalog.dart';
import '../config.dart';
import '../api/jellyfin.dart';
import 'token_store.dart';
import '../api/response_cache.dart';
import '../l10n/l10n.dart';

class Session {
  final Jellyfin api;
  final String userName;
  const Session(this.api, this.userName);
  String get userId => api.userId!;
}

/// [wan] is the main address (any network); [lan] is optional (local network, tried first).
class ServerUrls {
  final String lan;
  final String wan;
  const ServerUrls(this.lan, this.wan);
}

/// Account saved on the device: a user on a Jellyfin server. The token stays in the account [TokenStore]
/// (encrypted); here only what shows up in the list.
class Account {
  final String userId;
  final String userName;
  final String lan;
  final String wan;
  final String extras;
  const Account({
    required this.userId,
    required this.userName,
    required this.lan,
    required this.wan,
    this.extras = '',
  });

  String get id => userId;

  /// Address to show in the list ("music.example.com").
  String get host {
    final u = Uri.tryParse(wan.isNotEmpty ? wan : lan);
    return u == null || u.host.isEmpty ? (wan.isNotEmpty ? wan : lan) : u.host;
  }

  ServerUrls get urls => ServerUrls(lan, wan);

  Map<String, dynamic> toJson() => {
    'u': userId,
    'n': userName,
    'l': lan,
    'w': wan,
    if (extras.isNotEmpty) 'x': extras,
  };

  factory Account.fromJson(Map<String, dynamic> j) => Account(
    userId: j['u'] as String,
    userName: j['n'] as String? ?? '',
    lan: j['l'] as String? ?? '',
    wan: j['w'] as String? ?? '',
    extras: j['x'] as String? ?? '',
  );

  Account copyWith({String? userName}) => Account(
    userId: userId,
    userName: userName ?? this.userName,
    lan: lan,
    wan: wan,
    extras: extras,
  );
}

/// Completes the typed address: no scheme becomes https (or http on the local network), no trailing slash.
String normalizeUrl(String raw, {bool local = false}) {
  var s = raw.trim();
  if (s.isEmpty) return '';
  if (!s.contains('://')) s = '${local ? 'http' : 'https'}://$s';
  while (s.endsWith('/')) {
    s = s.substring(0, s.length - 1);
  }
  return s;
}

final prefsProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('prefsProvider is overridden in main'),
);

class SessionNotifier extends AsyncNotifier<Session?> {
  SharedPreferences get _prefs => ref.read(prefsProvider);

  static const _accountsKey = 'accounts';
  static const _activeKey = 'account';

  /// Account to return to if the person gives up adding another.
  String? _returnTo;

  /// Accounts saved on this device (the first is the oldest).
  List<Account> get accounts {
    final raw = _prefs.getString(_accountsKey);
    if (raw == null) return const [];
    try {
      return [
        for (final j in jsonDecode(raw) as List)
          Account.fromJson(j as Map<String, dynamic>),
      ];
    } catch (_) {
      return const [];
    }
  }

  String? get activeId => _prefs.getString(_activeKey);

  /// On the sign-in screen only to add another account (can go back).
  bool get adding => _returnTo != null;

  Future<void> _saveAccounts(List<Account> list) => _prefs.setString(
    _accountsKey,
    jsonEncode([for (final a in list) a.toJson()]),
  );

  /// The old keys (single account) remain valid for the account in use.
  Future<void> _mirror(Account a) async {
    await _prefs.setString(_activeKey, a.id);
    await _prefs.setString('userId', a.userId);
    await _prefs.setString('userName', a.userName);
    await _prefs.setString('lanUrl', a.lan);
    await _prefs.setString('wanUrl', a.wan);
    if (_prefs.getString('extrasUrl') != a.extras) {
      await _prefs.setString('extrasUrl', a.extras);
      ref.invalidate(extrasUrlProvider);
    }
  }

  /// Old versions stored a single account: it becomes the first in the list.
  Future<void> _migrate() async {
    if (_prefs.getString(_accountsKey) != null) return;
    final userId = _prefs.getString('userId');
    final token = await const TokenStore().read();
    if (userId == null || token == null) return;
    final a = Account(
      userId: userId,
      userName: _prefs.getString('userName') ?? '',
      lan: _prefs.getString('lanUrl') ?? defaultLanUrl,
      wan: _prefs.getString('wanUrl') ?? defaultServerUrl,
      extras: _prefs.getString('extrasUrl') ?? defaultExtrasUrl,
    );
    await TokenStore(a.id).write(token);
    await _saveAccounts([a]);
    await _prefs.setString(_activeKey, a.id);
    await const TokenStore().delete();
  }

  String get deviceId {
    var id = _prefs.getString('deviceId');
    if (id == null) {
      final r = Random.secure();
      id = List.generate(
        16,
        (_) => r.nextInt(256).toRadixString(16).padLeft(2, '0'),
      ).join();
      _prefs.setString('deviceId', id);
    }
    return id;
  }

  String get deviceName =>
      Platform.isAndroid ? 'Pudim Android' : 'Pudim ${Platform.localHostname}';

  ServerUrls get urls => ServerUrls(
    _prefs.getString('lanUrl') ?? defaultLanUrl,
    _prefs.getString('wanUrl') ?? defaultServerUrl,
  );

  /// LAN if it answers, otherwise the outside address.
  Future<String?> pickServer(ServerUrls u) async {
    final results = await Future.wait([
      u.lan.isEmpty ? Future.value(false) : Jellyfin.reachable(u.lan),
      u.wan.isEmpty
          ? Future.value(false)
          : Jellyfin.reachable(u.wan, timeout: const Duration(seconds: 10)),
    ]);
    if (results[0]) return u.lan;
    if (results[1]) return u.wan;
    return null;
  }

  @override
  Future<Session?> build() async {
    await _migrate();
    final all = accounts;
    final active =
        all.where((a) => a.id == activeId).firstOrNull ?? all.firstOrNull;
    if (active == null) return null;
    final token = await TokenStore(active.id).read();
    if (token == null) return null;
    await _mirror(active);
    final userId = active.userId;
    final userName = active.userName;
    final picked = await pickServer(urls);
    // No answer from either: the outside one works on any network once the internet is back.
    final base = picked ?? (urls.wan.isNotEmpty ? urls.wan : urls.lan);
    final cache = ResponseCache.instance;
    final api = Jellyfin(
      baseUrl: base,
      deviceId: deviceId,
      deviceName: deviceName,
      token: token,
      userId: userId,
      cache: cache,
    );
    if (cache != null) {
      // Search both addresses again: leaving the home Wi-Fi must not trap the app
      // on the local network address (it used to show "No internet" while 4G was working).
      cache.probe = () async {
        final p = await pickServer(urls);
        if (p == null) return false;
        if (p != api.baseUrl) api.switchTo(p);
        return true;
      };
      // No internet: open with what is stored.
      if (picked == null) cache.markOffline();
    }
    api.reportCapabilities();
    return Session(api, userName);
  }

  Future<Jellyfin> _connect(ServerUrls u) async {
    final base = await pickServer(u);
    if (base == null) {
      throw JellyfinException(
        u.lan.isEmpty
            ? appL10n.stateServerNoReply
            : appL10n.stateServerNoReplyBoth,
      );
    }
    return Jellyfin(
      baseUrl: base,
      deviceId: deviceId,
      deviceName: deviceName,
      cache: ResponseCache.instance,
    );
  }

  Future<void> login(ServerUrls u, String user, String password) async {
    final api = await _connect(u);
    await _finish(u, api, await api.login(user, password));
  }

  /// Quick Connect, step 1: finds the server and requests a code (shown on screen).
  Future<(Jellyfin, String, String)> quickConnectStart(ServerUrls u) async {
    final api = await _connect(u);
    if (!await api.quickConnectEnabled()) {
      throw JellyfinException(appL10n.apiQuickConnectOff);
    }
    final (secret, code) = await api.quickConnectStart();
    return (api, secret, code);
  }

  /// Quick Connect, step 2: true when the code was approved and the account signed in.
  Future<bool> quickConnectPoll(
    ServerUrls u,
    Jellyfin api,
    String secret,
  ) async {
    if (!await api.quickConnectApproved(secret)) return false;
    await _finish(u, api, await api.loginQuickConnect(secret));
    return true;
  }

  Future<void> _finish(ServerUrls u, Jellyfin api, AuthResult r) async {
    final a = Account(
      userId: r.userId,
      userName: r.userName,
      lan: u.lan,
      wan: u.wan,
      extras: _prefs.getString('extrasUrl') ?? defaultExtrasUrl,
    );
    await TokenStore(a.id).write(r.token);
    await _saveAccounts([
      for (final x in accounts)
        if (x.id != a.id) x,
      a,
    ]);
    await _mirror(a);
    _returnTo = null;
    api.reportCapabilities();
    state = AsyncData(Session(api, r.userName));
  }

  /// After changing the username in Jellyfin (the session stays the same).
  Future<void> renamed(String name) async {
    final s = state.value;
    if (s == null) return;
    await _prefs.setString('userName', name);
    await _saveAccounts([
      for (final a in accounts)
        a.id == s.userId ? a.copyWith(userName: name) : a,
    ]);
    state = AsyncData(Session(s.api, name));
  }

  /// Switches to another saved account (another user or another server).
  Future<void> switchTo(String id) async {
    final a = accounts.where((x) => x.id == id).firstOrNull;
    if (a == null || (id == activeId && state.value != null)) return;
    _returnTo = null;
    await _mirror(a);
    ResponseCache.instance?.markOnline();
    state = const AsyncLoading();
    ref.invalidateSelf();
  }

  /// Opens the sign-in screen to add another account, without leaving the current one.
  void beginAdd() {
    if (state.value == null) return;
    _returnTo = activeId;
    state = const AsyncData(null);
  }

  /// Gave up adding: goes back to the previous account.
  Future<void> cancelAdd() async {
    final back = _returnTo;
    _returnTo = null;
    if (back != null) await switchTo(back);
  }

  /// Signs out of the account in use (and forgets the token). If there are others, moves to the next.
  Future<void> logout() async {
    final s = state.value;
    final id = activeId;
    await s?.api.logout();
    if (id != null) await TokenStore(id).delete();
    final rest = [
      for (final a in accounts)
        if (a.id != id) a,
    ];
    await _saveAccounts(rest);
    await _prefs.remove('userId');
    await _prefs.remove('userName');
    await _prefs.remove(_activeKey);
    _returnTo = null;
    if (rest.isNotEmpty) {
      await switchTo(rest.last.id);
      return;
    }
    state = const AsyncData(null);
  }
}

final sessionProvider = AsyncNotifierProvider<SessionNotifier, Session?>(
  SessionNotifier.new,
);

/// Shortcut to the current session client (only used on logged-in screens).
final apiProvider = Provider<Jellyfin>((ref) {
  final s = ref.watch(sessionProvider).value;
  if (s == null) throw StateError('no session');
  return s.api;
});

/// Address of the extras server (empty = no extras).
class ExtrasUrl extends Notifier<String> {
  @override
  String build() =>
      ref.read(prefsProvider).getString('extrasUrl') ?? defaultExtrasUrl;

  Future<void> set(String url) async {
    final u = normalizeUrl(url);
    await ref.read(prefsProvider).setString('extrasUrl', u);
    state = u;
  }
}

final extrasUrlProvider = NotifierProvider<ExtrasUrl, String>(ExtrasUrl.new);

/// Is there an extras server? Without it, the screens and buttons that depend on it stay hidden.
final hasExtrasProvider = Provider<bool>(
  (ref) => ref.watch(extrasUrlProvider).isNotEmpty,
);

/// Client of the extras server, with the same token as Jellyfin.
final catalogProvider = Provider<Catalog>(
  (ref) => Catalog(
    ref.watch(apiProvider).token ?? '',
    baseUrl: ref.watch(extrasUrlProvider),
  ),
);
