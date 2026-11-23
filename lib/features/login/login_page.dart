import 'dart:async';

// A API nova (nativeapi) do window_manager 0.7 ainda é recente; usamos a ponte legada.
// ignore_for_file: deprecated_member_use
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/legacy.dart';

import '../../state/session.dart';
import '../../l10n/l10n.dart';
import '../../ui/responsive.dart';
import '../../ui/theme.dart';

/// Entrar com a conta do Jellyfin. A senha só vai para o servidor;
/// o app guarda apenas o token.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _user = TextEditingController();
  final _pass = TextEditingController();
  late final TextEditingController _lan;
  late final TextEditingController _wan;
  late final TextEditingController _extras;
  bool _busy = false;
  bool _showServer = false;
  bool _obscure = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    final u = ref.read(sessionProvider.notifier).urls;
    _lan = TextEditingController(text: u.lan);
    _wan = TextEditingController(text: u.wan);
    _extras = TextEditingController(text: ref.read(extrasUrlProvider));
    // Sem endereço salvo nem embutido no build: o campo do servidor já aparece aberto.
    _showServer = u.wan.isEmpty && u.lan.isEmpty;
    _user.text = ref.read(prefsProvider).getString('lastUser') ?? '';
  }

  @override
  void dispose() {
    for (final c in [_user, _pass, _lan, _wan, _extras]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    final wan = normalizeUrl(_wan.text);
    final lan = normalizeUrl(_lan.text, local: true);
    if (wan.isEmpty && lan.isEmpty) {
      setState(() {
        _showServer = true;
        _error = context.l10n.loginServerRequired;
      });
      return;
    }
    if (_user.text.trim().isEmpty) {
      setState(() => _error = context.l10n.loginUserRequired);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(prefsProvider).setString('lastUser', _user.text.trim());
      await ref.read(extrasUrlProvider.notifier).set(_extras.text);
      await ref
          .read(sessionProvider.notifier)
          .login(ServerUrls(lan, wan), _user.text.trim(), _pass.text);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      _pass.clear();
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Entrar sem digitar a senha: mostra um código para aprovar no Jellyfin de um aparelho já logado.
  Future<void> _quickConnect() async {
    final wan = normalizeUrl(_wan.text);
    final lan = normalizeUrl(_lan.text, local: true);
    if (wan.isEmpty && lan.isEmpty) {
      setState(() {
        _showServer = true;
        _error = context.l10n.loginServerRequired;
      });
      return;
    }
    setState(() => _error = null);
    await ref.read(extrasUrlProvider.notifier).set(_extras.text);
    if (!mounted) return;
    final urls = ServerUrls(lan, wan);
    final err = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _QuickConnectDialog(urls),
    );
    if (err != null && mounted) setState(() => _error = err);
  }

  InputDecoration _dec(String label, {Widget? suffix}) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: Pm.elevated,
    suffixIcon: suffix,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: Pm.muted),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: Pm.muted),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: Colors.white, width: 2),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pm.black,
      body: SafeArea(
        child: Column(
          children: [
            // Barra de título arrastável (a janela não tem moldura).
            if (isDesktop)
              SizedBox(
                height: 40,
                child: Row(
                  children: [
                    const Expanded(
                      child: DragToMoveArea(child: SizedBox.expand()),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 18,
                        color: Pm.subdued,
                      ),
                      tooltip: context.l10n.commonClose,
                      onPressed: () => windowManager.close(),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    width: 440,
                    padding: EdgeInsets.all(isCompact(context) ? 24 : 40),
                    decoration: BoxDecoration(
                      color: Pm.base,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: AutofillGroup(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'assets/icon/pudim_256.png',
                                width: 96,
                                height: 96,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            context.l10n.loginTitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            context.l10n.loginSubtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Pm.subdued),
                          ),
                          const SizedBox(height: 32),
                          if (_error != null) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              color: const Color(0xFFE91429),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(_error!)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          TextField(
                            controller: _user,
                            autofocus: _user.text.isEmpty,
                            autofillHints: const [AutofillHints.username],
                            decoration: _dec(context.l10n.loginUsername),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _pass,
                            autofocus: _user.text.isNotEmpty,
                            obscureText: _obscure,
                            autofillHints: const [AutofillHints.password],
                            decoration: _dec(
                              context.l10n.loginPassword,
                              suffix: IconButton(
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Pm.subdued,
                                ),
                                tooltip: _obscure
                                    ? context.l10n.loginShowPassword
                                    : context.l10n.loginHidePassword,
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                              ),
                            ),
                            onSubmitted: (_) => _busy ? null : _submit(),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 48,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: Pm.green,
                                foregroundColor: Colors.black,
                                shape: const StadiumBorder(),
                              ),
                              onPressed: _busy ? null : _submit,
                              child: _busy
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.black,
                                      ),
                                    )
                                  : Text(
                                      context.l10n.loginSubmit,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 48,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Pm.text,
                                side: const BorderSide(color: Pm.muted),
                                shape: const StadiumBorder(),
                              ),
                              icon: const Icon(Icons.qr_code_2, size: 20),
                              label: Text(
                                context.l10n.loginQuickConnect,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              onPressed: _busy ? null : _quickConnect,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () =>
                                setState(() => _showServer = !_showServer),
                            child: Text(
                              _showServer
                                  ? context.l10n.loginHideAddresses
                                  : context.l10n.loginServerAddress,
                              style: const TextStyle(color: Pm.subdued),
                            ),
                          ),
                          if (_showServer) ...[
                            const SizedBox(height: 8),
                            TextField(
                              controller: _wan,
                              keyboardType: TextInputType.url,
                              decoration: _dec(
                                context.l10n.loginJellyfinServer,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              context.l10n.loginJellyfinServerExample,
                              style: const TextStyle(
                                color: Pm.muted,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _lan,
                              keyboardType: TextInputType.url,
                              decoration: _dec(context.l10n.loginLocalNetwork),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              context.l10n.loginLocalNetworkExample,
                              style: const TextStyle(
                                color: Pm.muted,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _extras,
                              keyboardType: TextInputType.url,
                              decoration: _dec(context.l10n.loginExtrasServer),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              context.l10n.loginExtrasServerHint,
                              style: const TextStyle(
                                color: Pm.muted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mostra o código do Quick Connect e espera alguém aprovar (fecha sozinho quando entra).
/// Devolve a mensagem de erro, ou null quando entrou ou a pessoa cancelou.
class _QuickConnectDialog extends ConsumerStatefulWidget {
  final ServerUrls urls;
  const _QuickConnectDialog(this.urls);
  @override
  ConsumerState<_QuickConnectDialog> createState() =>
      _QuickConnectDialogState();
}

class _QuickConnectDialogState extends ConsumerState<_QuickConnectDialog> {
  String? _code;
  Timer? _timer;
  bool _checking = false;
  final _started = DateTime.now();

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _start() async {
    final s = ref.read(sessionProvider.notifier);
    try {
      final (api, secret, code) = await s.quickConnectStart(widget.urls);
      if (!mounted) return;
      setState(() => _code = code);
      _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
        if (_checking) return;
        if (DateTime.now().difference(_started) > const Duration(minutes: 5)) {
          _timer?.cancel();
          if (mounted) {
            Navigator.pop(context, appL10n.loginQcExpired);
          }
          return;
        }
        _checking = true;
        try {
          if (await s.quickConnectPoll(widget.urls, api, secret)) {
            _timer?.cancel();
            if (mounted) Navigator.pop(context);
          }
        } catch (_) {
          // sem resposta agora: tenta de novo em 3 s
        } finally {
          _checking = false;
        }
      });
    } catch (e) {
      if (mounted) {
        Navigator.pop(context, e.toString().replaceFirst('Exception: ', ''));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final code = _code;
    return AlertDialog(
      backgroundColor: Pm.elevated,
      title: const Text('Quick Connect'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.loginQcInstructions,
              style: const TextStyle(color: Pm.subdued),
            ),
            const SizedBox(height: 20),
            Center(
              child: code == null
                  ? const SizedBox(
                      height: 48,
                      child: Center(
                        child: CircularProgressIndicator(color: Pm.green),
                      ),
                    )
                  : SelectableText(
                      code,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 8,
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.l10n.loginQcWaiting,
                    style: const TextStyle(color: Pm.subdued, fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.commonCancel),
        ),
      ],
    );
  }
}
