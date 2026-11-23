import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Windows data folder of an older build, relative to %APPDATA% (e.g. `OldCompany\Pudim`).
///
/// The data folder comes from CompanyName/ProductName in `windows/runner/Runner.rc`. If a
/// build of yours used other names before, set this define so the first launch of the new
/// build copies login, settings, queue and offline files over instead of starting empty.
const legacyDataDir = String.fromEnvironment('PUDIM_LEGACY_DATA_DIR');

/// Copies the old Windows data folder into the current one, once (only while the current one
/// has no settings yet). The old folder is left untouched.
Future<void> migrateLegacyData() async {
  if (!Platform.isWindows || legacyDataDir.isEmpty) return;
  try {
    final appData = Platform.environment['APPDATA'];
    if (appData == null) return;
    final old = Directory('$appData$_sep$legacyDataDir');
    final now = await getApplicationSupportDirectory();
    if (old.absolute.path.toLowerCase() == now.absolute.path.toLowerCase()) {
      return;
    }
    if (!await old.exists() ||
        await File('${now.path}${_sep}shared_preferences.json').exists()) {
      return;
    }
    await _copy(old, now);
  } catch (_) {
    // Worst case the app starts empty, as it would without this.
  }
}

final _sep = Platform.pathSeparator;

Future<void> _copy(Directory from, Directory to) async {
  await to.create(recursive: true);
  await for (final e in from.list(followLinks: false)) {
    final name = e.uri.pathSegments.where((s) => s.isNotEmpty).last;
    final target = '${to.path}$_sep$name';
    if (e is Directory) {
      await _copy(e, Directory(target));
    } else if (e is File && !await File(target).exists()) {
      await e.copy(target);
    }
  }
}
