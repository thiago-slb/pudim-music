import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../api/models.dart';
import 'session.dart';
import 'notify.dart';

/// Álbum, playlist ou "Músicas curtidas" guardado no aparelho (ou as faixas baixadas uma a uma).
class OfflineCollection {
  final String id;
  final String name;
  final Item? head; // capa e nome do álbum/playlist
  final List<String> trackIds;
  const OfflineCollection(this.id, this.name, this.head, this.trackIds);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'head': ?head?.toStore(),
    'ids': trackIds,
  };

  factory OfflineCollection.fromJson(Map<String, dynamic> j) =>
      OfflineCollection(
        j['id'] as String,
        j['name'] as String? ?? '',
        j['head'] == null
            ? null
            : Item.fromStore(j['head'] as Map<String, dynamic>),
        [for (final x in (j['ids'] as List? ?? const [])) '$x'],
      );
}

class OfflineState {
  /// Faixas já no aparelho (o arquivo existe).
  final Map<String, Item> tracks;
  final Map<String, OfflineCollection> collections;

  /// Capas guardadas (id da imagem).
  final Set<String> covers;

  /// Faixas na fila de download -> progresso 0..1.
  final Map<String, double> pending;

  const OfflineState({
    this.tracks = const {},
    this.collections = const {},
    this.covers = const {},
    this.pending = const {},
  });

  bool has(String id) => tracks.containsKey(id);
  bool saved(String collectionId) => collections.containsKey(collectionId);

  /// Faixas de uma coleção que já estão no aparelho, na ordem dela.
  List<Item> tracksOf(String collectionId) => [
    for (final id in collections[collectionId]?.trackIds ?? const <String>[])
      ?tracks[id],
  ];

  OfflineState copyWith({
    Map<String, Item>? tracks,
    Map<String, OfflineCollection>? collections,
    Set<String>? covers,
    Map<String, double>? pending,
  }) => OfflineState(
    tracks: tracks ?? this.tracks,
    collections: collections ?? this.collections,
    covers: covers ?? this.covers,
    pending: pending ?? this.pending,
  );
}

/// Músicas no aparelho para ouvir sem internet. Os arquivos ficam na pasta do app
/// (`<suporte do app>/offline`), sem pedir permissão de armazenamento.
class OfflineNotifier extends Notifier<OfflineState> {
  /// Coleção das faixas baixadas uma a uma pelo menu.
  static const loose = '_avulsas';

  Directory? _dir;
  final _queue = <Item>[];
  bool _working = false;
  int _batchDone = 0; // baixadas nesta leva (para a notificação "3 de 20")
  final _dio = Dio();

  @override
  OfflineState build() {
    _init();
    return const OfflineState();
  }

  Future<Directory> _folder() async {
    if (_dir != null) return _dir!;
    final base = await getApplicationSupportDirectory();
    _dir = Directory('${base.path}${Platform.pathSeparator}offline');
    await _dir!.create(recursive: true);
    return _dir!;
  }

  String _audio(String id) => '${_dir!.path}${Platform.pathSeparator}$id.audio';
  String _cover(String id) => '${_dir!.path}${Platform.pathSeparator}$id.jpg';
  File get _index => File('${_dir!.path}${Platform.pathSeparator}index.json');

  /// Caminho do arquivo local da faixa, se já está no aparelho.
  String? audioPath(String id) =>
      _dir != null && state.has(id) ? _audio(id) : null;

  /// Capa guardada (para abrir sem internet).
  File? coverFile(String? imageId) =>
      _dir != null && imageId != null && state.covers.contains(imageId)
      ? File(_cover(imageId))
      : null;

