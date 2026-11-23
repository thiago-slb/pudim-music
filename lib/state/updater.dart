import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../version.dart';
import 'session.dart';

/// Atualização pronta para instalar (null = nada novo ou ainda baixando).
class UpdateReady {
  final int build;
  final String path;
  final String notes;
  const UpdateReady(this.build, this.path, this.notes);
}

/// Confere no servidor de extras (quando tem) se há versão nova; baixa em segundo plano e
/// avisa quando está pronta. Android abre a tela de instalar; Windows instala em silêncio e reabre.
final updaterProvider = NotifierProvider<Updater, UpdateReady?>(Updater.new);

class Updater extends Notifier<UpdateReady?> {
  Timer? _timer;
  bool _busy = false;

  static String? get _kind => Platform.isAndroid
      ? 'apk'
      : Platform.isWindows
      ? 'windows'
      : null;

  @override
  UpdateReady? build() {
    ref.onDispose(() => _timer?.cancel());
    if (_kind != null) {
      // Um pouco depois de abrir (não disputa a rede com a Início) e depois a cada 6 h.
      Timer(const Duration(seconds: 20), check);
      _timer = Timer.periodic(const Duration(hours: 6), (_) => check());
    }
    return null;
  }

  Future<void> check() async {
    final kind = _kind;
    if (kind == null || _busy || state != null) return;
    _busy = true;
    try {
      final cat = ref.read(catalogProvider);
      if (cat.token.isEmpty || !cat.enabled) return;
      final info = await cat.updateInfo();
      final build = (info['build'] as num?)?.toInt() ?? 0;
      final file = info[kind];
      if (build <= appBuild || file is! Map) return;
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
          return; // arquivo corrompido ou trocado no caminho: tenta de novo mais tarde
        }
        await File(part).rename(path);
      }
      state = UpdateReady(build, path, '${info['notes'] ?? ''}');
    } catch (_) {
      // Sem painel ou sem internet: tenta na próxima.
    } finally {
      _busy = false;
    }
  }

  static Future<String> _sha(File f) async =>
      (await sha256.bind(f.openRead()).first).toString();

  /// Instala a versão baixada.
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
      // O instalador fecha o app, instala sem perguntar nada e o script abre a versão nova.
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
