import 'package:material_ui/material_ui.dart';

import 'l10n.dart';

/// The widgets come from package:material_ui, so the Material texts must come from its delegates
/// too. L10n.localizationsDelegates brings flutter_localizations' Material delegate, which material_ui's
/// TextField does not see: every language other than English failed with "No MaterialLocalizations"
/// and the screens went gray.
const appLocalizationsDelegates = <LocalizationsDelegate<dynamic>>[
  L10n.delegate,
  ...GlobalMaterialLocalizations.delegates,
];
