import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dominant color of a cover, for the header gradients and the lyrics background.
/// Downloads a thumbnail, shrinks it to 24 px and picks the most "vivid" color.
final coverColorProvider = FutureProvider.family<Color, String>((
  ref,
  url,
) async {
  ref.keepAlive();
  try {
    final r = await Dio().get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    final codec = await ui.instantiateImageCodec(
      Uint8List.fromList(r.data!),
      targetWidth: 24,
      targetHeight: 24,
    );
    final frame = await codec.getNextFrame();
    final data = await frame.image.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );
    if (data == null) return fallbackColor;
    return _pick(data);
  } catch (_) {
    return fallbackColor;
  }
});

const fallbackColor = Color(0xFF535353);

Color _pick(ByteData data) {
  // Groups into hue buckets and adds a weight that favors saturation and medium brightness.
  final buckets = <int, List<double>>{};
  for (var i = 0; i + 3 < data.lengthInBytes; i += 4) {
    final c = Color.fromARGB(
      255,
      data.getUint8(i),
      data.getUint8(i + 1),
      data.getUint8(i + 2),
    );
    final hsv = HSVColor.fromColor(c);
    final weight = hsv.saturation * (1 - (hsv.value - 0.6).abs());
    final key = (hsv.hue / 20).floor();
    final b = buckets.putIfAbsent(key, () => [0, 0, 0, 0, 0]);
    b[0] += weight;
    b[1] += hsv.hue * weight;
    b[2] += hsv.saturation * weight;
    b[3] += hsv.value * weight;
    b[4] += 1;
  }
  if (buckets.isEmpty) return fallbackColor;
  final best = buckets.values.reduce((a, b) => a[0] >= b[0] ? a : b);
  if (best[0] < 0.5) {
    // Almost gray cover: uses a dark gray.
    return fallbackColor;
  }
  final hue = best[1] / best[0];
  final sat = (best[2] / best[0]).clamp(0.35, 0.8);
  // Darkens so the white text stays readable, as Spotify does.
  return HSVColor.fromAHSV(1, hue, sat, 0.55).toColor();
}

Color darken(Color c, double amount) {
  final hsl = HSLColor.fromColor(c);
  return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
}