  Future<void> _init() async {
    try {
      await _folder();
      if (!await _index.exists()) return;
      final j = jsonDecode(await _index.readAsString()) as Map<String, dynamic>;
      final tracks = <String, Item>{};
      (j['tracks'] as Map? ?? const {}).forEach((k, v) {
        if (File(_audio('$k')).existsSync()) {
          tracks['$k'] = Item.fromStore(v as Map<String, dynamic>);
        }
      });
      final cols = <String, OfflineCollection>{};
      (j['collections'] as Map? ?? const {}).forEach((k, v) {
        cols['$k'] = OfflineCollection.fromJson(v as Map<String, dynamic>);
      });
      final covers = {
        for (final c in (j['covers'] as List? ?? const []))
          if (File(_cover('$c')).existsSync()) '$c',
      };
      state = OfflineState(tracks: tracks, collections: cols, covers: covers);
      // Faltou terminar algum download da última vez: continua.
      final missing = <String>{
        for (final c in cols.values)
          for (final id in c.trackIds)
            if (!tracks.containsKey(id)) id,
      };
      if (missing.isNotEmpty) {
        // As pendentes ficam guardadas no índice com os dados da faixa.
        final pend = (j['pending'] as Map? ?? const {});
        final pending = <String, double>{};
        for (final id in missing) {
          final raw = pend[id];
          if (raw is Map<String, dynamic>) {
            _queue.add(Item.fromStore(raw));
            pending[id] = 0;
          }
        }
        state = state.copyWith(pending: pending);
        _pump();
      }
    } catch (_) {
      // Índice estragado: começa vazio (os arquivos ficam e são sobrescritos).
    }
  }

  Future<void> _saveIndex() async {
    await _folder();
    final pend = {for (final t in _queue) t.id: t.toStore()};
    await _index.writeAsString(
      jsonEncode({
        'tracks': {
          for (final e in state.tracks.entries) e.key: e.value.toStore(),
        },
        'collections': {
          for (final e in state.collections.entries) e.key: e.value.toJson(),
        },
        'covers': state.covers.toList(),
        'pending': pend,
      }),
    );
  }

  /// Guarda um álbum/playlist/curtidas no aparelho (e baixa o que falta).
  Future<void> saveCollection(
    String id,
    String name,
    Item? head,
    List<Item> tracks,
  ) async {
    final ok = tracks.where((t) => !t.isCatalog).toList();
    state = state.copyWith(
      collections: {
        ...state.collections,
        id: OfflineCollection(id, name, head, [for (final t in ok) t.id]),
      },
    );
    if (head != null) unawaited(_fetchCover(head.imageItemId));
    _enqueue(ok);
    await _saveIndex();
  }

  /// Baixa faixas soltas (menu ⋯ "Baixar no aparelho").
  Future<void> saveTracks(List<Item> tracks) async {
    final ok = tracks.where((t) => !t.isCatalog).toList();
    final cur = state.collections[loose];
    final ids = [...?cur?.trackIds];
    for (final t in ok) {
      if (!ids.contains(t.id)) ids.add(t.id);
    }
    state = state.copyWith(
      collections: {
        ...state.collections,
        loose: OfflineCollection(loose, 'Baixadas uma a uma', null, ids),
      },
    );
    _enqueue(ok);
    await _saveIndex();
  }

  Future<void> removeCollection(String id) async {
    final cols = {...state.collections}..remove(id);
    state = state.copyWith(collections: cols);
    await _prune();
  }

  /// Tira uma faixa do aparelho (de todas as coleções).
  Future<void> removeTrack(String id) async {
    final cols = {
      for (final e in state.collections.entries)
        e.key: OfflineCollection(
          e.value.id,
          e.value.name,
          e.value.head,
          e.value.trackIds.where((x) => x != id).toList(),
        ),
    };
    state = state.copyWith(collections: cols);
    await _prune();
  }

  /// Apaga os arquivos que nenhuma coleção usa mais.
  Future<void> _prune() async {
    final used = {for (final c in state.collections.values) ...c.trackIds};
    final keep = <String, Item>{};
    for (final e in state.tracks.entries) {
      if (used.contains(e.key)) {
        keep[e.key] = e.value;
      } else {
        try {
          await File(_audio(e.key)).delete();
        } catch (_) {}
      }
    }
    _queue.removeWhere((t) => !used.contains(t.id));
    if (_queue.isEmpty) Notify.cancel(Notify.offlineId);
    final pending = {
      for (final e in state.pending.entries)
        if (used.contains(e.key)) e.key: e.value,
    };
    state = state.copyWith(tracks: keep, pending: pending);
    await _saveIndex();
  }

