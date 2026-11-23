import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../audio/player.dart';
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
          const Text(
            'Configurações',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 24),
          const _Section('Conta'),
          _Row(
            title: 'Perfil',
            subtitle: 'Nome, usuário e senha',
            trailing: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Pm.text,
                side: const BorderSide(color: Pm.muted),
                shape: const StadiumBorder(),
              ),
              onPressed: () => context.go('/profile'),
              child: const Text('Editar'),
            ),
          ),
          _Row(
            title: s?.userName ?? '',
            subtitle: 'Conectado em ${s?.api.baseUrl ?? '-'}',
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
              child: const Text('Sair'),
            ),
          ),
          const _Section('Servidor'),
          _Row(
            title: 'Jellyfin',
            subtitle: urls.wan.isEmpty ? '-' : urls.wan,
          ),
          if (urls.lan.isNotEmpty) _Row(title: 'Na rede local', subtitle: urls.lan),
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'Para trocar os endereços do Jellyfin, saia da conta e abra "Endereço do servidor" na tela de entrada.',
              style: TextStyle(color: Pm.muted, fontSize: 12),
            ),
          ),
          _Row(
            title: 'Servidor de extras',
            subtitle: extras.isEmpty
                ? 'Não configurado (chat, Jam, Blend, mixes e Retrospectiva ficam escondidos)'
                : extras,
            trailing: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Pm.text,
                side: const BorderSide(color: Pm.muted),
                shape: const StadiumBorder(),
              ),
              onPressed: () => _editExtras(context, ref, extras),
              child: Text(extras.isEmpty ? 'Configurar' : 'Trocar'),
            ),
          ),
          const _Section('Reprodução'),
          _AutoplayRow(initial: autoplay),
          const _NormalizeRow(),
          const _QualityRow(
            prefKey: 'qWifi',
            title: 'Qualidade no Wi-Fi',
            subtitle: 'Original toca o arquivo como está na biblioteca.',
          ),
          if (Platform.isAndroid || Platform.isIOS)
            const _QualityRow(
              prefKey: 'qMobile',
              title: 'Qualidade nos dados móveis',
              subtitle: 'Uma qualidade menor gasta menos internet do celular.',
            ),
          if (extras.isNotEmpty) ...[
            const _Section('Last.fm'),
            const _LastfmRow(),
          ],
          const _Section('Sobre'),
          const _Row(title: 'Pudim', subtitle: 'Build $appBuild'),
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
      title: const Text('Servidor de extras'),
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
          const Text(
            'Deixe vazio para desligar os extras.',
            style: TextStyle(color: Pm.subdued, fontSize: 12),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, c.text),
          child: const Text('Salvar'),
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
    title: 'Reprodução automática',
    subtitle: 'Quando a fila acabar, continua tocando músicas parecidas (mix do Jellyfin).',
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
      return const _Row(title: 'Scrobble', subtitle: 'Carregando…');
    }
    if (!st.configured) {
      return const _Row(
        title: 'Scrobble',
        subtitle:
            'O servidor de extras ainda não tem uma chave da API do Last.fm configurada.',
      );
    }
    if (st.connected) {
      return _Row(
        title: 'Conectado como ${st.name ?? ''}',
        subtitle: 'Tudo que você ouve no Pudim vai para o seu perfil do Last.fm.',
        trailing: OutlinedButton(
          style: _outlined,
          onPressed: _busy
              ? null
              : () => _run(() async {
                  await ref.read(catalogProvider).lastfmDisconnect();
                  await _load();
                }),
          child: const Text('Desconectar'),
        ),
      );
    }
    if (_token != null) {
      return _Row(
        title: 'Autorize na página do Last.fm',
        subtitle: 'Depois de clicar em "Yes, allow access" lá, volte e toque em Concluir.',
        trailing: FilledButton(
          onPressed: _busy
              ? null
              : () => _run(() async {
                  await ref.read(catalogProvider).lastfmFinish(_token!);
                  _token = null;
                  await _load();
                  if (context.mounted) toast(context, 'Last.fm conectado');
                }),
          child: const Text('Concluir'),
        ),
      );
    }
    return _Row(
      title: 'Scrobble',
      subtitle: 'Registra no seu Last.fm cada música que você ouve.',
      trailing: OutlinedButton(
        style: _outlined,
        onPressed: _busy
            ? null
            : () => _run(() async {
                final (tok, url) = await ref.read(catalogProvider).lastfmConnect();
                await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                if (mounted) setState(() => _token = tok);
              }),
        child: const Text('Conectar'),
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
    title: 'Normalizar o volume',
    subtitle: 'Deixa todas as músicas no mesmo volume, com a análise feita pelo Jellyfin.',
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
  static const _options = {
    0: 'Original',
    320: '320 kbps',
    256: '256 kbps',
    192: '192 kbps',
    128: '128 kbps',
  };
  late int _v = ref.read(prefsProvider).getInt(widget.prefKey) ?? 0;

  @override
  Widget build(BuildContext context) => _Row(
    title: widget.title,
    subtitle: widget.subtitle,
    trailing: DropdownButton<int>(
      value: _options.containsKey(_v) ? _v : 0,
      dropdownColor: Pm.elevated,
      underline: const SizedBox.shrink(),
      borderRadius: BorderRadius.circular(8),
      items: [
        for (final e in _options.entries)
          DropdownMenuItem(value: e.key, child: Text(e.value)),
      ],
      onChanged: (v) {
        if (v == null) return;
        setState(() => _v = v);
        ref.read(prefsProvider).setInt(widget.prefKey, v);
        toast(context, 'Vale a partir da próxima música');
      },
    ),
  );
}
