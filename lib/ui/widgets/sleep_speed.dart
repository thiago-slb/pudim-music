import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../audio/player.dart';
import '../../audio/sleep_timer.dart';
import '../theme.dart';
import 'actions.dart';

String _short(Duration d) {
  if (d.inMinutes >= 1) return '${d.inMinutes + (d.inSeconds % 60 > 0 ? 1 : 0)} min';
  return '${d.inSeconds} s';
}

/// Botão do timer para dormir (lua). Verde e com o tempo que falta quando está ligado.
class SleepTimerButton extends ConsumerWidget {
  final double size;
  const SleepTimerButton({super.key, this.size = 18});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(sleepTimerProvider);
    final label = s.endOfTrack
        ? 'Para no fim da música'
        : s.active
        ? 'Para em ${_short(s.left)}'
        : 'Timer para dormir';
    return IconButton(
      tooltip: label,
      onPressed: () => _pick(context, ref),
      icon: Badge(
        isLabelVisible: s.until != null,
        backgroundColor: Pm.green,
        textColor: Colors.black,
        label: Text(s.until == null ? '' : '${(s.left.inSeconds / 60).ceil()}'),
        child: Icon(
          s.active ? Icons.bedtime : Icons.bedtime_outlined,
          size: size,
          color: s.active ? Pm.green : Pm.subdued,
        ),
      ),
    );
  }

  Future<void> _pick(BuildContext context, WidgetRef ref) async {
    final s = ref.read(sleepTimerProvider);
    final t = ref.read(sleepTimerProvider.notifier);
    const options = [5, 15, 30, 45, 60, 90];
    final choice = await showModalBottomSheet<Object>(
      context: context,
      useRootNavigator: true,
      backgroundColor: Pm.elevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
                child: Text(
                  s.active
                      ? (s.endOfTrack
                            ? 'Para no fim da música'
                            : 'Para em ${_short(s.left)}')
                      : 'Timer para dormir',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (s.active)
                ListTile(
                  leading: const Icon(Icons.close, color: Pm.subdued),
                  title: const Text('Desligar o timer'),
                  onTap: () => Navigator.pop(ctx, 'off'),
                ),
              for (final m in options)
                ListTile(
                  leading: const Icon(Icons.timer_outlined, color: Pm.subdued),
                  title: Text(m < 60 ? '$m minutos' : m == 60 ? '1 hora' : '1 hora e meia'),
                  onTap: () => Navigator.pop(ctx, m),
                ),
              ListTile(
                leading: const Icon(Icons.music_off_outlined, color: Pm.subdued),
                title: const Text('Fim da música'),
                onTap: () => Navigator.pop(ctx, 'end'),
              ),
            ],
          ),
        ),
      ),
    );
    if (choice == null || !context.mounted) return;
    if (choice == 'off') {
      t.cancel();
      toast(context, 'Timer desligado');
    } else if (choice == 'end') {
      t.endOfTrack();
      toast(context, 'A música para quando esta acabar');
    } else if (choice is int) {
      t.start(Duration(minutes: choice));
      toast(context, 'A música para em ${choice < 60 ? '$choice minutos' : choice == 60 ? '1 hora' : '1 hora e meia'}');
    }
  }
}

/// Velocidade (só aparece em podcast).
class SpeedButton extends ConsumerWidget {
  const SpeedButton({super.key});

  static const speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];

  static String label(double v) {
    var s = v.toStringAsFixed(2);
    while (s.endsWith('0')) {
      s = s.substring(0, s.length - 1);
    }
    if (s.endsWith('.')) s = s.substring(0, s.length - 1);
    return '${s.replaceAll('.', ',')}×';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cur = ref.watch(playerProvider.select((s) => s.current));
    if (cur == null || !cur.isPodcast) return const SizedBox.shrink();
    final v = ref.watch(speedProvider).value ?? 1.0;
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: v == 1.0 ? Pm.subdued : Pm.green,
        minimumSize: const Size(44, 36),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      onPressed: () async {
        final c = ref.read(playerProvider.notifier);
        final pick = await showModalBottomSheet<double>(
          context: context,
          useRootNavigator: true,
          backgroundColor: Pm.elevated,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (ctx) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 8, 24, 12),
                    child: Text(
                      'Velocidade do podcast',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  for (final s in speeds)
                    ListTile(
                      title: Text(label(s)),
                      trailing: s == v
                          ? const Icon(Icons.check, color: Pm.green)
                          : null,
                      onTap: () => Navigator.pop(ctx, s),
                    ),
                ],
              ),
            ),
          ),
        );
        if (pick != null) c.setPodcastSpeed(pick);
      },
      child: Text(
        label(v),
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
      ),
    );
  }
}
