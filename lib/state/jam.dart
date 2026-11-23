import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/catalog.dart';
import '../api/models.dart';
import '../audio/player.dart';
import 'session.dart';

/// Jam: listening together with other accounts.
///
/// Whoever creates it (host) sends the queue, the track, the position and whether it is playing on every change and every 2 s
/// (this also serves as "I am here"). The response carries the songs and commands the guests asked for,
/// and the host applies them to their queue. Guests poll every 2 s and copy the state; their player
/// buttons become requests to the host.
class JamController extends Notifier<JamState?> {
  Timer? _timer;
  List<Item> _queue = const [];
  int _from = 0; // where the window sent starts in the host queue
  String _sentSig = '';
  bool _busy = false;
  bool _pushSoon = false;

  Catalog get _cat => ref.read(catalogProvider);
  PlayerController get _player => ref.read(playerProvider.notifier);

  /// Queue everyone is listening to (the host one).
  List<Item> get queue => _queue;

  @override
  JamState? build() {
    ref.onDispose(() => _timer?.cancel());
    ref.listen(playerProvider, (prev, next) {
      final s = state;
      if (s == null || !s.isHost) return;
      if (prev == null ||
          prev.index != next.index ||
          prev.playing != next.playing ||
          !identical(prev.queue, next.queue)) {
        _schedulePush();
      }
    });
    // On app start: go back to the Jam this account was already in.
    Future.microtask(_resume);
    return null;
  }

  Future<void> _resume() async {
    try {
      final st = await _cat.jam();
      if (st != null && !st.ended) {
        _apply(st);
        if (!st.isHost) await _follow(st, force: true);
      }
    } catch (_) {}
  }

  // ---------- actions ----------

  Future<void> start() async {
    _sentSig = '';
    final st = await _cat.startJam(_snapshot(force: true));
    _apply(st);
  }

  Future<void> join(String id) async {
    final st = await _cat.joinJam(id);
    _apply(st);
    if (!st.isHost) await _follow(st, force: true);
  }

  Future<void> leave() async {
    final s = state;
    _stop();
    if (s != null) {
      try {
        await _cat.leaveJam(s.id);
      } catch (_) {}
    }
  }

  Future<void> invite(String userId) => _cat.jamInvite(state!.id, userId);

  // ---------- state ----------

  void _apply(JamState st) {
    if (st.ended) {
      _stop();
      return;
    }
    if (st.queue != null) _queue = st.queue!;
    state = st;
    _player.remote = st.isHost ? null : _remote;
    _timer ??= Timer.periodic(const Duration(seconds: 2), (_) => _tick());
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
    _player.remote = null;
    _queue = const [];
    _sentSig = '';
    state = null;
  }

  Future<void> _tick() async {
    final s = state;
    if (s == null || _busy) return;
    _busy = true;
    try {
      if (s.isHost) {
        await _push();
      } else {
        final st = await _cat.jam(rev: s.rev);
        if (st == null || st.ended) {
          _stop();
          return;
        }
        final changed = st.rev != s.rev;
        _apply(st);
        await _follow(st, force: false, revChanged: changed);
      }
    } on CatalogException catch (_) {
      // the Jam is gone (panel restarted or it ended): leave quietly
      final again = await _cat.jam().catchError((_) => null);
      if (again == null) _stop();
    } catch (_) {
      // no internet for a moment: try again on the next poll
    } finally {
      _busy = false;
    }
  }

  void _schedulePush() {
    if (_pushSoon) return;
    _pushSoon = true;
    Timer(const Duration(milliseconds: 400), () async {
      _pushSoon = false;
      if (_busy || state == null) return;
      _busy = true;
      try {
        await _push();
      } catch (_) {
      } finally {
        _busy = false;
      }
    });
  }

  Map<String, dynamic> _snapshot({bool force = false}) {
    final q = ref.read(playerProvider);
    _from = max(0, q.index - 20);
    final window = q.queue.skip(_from).take(300).toList();
    final sig = '$_from:${window.map((t) => t.id).join(',')}';
    final out = <String, dynamic>{
      'index': q.index - _from,
      'pos_ms': _player.position.inMilliseconds,
      'playing': q.playing,
      'context': q.contextName,
    };
    if (force || sig != _sentSig) {
      out['queue'] = [for (final t in window) t.toStore()];
      _sentSig = sig;
    }
    return out;
  }

  /// Host: sends the state and applies what the guests asked for.
  Future<void> _push() async {
    final s = state;
    if (s == null) return;
    final st = await _cat.pushJam(s.id, _snapshot());
    _apply(st);
    if (st.pending.isNotEmpty) {
      _player.addToQueue([
        for (final it in st.pending)
          if (it.name.isNotEmpty) it,
      ]);
    }
    for (final c in st.cmds) {
      switch (c['action']) {
        case 'next':
          await _player.next();
        case 'previous':
          await _player.previous();
        case 'toggle':
          await _player.togglePlay();
        case 'jump':
          final i = (c['index'] as num?)?.toInt();
          if (i != null) await _player.jumpTo(_from + i);
      }
    }
  }

  /// Guest: makes the player match the host one.
  Future<void> _follow(
    JamState st, {
    required bool force,
    bool revChanged = false,
  }) async {
    if (_queue.isEmpty || st.index < 0 || st.index >= _queue.length) return;
    final cur = ref.read(playerProvider);
    final target = _queue[st.index];
    final at = Duration(milliseconds: st.posMs);
    if (force || cur.current?.id != target.id) {
      await _player.jamLoad(_queue, st.index, at, st.playing, st.context);
      return;
    }
    if (revChanged) _player.jamQueue(_queue, st.index, st.context);
    if (st.playing != _player.audio.playing) {
      await _player.jamPlaying(st.playing);
    }
    final drift = (_player.audio.position - at).inMilliseconds.abs();
    if (st.playing && drift > 3000) await _player.audio.seek(at);
  }

  /// Guest buttons: they become requests to the host.
  bool _remote(String action, {int? index, List<Item>? items}) {
    final s = state;
    if (s == null || s.isHost) return false;
    if (action == 'add') {
      if (items != null && items.isNotEmpty) {
        unawaited(_cat.jamAdd(s.id, items).catchError((_) {}));
      }
      return true;
    }
    unawaited(_cat.jamCmd(s.id, action, index: index).catchError((_) {}));
    return true;
  }
}

final jamProvider = NotifierProvider<JamController, JamState?>(
  JamController.new,
);
