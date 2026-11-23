import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/catalog.dart';
import '../../l10n/l10n.dart';
import '../../state/downloads.dart';
import '../../state/session.dart';
import '../../ui/responsive.dart';
import '../../ui/theme.dart';
import '../../ui/widgets/actions.dart';
import '../../ui/widgets/disk_image.dart';

String _kind(L10n l, String type) => switch (type) {
  'Album' => l.catalogKindAlbum,
  'Single' => l.catalogKindSingle,
  'Broadcast' => l.catalogKindBroadcast,
  'Other' => l.catalogKindOther,
  _ => type, // EP and anything we don't recognize
};

String _sec(L10n l, String type) => switch (type) {
  'Live' => l.catalogSecLive,
  'Compilation' => l.catalogSecCompilation,
  'Soundtrack' => l.catalogSecSoundtrack,
  'Mixtape/Street' => l.catalogSecMixtape,
  'Interview' => l.catalogSecInterview,
  'Spokenword' => l.catalogSecSpokenword,
  'Remix' => 'remix',
  'Demo' => 'demo',
  _ => type, // DJ-mix and anything we don't recognize
};

/// "live · compilation" etc. of the album.
String planTag(L10n l, PlanAlbum a) => [
  if (a.type.isNotEmpty) _kind(l, a.type),
  for (final s in a.secondary) _sec(l, s),
].join(' · ');

/// Search albums: the discography missing from the library, with checkboxes to pick.
class AlbumPickerPage extends ConsumerStatefulWidget {
  final String artist;
  const AlbumPickerPage({super.key, required this.artist});

  @override
  ConsumerState<AlbumPickerPage> createState() => _AlbumPickerPageState();
}

class _AlbumPickerPageState extends ConsumerState<AlbumPickerPage> {
  AlbumPlan? _plan;
  String? _error;
  int _seconds = 0;
  final _picked = <int>{};
  bool _sending = false;
  Timer? _clock;
  bool _alive = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _alive = false;
    _clock?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    final cat = ref.read(catalogProvider);
    _clock = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });
    try {
      final token = await cat.startAlbumPlan(widget.artist);
      while (_alive) {
        await Future<void>.delayed(const Duration(milliseconds: 2500));
        if (!_alive) return;
        final p = await cat.albumPlan(token);
        if (p != null) {
          if (mounted) setState(() => _plan = p);
          break;
        }
      }
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    } finally {
      _clock?.cancel();
    }
  }

  void _pickAll(bool Function(PlanAlbum) test) => setState(() {
    _picked
      ..clear()
      ..addAll([
        for (var i = 0; i < _plan!.missing.length; i++)
          if (test(_plan!.missing[i])) i,
      ]);
  });

  Future<void> _send() async {
    final p = _plan!;
    final sel = [for (final i in _picked.toList()..sort()) p.missing[i]];
    setState(() => _sending = true);
    try {
      await ref.read(catalogProvider).getAlbums(p, sel);
      ref.read(downloadsProvider.notifier).refreshSoon();
      if (!mounted) return;
      final l = context.l10n;
      toast(
        context,
        sel.length == 1
            ? l.catalogDownloadingOne(sel.first.title)
            : l.catalogDownloadingMany(sel.length, p.artist),
      );
      Navigator.of(context).maybePop();
    } catch (e) {
      if (mounted) {
        setState(() => _sending = false);
        toast(context, '$e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = _plan;
    final compact = isCompact(context);
    final side = compact ? 16.0 : 32.0;
    final n = _picked.length;
    final sub = _error != null
        ? _error!
        : p == null
        ? l.catalogCheckingDiscography(_seconds)
        : [
            l.catalogToDownload(p.missing.length),
            l.catalogInLibraryCount(p.have),
            if (p.skippedOneSong > 0) l.catalogSkippedOneSong(p.skippedOneSong),
          ].join(' · ');

    return Container(
      color: Pm.base,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(side, compact ? 64 : 24, side, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p?.artist ?? widget.artist,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(sub, style: const TextStyle(color: Pm.subdued)),
                if (p != null && p.missing.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _Chip(l.catalogPickAll, () => _pickAll((_) => true)),
                      _Chip(
                        l.catalogPickStudio,
                        () => _pickAll((a) => a.studio),
                      ),
                      _Chip(l.catalogPickNone, () => _pickAll((_) => false)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Pm.green,
                      foregroundColor: Colors.black,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onPressed: n == 0 || _sending ? null : _send,
                    child: Text(
                      n == 0
                          ? l.catalogDownloadSelected
                          : l.catalogDownloadNSelected(n),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: p == null
                ? (_error == null
                      ? const Center(child: CircularProgressIndicator())
                      : const SizedBox.shrink())
                : p.missing.isEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: side),
                    child: Text(
                      l.catalogNothingMissing,
                      style: const TextStyle(color: Pm.subdued),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.fromLTRB(side - 8, 0, side - 8, 160),
                    itemCount: p.missing.length,
                    itemBuilder: (_, i) {
                      final a = p.missing[i];
                      final tag = planTag(l, a);
                      return CheckboxListTile(
                        value: _picked.contains(i),
                        onChanged: (v) => setState(
                          () => v == true ? _picked.add(i) : _picked.remove(i),
                        ),
                        activeColor: Pm.green,
                        checkColor: Colors.black,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        secondary: _Cover(a.rgid),
                        title: Text(
                          a.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          [
                            if (a.year.isNotEmpty) a.year,
                            if (tag.isNotEmpty) tag,
                            if (a.partial) l.catalogPartial,
                          ].join(' · '),
                          style: const TextStyle(color: Pm.subdued),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Album cover from the Cover Art Archive (MusicBrainz's cover database); music note if none.
class _Cover extends StatelessWidget {
  final String rgid;
  const _Cover(this.rgid);

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(4),
    child: SizedBox(
      width: 56,
      height: 56,
      child: Image(
        image: DiskImage(
          'https://coverartarchive.org/release-group/$rgid/front-250',
        ),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          color: Pm.elevated,
          child: const Icon(Icons.album, color: Pm.muted),
        ),
      ),
    ),
  );
}

class _Chip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _Chip(this.label, this.onTap);

  @override
  Widget build(BuildContext context) => OutlinedButton(
    style: OutlinedButton.styleFrom(
      foregroundColor: Pm.text,
      side: const BorderSide(color: Pm.muted),
      shape: const StadiumBorder(),
      visualDensity: VisualDensity.compact,
    ),
    onPressed: onTap,
    child: Text(label),
  );
}
