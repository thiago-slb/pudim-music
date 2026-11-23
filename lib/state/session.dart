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

/// [wan] é o endereço principal (qualquer rede); [lan] é opcional (rede local, tentado primeiro).
class ServerUrls {
  final String lan;
  final String wan;
  const ServerUrls(this.lan, this.wan);
}

/// Conta salva no aparelho: um usuário num servidor Jellyfin. O token fica no [TokenStore]
/// da conta (cifrado); aqui só o que aparece na lista.
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

  /// Endereço para mostrar na lista ("music.exemplo.com").
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

/// Completa o endereço digitado: sem esquema vira https (ou http na rede local), sem barra no fim.
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
  (ref) => throw UnimplementedError('prefsProvider é sobrescrito no main'),
);

class SessionNotifier extends AsyncNotifier<Session?> {
  SharedPreferences get _prefs => ref.read(prefsProvider);

  static const _accountsKey = 'accounts';
  static const _activeKey = 'account';

  /// Conta para onde voltar se a pessoa desistir de adicionar outra.
  String? _returnTo;

  /// Contas salvas neste aparelho (a primeira é a mais antiga).
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

  /// Está na tela de entrar só para adicionar outra conta (dá para voltar).
  bool get adding => _returnTo != null;

  Future<void> _saveAccounts(List<Account> list) => _prefs.setString(
    _accountsKey,
    jsonEncode([for (final a in list) a.toJson()]),
  );

  /// As chaves antigas (uma conta só) continuam valendo para a conta em uso.
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

  /// Versões antigas guardavam uma conta só: vira a primeira da lista.
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

  /// LAN se responder, senão o endereço de fora.
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
    // Sem resposta de nenhum: o de fora funciona em qualquer rede quando a internet voltar.
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
      // Volta a procurar nos dois endereços: sair do Wi-Fi de casa não pode prender o app
      // no endereço da rede local (era o "Sem internet" com o 4G funcionando).
      cache.probe = () async {
        final p = await pickServer(urls);
        if (p == null) return false;
        if (p != api.baseUrl) api.switchTo(p);
        return true;
      };
      // Sem internet: abre com o que está guardado.
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

  /// Quick Connect, passo 1: acha o servidor e pede um código (mostrado na tela).
  Future<(Jellyfin, String, String)> quickConnectStart(ServerUrls u) async {
    final api = await _connect(u);
    if (!await api.quickConnectEnabled()) {
      throw JellyfinException(appL10n.apiQuickConnectOff);
    }
    final (secret, code) = await api.quickConnectStart();
    return (api, secret, code);
  }

  /// Quick Connect, passo 2: true quando o código foi aprovado e a conta entrou.
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

  /// Depois de trocar o nome de usuário no Jellyfin (a sessão continua a mesma).
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

  /// Troca para outra conta salva (outro usuário ou outro servidor).
  Future<void> switchTo(String id) async {
    final a = accounts.where((x) => x.id == id).firstOrNull;
    if (a == null || (id == activeId && state.value != null)) return;
    _returnTo = null;
    await _mirror(a);
    ResponseCache.instance?.markOnline();
    state = const AsyncLoading();
    ref.invalidateSelf();
  }

  /// Abre a tela de entrar para adicionar outra conta, sem sair da atual.
  void beginAdd() {
    if (state.value == null) return;
    _returnTo = activeId;
    state = const AsyncData(null);
  }

  /// Desistiu de adicionar: volta para a conta de antes.
  Future<void> cancelAdd() async {
    final back = _returnTo;
    _returnTo = null;
    if (back != null) await switchTo(back);
  }

  /// Sai da conta em uso (e esquece o token). Se houver outras, entra na próxima.
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

/// Atalho para o cliente da sessão atual (só usado em telas logadas).
final apiProvider = Provider<Jellyfin>((ref) {
  final s = ref.watch(sessionProvider).value;
  if (s == null) throw StateError('sem sessão');
  return s.api;
});

/// Endereço do servidor de extras (vazio = sem extras).
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

/// Tem servidor de extras? Sem ele, as telas e botões que dependem dele ficam escondidos.
final hasExtrasProvider = Provider<bool>(
  (ref) => ref.watch(extrasUrlProvider).isNotEmpty,
);

/// Cliente do servidor de extras, com o mesmo token do Jellyfin.
final catalogProvider = Provider<Catalog>(
  (ref) => Catalog(
    ref.watch(apiProvider).token ?? '',
    baseUrl: ref.watch(extrasUrlProvider),
  ),
);
