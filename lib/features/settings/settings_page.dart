import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/l10n.dart';
import '../../ui/widgets/accounts.dart';

import '../../audio/player.dart';
import '../../state/app_theme.dart';
import '../../state/updater.dart';
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
                side: BorderSide(color: Pm.muted),
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
                side: BorderSide(color: Pm.muted),
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
          _Section(context.l10n.settingsSectionAppearance),
          const _ThemePicker(),
          _Section(context.l10n.settingsSectionServer),
          _Row(title: 'Jellyfin', subtitle: urls.wan.isEmpty ? '-' : urls.wan),
          if (urls.lan.isNotEmpty)
            _Row(title: context.l10n.settingsLocalNetwork, subtitle: urls.lan),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              context.l10n.settingsServerNote,
              style: TextStyle(color: Pm.muted, fontSize: 12),
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
                side: BorderSide(color: Pm.muted),
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
          if (Platform.isAndroid || Platform.isWindows) const _UpdateRow(),
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
            style: TextStyle(color: Pm.subdued, fontSize: 12),
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
                  style: TextStyle(color: Pm.subdued, fontSize: 13),
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
      activeTrackColor: Pm.accent,
      onChanged: (v) {
        setState(() => _v = v);
        ref.read(playerProvider.notifier).setAutoplay(v);
      },
    ),
  );
}

/// Connect Last.fm: the panel asks for a token, the user authorizes on the Last.fm page and comes
/// back here.
class _LastfmRow extends ConsumerStatefulWidget {
  const _LastfmRow();
  @override
  ConsumerState<_LastfmRow> createState() => _LastfmRowState();
}

class _LastfmRowState extends ConsumerState<_LastfmRow> {
  LastfmStatus? _st;
  String? _token; // waiting for the user to authorize in the browser
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final st = await ref.read(catalogProvider).lastfm();
      // the player only sends scrobbles with this on
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
    side: BorderSide(color: Pm.muted),
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
      activeTrackColor: Pm.accent,
      onChanged: (v) {
        setState(() => _v = v);
        ref.read(playerProvider.notifier).setNormalize(v);
      },
    ),
  );
}

/// Streaming quality: original file or converted by Jellyfin (AAC).
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

/// Interface language: the device's or one of those the app translates.
class _LanguageRow extends ConsumerWidget {
  const _LanguageRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(localeProvider)?.languageCode ?? '';
    return _Row(
      title: context.l10n.languageTitle,
      subtitle: context.l10n.languageSubtitle,
      trailing: DropdownButton<String>(
        value: appLanguages.contains(current) ? current : '',
        dropdownColor: Pm.elevated,
        underline: const SizedBox.shrink(),
        borderRadius: BorderRadius.circular(8),
        items: [
          DropdownMenuItem(value: '', child: Text(context.l10n.languageSystem)),
          // language names stay in their own language
          for (final code in appLanguages)
            DropdownMenuItem(
              value: code,
              child: Text(appLanguageNames[code] ?? code),
            ),
        ],
        onChanged: (v) {
          if (v == null) return;
          ref.read(localeProvider.notifier).set(v.isEmpty ? null : Locale(v));
        },
      ),
    );
  }
}

/// The five looks, each with a small preview of its colors.
class _ThemePicker extends ConsumerWidget {
  const _ThemePicker();

