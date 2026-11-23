import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

/// UI languages. The first one is the default when the device's language is not supported.
const appLanguages = [
  'pt', 'en', 'es', 'fr', 'de', 'it', 'nl', 'sv', 'pl', 'tr', 'ru', 'uk', //
  'ja', 'ko', 'zh',
];

/// Name of each language in its own language (picker in Settings).
const appLanguageNames = {
  'pt': 'Português',
  'en': 'English',
  'es': 'Español',
  'fr': 'Français',
  'de': 'Deutsch',
  'it': 'Italiano',
  'nl': 'Nederlands',
  'sv': 'Svenska',
  'pl': 'Polski',
  'tr': 'Türkçe',
  'ru': 'Русский',
  'uk': 'Українська',
  'ja': '日本語',
  'ko': '한국어',
  'zh': '简体中文',
};

/// Strings of the current language for code that has a [BuildContext].
extension L10nContext on BuildContext {
  L10n get l10n => L10n.of(this);
}

L10n _current = lookupL10n(const Locale('pt'));

/// Strings of the current language for code without a [BuildContext] (notifications, errors coming
/// from state). The app keeps this up to date in `MaterialApp.builder`.
L10n get appL10n => _current;
set appL10n(L10n value) => _current = value;

/// Picks the language: the first device language the app supports, otherwise Portuguese.
Locale resolveAppLocale(List<Locale>? device) {
  for (final l in device ?? const <Locale>[]) {
    if (appLanguages.contains(l.languageCode)) return Locale(l.languageCode);
  }
  return const Locale('pt');
}
