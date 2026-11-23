import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:pudim_music/l10n/l10n.dart';

void main() {
  test('languages load', () {
    expect(lookupL10n(const Locale('pt')).commonLikedSongs, 'Músicas curtidas');
    expect(lookupL10n(const Locale('en')).commonLikedSongs, 'Liked Songs');
    expect(
      lookupL10n(const Locale('es')).commonLikedSongs,
      'Canciones que te gustan',
    );
    expect(
      L10n.supportedLocales.map((l) => l.languageCode).toSet(),
      appLanguages.toSet(),
    );
    for (final code in appLanguages) {
      expect(appLanguageNames[code], isNotNull, reason: code);
      expect(lookupL10n(Locale(code)).commonLikedSongs, isNotEmpty);
    }
  });

  test('song count plural', () {
    expect(lookupL10n(const Locale('pt')).commonSongCount(1), '1 música');
    expect(lookupL10n(const Locale('en')).commonSongCount(3), '3 songs');
    expect(lookupL10n(const Locale('es')).commonSongCount(2), '2 canciones');
  });

  test('follows the device language, otherwise Portuguese', () {
    expect(resolveAppLocale(const [Locale('es', 'MX')]), const Locale('es'));
    expect(
      resolveAppLocale(const [Locale('hi'), Locale('en', 'US')]),
      const Locale('en'),
    );
    expect(resolveAppLocale(const [Locale('ja', 'JP')]), const Locale('ja'));
    expect(resolveAppLocale(const [Locale('hi')]), const Locale('pt'));
    expect(resolveAppLocale(null), const Locale('pt'));
  });

  test('all translations have the same keys as Portuguese', () {
    Set<String> keys(String loc) {
      final m = jsonDecode(
        File('lib/l10n/app_$loc.arb').readAsStringSync(),
      ) as Map<String, dynamic>;
      return m.keys.where((k) => !k.startsWith('@')).toSet();
    }

    final pt = keys('pt');
    for (final code in appLanguages) {
      expect(keys(code), pt, reason: code);
    }
  });
}
