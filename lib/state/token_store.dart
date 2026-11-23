import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:win32/win32.dart';

import '../l10n/l10n.dart';

/// Stores the encrypted Jellyfin token. The password is never stored.
///
/// - Windows: DPAPI (only your Windows account, on this machine, can open it).
///   We use DPAPI directly instead of flutter_secure_storage because its plugin
///   on Windows requires the Visual Studio ATL component to build.
/// - Android: AES-GCM key in the Android Keystore (MainActivity.kt, channel
///   `pudim/token`); the encrypted file lives in the private app folder.
/// - iOS/macOS arrive in the Apple phase (Keychain).
class TokenStore {
  /// Account that owns the token (empty = old file, from when only one account fit).
  final String account;
  const TokenStore([this.account = '']);

  static const _entropy = 'PudimMusic/token/v1';
  static const _uiForbidden = 0x1; // CRYPTPROTECT_UI_FORBIDDEN
  static const _android = MethodChannel('pudim/token');

  Future<File> _file() async {
    final dir = await getApplicationSupportDirectory();
    final suffix = account.isEmpty ? '' : '-$account';
    final name = Platform.isAndroid ? 'token$suffix.enc' : 'token$suffix.bin';
    return File('${dir.path}${Platform.pathSeparator}$name');
  }

  Future<String?> read() async {
    if (!Platform.isWindows && !Platform.isAndroid) return null;
    final f = await _file();
    if (!await f.exists()) return null;
    try {
      if (Platform.isAndroid) {
        return await _android.invokeMethod<String>(
          'decrypt',
          await f.readAsString(),
        );
      }
      final plain = _unprotect(await f.readAsBytes());
      return String.fromCharCodes(plain);
    } catch (_) {
      return null;
    }
  }

  Future<void> write(String token) async {
    if (!Platform.isWindows && !Platform.isAndroid) {
      throw UnsupportedError(appL10n.stateTokenStoreUnsupported);
    }
    final f = await _file();
    await f.parent.create(recursive: true);
    if (Platform.isAndroid) {
      final enc = await _android.invokeMethod<String>('encrypt', token);
      await f.writeAsString(enc!, flush: true);
      return;
    }
    await f.writeAsBytes(
      _protect(Uint8List.fromList(token.codeUnits)),
      flush: true,
    );
  }

  Future<void> delete() async {
    final f = await _file();
    if (await f.exists()) await f.delete();
  }

  static Uint8List _protect(Uint8List data) => _run(data, encrypt: true);
  static Uint8List _unprotect(Uint8List data) => _run(data, encrypt: false);

  static Uint8List _run(Uint8List data, {required bool encrypt}) {
    return using((arena) {
      Pointer<CRYPT_INTEGER_BLOB> blob(List<int> bytes) {
        final buf = arena<Uint8>(bytes.isEmpty ? 1 : bytes.length);
        buf.asTypedList(bytes.length).setAll(0, bytes);
        final b = arena<CRYPT_INTEGER_BLOB>();
        b.ref
          ..cbData = bytes.length
          ..pbData = buf;
        return b;
      }

      final input = blob(data);
      final entropy = blob(_entropy.codeUnits);
      final output = arena<CRYPT_INTEGER_BLOB>();
      final ok = encrypt
          ? CryptProtectData(input, null, entropy, null, _uiForbidden, output)
          : CryptUnprotectData(
              input,
              null,
              entropy,
              null,
              _uiForbidden,
              output,
            );
      if (!ok.value) {
        throw StateError('DPAPI failed (error ${ok.error})');
      }
      final out = Uint8List.fromList(
        output.ref.pbData.asTypedList(output.ref.cbData),
      );
      LocalFree(HLOCAL(output.ref.pbData));
      return out;
    });
  }
}
