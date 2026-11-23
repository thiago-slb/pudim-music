import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/l10n.dart';
import 'session.dart';

/// Language chosen in Settings; `null` follows the device language.
class AppLocale extends Notifier<Locale?> {
  static const _key = 'locale';

  @override
  Locale? build() {
    final v = ref.read(prefsProvider).getString(_key);
    return v != null && appLanguages.contains(v) ? Locale(v) : null;
  }

  void set(Locale? locale) {
    state = locale;
    final prefs = ref.read(prefsProvider);
    if (locale == null) {
      prefs.remove(_key);
    } else {
      prefs.setString(_key, locale.languageCode);
    }
  }
}

final localeProvider = NotifierProvider<AppLocale, Locale?>(AppLocale.new);
