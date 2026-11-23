import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Guarda no aparelho as respostas GET do servidor: sem internet o app mostra a última versão
/// de tudo o que já abriu (biblioteca, playlists, álbuns, início, artistas, letras).
/// Com internet sempre busca de novo e atualiza a cópia.
class ResponseCache {
  ResponseCache(this.dir);

  /// Cache usado pelo app (criado no main; nulo nos testes).
  static ResponseCache? instance;

  final Directory dir;

  /// Sem conexão com o servidor agora (a interface mostra o aviso "Sem internet").
  final offline = ValueNotifier<bool>(false);
  DateTime _retryAt = DateTime.fromMillisecondsSinceEpoch(0);
  Timer? _probeTimer;

  /// Testa se o servidor voltou (definido pela sessão).
  Future<bool> Function()? probe;

  static Future<ResponseCache> open(String basePath) async {
    final d = Directory('$basePath${Platform.pathSeparator}apicache');
    await d.create(recursive: true);
    return ResponseCache(d);
  }

  /// Marca sem rede: por 30 s as respostas vêm direto do aparelho, sem esperar o servidor.
  void markOffline() {
    offline.value = true;
    _retryAt = DateTime.now().add(const Duration(seconds: 30));
    _probeTimer ??= Timer.periodic(const Duration(seconds: 20), (_) async {
      final p = probe;
      if (p != null && await p()) markOnline();
    });
  }

  void markOnline() {
    offline.value = false;
    _retryAt = DateTime.fromMillisecondsSinceEpoch(0);
    _probeTimer?.cancel();
    _probeTimer = null;
  }

  bool get _skipNetwork => DateTime.now().isBefore(_retryAt);

  /// Chave estável: caminho + parâmetros em ordem (FNV-1a 64 bits em hex).
  static String keyOf(String path, Map<String, dynamic> query) {
    final keys = query.keys.toList()..sort();
    final s = '$path?${[for (final k in keys) '$k=${query[k]}'].join('&')}';
    var h = 0xcbf29ce484222325;
    for (final b in utf8.encode(s)) {
      h ^= b;
      h = (h * 0x100000001b3) & 0xFFFFFFFFFFFFFFFF;
    }
    return h.toUnsigned(64).toRadixString(16).padLeft(16, '0');
  }

  File _file(String key) =>
      File('${dir.path}${Platform.pathSeparator}$key.json');

  Future<void> put(String key, Object? data) async {
    try {
      final f = _file(key);
      final tmp = File('${f.path}.tmp');
      await tmp.writeAsString(jsonEncode(data));
      await tmp.rename(f.path);
    } catch (_) {}
  }

  Future<Object?> get(String key) async {
    try {
      final f = _file(key);
      if (!await f.exists()) return null;
      return jsonDecode(await f.readAsString());
    } catch (_) {
      return null;
    }
  }

  /// Quando a cópia foi atualizada pela última vez (nulo se não existe).
  Future<DateTime?> savedAt(String key) async {
    try {
      final f = _file(key);
      return await f.exists() ? await f.lastModified() : null;
    } catch (_) {
      return null;
    }
  }

  static bool _isNetworkError(DioException e) => switch (e.type) {
    DioExceptionType.connectionError ||
    DioExceptionType.connectionTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.sendTimeout => true,
    DioExceptionType.unknown => e.error is SocketException,
    _ => false,
  };

  /// Interceptor para o Dio do Jellyfin.
  Interceptor interceptor() => InterceptorsWrapper(
    onRequest: (o, h) async {
      if (o.method == 'GET' && _skipNetwork) {
        final hit = await get(keyOf(o.path, o.queryParameters));
        if (hit != null) {
          return h.resolve(
            Response(requestOptions: o, data: hit, statusCode: 200),
          );
        }
      }
      h.next(o);
    },
    onResponse: (r, h) {
      final o = r.requestOptions;
      if (offline.value) markOnline();
      if (o.method == 'GET' && r.statusCode == 200 && r.data is! String) {
        unawaited(put(keyOf(o.path, o.queryParameters), r.data));
      }
      h.next(r);
    },
    onError: (e, h) async {
      final o = e.requestOptions;
      if (_isNetworkError(e)) {
        markOffline();
        if (o.method == 'GET') {
          final hit = await get(keyOf(o.path, o.queryParameters));
          if (hit != null) {
            return h.resolve(
              Response(requestOptions: o, data: hit, statusCode: 200),
            );
          }
        }
      }
      h.next(e);
    },
  );
}
