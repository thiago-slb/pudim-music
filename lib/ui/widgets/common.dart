import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../api/models.dart';
import '../../state/offline.dart';
import '../../state/session.dart';
import '../../l10n/l10n.dart';
import '../theme.dart';
import 'offline_button.dart';
import 'theme_bits.dart';
import 'themed.dart';
import 'disk_image.dart';
import 'user_photo.dart';

/// Cover (square) or photo (round) of an item, with a placeholder.
class Cover extends ConsumerWidget {
  final Item? item;
  final double size;
  final bool round;
  final double radius;
  final String type;
  const Cover(
    this.item, {
    super.key,
    this.size = 48,
    this.round = false,
    this.radius = 4,
    this.type = 'Primary',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(apiProvider);
    final it = item;
    final url = it == null
        ? null
        : api.imageUrl(
            it.imageItemId,
            type: type,
            size: (size * 2).clamp(64, 800).round(),
          );
    final icon = switch (it?.kind) {
      ItemKind.artist => Icons.person_outline,
      ItemKind.playlist => Icons.queue_music,
      ItemKind.album => Icons.album_outlined,
      _ => Icons.music_note_outlined,
    };
    final placeholder = Container(
      color: Pm.highlight,
      alignment: Alignment.center,
      child: Icon(icon, color: Pm.muted, size: size * 0.4),
    );
    ref.watch(offlineProvider.select((o) => o.covers.length));
    final saved = it == null || type != 'Primary'
        ? null
        : ref.read(offlineProvider.notifier).coverFile(it.imageItemId);
    final img = saved != null
        ? Image.file(
            saved,
            width: size,
            height: size,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            errorBuilder: (_, _, _) => placeholder,
          )
        : url == null
        ? placeholder
        : Image(
            image: DiskImage(url),
            width: size,
            height: size,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            errorBuilder: (_, _, _) => placeholder,
          );
    return SizedBox(
      width: size,
      height: size,
      child: round
          ? ClipOval(child: img)
          : ClipRRect(borderRadius: BorderRadius.circular(radius), child: img),
    );
  }
}

/// Small album quality label ("FLAC" in green, the rest muted).
class QualityChip extends StatelessWidget {
  final String label;
  const QualityChip(this.label, {super.key});
  @override
  Widget build(BuildContext context) {
    final flac = label == 'FLAC';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: flac ? const Color(0xFF246240) : Pm.highlight,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: flac ? Colors.white : Pm.subdued,
        ),
      ),
    );
  }
}

/// The theme's play/pause button (round accent, bevelled key or glossy orb).
class GreenPlayButton extends StatelessWidget {
  final double size;
  final bool playing;
  final VoidCallback onPressed;
  const GreenPlayButton({
    super.key,
    this.size = 56,
    this.playing = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => HoverScale(
    child: ThemedPlayButton(size: size, playing: playing, onPressed: onPressed),
  );
}

class HoverScale extends StatefulWidget {
  final Widget child;
  final double scale;
  const HoverScale({super.key, required this.child, this.scale = 1.04});
  @override
  State<HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<HoverScale> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hover = true),
    onExit: (_) => setState(() => _hover = false),
    child: AnimatedScale(
      scale: _hover ? widget.scale : 1,
      duration: const Duration(milliseconds: 120),
      child: widget.child,
    ),
  );
}

/// Text link that underlines on mouse hover (artist name, album...).
class TextLink extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final TextStyle? style;
  const TextLink(this.text, {super.key, this.onTap, this.style});
  @override
  State<TextLink> createState() => _TextLinkState();
}

class _TextLinkState extends State<TextLink> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    final style = (widget.style ?? DefaultTextStyle.of(context).style).copyWith(
      decoration: _hover && widget.onTap != null
          ? TextDecoration.underline
          : TextDecoration.none,
      color: _hover && widget.onTap != null ? Pm.text : null,
    );
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.text,
          style: style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

/// "Artist 1, Artist 2" with each name clickable.
/// Cloud: it is in the catalog, not yet in the library (plays through the panel and downloads along).
class CloudBadge extends StatelessWidget {
  final double size;
  const CloudBadge({super.key, this.size = 14});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 4),
    child: Tooltip(
      message: context.l10n.widgetCommonCatalogBadge,
      child: Icon(Icons.cloud_outlined, size: size, color: Pm.subdued),
    ),
  );
}

class ArtistLinks extends StatelessWidget {
  final Item item;
  final TextStyle? style;
  const ArtistLinks(this.item, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    final list = item.artists.isNotEmpty ? item.artists : item.albumArtists;
    final st = style ?? TextStyle(color: Pm.subdued, fontSize: 13.5);
    if (list.isEmpty) return const SizedBox.shrink();
    return DefaultTextStyle(
      style: st,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      child: Wrap(
        clipBehavior: Clip.hardEdge,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (item.cloud) const CloudBadge(),
          OfflineBadge(item.id, size: st.fontSize ?? 14),
          for (var i = 0; i < list.length; i++) ...[
            TextLink(
              list[i].name,
              style: st,
              onTap: list[i].id.isEmpty
                  ? null
                  : () => context.go('/artist/${list[i].id}'),
            ),
            if (i < list.length - 1) Text(', ', style: st),
          ],
        ],
      ),
    );
  }
}

