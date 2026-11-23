import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Stores the server's GET responses on the device: without internet the app shows the last version
/// of everything it has already opened (library, playlists, albums, home, artists, lyrics).
/// With internet it always fetches again and updates the copy.
class ResponseCache {
  ResponseCache(this.dir);

  /// Cache used by the app (created in main; null in tests).
  static ResponseCache? instance;

  final Directory dir;

  /// No connection to the server right now (the UI shows the "No internet" notice).
  final offline = ValueNotifier<bool>(false);
  DateTime _retryAt = DateTime.fromMillisecondsSinceEpoch(0);
  Timer? _probeTimer;

  /// Checks whether the server is back (set by the session).
  Future<bool> Function()? probe;

  static Future<ResponseCache> open(String basePath) async {
    final d = Directory('$basePath${Platform.pathSeparator}apicache');
    await d.create(recursive: true);
    return ResponseCache(d);
  }

  /// Marks as offline: for 30 s responses come straight from the device, without waiting for the server.
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

  /// Stable key: path + parameters in order (64-bit FNV-1a, hex).
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

  /// When the copy was last updated (null if it does not exist).
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

  /// Interceptor for the Jellyfin Dio.
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
