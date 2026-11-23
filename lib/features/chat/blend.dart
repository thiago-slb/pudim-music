import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../api/catalog.dart';
import '../../l10n/l10n.dart';
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
              ? context.l10n.blendWorking
              : b?.affinity != null
              ? context.l10n.blendAffinityButton(b!.affinity!)
              : context.l10n.blendCreate,
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
        title: Text(context.l10n.blendWith(widget.other.displayName)),
        content: Text(ctx.l10n.blendExplain),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(ctx.l10n.blendNotNow),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(ctx.l10n.blendCreate),
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
                ctx.l10n.blendAffinityTitle(b.affinity ?? 0),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (b.common.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  ctx.l10n.blendInCommon(b.common.join(', ')),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Pm.subdued),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(ctx, 'open'),
                  child: Text(ctx.l10n.blendOpen(b.tracks)),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, 'refresh'),
                    child: Text(ctx.l10n.blendRefreshNow),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: Pm.subdued),
                    onPressed: () => Navigator.pop(ctx, 'delete'),
                    child: Text(ctx.l10n.blendUndo),
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
          if (mounted) toast(context, context.l10n.blendRefreshing);
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
            title: Text(ctx.l10n.blendUndoTitle),
            content: Text(ctx.l10n.blendUndoBody(widget.other.displayName)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(ctx.l10n.commonCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(ctx.l10n.blendUndoConfirm),
              ),
            ],
          ),
        );
        if (sure != true) return;
        try {
          await cat.deleteBlend(widget.other.id);
          ref.invalidate(madeProvider);
          ref.invalidate(libraryProvider);
          if (mounted) toast(context, context.l10n.blendUndone);
        } catch (e) {
          if (mounted) toast(context, '$e');
        }
    }
  }
}
