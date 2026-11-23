import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart' show AppLifecycleListener;

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../version.dart';
import 'session.dart';

/// Update ready to install (null = nothing new or still downloading).
class UpdateReady {
  final int build;
  final String path;
  final String notes;
  const UpdateReady(this.build, this.path, this.notes);
}

/// Checks the extras server (when there is one) for a new version; downloads in the background and
/// notifies when it is ready. Android opens the install screen; Windows installs silently and reopens.
final updaterProvider = NotifierProvider<Updater, UpdateReady?>(Updater.new);

class Updater extends Notifier<UpdateReady?> {
  Timer? _timer;
  bool _busy = false;

  static String? get _kind => Platform.isAndroid
      ? 'apk'
      : Platform.isWindows
      ? 'windows'
      : null;

  DateTime? _checked;

  @override
  UpdateReady? build() {
    ref.onDispose(() => _timer?.cancel());
    if (_kind != null) {
      // A little after opening (do not compete for the network with Home) and then every hour.
      Timer(const Duration(seconds: 20), check);
      _timer = Timer.periodic(const Duration(hours: 1), (_) => check());
      // The app usually stays in the background for days: also check when it comes back.
      final life = AppLifecycleListener(
        onResume: () {
          final last = _checked;
          if (last == null ||
              DateTime.now().difference(last) > const Duration(minutes: 10)) {
            check();
          }
        },
      );
      ref.onDispose(life.dispose);
    }
    return null;
  }

  Future<void> check() async {
    final kind = _kind;
    if (kind == null || _busy) return;
    _busy = true;
    _checked = DateTime.now();
    try {
      final cat = ref.read(catalogProvider);
      if (cat.token.isEmpty || !cat.enabled) return;
      final info = await cat.updateInfo();
      final build = (info['build'] as num?)?.toInt() ?? 0;
      final file = info[kind];
      // A newer build than the one already downloaded also counts (it was never installed).
      if (!updateWanted(build, appBuild, state?.build) || file is! Map) return;
      final want = '${file['sha256'] ?? ''}'.toLowerCase();
      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}${Platform.pathSeparator}pudim-$build.${kind == 'apk' ? 'apk' : 'exe'}';
      final f = File(path);
      if (!(await f.exists() && await _sha(f) == want)) {
        final part = '$path.part';
        await cat.downloadUpdate(kind, part);
        if (want.isNotEmpty && await _sha(File(part)) != want) {
          await File(part).delete();
          return; // file corrupted or swapped on the way: try again later
        }
        await File(part).rename(path);
      }
      state = UpdateReady(build, path, '${info['notes'] ?? ''}');
    } catch (_) {
      // No panel or no internet: try on the next one.
    } finally {
      _busy = false;
    }
  }

  static Future<String> _sha(File f) async =>
      (await sha256.bind(f.openRead()).first).toString();

  /// Installs the downloaded version.
  Future<String?> install() async {
    final u = state;
    if (u == null) return null;
    if (Platform.isAndroid) {
      final r = await OpenFilex.open(
        u.path,
        type: 'application/vnd.android.package-archive',
      );
      return r.type == ResultType.done ? null : r.message;
    }
    if (Platform.isWindows) {
      // The installer closes the app, installs without asking anything and the script opens the new version.
      final exe = Platform.resolvedExecutable;
      final bat = File('${File(u.path).parent.path}\\pudim-atualizar.cmd');
      await bat.writeAsString(
        '@echo off\r\n'
        'timeout /t 2 /nobreak >nul\r\n'
        '"${u.path}" /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /CLOSEAPPLICATIONS\r\n'
        'start "" "$exe"\r\n',
      );
      await Process.start('cmd', [
        '/c',
        bat.path,
      ], mode: ProcessStartMode.detached);
      exit(0);
    }
    return null;
  }
}

/// Whether the server's [remote] build should be downloaded: newer than the running one and not the
/// one already downloaded. A newer build than the downloaded one still counts (it was never installed).
bool updateWanted(int remote, int running, int? downloaded) =>
    remote > running && remote != downloaded;