  void _enqueue(List<Item> tracks) {
    final pending = {...state.pending};
    for (final t in tracks) {
      if (state.has(t.id) || pending.containsKey(t.id)) continue;
      pending[t.id] = 0;
      _queue.add(t);
    }
    state = state.copyWith(pending: pending);
    _pump();
  }

  Future<void> _pump() async {
    if (_working) return;
    _working = true;
    try {
      await _folder();
      while (_queue.isNotEmpty) {
        final t = _queue.first;
        _notifyProgress();
        final ok = await _download(t);
        _queue.remove(t);
        if (ok) _batchDone++;
        final pending = {...state.pending}..remove(t.id);
        state = state.copyWith(
          pending: pending,
          tracks: ok ? {...state.tracks, t.id: t} : state.tracks,
        );
        if (!ok) {
          // Sem rede: para e tenta de novo daqui a pouco, sem perder a fila.
          _queue.add(t);
          state = state.copyWith(pending: {...state.pending, t.id: 0});
          await _saveIndex();
          Timer(const Duration(seconds: 30), _pump);
          return;
        }
        await _saveIndex();
      }
      if (_batchDone > 0) {
        await Notify.cancel(Notify.offlineId);
        await Notify.show(
          Notify.offlineId + 100,
          'Baixadas no aparelho',
          _batchDone == 1
              ? '1 música pronta para ouvir sem internet'
              : '$_batchDone músicas prontas para ouvir sem internet',
        );
      }
      _batchDone = 0;
    } finally {
      _working = false;
    }
  }

  void _notifyProgress() {
    final total = _batchDone + _queue.length;
    final t = _queue.first;
    Notify.progress(
      Notify.offlineId,
      'Baixando no aparelho',
      '${_batchDone + 1} de $total • ${t.name}',
      done: _batchDone,
      total: total,
    );
  }

  Future<bool> _download(Item t) async {
    final api = ref.read(apiProvider);
    final tmp = '${_audio(t.id)}.part';
    try {
      await _dio.download(
        api.streamUrl(t.id),
        tmp,
        onReceiveProgress: (got, total) {
          if (total > 0 && state.pending.containsKey(t.id)) {
            state = state.copyWith(
              pending: {...state.pending, t.id: got / total},
            );
          }
        },
      );
      await File(tmp).rename(_audio(t.id));
      await _fetchCover(t.imageItemId);
      return true;
    } catch (_) {
      try {
        await File(tmp).delete();
      } catch (_) {}
      return false;
    }
  }

  Future<void> _fetchCover(String? imageId) async {
    if (imageId == null || state.covers.contains(imageId)) return;
    final url = ref.read(apiProvider).imageUrl(imageId, size: 600);
    if (url == null) return;
    try {
      await _folder();
      await _dio.download(url, _cover(imageId));
      state = state.copyWith(covers: {...state.covers, imageId});
    } catch (_) {}
  }

  /// Espaço usado no aparelho, em bytes.
  Future<int> usedBytes() async {
    final d = await _folder();
    var total = 0;
    await for (final f in d.list()) {
      if (f is File) total += await f.length();
    }
    return total;
  }

  /// Apaga tudo o que foi baixado.
  Future<void> clearAll() async {
    _queue.clear();
    final d = await _folder();
    await for (final f in d.list()) {
      try {
        await f.delete(recursive: true);
      } catch (_) {}
    }
    state = const OfflineState();
    await _saveIndex();
  }
}

final offlineProvider = NotifierProvider<OfflineNotifier, OfflineState>(
  OfflineNotifier.new,
);
