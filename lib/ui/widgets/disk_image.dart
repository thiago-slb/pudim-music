import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Imagem da rede guardada no aparelho: abre na hora (e sem internet) com a cópia local
/// e atualiza em segundo plano quando a cópia tem mais de 7 dias.
class DiskImage extends ImageProvider<DiskImage> {
  final String url;
  const DiskImage(this.url);

  static Directory? _dir;
  static final _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 30),
      responseType: ResponseType.bytes,
    ),
  );
  static final _inFlight = <String, Future<Uint8List>>{};

  /// Chamado no main: pasta das capas e limpeza se passar de 400 MB.
  static Future<void> init(String basePath) async {
    final d = Directory('$basePath${Platform.pathSeparator}imgcache');
    await d.create(recursive: true);
    _dir = d;
    unawaited(_trim(400 * 1024 * 1024));
  }

  static Future<void> _trim(int maxBytes) async {
    try {
      final files = <File, FileStat>{};
      await for (final f in _dir!.list()) {
        if (f is File) files[f] = await f.stat();
      }
      var total = files.values.fold<int>(0, (a, s) => a + s.size);
      if (total <= maxBytes) return;
      final old = files.entries.toList()
        ..sort((a, b) => a.value.modified.compareTo(b.value.modified));
      for (final e in old) {
        if (total <= maxBytes * 0.8) break;
        total -= e.value.size;
        await e.key.delete();
      }
    } catch (_) {}
  }

  /// A chave ignora o endereço do servidor: a mesma capa vale em casa e fora.
  static File? _file(String url) {
    final u = Uri.tryParse(url);
    return _named(u == null || !u.hasAuthority ? url : '${u.path}?${u.query}');
  }

  static File? _named(String key) {
    if (_dir == null) return null;
    var h = 0xcbf29ce484222325;
    for (final b in utf8.encode(key)) {
      h ^= b;
      h = (h * 0x100000001b3) & 0xFFFFFFFFFFFFFFFF;
    }
    final name = h.toUnsigned(64).toRadixString(16).padLeft(16, '0');
    return File('${_dir!.path}${Platform.pathSeparator}$name.img');
  }

  /// Arquivo da capa; aproveita o que foi guardado com a chave antiga (URL inteira).
  static Future<File?> _local(String url) async {
    final f = _file(url);
    if (f == null || await f.exists()) return f;
    final old = _named(url);
    if (old != null && old.path != f.path && await old.exists()) {
      try {
        await old.rename(f.path);
      } catch (_) {}
    }
    return f;
  }

  /// Bytes da imagem: do aparelho se tiver, senão baixa e guarda.
  static Future<Uint8List> fetch(String url) async {
    final f = await _local(url);
    if (f != null && await f.exists()) {
      final bytes = await f.readAsBytes();
      final age = DateTime.now().difference(await f.lastModified());
      if (age > const Duration(days: 7)) {
        unawaited(_download(url).catchError((_) => Uint8List(0)));
      }
      if (bytes.isNotEmpty) return bytes;
    }
    return _download(url);
  }

  /// Baixa e guarda (sem mostrar), para ter a capa sem internet depois.
  static Future<void> prefetch(String url) async {
    final f = await _local(url);
    if (f == null || await f.exists()) return;
    try {
      await _download(url);
    } catch (_) {}
  }

  static Future<Uint8List> _download(String url) =>
      _inFlight.putIfAbsent(url, () async {
        try {
          final r = await _dio.get<List<int>>(url);
          final bytes = Uint8List.fromList(r.data ?? const []);
          if (bytes.isEmpty) throw StateError('imagem vazia');
          final f = _file(url);
          if (f != null) {
            final tmp = File('${f.path}.tmp');
            await tmp.writeAsBytes(bytes);
            await tmp.rename(f.path);
          }
          return bytes;
        } finally {
          unawaited(Future(() => _inFlight.remove(url)));
        }
      });

  @override
  Future<DiskImage> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture(this);

  @override
  ImageStreamCompleter loadImage(DiskImage key, ImageDecoderCallback decode) =>
      MultiFrameImageStreamCompleter(
        codec: _load(decode),
        scale: 1.0,
        debugLabel: url,
      );

  Future<ui.Codec> _load(ImageDecoderCallback decode) async {
    final bytes = await fetch(url);
    return decode(await ui.ImmutableBuffer.fromUint8List(bytes));
  }

  @override
  bool operator ==(Object other) => other is DiskImage && other.url == url;

  @override
  int get hashCode => url.hashCode;
}
