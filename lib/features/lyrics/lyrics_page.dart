import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/models.dart';
import '../../audio/player.dart';
import '../../state/session.dart';
import '../../ui/colors.dart';
import '../../ui/responsive.dart';
import '../../ui/theme.dart';
import 'lyrics_data.dart';

/// Letra em tela cheia, na cor da capa, com a linha atual em destaque.
class LyricsPage extends ConsumerWidget {
  const LyricsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cur = ref.watch(playerProvider.select((q) => q.current));
    if (cur == null) {
      return const ColoredBox(
        color: Pm.base,
        child: Center(
          child: Text(
            'Toque alguma coisa para ver a letra.',
            style: TextStyle(color: Pm.subdued, fontSize: 18),
          ),
        ),
      );
    }
    final api = ref.watch(apiProvider);
    final url = api.imageUrl(cur.imageItemId, size: 64);
    final color = url == null
        ? fallbackColor
        : ref.watch(coverColorProvider(url)).value ?? fallbackColor;
    final lyrics = ref.watch(lyricsProvider(cur.id));
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      color: darken(color, 0.15),
      child: lyrics.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (_, _) => const _NoLyrics(),
        data: (l) => l.isEmpty
            ? const _NoLyrics()
            : _LyricsView(l, key: ValueKey(cur.id)),
      ),
    );
  }
}

class _NoLyrics extends StatelessWidget {
  const _NoLyrics();
  @override
  Widget build(BuildContext context) => const Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Sem letra para esta música',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 8),
        Text(
          'Quando tiver um .lrc ou .txt ao lado do arquivo, ela aparece aqui.',
          style: TextStyle(color: Colors.white70),
        ),
      ],
    ),
  );
}

class _LyricsView extends ConsumerStatefulWidget {
  final Lyrics lyrics;
  const _LyricsView(this.lyrics, {super.key});
  @override
  ConsumerState<_LyricsView> createState() => _LyricsViewState();
}

class _LyricsViewState extends ConsumerState<_LyricsView> {
  final _keys = <int, GlobalKey>{};
  int _last = -1;

  GlobalKey _key(int i) => _keys.putIfAbsent(i, GlobalKey.new);

  void _follow(int i) {
    if (i == _last || i < 0) return;
    _last = i;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _keys[i]?.currentContext;
      if (ctx != null && ctx.mounted) {
        Scrollable.ensureVisible(
          ctx,
          alignment: 0.35,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.lyrics;
    final pos = ref.watch(positionProvider).value ?? Duration.zero;
    final idx = l.synced ? l.indexAt(pos) : -1;
    _follow(idx);
    final compact = isCompact(context);
    return SingleChildScrollView(
      padding: compact
          ? const EdgeInsets.fromLTRB(24, 16, 24, 48)
          : const EdgeInsets.fromLTRB(48, 48, 48, 160),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < l.lines.length; i++)
                Padding(
                  key: _key(i),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: MouseRegion(
                    cursor: l.synced
                        ? SystemMouseCursors.click
                        : MouseCursor.defer,
                    child: GestureDetector(
                      onTap: l.synced && l.lines[i].start != null
                          ? () => ref
                                .read(playerProvider.notifier)
                                .seek(l.lines[i].start!)
                          : null,
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: compact ? 24 : 32,
                          height: 1.3,
                          fontWeight: FontWeight.w800,
                          color: !l.synced
                              ? Colors.white
                              : i == idx
                              ? Colors.white
                              : i < idx
                              ? Colors.white.withValues(alpha: 0.7)
                              : Colors.black.withValues(alpha: 0.75),
                        ),
                        child: Text(
                          l.lines[i].text.isEmpty ? '♪' : l.lines[i].text,
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              Text(
                l.synced
                    ? 'Letra sincronizada do arquivo .lrc'
                    : 'Letra sem sincronização',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
