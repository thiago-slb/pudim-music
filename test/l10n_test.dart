import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:pudim_music/l10n/l10n.dart';

void main() {
  test('os três idiomas carregam', () {
    expect(lookupL10n(const Locale('pt')).commonLikedSongs, 'Músicas curtidas');
    expect(lookupL10n(const Locale('en')).commonLikedSongs, 'Liked Songs');
    expect(
      lookupL10n(const Locale('es')).commonLikedSongs,
      'Canciones que te gustan',
    );
    expect(L10n.supportedLocales.map((l) => l.languageCode).toSet(), {
      'pt',
      'en',
      'es',
    });
  });

  test('plural das músicas', () {
    expect(lookupL10n(const Locale('pt')).commonSongCount(1), '1 música');
    expect(lookupL10n(const Locale('en')).commonSongCount(3), '3 songs');
    expect(lookupL10n(const Locale('es')).commonSongCount(2), '2 canciones');
  });

  test('segue o idioma do aparelho, senão português', () {
    expect(resolveAppLocale(const [Locale('es', 'MX')]), const Locale('es'));
    expect(
      resolveAppLocale(const [Locale('fr'), Locale('en', 'US')]),
      const Locale('en'),
    );
    expect(resolveAppLocale(const [Locale('de')]), const Locale('pt'));
    expect(resolveAppLocale(null), const Locale('pt'));
  });

  test('todas as traduções têm as mesmas chaves do português', () {
    Set<String> keys(String loc) {
      final m = jsonDecode(
        File('lib/l10n/app_$loc.arb').readAsStringSync(),
      ) as Map<String, dynamic>;
      return m.keys.where((k) => !k.startsWith('@')).toSet();
    }

    final pt = keys('pt');
    expect(keys('en'), pt);
    expect(keys('es'), pt);
  });
}
