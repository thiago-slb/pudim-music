import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smtc_windows/smtc_windows.dart' as smtc;

import '../api/models.dart';
import '../state/session.dart';
import 'player.dart';

/// Carrega a parte nativa (Rust) do SMTC. Só no Windows; falha não impede o app.
Future<void> initWindowsMediaControls() async {
  if (!Platform.isWindows) return;
  try {
    await smtc.SMTCWindows.initialize();
  } catch (e) {
    debugPrint('SMTC indisponível: $e');
  }
}

/// Controles de mídia do Windows (SMTC): o painel de volume/mídia, as teclas
/// de mídia do teclado e a tela de bloqueio mostram a faixa e comandam o player.
/// Basta assistir este provider (o app faz isso no Windows).
final windowsMediaControlsProvider = Provider<void>((ref) {
  if (!Platform.isWindows) return;
  final smtc.SMTCWindows controls;
  try {
    controls = smtc.SMTCWindows(
      enabled: false,
      config: const smtc.SMTCConfig(
        playEnabled: true,
        pauseEnabled: true,
        nextEnabled: true,
        prevEnabled: true,
        stopEnabled: true,
        fastForwardEnabled: false,
        rewindEnabled: false,
      ),
    );
  } catch (e) {
    debugPrint('SMTC indisponível: $e');
    return;
  }
  final player = ref.read(playerProvider.notifier);
  final subs = <StreamSubscription>[];

  void apply(QueueState? prev, QueueState q) {
    final cur = q.current;
    if (cur == null) {
      if (prev?.current != null) {
        controls.setPlaybackStatus(smtc.PlaybackStatus.stopped);
        controls.disableSmtc();
      }
      return;
    }
    if (prev?.current?.id != cur.id) {
      if (prev?.current == null) controls.enableSmtc();
      controls.updateMetadata(metadataFor(ref, cur));
      _timeline(controls, Duration.zero, cur.duration);
    }
    if (prev?.playing != q.playing || prev?.current == null) {
      controls.setPlaybackStatus(
        q.playing ? smtc.PlaybackStatus.playing : smtc.PlaybackStatus.paused,
      );
    }
    if (prev?.shuffle != q.shuffle) controls.setShuffleEnabled(q.shuffle);
    if (prev?.repeat != q.repeat) {
      controls.setRepeatMode(switch (q.repeat) {
        RepeatMode.off => smtc.RepeatMode.none,
        RepeatMode.all => smtc.RepeatMode.list,
        RepeatMode.one => smtc.RepeatMode.track,
      });
    }
  }

  ref.listen<QueueState>(playerProvider, apply, fireImmediately: true);

  // Posição: a cada poucos segundos e logo depois de um seek (salto > 2 s).
  var lastSent = Duration.zero;
  subs.add(
    player.audio.positionStream.listen((pos) {
      final cur = ref.read(playerProvider).current;
      if (cur == null) return;
      final jump = (pos - lastSent).abs() > const Duration(seconds: 7);
      if (jump || pos - lastSent >= const Duration(seconds: 5)) {
        lastSent = pos;
        _timeline(controls, pos, player.audio.duration ?? cur.duration);
      }
    }),
  );

  subs.add(
    controls.buttonPressStream.listen((b) {
      switch (b) {
        case smtc.PressedButton.play:
          if (!player.audio.playing) player.togglePlay();
        case smtc.PressedButton.pause:
          if (player.audio.playing) player.togglePlay();
        case smtc.PressedButton.next:
          player.next();
        case smtc.PressedButton.previous:
          player.previous();
        case smtc.PressedButton.stop:
          player.audio.pause();
        default:
          break;
      }
    }),
  );
  subs.add(
    controls.shuffleChangeStream.listen((on) {
      if (ref.read(playerProvider).shuffle != on) player.toggleShuffle();
    }),
  );
  subs.add(
    controls.repeatModeChangeStream.listen((m) {
      final want = switch (m) {
        smtc.RepeatMode.none => RepeatMode.off,
        smtc.RepeatMode.list => RepeatMode.all,
        smtc.RepeatMode.track => RepeatMode.one,
      };
      for (var i = 0; i < 3 && ref.read(playerProvider).repeat != want; i++) {
        player.cycleRepeat();
      }
    }),
  );

  ref.onDispose(() {
    for (final s in subs) {
      s.cancel();
    }
    controls.dispose();
  });
});

/// Título, artistas, álbum e capa como o Windows mostra no painel de mídia.
smtc.MusicMetadata metadataFor(Ref ref, Item t) {
  final albumArtist = t.albumArtists.map((a) => a.name).join(', ');
  return smtc.MusicMetadata(
    title: t.name,
    artist: t.artistLine,
    album: t.album ?? '',
    albumArtist: albumArtist.isEmpty ? t.artistLine : albumArtist,
    thumbnail: ref.read(apiProvider).imageUrl(t.imageItemId, size: 512),
  );
}

void _timeline(smtc.SMTCWindows c, Duration pos, Duration total) {
  final end = total.inMilliseconds;
  c.updateTimeline(
    smtc.PlaybackTimeline(
      startTimeMs: 0,
      endTimeMs: end,
      positionMs: pos.inMilliseconds.clamp(0, end < 0 ? 0 : end),
      minSeekTimeMs: 0,
      maxSeekTimeMs: end,
    ),
  );
}
