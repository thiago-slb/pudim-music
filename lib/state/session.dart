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

final _secure = TokenStore();

class SessionNotifier extends AsyncNotifier<Session?> {
  SharedPreferences get _prefs => ref.read(prefsProvider);

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
    final token = await _secure.read();
    final userId = _prefs.getString('userId');
    final userName = _prefs.getString('userName');
    if (token == null || userId == null) return null;
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
    return Session(api, userName ?? '');
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
    await _secure.write(r.token);
    await _prefs.setString('userId', r.userId);
    await _prefs.setString('userName', r.userName);
    await _prefs.setString('lanUrl', u.lan);
    await _prefs.setString('wanUrl', u.wan);
    api.reportCapabilities();
    state = AsyncData(Session(api, r.userName));
  }

  /// Depois de trocar o nome de usuário no Jellyfin (a sessão continua a mesma).
  Future<void> renamed(String name) async {
    final s = state.value;
    if (s == null) return;
    await _prefs.setString('userName', name);
    state = AsyncData(Session(s.api, name));
  }

  Future<void> logout() async {
    final s = state.value;
    await s?.api.logout();
    await _secure.delete();
    await _prefs.remove('userId');
    await _prefs.remove('userName');
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
