import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/models.dart';
import '../../l10n/l10n.dart';
import '../../ui/widgets/actions.dart';
import '../../ui/widgets/common.dart';
import 'lyrics_data.dart';

/// Pill shown where the lyrics would be when a song has none: looks them up (server providers,
/// then the public library) and they appear in place once found.
class FindLyricsButton extends ConsumerStatefulWidget {
  final Item track;
  const FindLyricsButton(this.track, {super.key});

  @override
  ConsumerState<FindLyricsButton> createState() => _FindLyricsButtonState();
}

class _FindLyricsButtonState extends ConsumerState<FindLyricsButton> {
  bool _busy = false;

  Future<void> _find() async {
    if (_busy) return;
    setState(() => _busy = true);
    final notFound = context.l10n.lyricsNotFound;
    final found = await findLyrics(ref, widget.track);
    if (!mounted) return;
    setState(() => _busy = false);
    if (!found) toast(context, notFound);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Chip2(
      _busy ? l.lyricsFinding : l.lyricsFind,
      selected: false,
      onTap: _find,
      icon: _busy
          ? const SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.lyrics_outlined),
    );
  }
}
