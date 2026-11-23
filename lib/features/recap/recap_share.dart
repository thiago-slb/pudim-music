import 'dart:io' as io;
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../l10n/l10n.dart';
import '../../state/session.dart';
import '../../ui/theme.dart';
import '../../ui/widgets/actions.dart';
import '../../ui/widgets/disk_image.dart';

String _fmt(Object? v) {
  final n = (v is num ? v : num.tryParse('$v') ?? 0).round();
  return NumberFormat.decimalPattern(appL10n.localeName).format(n);
}

/// Cartões da Retrospectiva no formato de stories (9:16), para salvar ou mandar.
Future<void> showRecapShare(BuildContext context, Map<String, dynamic> r) =>
    showDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierColor: Colors.black87,
      builder: (_) => _ShareCards(r),
    );

class _ShareCards extends ConsumerStatefulWidget {
  final Map<String, dynamic> r;
  const _ShareCards(this.r);
  @override
  ConsumerState<_ShareCards> createState() => _ShareCardsState();
}

class _ShareCardsState extends ConsumerState<_ShareCards> {
  final _keys = List.generate(3, (_) => GlobalKey());
  final _page = PageController(viewportFraction: 0.86);
  int _at = 0;
  bool _busy = false;

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  Future<io.File> _render() async {
    final box =
        _keys[_at].currentContext!.findRenderObject() as RenderRepaintBoundary;
    final img = await box.toImage(pixelRatio: 1080 / box.size.width);
    final png = (await img.toByteData(format: ui.ImageByteFormat.png))!;
    final dir = await getTemporaryDirectory();
    final f = io.File(
      '${dir.path}/retrospectiva-${widget.r['year']}-${_at + 1}.png',
    );
    await f.writeAsBytes(png.buffer.asUint8List(), flush: true);
    return f;
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    setState(() => _busy = true);
    try {
      final f = await _render();
      final bytes = await f.readAsBytes();
      final path = await FilePicker.saveFile(
        dialogTitle: l10n.recapShareSaveDialog,
        fileName: f.uri.pathSegments.last,
        bytes: bytes,
        mimeType: 'image/png',
      );
      if (path != null && mounted) toast(context, context.l10n.recapShareSaved);
    } catch (e) {
      if (mounted) toast(context, context.l10n.recapShareSaveFailed('$e'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _share() async {
    final l10n = context.l10n;
    setState(() => _busy = true);
    try {
      final f = await _render();
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(f.path, mimeType: 'image/png')],
          text: l10n.recapShareText(widget.r['year'] as int),
        ),
      );
    } catch (e) {
      if (mounted) toast(context, context.l10n.recapShareShareFailed('$e'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cat = ref.watch(catalogProvider);
    final name = ref.watch(sessionProvider).value?.userName ?? '';
    final cards = [
      _SummaryCard(r: widget.r, name: name),
      _TopCard(
        r: widget.r,
        kind: 'top_artists',
        title: context.l10n.recapShareMyArtists,
        colors: const [Color(0xFF7A2BD6), Color(0xFFF037A5)],
        image: (x) => cat.recapImage(tipo: 'artista', artista: '${x['name']}'),
        line: (x) => '${x['name']}',
        sub: (x) => context.l10n.recapMinShort(_fmt(x['minutes'])),
        round: true,
      ),
      _TopCard(
        r: widget.r,
        kind: 'top_songs',
        title: context.l10n.recapShareMySongs,
        colors: const [Color(0xFF148A08), Color(0xFF0D3B66)],
        image: (x) => cat.recapImage(
          tipo: 'capa',
          item: x['item_id'] as String?,
          artista: x['artist'] as String?,
          album: x['album'] as String?,
        ),
        line: (x) => '${x['title']}',
        sub: (x) => '${x['artist']}',
      ),
    ];
    final h = MediaQuery.sizeOf(context).height;
    final cardH = (h - 200).clamp(320.0, 720.0);
    final mobile = io.Platform.isAndroid || io.Platform.isIOS;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: cardH,
            width: cardH * 9 / 16 / 0.86 + 40,
            child: PageView.builder(
              controller: _page,
              itemCount: cards.length,
              onPageChanged: (i) => setState(() => _at = i),
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 9 / 16,
                    child: RepaintBoundary(
                      key: _keys[i],
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: FittedBox(
                          child: SizedBox(
                            width: 360,
                            height: 640,
                            child: cards[i],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < cards.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _at ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == _at ? Pm.text : Pm.muted,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Pm.text,
                  side: const BorderSide(color: Pm.muted),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.download_rounded, size: 18),
                label: Text(context.l10n.recapShareSaveImage),
                onPressed: _busy ? null : _save,
              ),
              if (mobile) ...[
                const SizedBox(width: 12),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                  ),
                  icon: const Icon(Icons.ios_share, size: 18),
                  label: Text(context.l10n.recapShareButton),
                  onPressed: _busy ? null : _share,
                ),
              ],
              const SizedBox(width: 4),
              IconButton(
                tooltip: context.l10n.commonClose,
                icon: const Icon(Icons.close, color: Pm.subdued),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  final int year;
  const _Brand(this.year);
  @override
  Widget build(BuildContext context) => Row(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset('assets/icon/pudim_256.png', width: 26, height: 26),
      ),
      const SizedBox(width: 8),
      Text(
        context.l10n.recapBrand(year),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 14,
        ),
      ),
    ],
  );
}

class _SummaryCard extends StatelessWidget {
  final Map<String, dynamic> r;
  final String name;
  const _SummaryCard({required this.r, required this.name});

  @override
  Widget build(BuildContext context) {
    final genres = [
      for (final g in (r['top_genres'] as List? ?? const []))
        if (g is Map) '${g['name']}',
    ];
    final artist = (r['top_artists'] as List? ?? const [])
        .whereType<Map>()
        .map((a) => '${a['name']}')
        .firstOrNull;
    Widget stat(String n, String label) => Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            n,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E3264), Color(0xFF7B2FF7), Color(0xFFF037A5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Brand((r['year'] as num?)?.toInt() ?? DateTime.now().year),
          const Spacer(),
          Text(
            name.isEmpty
                ? context.l10n.recapShareMyYear
                : context.l10n.recapShareYearOf(name),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 24),
          stat(_fmt(r['minutes']), context.l10n.recapBigMinutes),
          stat(_fmt(r['songs']), context.l10n.recapBigSongs),
          stat(_fmt(r['artists']), context.l10n.recapBigArtists),
          if (artist != null) stat(artist, context.l10n.recapShareTopArtist),
          if (genres.isNotEmpty)
            Text(
              context.l10n.recapShareGenres(genres.take(3).join(', ')),
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _TopCard extends StatelessWidget {
  final Map<String, dynamic> r;
  final String kind, title;
  final List<Color> colors;
  final String Function(Map) image, line, sub;
  final bool round;
  const _TopCard({
    required this.r,
    required this.kind,
    required this.title,
    required this.colors,
    required this.image,
    required this.line,
    required this.sub,
    this.round = false,
  });

  @override
  Widget build(BuildContext context) {
    final list = (r[kind] as List? ?? const [])
        .whereType<Map>()
        .take(5)
        .toList();
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Brand((r['year'] as num?)?.toInt() ?? DateTime.now().year),
          const SizedBox(height: 28),
          if (list.isNotEmpty)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(round ? 100 : 8),
                child: Image(
                  image: DiskImage(image(list.first)),
                  width: 180,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      Container(width: 180, height: 180, color: Colors.black26),
                ),
              ),
            ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          for (final (i, x) in list.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 30,
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          line(x),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          sub(x),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
