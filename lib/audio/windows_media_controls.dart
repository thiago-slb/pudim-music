import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smtc_windows/smtc_windows.dart' as smtc;

import '../api/models.dart';
import '../state/session.dart';
import 'player.dart';

/// Loads the native (Rust) part of SMTC. Windows only; a failure does not stop the app.
Future<void> initWindowsMediaControls() async {
  if (!Platform.isWindows) return;
  try {
    await smtc.SMTCWindows.initialize();
  } catch (e) {
    debugPrint('SMTC unavailable: $e');
  }
}

/// Windows media controls (SMTC): the volume/media panel, the keyboard media keys
/// and the lock screen show the track and control the player.
/// Just watch this provider (the app does so on Windows).
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
    debugPrint('SMTC unavailable: $e');
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

  // Position: every few seconds and right after a seek (jump > 2 s).
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
          if (!player.isPlaying) player.togglePlay();
        case smtc.PressedButton.pause:
          if (player.isPlaying) player.togglePlay();
        case smtc.PressedButton.next:
          player.next();
        case smtc.PressedButton.previous:
          player.previous();
        case smtc.PressedButton.stop:
          player.pause();
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

/// Title, artists, album and cover as Windows shows them in the media panel.
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