  String _desc(BuildContext context, String id) => switch (id) {
    'red' => context.l10n.themeRedDesc,
    'wave' => context.l10n.themeWaveDesc,
    'retro' => context.l10n.themeRetroDesc,
    'classic' => context.l10n.themeClassicDesc,
    _ => context.l10n.themeNightDesc,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(appThemeProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Row(
          title: context.l10n.settingsTheme,
          subtitle: context.l10n.settingsThemeSubtitle,
        ),
        for (final t in appThemes)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(Pm.radius),
              onTap: () => ref.read(appThemeProvider.notifier).set(t),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: t.id == current.id ? Pm.highlight : Pm.elevated,
                  borderRadius: BorderRadius.circular(Pm.radius),
                  border: Border.all(
                    color: t.id == current.id ? Pm.accent : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    ThemePreview(t),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            _desc(context, t.id),
                            style: TextStyle(color: Pm.subdued, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    if (t.id == current.id)
                      Icon(Icons.check_circle, color: Pm.accent),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Miniature phone screen in a theme's layout: content blocks, mini player shape and navigation.
class ThemePreview extends StatelessWidget {
  final AppTheme t;
  const ThemePreview(this.t, {super.key});

  @override
  Widget build(BuildContext context) {
    final st = t.style;
    Widget block(double h, {Color? c}) => Container(
      height: h,
      margin: const EdgeInsets.only(bottom: 3),
      decoration: BoxDecoration(
        color: c ?? t.elevated,
        borderRadius: BorderRadius.circular(t.coverRadius / 3),
      ),
    );
    final Widget mini = switch (st) {
      UiStyle.ruby => Container(
        height: 9,
        color: t.elevated,
        alignment: Alignment.topLeft,
        child: Container(height: 1.5, width: 24, color: t.accent),
      ),
      UiStyle.wave => Container(
        height: 9,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: LinearGradient(colors: [t.accent, t.black]),
        ),
      ),
      UiStyle.retro => Container(
        height: 10,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: t.highlight,
          border: Border.all(color: const Color(0xFF8A8A98)),
        ),
        padding: const EdgeInsets.all(2),
        child: Container(
          color: Colors.black,
          alignment: Alignment.centerLeft,
          child: Container(height: 2, width: 18, color: t.accent),
        ),
      ),
      UiStyle.glass => Container(
        height: 9,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [t.press, t.black],
          ),
          border: Border.all(
            color: t.accent.withValues(alpha: 0.7),
            width: 0.8,
          ),
        ),
      ),
      UiStyle.night => Container(
        height: 8,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: t.highlight,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    };
    final nav = Container(
      height: 8,
      color: t.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (var i = 0; i < 4; i++)
            Container(
              width: 6,
              height: 3,
              decoration: BoxDecoration(
                color: i == 0
                    ? (st == UiStyle.night || st == UiStyle.ruby
                          ? t.text
                          : t.accent)
                    : t.muted,
                borderRadius: BorderRadius.circular(
                  st == UiStyle.retro ? 0 : 2,
                ),
              ),
            ),
        ],
      ),
    );
    final Widget content = switch (st) {
      UiStyle.retro || UiStyle.glass => Column(
        children: [
          for (var i = 0; i < 5; i++)
            Container(
              height: 4,
              margin: const EdgeInsets.only(bottom: 2),
              color: i == 1
                  ? t.accent.withValues(alpha: 0.5)
                  : (st == UiStyle.glass && i.isEven
                        ? t.elevated
                        : t.highlight.withValues(alpha: 0.5)),
            ),
        ],
      ),
      UiStyle.ruby => Row(
        children: [
          Expanded(child: block(22)),
          const SizedBox(width: 3),
          Expanded(child: block(22)),
        ],
      ),
      UiStyle.wave => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 5,
            width: 30,
            color: t.text,
            margin: const EdgeInsets.only(bottom: 3),
          ),
          block(16, c: t.accent.withValues(alpha: 0.6)),
        ],
      ),
      UiStyle.night => Column(
        children: [
          block(10),
          Row(
            children: [
              Expanded(child: block(12)),
              const SizedBox(width: 3),
              Expanded(child: block(12)),
            ],
          ),
        ],
      ),
    };
    final hero = t.hero;
    return Container(
      width: 52,
      height: 74,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(t.radius == 0 ? 0 : 5),
        border: Border.all(color: t.highlight, width: 1.5),
        gradient: hero == null
            ? null
            : LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: hero,
              ),
        color: hero == null ? t.base : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          if (st == UiStyle.retro) nav,
          Expanded(
            child: Padding(padding: const EdgeInsets.all(4), child: content),
          ),
          mini,
          const SizedBox(height: 2),
          if (st != UiStyle.retro) nav,
        ],
      ),
    );
  }
}

/// "Check for updates": runs the check now and says what happened (also when it fails).
class _UpdateRow extends ConsumerWidget {
  const _UpdateRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = ref.watch(updateStatusProvider);
    final l = context.l10n;
    final text = switch (st.phase) {
      UpdatePhase.idle => null,
      UpdatePhase.checking => l.updateChecking,
      UpdatePhase.downloading => l.updateDownloading(
        st.remote,
        ((st.progress ?? 0) * 100).round(),
      ),
      UpdatePhase.upToDate => l.updateUpToDate(appBuild),
      UpdatePhase.ready => l.widgetUpdateReady,
      UpdatePhase.failed => l.updateFailed(st.error ?? ''),
      UpdatePhase.unavailable => l.updateUnavailable,
    };
    final busy =
        st.phase == UpdatePhase.checking || st.phase == UpdatePhase.downloading;
    return _Row(
      title: l.settingsCheckUpdates,
      subtitle: text,
      trailing: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Pm.text,
          side: BorderSide(color: Pm.muted),
          shape: const StadiumBorder(),
        ),
        onPressed: busy
            ? null
            : () => ref.read(updaterProvider.notifier).check(),
        child: Text(l.settingsCheckUpdates),
      ),
    );
  }
}
