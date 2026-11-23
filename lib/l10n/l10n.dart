import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

/// Idiomas da interface. O primeiro é o padrão quando o do aparelho não é suportado.
const appLanguages = [
  'pt', 'en', 'es', 'fr', 'de', 'it', 'nl', 'sv', 'pl', 'tr', 'ru', 'uk', //
  'ja', 'ko', 'zh',
];

/// Nome de cada idioma na própria língua (seletor em Configurações).
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

/// Textos do idioma atual para quem tem um [BuildContext].
extension L10nContext on BuildContext {
  L10n get l10n => L10n.of(this);
}

L10n _current = lookupL10n(const Locale('pt'));

/// Textos do idioma atual para código sem [BuildContext] (notificações, erros vindos do estado).
/// O app mantém isto em dia em `MaterialApp.builder`.
L10n get appL10n => _current;
set appL10n(L10n value) => _current = value;

/// Escolhe o idioma: o primeiro do aparelho que o app sabe falar, senão português.
Locale resolveAppLocale(List<Locale>? device) {
  for (final l in device ?? const <Locale>[]) {
    if (appLanguages.contains(l.languageCode)) return Locale(l.languageCode);
  }
  return const Locale('pt');
}
