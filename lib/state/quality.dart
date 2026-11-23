import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/catalog.dart';
import 'session.dart';

/// Qualidade dos álbuns de um artista na biblioteca (FLAC, som fraco, incompleto), pelo nome.
/// Sem painel ou sem a pasta: vazio (as páginas só não mostram as etiquetas).
final qualityProvider = FutureProvider.autoDispose
    .family<ArtistQuality, String>((ref, name) async {
      if (name.isEmpty) return ArtistQuality.empty;
      try {
        return await ref.watch(catalogProvider).quality(name);
      } catch (_) {
        return ArtistQuality.empty;
      }
    });

/// Etiqueta curta para o álbum ("FLAC", "som fraco", "incompleto") ou null.
String? qualityTag(AlbumQuality? q) => q == null
    ? null
    : q.flac
    ? 'FLAC'
    : q.poor
    ? 'som fraco'
    : q.partial
    ? 'incompleto'
    : null;