/// Section title with "Show all".
class SectionHeader extends StatelessWidget {
  final String title;
  final String? overline;
  final String? subtitle;
  final VoidCallback? onShowAll;
  const SectionHeader(
    this.title, {
    super.key,
    this.overline,
    this.subtitle,
    this.onShowAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (overline != null)
                  Text(
                    overline!,
                    style: TextStyle(color: Pm.subdued, fontSize: 13),
                  ),
                Text(
                  // Retro: uppercase labels; wave: heavier, tighter type.
                  Pm.current.style == UiStyle.retro
                      ? title.toUpperCase()
                      : title,
                  style: TextStyle(
                    fontSize:
                        (MediaQuery.sizeOf(context).width < 700 ? 20 : 24) +
                        (Pm.current.style == UiStyle.wave ? 4 : 0),
                    fontWeight: Pm.current.style == UiStyle.wave
                        ? FontWeight.w900
                        : FontWeight.w800,
                    letterSpacing: switch (Pm.current.style) {
                      UiStyle.wave => -0.6,
                      UiStyle.retro => 1.5,
                      _ => null,
                    },
                    color: Pm.current.style == UiStyle.retro ? Pm.accent : null,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(color: Pm.subdued, fontSize: 13),
                  ),
              ],
            ),
          ),
          if (onShowAll != null)
            TextLink(
              context.l10n.widgetCommonShowAll,
              onTap: onShowAll,
              style: TextStyle(
                color: Pm.subdued,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}

class Chip2 extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  /// Space on the right (use 0 inside a Wrap that already has spacing).
  final double gap;
  const Chip2(
    this.label, {
    super.key,
    required this.selected,
    required this.onTap,
    this.gap = 8,
  });

  @override
  Widget build(BuildContext context) {
    final t = Pm.current;
    final (deco, fg) = switch (t.style) {
      UiStyle.retro => (bevel(pressed: selected), selected ? t.accent : t.text),
      UiStyle.ruby => (
        BoxDecoration(
          color: selected ? t.text : const Color(0x1FFFFFFF),
          borderRadius: BorderRadius.circular(8),
        ),
        selected ? Colors.black : t.text,
      ),
      UiStyle.wave => (
        BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: selected
              ? LinearGradient(
                  colors: [t.accent, Color.lerp(t.accent, Colors.pink, 0.45)!],
                )
              : null,
          border: selected ? null : Border.all(color: t.muted, width: 1.5),
        ),
        selected ? t.onAccent : t.text,
      ),
      UiStyle.glass => (
        selected
            ? glass(radius: BorderRadius.circular(32))
                  .copyWith(boxShadow: const [])
            : BoxDecoration(
                color: t.elevated,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: t.accent.withValues(alpha: 0.4)),
              ),
        selected ? Colors.white : t.text,
      ),
      UiStyle.night => (
        BoxDecoration(
          color: selected ? t.text : t.highlight,
          borderRadius: BorderRadius.circular(32),
        ),
        selected ? Colors.black : t.text,
      ),
    };
    final retro = t.style == UiStyle.retro;
    return Padding(
      padding: EdgeInsets.only(right: gap),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 32,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: deco,
            child: Text(
              retro ? label.toUpperCase() : label,
              maxLines: 1,
              style: TextStyle(
                color: fg,
                fontSize: retro ? 12.5 : 14,
                fontWeight: t.style == UiStyle.wave && selected
                    ? FontWeight.w800
                    : FontWeight.w500,
                letterSpacing: retro ? 1 : null,
                height: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Row of pills with breathing room below (so the content does not touch them).
class ChipBar extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets padding;
  const ChipBar({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.only(top: 4, bottom: 16),
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: padding,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: children),
    ),
  );
}

class LoadingBox extends StatelessWidget {
  const LoadingBox({super.key});
  @override
  Widget build(BuildContext context) => const Center(
    child: Padding(padding: EdgeInsets.all(48), child: ThemedLoading()),
  );
}

class ErrorBox extends ConsumerWidget {
  final Object error;
  final VoidCallback? onRetry;
  const ErrorBox(this.error, {super.key, this.onRetry});
  @override
  Widget build(BuildContext context, WidgetRef ref) => Center(
    child: Padding(
      padding: const EdgeInsets.all(48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ThemedBadgeIcon(Icons.cloud_off_rounded),
          const SizedBox(height: 16),
          Text(
            Pm.current.style == UiStyle.retro
                ? context.l10n.widgetCommonSomethingWentWrong.toUpperCase()
                : context.l10n.widgetCommonSomethingWentWrong,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Pm.current.style == UiStyle.retro ? Pm.accent : null,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$error',
            style: TextStyle(color: Pm.subdued),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onRetry,
              child: Text(context.l10n.commonRetry),
            ),
          ],
          // No internet: what is on the device keeps playing.
          if (ref.watch(
            offlineProvider.select((o) => o.tracks.isNotEmpty),
          )) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () => context.go('/collection/offline'),
              icon: Icon(Icons.arrow_circle_down, color: Pm.accent),
              label: Text(context.l10n.widgetCommonListenDownloaded),
            ),
          ],
        ],
      ),
    ),
  );
}

/// Small icon with no background, which lights up on mouse hover.
class IconBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final double size;
  final Color? color;
  final bool active;
  const IconBtn(
    this.icon, {
    super.key,
    required this.tooltip,
    this.onPressed,
    this.size = 20,
    this.color,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? (active ? Pm.accent : Pm.subdued);
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: size),
        color: c,
        hoverColor: Colors.transparent,
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.hovered) && !active ? Pm.text : c,
          ),
        ),
      ),
    );
  }
}

/// Bubble with the user initial (opens Settings), as in the Spotify phone app.
class UserAvatar extends ConsumerWidget {
  final double size;
  const UserAvatar({super.key, this.size = 32});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.go('/settings'),
      child: MyPhoto(size: size),
    );
  }
}
