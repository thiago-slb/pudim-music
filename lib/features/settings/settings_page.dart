import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/l10n.dart';
import '../../ui/widgets/accounts.dart';

import '../../audio/player.dart';
import '../../state/locale.dart';
import '../../state/session.dart';
import '../../ui/responsive.dart';
import '../../ui/theme.dart';

import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/catalog.dart';
import '../../ui/widgets/actions.dart';
import '../../version.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(sessionProvider).value;
    final urls = ref.read(sessionProvider.notifier).urls;
    final autoplay = ref.read(playerProvider.notifier).autoplay;
    final extras = ref.watch(extrasUrlProvider);
    return Container(
      color: Pm.base,
      child: ListView(
        padding: isCompact(context)
            ? const EdgeInsets.fromLTRB(16, 64, 16, 32)
            : const EdgeInsets.fromLTRB(32, 24, 32, 64),
        children: [
          Text(
            context.l10n.commonSettings,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 24),
          _Section(context.l10n.settingsSectionAccount),
          _Row(
            title: context.l10n.commonProfile,
            subtitle: context.l10n.settingsProfileSubtitle,
            trailing: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Pm.text,
                side: const BorderSide(color: Pm.muted),
                shape: const StadiumBorder(),
              ),
              onPressed: () => context.go('/profile'),
              child: Text(context.l10n.commonEdit),
            ),
          ),
          _Row(
            title: s?.userName ?? '',
            subtitle: context.l10n.settingsConnectedAt(s?.api.baseUrl ?? '-'),
            trailing: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Pm.text,
                side: const BorderSide(color: Pm.muted),
                shape: const StadiumBorder(),
              ),
              onPressed: () async {
                await ref.read(playerProvider.notifier).stop();
                await ref.read(sessionProvider.notifier).logout();
              },
              child: Text(context.l10n.settingsSignOut),
            ),
          ),
          _Section(context.l10n.accountsTitle),
          const AccountsList(),
          const _LanguageRow(),
          _Section(context.l10n.settingsSectionServer),
          _Row(title: 'Jellyfin', subtitle: urls.wan.isEmpty ? '-' : urls.wan),
          if (urls.lan.isNotEmpty)
            _Row(title: context.l10n.settingsLocalNetwork, subtitle: urls.lan),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              context.l10n.settingsServerNote,
              style: const TextStyle(color: Pm.muted, fontSize: 12),
            ),
          ),
          _Row(
            title: context.l10n.settingsExtrasServer,
            subtitle: extras.isEmpty
                ? context.l10n.settingsExtrasNotConfigured
                : extras,
            trailing: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Pm.text,
                side: const BorderSide(color: Pm.muted),
                shape: const StadiumBorder(),
              ),
              onPressed: () => _editExtras(context, ref, extras),
              child: Text(
                extras.isEmpty
                    ? context.l10n.settingsConfigure
                    : context.l10n.settingsChange,
              ),
            ),
          ),
          _Section(context.l10n.settingsSectionPlayback),
          _AutoplayRow(initial: autoplay),
          const _NormalizeRow(),
          _QualityRow(
            prefKey: 'qWifi',
            title: context.l10n.settingsQualityWifi,
            subtitle: context.l10n.settingsQualityWifiSubtitle,
          ),
          if (Platform.isAndroid || Platform.isIOS)
            _QualityRow(
              prefKey: 'qMobile',
              title: context.l10n.settingsQualityMobile,
              subtitle: context.l10n.settingsQualityMobileSubtitle,
            ),
          if (extras.isNotEmpty) ...[
            const _Section('Last.fm'),
            const _LastfmRow(),
          ],
          _Section(context.l10n.settingsSectionAbout),
          _Row(title: 'Pudim', subtitle: context.l10n.settingsBuild(appBuild)),
        ],
      ),
    );
  }
}

