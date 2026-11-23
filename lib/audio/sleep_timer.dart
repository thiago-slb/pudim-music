import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'player.dart';

class SleepState {
  /// Quando para (null = sem timer de tempo).
  final DateTime? until;

  /// Para quando a música atual acabar.
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

/// Timer para dormir: para a música depois de um tempo (baixando o volume nos últimos
/// 20 segundos) ou quando a música atual acabar.
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
    state = SleepState(until: state.until); // atualiza o tempo que falta na tela
  }
}

final sleepTimerProvider = NotifierProvider<SleepTimer, SleepState>(
  SleepTimer.new,
);
