// Queue QA: the real player on a fake audio engine. The queue must stay the list the user started
// (a playlist stays that playlist through next / previous / track ends), in the expected order.
import 'package:flutter_test/flutter_test.dart';
import 'package:pudim_music/audio/player.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_player.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Rig r;

  setUp(() async => r = await makeRig());
  tearDown(() => r.dispose());

  final pl = tracks(
    'p',
    6,
  ); // a playlist: p0..p5, each from its own album "palbum"

  Future<void> playPlaylist({int start = 0}) async {
    await r.player.playList(
      pl,
      start: start,
      contextName: 'My playlist',
      contextRoute: '/playlist/abc',
    );
    await r.settle();
  }

  group('next / previous stay in the playlist', () {
    test('play from a track, next, next, previous, previous', () async {
      await playPlaylist(start: 2);
      expect(r.current, 'p2');
      expect(r.audio.current, 'p2');
      expect(r.ids, pl.map((t) => t.id));
      await r.player.next();
      await r.settle();
      expect(r.current, 'p3');
      expect(r.audio.current, 'p3');
      await r.player.next();
      await r.settle();
      expect(r.current, 'p4');
      await r.player.previous();
      await r.settle();
      expect(r.current, 'p3');
      expect(r.audio.current, 'p3');
      await r.player.previous();
      await r.settle();
      expect(r.current, 'p2');
      expect(r.ids, pl.map((t) => t.id), reason: 'queue is still the playlist');
      expect(r.q.contextName, 'My playlist');
      expect(r.q.contextRoute, '/playlist/abc');
    });

    test(
      'previous after 3 s restarts the track; in the first seconds goes back',
      () async {
        await playPlaylist(start: 3);
        r.audio.playedTo(const Duration(seconds: 40));
        await r.settle(50);
        await r.player.previous();
        await r.settle();
        expect(r.current, 'p3');
        expect(r.audio.pos, Duration.zero);
        await r.player.previous();
        await r.settle();
        expect(r.current, 'p2');
      },
    );

    test('previous on the first track restarts it', () async {
      await playPlaylist();
      await r.player.previous();
      await r.settle();
      expect(r.current, 'p0');
      expect(r.audio.pos, Duration.zero);
    });

    test(
      'many next / previous presses in a row never leave the playlist',
      () async {
        await playPlaylist(start: 1);
        for (var i = 0; i < 3; i++) {
          await r.player.next();
        }
        for (var i = 0; i < 2; i++) {
          await r.player.previous();
        }
        await r.player.next();
        await r.settle();
        expect(r.current, 'p3');
        expect(r.audio.current, 'p3');
        expect(r.ids, pl.map((t) => t.id));
      },
    );
  });

  group('tracks ending on their own (gapless)', () {
    test(
      'the next track is preloaded and the queue follows each ending',
      () async {
        await playPlaylist();
        for (var i = 1; i <= 4; i++) {
          expect(r.audio.ids.last, 'p$i', reason: 'next one preloaded');
          r.audio.finishTrack();
          await r.settle();
          expect(r.current, 'p$i');
          expect(r.audio.current, 'p$i');
        }
        expect(r.ids, pl.map((t) => t.id));
      },
    );

    test(
      'end of the playlist with autoplay off: stops on the last one',
      () async {
        r.player.autoplay = false;
        await playPlaylist(start: 5);
        r.audio.finishTrack();
        await r.settle();
        expect(r.current, 'p5');
        expect(r.audio.playing, false);
        expect(r.ids, pl.map((t) => t.id));
      },
    );

    test('end of the playlist with autoplay on: continues with a radio of the last one', () async {
      r.http.mix = [track('m1'), track('p2'), track('m2')];
      r.player.autoplay = true;
      await playPlaylist(start: 5);
      r.audio.finishTrack();
      await r.until(() => r.current == 'm1');
      await r.settle();
      expect(r.current, 'm1');
      // the playlist is still there before it, nothing repeated
      expect(r.ids, [...pl.map((t) => t.id), 'm1', 'm2']);
    });

    test('repeat all wraps to the first track', () async {
      await playPlaylist(start: 5);
      r.player.cycleRepeat(); // off -> all
      expect(r.q.repeat, RepeatMode.all);
      await r.settle();
      r.audio.finishTrack();
      await r.settle();
      expect(r.current, 'p0');
      expect(r.audio.current, 'p0');
    });

    test('repeat one replays the same track', () async {
      await playPlaylist(start: 2);
      r.player.cycleRepeat();
      r.player.cycleRepeat(); // all -> one
      expect(r.q.repeat, RepeatMode.one);
      await r.settle();
      expect(r.audio.ids.length, 1, reason: 'nothing preloaded on repeat one');
      r.audio.finishTrack();
      await r.settle();
      expect(r.current, 'p2');
      expect(r.audio.current, 'p2');
    });
  });

  group('shuffle', () {
    test(
      'on keeps the current track and the same songs; off restores the order',
      () async {
        await playPlaylist(start: 2);
        r.player.toggleShuffle();
        expect(r.q.shuffle, true);
        expect(r.current, 'p2');
        expect(r.ids.toSet(), pl.map((t) => t.id).toSet());
        expect(r.ids.take(3), [
          'p0',
          'p1',
          'p2',
        ], reason: 'played part untouched');
        await r.player.next();
        await r.settle();
        final now = r.current!;
        // turns shuffle off on what is playing now (it is no longer necessarily the
        // Smart Shuffle step: this is a playlist, so the cycle is shuffle -> smart -> off)
        r.player.toggleShuffle(); // smart
        r.player.toggleShuffle(); // off
        expect(r.q.shuffle, false);
        expect(r.current, now);
        final i = pl.indexWhere((t) => t.id == now);
        expect(
          r.ids.skip(r.q.index + 1),
          pl.skip(i + 1).map((t) => t.id),
          reason: 'continues in playlist order after the current track',
        );
      },
    );

    test('shuffle order survives a restart and can still be undone', () async {
      await playPlaylist(start: 0);
      r.player.toggleShuffle();
      await r.settle(100);
      final shuffled = r.ids;
      final prefs = r.box.read(prefsProviderForTest);
      r.player.saveNow();
      r.dispose();
      r = await makeRig(prefs: prefs);
      expect(r.ids, shuffled);
      expect(r.q.shuffle, true);
      r.player.toggleShuffle(); // smart (playlist)
      r.player.toggleShuffle(); // off
      expect(r.q.shuffle, false);
      expect(
        r.ids.skip(r.q.index + 1),
        pl.skip(1).map((t) => t.id),
        reason: 'original order comes back after the restart',
      );
    });
  });

  group('Play next / Add to queue', () {
    test(
      'Add to queue goes after earlier additions, before the playlist',
      () async {
        await playPlaylist(start: 1);
        r.player.addToQueue([track('a')]);
        r.player.addToQueue([track('b')]);
        expect(r.ids.skip(2).take(3), ['a', 'b', 'p2']);
        expect(r.q.manualNext.map((t) => t.id), ['a', 'b']);
      },
    );

    test('Play next goes right after the current track', () async {
      await playPlaylist(start: 1);
      r.player.addToQueue([track('a')]);
      r.player.playNext([track('n')]);
      expect(r.ids.skip(2).take(3), ['n', 'a', 'p2']);
    });

    test(
      'queued songs play, then the playlist continues where it was',
      () async {
        await playPlaylist(start: 1);
        r.player.addToQueue([track('a'), track('b')]);
        await r.settle();
        for (final want in ['a', 'b', 'p2', 'p3']) {
          await r.player.next();
          await r.settle();
          expect(r.current, want);
        }
        expect(r.q.manualCount, 0);
      },
    );

    test('queued songs also play when tracks end on their own', () async {
      await playPlaylist(start: 1);
      r.player.addToQueue([track('a')]);
      await r.settle();
      expect(
        r.audio.ids.last,
        'a',
        reason: 'the queued song is the one preloaded',
      );
      r.audio.finishTrack();
      await r.settle();
      expect(r.current, 'a');
      r.audio.finishTrack();
      await r.settle();
      expect(r.current, 'p2');
    });

    test('back and forward keeps queued songs as queued', () async {
      await playPlaylist(start: 1);
      r.player.addToQueue([track('a'), track('b')]);
      await r.player.previous();
      await r.settle();
      expect(r.current, 'p0');
      await r.player.next();
      await r.settle();
      expect(r.current, 'p1', reason: 'forward again returns to where it was');
      expect(r.q.manualNext.map((t) => t.id), ['a', 'b']);
      r.player.addToQueue([track('c')]);
      expect(r.ids.skip(2).take(4), ['a', 'b', 'c', 'p2']);
    });
  });

  group('editing the queue', () {
    test('remove and reorder what comes next', () async {
      await playPlaylist(start: 0);
      r.player.removeAt(2); // p2
      expect(r.ids, ['p0', 'p1', 'p3', 'p4', 'p5']);
      r.player.move(4, 1); // p5 right after the current one
      expect(r.ids, ['p0', 'p5', 'p1', 'p3', 'p4']);
      await r.settle();
      expect(r.audio.ids.last, 'p5', reason: 'preload follows the new order');
      await r.player.next();
      await r.settle();
      expect(r.current, 'p5');
    });

    test('removing a queued song keeps the others queued', () async {
      await playPlaylist(start: 0);
      r.player.addToQueue([track('a'), track('b')]);
      r.player.removeAt(1); // a
      expect(r.q.manualNext.map((t) => t.id), ['b']);
    });

    test('tapping a song further down the queue jumps there', () async {
      await playPlaylist(start: 0);
      await r.player.jumpTo(4);
      await r.settle();
      expect(r.current, 'p4');
      expect(r.audio.current, 'p4');
      expect(r.ids, pl.map((t) => t.id));
      await r.player.next();
      await r.settle();
      expect(r.current, 'p5');
    });
  });

  group('changing what plays', () {
    test('another list replaces the queue and its origin', () async {
      await playPlaylist(start: 2);
      final album = tracks('al', 3);
      await r.player.playList(
        album,
        contextName: 'Album',
        contextRoute: '/album/x',
      );
      await r.settle();
      expect(r.ids, album.map((t) => t.id));
      expect(r.q.contextRoute, '/album/x');
      // search results have no page: the old playlist must not stay as the origin
      await r.player.playList(tracks('s', 2), contextName: 'Search');
      await r.settle();
      expect(r.q.contextRoute, isNull);
      expect(r.q.contextPlaylistId, isNull);
    });

    test('songs queued earlier do not stick to a new list', () async {
      await playPlaylist(start: 0);
      r.player.addToQueue([track('a')]);
      await r.player.playList(tracks('al', 3), contextName: 'Album');
      await r.settle();
      expect(r.q.manualCount, 0);
      expect(r.ids, ['al0', 'al1', 'al2']);
    });
  });

  group('restart', () {
    test('the app reopens paused on the same track, same queue', () async {
      await playPlaylist(start: 3);
      r.audio.playedTo(const Duration(seconds: 70));
      await r.settle(50);
      r.player.saveNow();
      final prefs = r.box.read(prefsProviderForTest);
      r.dispose();
      r = await makeRig(prefs: prefs);
      expect(r.current, 'p3');
      expect(r.ids, pl.map((t) => t.id));
      expect(r.q.contextRoute, '/playlist/abc');
      expect(r.player.pendingPosition!.inSeconds, 70);
      expect(r.player.isPlaying, false);
      expect(r.player.sourceReady, false, reason: 'loads only on play');
    });

    test(
      'after reopening, previous restarts the track it was in the middle of',
      () async {
        await playPlaylist(start: 3);
        r.audio.playedTo(const Duration(seconds: 70));
        await r.settle(50);
        r.player.saveNow();
        final prefs = r.box.read(prefsProviderForTest);
        r.dispose();
        r = await makeRig(prefs: prefs);
        await r.player.previous();
        await r.settle();
        expect(r.current, 'p3');
      },
    );

    test('play after reopening continues from the saved point', () async {
      await playPlaylist(start: 3);
      r.audio.playedTo(const Duration(seconds: 70));
      await r.settle(50);
      r.player.saveNow();
      final prefs = r.box.read(prefsProviderForTest);
      r.dispose();
      r = await makeRig(prefs: prefs);
      await r.player.togglePlay();
      await r.settle();
      expect(r.audio.current, 'p3');
      expect(r.audio.pos.inSeconds, 70);
      await r.player.next();
      await r.settle();
      expect(r.current, 'p4');
    });

    test('seek before pressing play loads paused at that point', () async {
      await playPlaylist(start: 3);
      r.player.saveNow();
      final prefs = r.box.read(prefsProviderForTest);
      r.dispose();
      r = await makeRig(prefs: prefs);
      await r.player.seek(const Duration(seconds: 30));
      await r.settle();
      expect(r.audio.current, 'p3');
      expect(r.audio.pos, const Duration(seconds: 30));
      expect(r.audio.playing, false);
    });
  });

  group('more edge cases', () {
    test('jumping back to an earlier track drops the queued marker', () async {
      await playPlaylist(start: 3);
      r.player.addToQueue([track('a')]);
      await r.player.jumpTo(1);
      await r.settle();
      expect(r.current, 'p1');
      expect(r.q.manualCount, 0);
      r.player.addToQueue([track('b')]);
      expect(r.ids[2], 'b', reason: 'queued right after the current track');
    });

    test(
      'car / notification shuffle button is on / off (no Smart step)',
      () async {
        await playPlaylist(start: 0);
        r.player.toggleShuffle(smartStep: false);
        expect(r.q.shuffle, true);
        r.player.toggleShuffle(smartStep: false);
        expect(r.q.shuffle, false);
        expect(r.q.smart, false);
        expect(r.ids, pl.map((t) => t.id));
      },
    );

    test(
      'shuffle on, add to queue, shuffle off: the queued song stays next',
      () async {
        await playPlaylist(start: 0);
        r.player.toggleShuffle(smartStep: false);
        r.player.addToQueue([track('a')]);
        r.player.toggleShuffle(smartStep: false);
        expect(r.ids.take(3), ['p0', 'a', 'p1']);
        expect(r.ids.skip(2), pl.skip(1).map((t) => t.id));
      },
    );

    test(
      'play next after stepping back plays now, then forward returns',
      () async {
        await playPlaylist(start: 1);
        r.player.addToQueue([track('a')]);
        await r.player.previous();
        await r.settle();
        r.player.playNext([track('n')]);
        for (final want in ['n', 'p1', 'a', 'p2']) {
          await r.player.next();
          await r.settle();
          expect(r.current, want);
        }
      },
    );

    test('step back, then the tracks end on their own: queued songs still play in order', () async {
      await playPlaylist(start: 1);
      r.player.addToQueue([track('a')]);
      await r.player.previous();
      await r.settle();
      for (final want in ['p1', 'a', 'p2']) {
        r.audio.finishTrack();
        await r.settle();
        expect(r.current, want);
      }
    });

    test(
      'add to queue while stepped back goes after the songs already queued',
      () async {
        await playPlaylist(start: 1);
        r.player.addToQueue([track('a')]);
        await r.player.previous();
        await r.settle();
        r.player.addToQueue([track('b')]);
        for (final want in ['p1', 'a', 'b', 'p2']) {
          await r.player.next();
          await r.settle();
          expect(r.current, want);
        }
      },
    );

    test(
      'an album played from the search result keeps its own order',
      () async {
        final album = tracks('al', 4);
        await r.player.playList(
          album,
          start: 1,
          contextName: 'Album',
          contextRoute: '/album/x',
        );
        await r.settle();
        await r.player.next();
        await r.player.next();
        await r.player.previous();
        await r.settle();
        expect(r.current, 'al2');
        expect(r.ids, album.map((t) => t.id));
      },
    );
  });

  test('prefs helper', () async {
    expect(r.box.read(prefsProviderForTest), isA<SharedPreferences>());
  });
}
