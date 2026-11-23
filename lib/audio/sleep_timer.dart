import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'player.dart';

class SleepState {
  /// When it stops (null = no time-based timer).
  final DateTime? until;

  /// Stops when the current track ends.
  final bool endOfTrack;

  const SleepState({this.until, this.endOfTrack = false});

  bool get active => until != null || endOfTrack;

  Duration get left {
    final u = until;
    if (u == null) return Duration.zero;
    final d = u.difference(DateTime.now());
    return d.isNegative ? Duration.zero : d;
  }
}

/// Sleep timer: stops the music after a set time (fading the volume over the last
/// 20 seconds) or when the current track ends.
class SleepTimer extends Notifier<SleepState> {
  static const _fadeFor = Duration(seconds: 20);
  Timer? _t;

  PlayerController get _player => ref.read(playerProvider.notifier);

  @override
  SleepState build() {
    ref.onDispose(() => _t?.cancel());
    _player.onSleepEnded = () => state = const SleepState();
    return const SleepState();
  }

  void start(Duration d) {
    _reset();
    state = SleepState(until: DateTime.now().add(d));
    _t = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void endOfTrack() {
    _reset();
    _player.stopAfterCurrent = true;
    state = const SleepState(endOfTrack: true);
  }

  void cancel() {
    _reset();
    state = const SleepState();
  }

  void _reset() {
    _t?.cancel();
    _t = null;
    _player
      ..fade = 1
      ..stopAfterCurrent = false;
  }

  Future<void> _tick() async {
    final left = state.left;
    if (left == Duration.zero) {
      _t?.cancel();
      await _player.pause();
      cancel();
      return;
    }
    if (left < _fadeFor) {
      _player.fade = left.inMilliseconds / _fadeFor.inMilliseconds;
    }
    state = SleepState(
      until: state.until,
    ); // updates the remaining time on screen
  }
}

final sleepTimerProvider = NotifierProvider<SleepTimer, SleepState>(
  SleepTimer.new,
);
