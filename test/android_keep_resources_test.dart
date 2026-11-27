import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// Build 27-29: the release build stripped the car/notification button icons (only looked up by
// name), and the media notification disappeared. Every drawable the media session names must be
// kept from resource shrinking.
void main() {
  test('drawables named by the media session are kept in release builds', () {
    final keep = File(
      'android/app/src/main/res/raw/keep.xml',
    ).readAsStringSync();
    final patterns = RegExp(r'tools:keep="([^"]*)"')
        .firstMatch(keep)!
        .group(1)!
        .split(',')
        .map((p) => p.trim().replaceFirst('@drawable/', ''));
    bool kept(String name) => patterns.any(
      (p) => p.endsWith('*')
          ? name.startsWith(p.substring(0, p.length - 1))
          : name == p,
    );
    final sources = [
      File('lib/audio/media_session.dart').readAsStringSync(),
      File('lib/main.dart').readAsStringSync(),
    ].join('\n');
    final named = RegExp(r"'drawable/(\w+)'")
        .allMatches(sources)
        .map((m) => m.group(1)!)
        .toSet();
    expect(named, isNotEmpty);
    for (final n in named) {
      expect(kept(n), isTrue, reason: '$n missing from res/raw/keep.xml');
      expect(
        File('android/app/src/main/res/drawable/$n.xml').existsSync(),
        isTrue,
        reason: '$n has no drawable file',
      );
    }
  });
}
