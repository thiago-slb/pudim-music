import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../api/catalog.dart';
import '../../state/library.dart';
import '../../state/session.dart';
import '../../ui/theme.dart';
import '../../ui/widgets/actions.dart';
import '../../ui/widgets/mix_button.dart';

/// Botão "Blend" no topo da conversa: cria ou abre a playlist que mistura o gosto das duas contas.
class BlendButton extends ConsumerStatefulWidget {
  final Contact other;
  const BlendButton(this.other, {super.key});
  @override
  ConsumerState<BlendButton> createState() => _BlendButtonState();
}

class _BlendButtonState extends ConsumerState<BlendButton> {
  bool _waiting = false;

  @override
  Widget build(BuildContext context) {
    final made = ref.watch(madeProvider).value;
    final b = made?.blendWith(widget.other.id);
    final busy = _waiting || (b?.running ?? false);
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: Pm.text,
          side: const BorderSide(color: Pm.muted),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          visualDensity: VisualDensity.compact,
        ),
        icon: busy
            ? const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.join_inner, size: 18),
        label: Text(
          busy
              ? 'Misturando…'
              : b?.affinity != null
              ? 'Blend ${b!.affinity}%'
              : 'Criar Blend',
        ),
        onPressed: busy
            ? null
            : () => b?.playlist != null ? _show(b!) : _create(),
      ),
    );
  }

  Future<void> _create() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Pm.elevated,
        title: Text('Blend com ${widget.other.displayName}'),
        content: const Text(
          'Uma playlist igual para vocês dois, com o que os dois ouvem, os artistas em comum '
          'e um pouco do que cada um mais gosta. Mostra a afinidade de vocês e se atualiza todo dia.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Agora não'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Criar Blend'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _waiting = true);
    try {
      await ref.read(catalogProvider).makeBlend(widget.other.id);
      for (var i = 0; i < 60 && mounted; i++) {
        await Future<void>.delayed(const Duration(seconds: 3));
        ref.invalidate(madeProvider);
        final m = await ref.read(madeProvider.future);
        final b = m?.blendWith(widget.other.id);
        if (b != null && !b.running) {
          ref.invalidate(libraryProvider);
          if (!mounted) return;
          setState(() => _waiting = false);
          if (b.error != null) {
            toast(context, b.error!);
          } else {
            await _show(b);
          }
          return;
        }
      }
    } catch (e) {
      if (mounted) toast(context, '$e');
    }
    if (mounted) setState(() => _waiting = false);
  }

  Future<void> _show(BlendInfo b) async {
    final action = await showDialog<String>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Pm.elevated,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 120,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFF037A5), Color(0xFF1ED760)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Text(
                  '${b.affinity ?? 0}%',
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Vocês têm ${b.affinity ?? 0}% de afinidade',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              if (b.common.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Em comum: ${b.common.join(', ')}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Pm.subdued),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(ctx, 'open'),
                  child: Text('Abrir o Blend (${b.tracks} músicas)'),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, 'refresh'),
                    child: const Text('Atualizar agora'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: Pm.subdued),
                    onPressed: () => Navigator.pop(ctx, 'delete'),
                    child: const Text('Desfazer Blend'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (!mounted) return;
    final cat = ref.read(catalogProvider);
    switch (action) {
      case 'open':
        context.push('/playlist/${b.playlist}');
      case 'refresh':
        try {
          await cat.makeBlend(widget.other.id);
          ref.invalidate(madeProvider);
          if (mounted) toast(context, 'Atualizando o Blend…');
          Timer(const Duration(seconds: 30), () {
            try {
              ref.invalidate(madeProvider);
              ref.invalidate(libraryProvider);
            } catch (_) {}
          });
        } catch (e) {
          if (mounted) toast(context, '$e');
        }
      case 'delete':
        final sure = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: Pm.elevated,
            title: const Text('Desfazer o Blend?'),
            content: Text(
              'A playlist some para você e para ${widget.other.displayName}.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Desfazer'),
              ),
            ],
          ),
        );
        if (sure != true) return;
        try {
          await cat.deleteBlend(widget.other.id);
          ref.invalidate(madeProvider);
          ref.invalidate(libraryProvider);
          if (mounted) toast(context, 'Blend desfeito');
        } catch (e) {
          if (mounted) toast(context, '$e');
        }
    }
  }
}
