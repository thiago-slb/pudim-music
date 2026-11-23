import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../audio/player.dart';
import 'session.dart';

/// Mantém o widget da tela inicial do Android igual ao player (música, artista, tocando e capa).
final androidWidgetProvider = Provider<void>((ref) {
  if (!Platform.isAndroid) return;
  const channel = MethodChannel('pudim/widget');
  String? lastKey;
  String? coverFor;
  String? coverPath;
  final dio = Dio(
    BaseOptions(
      responseType: ResponseType.bytes,
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  Future<String?> cover(String? imageId) async {
    if (imageId == null) return null;
    if (coverFor == imageId) return coverPath;
    final url = ref.read(apiProvider).imageUrl(imageId, size: 300);
    if (url == null) return null;
    try {
      final r = await dio.get<List<int>>(url);
      final dir = await getApplicationSupportDirectory();
      final f = File('${dir.path}/widget_cover.jpg');
      await f.writeAsBytes(r.data!, flush: true);
      coverFor = imageId;
      coverPath = f.path;
      return f.path;
    } catch (_) {
      return null;
    }
  }

  Future<void> push(QueueState q) async {
    final c = q.current;
    final key = '${c?.id}|${q.playing}';
    if (key == lastKey) return;
    lastKey = key;
    try {
      await channel.invokeMethod('update', {
        'title': c?.name ?? '',
        'artist': c?.artistLine ?? '',
        'playing': q.playing,
        'cover': await cover(c?.imageItemId),
      });
    } catch (_) {}
  }

  ref.listen<QueueState>(
    playerProvider,
    (_, q) => unawaited(push(q)),
    fireImmediately: true,
  );
});