Future<void> _editExtras(
  BuildContext context,
  WidgetRef ref,
  String current,
) async {
  final c = TextEditingController(text: current);
  final url = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Pm.elevated,
      title: Text(ctx.l10n.settingsExtrasServer),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: c,
            autofocus: true,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(
              hintText: 'https://extras.exemplo.com',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ctx.l10n.settingsExtrasEmptyHint,
            style: const TextStyle(color: Pm.subdued, fontSize: 12),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(ctx.l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, c.text),
          child: Text(ctx.l10n.commonSave),
        ),
      ],
    ),
  );
  c.dispose();
  if (url != null) await ref.read(extrasUrlProvider.notifier).set(url);
}

class _Section extends StatelessWidget {
  final String title;
  const _Section(this.title);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 8),
    child: Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    ),
  );
}

class _Row extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  const _Row({required this.title, this.subtitle, this.trailing});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14)),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: const TextStyle(color: Pm.subdued, fontSize: 13),
                ),
            ],
          ),
        ),
        ?trailing,
      ],
    ),
  );
}

class _AutoplayRow extends ConsumerStatefulWidget {
  final bool initial;
  const _AutoplayRow({required this.initial});
  @override
  ConsumerState<_AutoplayRow> createState() => _AutoplayRowState();
}

class _AutoplayRowState extends ConsumerState<_AutoplayRow> {
  late bool _v = widget.initial;
  @override
  Widget build(BuildContext context) => _Row(
    title: context.l10n.settingsAutoplay,
    subtitle: context.l10n.settingsAutoplaySubtitle,
    trailing: Switch(
      value: _v,
      activeTrackColor: Pm.green,
      onChanged: (v) {
        setState(() => _v = v);
        ref.read(playerProvider.notifier).setAutoplay(v);
      },
    ),
  );
}

/// Conectar o Last.fm: o painel pede um token, a pessoa autoriza na página do Last.fm e volta aqui.
class _LastfmRow extends ConsumerStatefulWidget {
  const _LastfmRow();
  @override
  ConsumerState<_LastfmRow> createState() => _LastfmRowState();
}

