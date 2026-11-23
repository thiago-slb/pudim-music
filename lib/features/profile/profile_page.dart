import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/catalog.dart';
import '../../state/session.dart';
import '../../ui/responsive.dart';
import '../../ui/theme.dart';
import '../../ui/widgets/actions.dart';

import 'package:file_picker/file_picker.dart';

import '../../ui/widgets/user_photo.dart';

final meProvider = FutureProvider.autoDispose<Contact>(
  (ref) => ref.watch(catalogProvider).me(),
);

/// Perfil: nome que aparece para os contatos, nome de usuário do Jellyfin e senha.
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});
  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _display = TextEditingController();
  final _user = TextEditingController();
  final _cur = TextEditingController();
  final _new = TextEditingController();
  final _new2 = TextEditingController();
  bool _loaded = false;
  String? _busy;

  @override
  void dispose() {
    for (final c in [_display, _user, _cur, _new, _new2]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _run(String what, Future<String> Function() job) async {
    setState(() => _busy = what);
    try {
      final msg = await job();
      if (mounted) toast(context, msg);
    } catch (e) {
      if (mounted) toast(context, '$e');
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  Future<void> _pickPhoto() => _run('photo', () async {
    final picked = await FilePicker.pickFiles(type: FileType.image);
    final f = picked.firstOrNull;
    if (f == null) return 'Nenhuma foto escolhida';
    final bytes = await f.readAsBytes();
    if (bytes.length > 8 * 1024 * 1024) return 'Foto grande demais (até 8 MB)';
    final ext = (f.extension ?? '').toLowerCase();
    final mime = ext == 'png'
        ? 'image/png'
        : ext == 'webp'
        ? 'image/webp'
        : 'image/jpeg';
    await ref.read(apiProvider).setMyImage(bytes, mime);
    ref.invalidate(myPhotoTagProvider);
    return 'Foto do perfil trocada';
  });

  Future<void> _removePhoto() => _run('photo', () async {
    await ref.read(apiProvider).deleteMyImage();
    ref.invalidate(myPhotoTagProvider);
    return 'Foto removida';
  });

  Future<void> _saveDisplay() => _run('display', () async {
    await ref.read(catalogProvider).saveDisplayName(_display.text.trim());
    ref.invalidate(meProvider);
    return 'Nome do perfil salvo';
  });

  Future<void> _rename() async {
    final name = _user.text.trim();
    final cur = ref.read(sessionProvider).value?.userName ?? '';
    if (name.isEmpty || name == cur) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Pm.elevated,
        title: const Text('Trocar o nome de usuário?'),
        content: Text(
          'Você passa a entrar como "$name" no Pudim, no Jellyfin e nos outros apps '
          '(Finamp, Feishin…). Suas Descobertas, Mistura e Retrospectiva vêm junto.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Trocar'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await _run('user', () async {
      final got = await ref.read(catalogProvider).renameUser(name);
      await ref.read(sessionProvider.notifier).renamed(got);
      ref.invalidate(meProvider);
      return 'Agora você entra como $got';
    });
  }

  Future<void> _password() async {
    if (_new.text.isEmpty) return toast(context, 'Digite a senha nova');
    if (_new.text != _new2.text) {
      return toast(context, 'As senhas novas não são iguais');
    }
    await _run('pw', () async {
      await ref.read(apiProvider).changePassword(_cur.text, _new.text);
      for (final c in [_cur, _new, _new2]) {
        c.clear();
      }
      return 'Senha trocada';
    });
  }

  @override
  Widget build(BuildContext context) {
    final me = ref.watch(meProvider);
    if (!_loaded && me.value != null) {
      _loaded = true;
      _display.text = me.value!.displayName;
      _user.text = me.value!.name;
    }
    final compact = isCompact(context);
    return Container(
      color: Pm.base,
      child: ListView(
        padding: compact
            ? const EdgeInsets.fromLTRB(16, 64, 16, 160)
            : const EdgeInsets.fromLTRB(32, 24, 32, 64),
        children: [
          const Text(
            'Perfil',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const MyPhoto(size: 96),
              const SizedBox(width: 20),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Save(
                      busy: _busy == 'photo',
                      label: 'Trocar foto',
                      onPressed: _pickPhoto,
                    ),
                    if (ref.watch(myPhotoTagProvider).value != null)
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Pm.subdued,
                        ),
                        onPressed: _busy == null ? _removePhoto : null,
                        child: const Text('Remover'),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (me.hasError && ref.watch(hasExtrasProvider))
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Não consegui falar com o servidor de extras; o nome do perfil e o de usuário ficam para depois.',
                style: TextStyle(color: Pm.subdued),
              ),
            ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ref.watch(hasExtrasProvider)) ...[
                const _Title('Nome no perfil'),
                const _Help('É como seus contatos veem você nas conversas.'),
                _Field(_display, hint: 'Seu nome'),
                _Save(
                  busy: _busy == 'display',
                  onPressed: me.value == null ? null : _saveDisplay,
                ),
                const _Title('Nome de usuário'),
                const _Help(
                  'O nome para entrar no Jellyfin (aqui e nos outros apps).',
                ),
                _Field(_user, hint: 'Usuário'),
                _Save(
                  busy: _busy == 'user',
                  label: 'Trocar usuário',
                  onPressed: me.value == null ? null : _rename,
                ),
                ],
                const _Title('Senha'),
                _Field(_cur, hint: 'Senha atual', obscure: true),
                _Field(_new, hint: 'Senha nova', obscure: true),
                _Field(_new2, hint: 'Repita a senha nova', obscure: true),
                _Save(
                  busy: _busy == 'pw',
                  label: 'Trocar senha',
                  onPressed: _password,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String text;
  const _Title(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 28, bottom: 4),
    child: Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    ),
  );
}

class _Help extends StatelessWidget {
  final String text;
  const _Help(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(color: Pm.subdued, fontSize: 13)),
  );
}

class _Field extends StatelessWidget {
  final TextEditingController c;
  final String hint;
  final bool obscure;
  const _Field(this.c, {required this.hint, this.obscure = false});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: TextField(
      controller: c,
      obscureText: obscure,
      autocorrect: !obscure,
      enableSuggestions: !obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Pm.elevated,
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

class _Save extends StatelessWidget {
  final bool busy;
  final String label;
  final VoidCallback? onPressed;
  const _Save({required this.busy, this.label = 'Salvar', this.onPressed});
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: Pm.green,
        foregroundColor: Colors.black,
        shape: const StadiumBorder(),
      ),
      onPressed: busy ? null : onPressed,
      child: busy
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    ),
  );
}
