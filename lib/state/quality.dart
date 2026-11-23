import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/catalog.dart';
import 'session.dart';
import '../l10n/l10n.dart';

/// Quality of an artist albums in the library (FLAC, low volume, incomplete), by name.
/// Without a panel or the folder: empty (the pages just do not show the labels).
final qualityProvider = FutureProvider.autoDispose
    .family<ArtistQuality, String>((ref, name) async {
      if (name.isEmpty) return ArtistQuality.empty;
      try {
        return await ref.watch(catalogProvider).quality(name);
      } catch (_) {
        return ArtistQuality.empty;
      }
    });

/// Short label for the album ("FLAC", "low volume", "incomplete") or null.
String? qualityTag(AlbumQuality? q) => q == null
    ? null
    : q.flac
    ? 'FLAC'
    : q.poor
    ? appL10n.stateQualityPoor
    : q.partial
    ? appL10n.stateQualityPartial
    : null;