class _LastfmRowState extends ConsumerState<_LastfmRow> {
  LastfmStatus? _st;
  String? _token; // esperando a pessoa autorizar no navegador
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final st = await ref.read(catalogProvider).lastfm();
      // o player só manda scrobble com isto ligado
      await ref.read(prefsProvider).setBool('lastfm', st.connected);
      if (mounted) setState(() => _st = st);
    } catch (_) {
      if (mounted) setState(() => _st = const LastfmStatus(false, false, null));
    }
  }

  Future<void> _run(Future<void> Function() f) async {
    setState(() => _busy = true);
    try {
      await f();
    } catch (e) {
      if (mounted) toast(context, '$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  ButtonStyle get _outlined => OutlinedButton.styleFrom(
    foregroundColor: Pm.text,
    side: const BorderSide(color: Pm.muted),
    shape: const StadiumBorder(),
  );

  @override
  Widget build(BuildContext context) {
    final st = _st;
    if (st == null) {
      return _Row(
        title: context.l10n.settingsScrobble,
        subtitle: context.l10n.settingsLoading,
      );
    }
    if (!st.configured) {
      return _Row(
        title: context.l10n.settingsScrobble,
        subtitle: context.l10n.settingsLastfmNoKey,
      );
    }
    if (st.connected) {
      return _Row(
        title: context.l10n.settingsConnectedAs(st.name ?? ''),
        subtitle: context.l10n.settingsLastfmConnectedSubtitle,
        trailing: OutlinedButton(
          style: _outlined,
          onPressed: _busy
              ? null
              : () => _run(() async {
                  await ref.read(catalogProvider).lastfmDisconnect();
                  await _load();
                }),
          child: Text(context.l10n.settingsDisconnect),
        ),
      );
    }
    if (_token != null) {
      return _Row(
        title: context.l10n.settingsLastfmAuthorize,
        subtitle: context.l10n.settingsLastfmAuthorizeSubtitle,
        trailing: FilledButton(
          onPressed: _busy
              ? null
              : () => _run(() async {
                  await ref.read(catalogProvider).lastfmFinish(_token!);
                  _token = null;
                  await _load();
                  if (context.mounted) {
                    toast(context, context.l10n.settingsLastfmConnected);
                  }
                }),
          child: Text(context.l10n.settingsFinish),
        ),
      );
    }
    return _Row(
      title: context.l10n.settingsScrobble,
      subtitle: context.l10n.settingsLastfmScrobbleSubtitle,
      trailing: OutlinedButton(
        style: _outlined,
        onPressed: _busy
            ? null
            : () => _run(() async {
                final (tok, url) = await ref
                    .read(catalogProvider)
                    .lastfmConnect();
                await launchUrl(
                  Uri.parse(url),
                  mode: LaunchMode.externalApplication,
                );
                if (mounted) setState(() => _token = tok);
              }),
        child: Text(context.l10n.settingsConnect),
      ),
    );
  }
}

class _NormalizeRow extends ConsumerStatefulWidget {
  const _NormalizeRow();
  @override
  ConsumerState<_NormalizeRow> createState() => _NormalizeRowState();
}

class _NormalizeRowState extends ConsumerState<_NormalizeRow> {
  late bool _v = ref.read(playerProvider.notifier).normalize;
  @override
  Widget build(BuildContext context) => _Row(
    title: context.l10n.settingsNormalize,
    subtitle: context.l10n.settingsNormalizeSubtitle,
    trailing: Switch(
      value: _v,
      activeTrackColor: Pm.green,
      onChanged: (v) {
        setState(() => _v = v);
        ref.read(playerProvider.notifier).setNormalize(v);
      },
    ),
  );
}

/// Qualidade do streaming: arquivo original ou convertido pelo Jellyfin (AAC).
class _QualityRow extends ConsumerStatefulWidget {
  final String prefKey;
  final String title;
  final String subtitle;
  const _QualityRow({
    required this.prefKey,
    required this.title,
    required this.subtitle,
  });
  @override
  ConsumerState<_QualityRow> createState() => _QualityRowState();
}

class _QualityRowState extends ConsumerState<_QualityRow> {
  Map<int, String> _options(BuildContext context) => {
    0: context.l10n.settingsQualityOriginal,
    320: '320 kbps',
    256: '256 kbps',
    192: '192 kbps',
    128: '128 kbps',
  };
  late int _v = ref.read(prefsProvider).getInt(widget.prefKey) ?? 0;

  @override
  Widget build(BuildContext context) {
    final options = _options(context);
    return _Row(
      title: widget.title,
      subtitle: widget.subtitle,
      trailing: DropdownButton<int>(
        value: options.containsKey(_v) ? _v : 0,
        dropdownColor: Pm.elevated,
        underline: const SizedBox.shrink(),
        borderRadius: BorderRadius.circular(8),
        items: [
          for (final e in options.entries)
            DropdownMenuItem(value: e.key, child: Text(e.value)),
        ],
        onChanged: (v) {
          if (v == null) return;
          setState(() => _v = v);
          ref.read(prefsProvider).setInt(widget.prefKey, v);
          toast(context, context.l10n.settingsAppliesNextSong);
        },
      ),
    );
  }
}

/// Idioma da interface: o do aparelho ou um dos que o app traduz.
class _LanguageRow extends ConsumerWidget {
  const _LanguageRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(localeProvider)?.languageCode ?? '';
    return _Row(
      title: context.l10n.languageTitle,
      subtitle: context.l10n.languageSubtitle,
      trailing: DropdownButton<String>(
        value: const ['pt', 'en', 'es'].contains(current) ? current : '',
        dropdownColor: Pm.elevated,
        underline: const SizedBox.shrink(),
        borderRadius: BorderRadius.circular(8),
        items: [
          DropdownMenuItem(value: '', child: Text(context.l10n.languageSystem)),
          // nomes dos idiomas ficam na própria língua
          const DropdownMenuItem(value: 'pt', child: Text('Português')),
          const DropdownMenuItem(value: 'en', child: Text('English')),
          const DropdownMenuItem(value: 'es', child: Text('Español')),
        ],
        onChanged: (v) {
          if (v == null) return;
          ref.read(localeProvider.notifier).set(v.isEmpty ? null : Locale(v));
        },
      ),
    );
  }
}
