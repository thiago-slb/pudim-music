import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/widgets.dart' show AppLifecycleListener;

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../config.dart';
import '../version.dart';
import 'session.dart';

/// Update ready to install (null = nothing new or still downloading).
class UpdateReady {
  final int build;
  final String path;
  final String notes;
  const UpdateReady(this.build, this.path, this.notes);
}

/// What the updater is doing, for Settings and the strip ("downloading build 16, 40%").
class UpdateStatus {
  final UpdatePhase phase;
  final int remote;
  final double? progress;
  final String? error;
  const UpdateStatus(this.phase, {this.remote = 0, this.progress, this.error});
}

enum UpdatePhase {
  idle,
  checking,
  downloading,
  upToDate,
  ready,
  failed,
  unavailable,
}

final updateStatusProvider =
    NotifierProvider<UpdateStatusNotifier, UpdateStatus>(
      UpdateStatusNotifier.new,
    );

class UpdateStatusNotifier extends Notifier<UpdateStatus> {
  @override
  UpdateStatus build() => const UpdateStatus(UpdatePhase.idle);
  void set(UpdateStatus s) => state = s;
}

/// Checks the extras server (when there is one) for a new version; downloads in the background and
/// notifies when it is ready. Android opens the install screen; Windows installs silently and reopens;
/// macOS swaps its own .app bundle for the one in the downloaded zip and reopens.
final updaterProvider = NotifierProvider<Updater, UpdateReady?>(Updater.new);

class Updater extends Notifier<UpdateReady?> {
  Timer? _timer;
  bool _busy = false;

  static String? get _kind => playStoreBuild
      ? null // the store updates this build
      : Platform.isAndroid
      ? 'apk'
      : Platform.isWindows
      ? 'windows'
      : Platform.isMacOS
      ? 'macos'
      : null;

  /// Last check that reached the server (failed or skipped ones do not hold the next one back).
  DateTime? _checked;

  void _status(UpdateStatus st) {
    if (ref.mounted) ref.read(updateStatusProvider.notifier).set(st);
  }

  // Shows up in logcat / the console in release builds too.
  static void _log(String m) => debugPrint('updater: $m');

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
              DateTime.now().difference(last) > const Duration(minutes: 2)) {
            check();
          }
        },
      );
      ref.onDispose(life.dispose);
    }
    return null;
  }

  /// Also called by the Settings button; the result goes to [updateStatusProvider].
  Future<void> check() async {
    final kind = _kind;
    if (kind == null || _busy) return;
    final cat = ref.read(catalogProvider);
    if (!cat.enabled) {
      _log('no extras server configured');
      _status(const UpdateStatus(UpdatePhase.unavailable));
      return;
    }
    if (cat.token.isEmpty) {
      // Still signing in: try again shortly instead of waiting for the next hour.
      _log('not signed in yet, retrying in 30 s');
      Timer(const Duration(seconds: 30), check);
      return;
    }
    _busy = true;
    _status(const UpdateStatus(UpdatePhase.checking));
    try {
      final info = await cat.updateInfo();
      _checked = DateTime.now();
      final build = (info['build'] as num?)?.toInt() ?? 0;
      final file = info[kind];
      _log('server has build $build, running $appBuild');
      if (state != null && state!.build >= build) {
        _status(UpdateStatus(UpdatePhase.ready, remote: state!.build));
        return;
      }
      // A newer build than the one already downloaded also counts (it was never installed).
      if (!updateWanted(build, appBuild, state?.build) || file is! Map) {
        _status(UpdateStatus(UpdatePhase.upToDate, remote: build));
        return;
      }
      final want = '${file['sha256'] ?? ''}'.toLowerCase();
      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}${Platform.pathSeparator}pudim-$build.${kind == 'apk'
              ? 'apk'
              : kind == 'macos'
              ? 'zip'
              : 'exe'}';
      final f = File(path);
      if (!(await f.exists() && await _sha(f) == want)) {
        final part = '$path.part';
        _status(
          UpdateStatus(UpdatePhase.downloading, remote: build, progress: 0),
        );
        await cat.downloadUpdate(
          kind,
          part,
          onProgress: (got, total) {
            if (total > 0) {
              _status(
                UpdateStatus(
                  UpdatePhase.downloading,
                  remote: build,
                  progress: got / total,
                ),
              );
            }
          },
        );
        if (want.isNotEmpty && await _sha(File(part)) != want) {
          await File(part).delete();
          throw const FileSystemException('checksum mismatch');
        }
        await File(part).rename(path);
      }
      _log('build $build downloaded');
      state = UpdateReady(build, path, '${info['notes'] ?? ''}');
      _status(UpdateStatus(UpdatePhase.ready, remote: build));
    } catch (e) {
      // No panel, no internet or token refused: logged and shown in Settings; tries again later.
      _log('check failed: $e');
      _status(UpdateStatus(UpdatePhase.failed, error: '$e'));
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
    if (Platform.isMacOS) {
      // Unzips the new version, swaps the .app it is running from and reopens it.
      final app = Directory(
        Platform.resolvedExecutable,
      ).parent.parent.parent.path;
      final work = '${File(u.path).parent.path}/pudim-update-${u.build}';
      final sh = File('$work.sh');
      await sh.writeAsString(
        '#!/bin/sh\n'
        'sleep 2\n'
        'rm -rf "$work" && mkdir -p "$work" || exit 1\n'
        '/usr/bin/ditto -x -k "${u.path}" "$work" || exit 1\n'
        'NEW=\$(ls -d "$work"/*.app | head -n 1)\n'
        '[ -d "\$NEW" ] || exit 1\n'
        'rm -rf "$app" && /usr/bin/ditto "\$NEW" "$app" || exit 1\n'
        '/usr/bin/xattr -dr com.apple.quarantine "$app" 2>/dev/null\n'
        'rm -rf "$work"\n'
        '/usr/bin/open "$app"\n',
      );
      await Process.start('/bin/sh', [
        sh.path,
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
