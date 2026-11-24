import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/models.dart';
import '../../audio/player.dart';
import '../../l10n/l10n.dart';
import '../../state/session.dart';
import '../../ui/colors.dart';
import '../../ui/responsive.dart';
import '../../ui/theme.dart';
import 'find_lyrics_button.dart';
import 'lyrics_data.dart';
import '../../ui/widgets/themed.dart';

/// Full-screen lyrics, in the cover color, with the current line highlighted.
class LyricsPage extends ConsumerWidget {
  const LyricsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cur = ref.watch(playerProvider.select((q) => q.current));
    if (cur == null) {
      return ColoredBox(
        color: Pm.base,
        child: Center(
          child: EmptyState(
            icon: Icons.lyrics_outlined,
            title: context.l10n.lyricsPlaySomething,
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
    final t = Pm.current;
    // Night keeps the cover color; the others use their own backdrop.
    final bg = switch (t.style) {
      UiStyle.night => BoxDecoration(color: darken(color, 0.15)),
      UiStyle.ruby => BoxDecoration(color: t.base),
      UiStyle.retro => const BoxDecoration(color: Colors.black),
      UiStyle.wave => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.lerp(color, t.accent, 0.6)!, t.base],
        ),
      ),
      UiStyle.glass => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color.lerp(color, t.accent, 0.5)!, t.press, t.black],
        ),
      ),
    };
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      decoration: bg,
      child: lyrics.when(
        loading: () => const Center(child: ThemedLoading()),
        error: (_, _) => _NoLyrics(cur),
        data: (l) =>
            l.isEmpty ? _NoLyrics(cur) : _LyricsView(l, key: ValueKey(cur.id)),
      ),
    );
  }
}

/// Line look per theme; [state] is -1 sung, 0 current (or unsynced), 1 still to come.
TextStyle _lineStyle({required bool compact, required int state}) {
  final t = Pm.current;
  final size = compact ? 24.0 : 32.0;
  switch (t.style) {
    case UiStyle.retro:
      return TextStyle(
        fontFamily: t.fontFamily,
        fontFamilyFallback: t.fontFamilyFallback,
        fontSize: size * 0.75,
        height: 1.5,
        color: state == 0
            ? t.accent
            : t.accent.withValues(alpha: state < 0 ? 0.5 : 0.25),
      );
    case UiStyle.glass:
      return TextStyle(
        fontSize: size,
        height: 1.3,
        fontWeight: FontWeight.w700,
        color: state == 0
            ? Colors.white
            : Colors.white.withValues(alpha: state < 0 ? 0.55 : 0.3),
        shadows: state == 0
            ? [Shadow(color: t.accent, blurRadius: 16)]
            : const [],
      );
    case UiStyle.ruby:
      return TextStyle(
        fontFamily: t.fontFamily,
        fontSize: size * 0.85,
        height: 1.35,
        fontWeight: state == 0 ? FontWeight.w700 : FontWeight.w500,
        color: state == 0
            ? Colors.white
            : Colors.white.withValues(alpha: state < 0 ? 0.5 : 0.35),
      );
    case UiStyle.wave:
      return TextStyle(
        fontFamily: t.fontFamily,
        fontSize: size * 1.1,
        height: 1.2,
        fontWeight: FontWeight.w900,
        letterSpacing: -0.5,
        color: state == 0
            ? Colors.white
            : Colors.white.withValues(alpha: state < 0 ? 0.6 : 0.3),
      );
    case UiStyle.night:
      return TextStyle(
        fontFamily: 'Segoe UI',
        fontSize: size,
        height: 1.3,
        fontWeight: FontWeight.w800,
        color: state == 0
            ? Colors.white
            : state < 0
            ? Colors.white.withValues(alpha: 0.7)
            : Colors.black.withValues(alpha: 0.75),
      );
  }
}

class _NoLyrics extends StatelessWidget {
  final Item track;
  const _NoLyrics(this.track);
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.l10n.lyricsNone,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.lyricsNoneHint,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 20),
        FindLyricsButton(track, key: ValueKey(track.id)),
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
                        style: _lineStyle(
                          compact: compact,
                          state: !l.synced || i == idx ? 0 : (i < idx ? -1 : 1),
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
                    ? context.l10n.lyricsSynced
                    : context.l10n.lyricsUnsynced,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
