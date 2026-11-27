// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class L10nPt extends L10n {
  L10nPt([String locale = 'pt']) : super(locale);

  @override
  String get languageTitle => 'Idioma';

  @override
  String get languageSubtitle => 'Idioma da interface';

  @override
  String get languageSystem => 'Padrão do sistema';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonClose => 'Fechar';

  @override
  String get commonBack => 'Voltar';

  @override
  String get commonSave => 'Salvar';

  @override
  String get commonEdit => 'Editar';

  @override
  String get commonDelete => 'Excluir';

  @override
  String get commonRemove => 'Remover';

  @override
  String get commonOk => 'OK';

  @override
  String get commonRetry => 'Tentar de novo';

  @override
  String get commonQueue => 'Fila';

  @override
  String get commonAlbum => 'Álbum';

  @override
  String get commonAlbums => 'Álbuns';

  @override
  String get commonArtist => 'Artista';

  @override
  String get commonArtists => 'Artistas';

  @override
  String get commonSong => 'Música';

  @override
  String get commonSongs => 'Músicas';

  @override
  String get commonPlaylist => 'Playlist';

  @override
  String get commonPlaylists => 'Playlists';

  @override
  String get commonSingle => 'Single';

  @override
  String get commonLikedSongs => 'Músicas curtidas';

  @override
  String get commonAddToLiked => 'Adicionar a Músicas curtidas';

  @override
  String get commonRemoveFromLiked => 'Remover das Músicas curtidas';

  @override
  String get commonShufflePlay => 'Tocar em ordem aleatória';

  @override
  String get commonPlay => 'Tocar';

  @override
  String get commonPause => 'Pausar';

  @override
  String get commonFollow => 'Seguir';

  @override
  String get commonFollowing => 'Seguindo';

  @override
  String get commonDownloadToDevice => 'Baixar no aparelho';

  @override
  String get commonRemoveFromDevice => 'Remover do aparelho';

  @override
  String get commonDownloaded => 'Baixadas';

  @override
  String get commonDownloads => 'Downloads';

  @override
  String get commonAll => 'Tudo';

  @override
  String get commonRecentlyPlayed => 'Tocadas recentemente';

  @override
  String get commonYourLibrary => 'Sua Biblioteca';

  @override
  String get commonHome => 'Início';

  @override
  String get commonSearch => 'Buscar';

  @override
  String get commonProfile => 'Perfil';

  @override
  String get commonSettings => 'Configurações';

  @override
  String get commonBuilding => 'Montando…';

  @override
  String get commonBuildNow => 'Montar agora';

  @override
  String get commonShows => 'Shows';

  @override
  String get commonPodcasts => 'Podcasts';

  @override
  String commonSongCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count músicas',
      one: '1 música',
      zero: 'Nenhuma música',
    );
    return '$_temp0';
  }

  @override
  String commonMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutos',
      one: '1 minuto',
    );
    return '$_temp0';
  }

  @override
  String commonError(String error) {
    return 'Erro: $error';
  }

  @override
  String get apiStatusQueued => 'Na fila';

  @override
  String get apiStatusDownloading => 'Baixando';

  @override
  String get apiStatusDone => 'Chegou na biblioteca';

  @override
  String get apiStatusUpToDate => 'Já estava na biblioteca';

  @override
  String get apiStatusPartial => 'Chegou em parte';

  @override
  String get apiStatusNotFound => 'Não encontrado';

  @override
  String get apiStatusCancelled => 'Cancelado';

  @override
  String get apiStatusInterrupted => 'Interrompido';

  @override
  String get apiStatusFailed => 'Falhou';

  @override
  String get apiExtrasNoResponse => 'O servidor de extras não respondeu.';

  @override
  String get apiAlbumListFailed => 'Não consegui listar os álbuns.';

  @override
  String apiPlaylistSaved(int found, int total) {
    return 'Playlist na Sua Biblioteca ($found de $total músicas)';
  }

  @override
  String apiPlaylistDownloading(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count músicas',
      one: '1 música',
    );
    return 'Playlist na Sua Biblioteca; baixando mais $_temp0';
  }

  @override
  String get apiBadCredentials => 'Usuário ou senha incorretos.';

  @override
  String get apiServerUnreachable => 'Não consegui falar com o servidor.';

  @override
  String get apiQuickConnectOff =>
      'O Quick Connect está desligado neste servidor.';

  @override
  String get apiWrongCurrentPassword => 'A senha atual não confere.';

  @override
  String stateChatShared(String title) {
    return 'Compartilhou $title';
  }

  @override
  String stateDownloadingName(String name) {
    return 'Baixando $name';
  }

  @override
  String stateDownloadingRequests(int count) {
    return 'Baixando $count pedidos';
  }

  @override
  String stateDownloadArrived(String name) {
    return '$name chegou na biblioteca';
  }

  @override
  String stateDownloadPartial(String name) {
    return '$name chegou em parte';
  }

  @override
  String stateDownloadEnded(String name, String status) {
    return '$name: $status';
  }

  @override
  String get stateNotFromCatalog => 'Esse item não veio do catálogo.';

  @override
  String stateAlreadyDownloading(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Já está baixando o álbum.',
      'artist': 'Já está baixando a discografia.',
      'other': 'Já está baixando a música.',
    });
    return '$_temp0';
  }

  @override
  String stateDownloadRequested(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Baixando o álbum. Aparece no sino quando chegar.',
      'artist': 'Baixando a discografia. Aparece no sino quando chegar.',
      'other': 'Baixando a música. Aparece no sino quando chegar.',
    });
    return '$_temp0';
  }

  @override
  String get stateNotifyDownloadsChannel => 'Downloads';

  @override
  String get stateNotifyDownloadsChannelDesc =>
      'Progresso das músicas baixando';

  @override
  String get stateNotifyNewsChannel => 'Novidades';

  @override
  String get stateNotifyNewsChannelDesc =>
      'Músicas que chegaram, lançamentos, Descobertas e Mistura';

  @override
  String get stateOfflineLoose => 'Baixadas uma a uma';

  @override
  String get stateOfflineDoneTitle => 'Baixadas no aparelho';

  @override
  String stateOfflineDoneBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count músicas prontas para ouvir sem internet',
      one: '1 música pronta para ouvir sem internet',
    );
    return '$_temp0';
  }

  @override
  String get stateOfflineProgressTitle => 'Baixando no aparelho';

  @override
  String stateOfflineProgressBody(int done, int total, String name) {
    return '$done de $total • $name';
  }

  @override
  String get stateServerNoReply =>
      'O servidor não respondeu. Confira o endereço.';

  @override
  String get stateServerNoReplyBoth =>
      'O servidor não respondeu em nenhum dos dois endereços.';

  @override
  String get stateTokenStoreUnsupported =>
      'Por enquanto o Pudim só guarda login no Windows e no Android.';

  @override
  String get stateQualityPoor => 'som fraco';

  @override
  String get stateQualityPartial => 'incompleto';

  @override
  String get audioPlaybackChannel => 'Reprodução';

  @override
  String get audioRecentAlbums => 'Álbuns recentes';

  @override
  String audioSearchContext(String query) {
    return 'Busca: $query';
  }

  @override
  String audioRadioContext(String name) {
    return 'Rádio de $name';
  }

  @override
  String podcastsMonthShort(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': 'jan',
      'm2': 'fev',
      'm3': 'mar',
      'm4': 'abr',
      'm5': 'mai',
      'm6': 'jun',
      'm7': 'jul',
      'm8': 'ago',
      'm9': 'set',
      'm10': 'out',
      'm11': 'nov',
      'other': 'dez',
    });
    return '$_temp0';
  }

  @override
  String podcastsDateThisYear(int day, String month) {
    return '$day de $month';
  }

  @override
  String podcastsDateOtherYear(int day, String month, int year) {
    return '$day de $month de $year';
  }

  @override
  String podcastsHoursMin(int h, int min) {
    return '$h h $min min';
  }

  @override
  String podcastsMin(int min) {
    return '$min min';
  }

  @override
  String get podcastsPlayed => 'ouvido';

  @override
  String podcastsTimeLeft(String time) {
    return 'faltam $time';
  }

  @override
  String get podcastsSearchHint => 'Buscar podcasts';

  @override
  String get podcastsNothingFound => 'Nada encontrado.';

  @override
  String get podcastsYours => 'Seus podcasts';

  @override
  String get podcastsNewEpisodes => 'Episódios novos';

  @override
  String get podcastsTrendingBrazil => 'Em alta no Brasil';

  @override
  String get podcastsLoadFailed => 'Não carregou. Tentar de novo';

  @override
  String get podcastsNoEpisodes => 'Nenhum episódio no feed.';

  @override
  String podcastsNoEpisodeMatch(String q) {
    return 'Nenhum episódio com \"$q\".';
  }

  @override
  String get podcastsKind => 'Podcast';

  @override
  String get podcastsEpisodes => 'Episódios';

  @override
  String podcastsEpisodesCount(int total) {
    return 'Episódios ($total)';
  }

  @override
  String get podcastsFindEpisode => 'Procurar episódio';

  @override
  String showsMonthName(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': 'janeiro',
      'm2': 'fevereiro',
      'm3': 'março',
      'm4': 'abril',
      'm5': 'maio',
      'm6': 'junho',
      'm7': 'julho',
      'm8': 'agosto',
      'm9': 'setembro',
      'm10': 'outubro',
      'm11': 'novembro',
      'other': 'dezembro',
    });
    return '$_temp0';
  }

  @override
  String showsMonthYear(String month, int year) {
    return '$month de $year';
  }

  @override
  String showsWeekdayShort(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'w1': 'seg',
      'w2': 'ter',
      'w3': 'qua',
      'w4': 'qui',
      'w5': 'sex',
      'w6': 'sáb',
      'other': 'dom',
    });
    return '$_temp0';
  }

  @override
  String get showsFollowingNone => 'Dos artistas que você segue';

  @override
  String showsFollowingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dos $count artistas que você segue',
      one: 'Do 1 artista que você segue',
    );
    return '$_temp0';
  }

  @override
  String showsSearchingFor(int count) {
    return 'procurando shows de $count…';
  }

  @override
  String get showsUpcoming => 'Próximos';

  @override
  String get showsPast => 'Já aconteceram';

  @override
  String get showsInBrazil => 'No Brasil';

  @override
  String get showsEmptyFollow =>
      'Siga artistas (botão Seguir na página do artista) para ver os shows deles aqui.';

  @override
  String get showsNonePast => 'Nenhum show registrado ainda.';

  @override
  String get showsNoneUpcoming => 'Nenhum show marcado por enquanto.';

  @override
  String get showsStillSearching => 'Ainda procurando…';

  @override
  String get showsSource =>
      'Datas do MusicBrainz (feito por fãs); shows novos podem demorar a aparecer.';

  @override
  String get showsCancelled => 'cancelado';

  @override
  String get showsFestival => 'festival';

  @override
  String get catalogKindAlbum => 'Álbum';

  @override
  String get catalogKindSingle => 'Single';

  @override
  String get catalogKindBroadcast => 'Transmissão';

  @override
  String get catalogKindOther => 'Outro';

  @override
  String get catalogSecLive => 'ao vivo';

  @override
  String get catalogSecCompilation => 'coletânea';

  @override
  String get catalogSecSoundtrack => 'trilha sonora';

  @override
  String get catalogSecMixtape => 'mixtape';

  @override
  String get catalogSecInterview => 'entrevista';

  @override
  String get catalogSecSpokenword => 'falado';

  @override
  String catalogDownloadingOne(String title) {
    return 'Baixando $title';
  }

  @override
  String catalogDownloadingMany(int count, String artist) {
    return 'Baixando $count álbuns de $artist';
  }

  @override
  String catalogCheckingDiscography(int seconds) {
    return 'Conferindo a discografia… ${seconds}s';
  }

  @override
  String catalogToDownload(int count) {
    return '$count para baixar';
  }

  @override
  String catalogInLibraryCount(int count) {
    return '$count já na biblioteca';
  }

  @override
  String catalogSkippedOneSong(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de 1 música ficam de fora',
      one: '1 de 1 música fica de fora',
    );
    return '$_temp0';
  }

  @override
  String get catalogPickAll => 'Todos';

  @override
  String get catalogPickStudio => 'Estúdio';

  @override
  String get catalogPickNone => 'Nenhum';

  @override
  String get catalogDownloadSelected => 'Baixar selecionados';

  @override
  String catalogDownloadNSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Baixar $count selecionados',
      one: 'Baixar 1 selecionado',
    );
    return '$_temp0';
  }

  @override
  String get catalogNothingMissing => 'Nada faltando.';

  @override
  String get catalogPartial => 'parcial';

  @override
  String get catalogDownload => 'Baixar';

  @override
  String get catalogAddToLibrary => 'Adicionar à Sua Biblioteca';

  @override
  String get catalogInYourLibrary => 'Na Sua Biblioteca';

  @override
  String get catalogAllInLibrary => 'tudo na biblioteca';

  @override
  String catalogNInLibrary(int count) {
    return '$count na biblioteca';
  }

  @override
  String get catalogDownloadAlbum => 'Baixar álbum';

  @override
  String get catalogArtistNotFound => 'Artista não encontrado.';

  @override
  String get catalogFromCatalog => 'Do catálogo: ainda não está na biblioteca';

  @override
  String get catalogDownloadAll => 'Baixar tudo';

  @override
  String get catalogDownloadDiscography => 'Baixar discografia';

  @override
  String get catalogPopular => 'Populares';

  @override
  String get catalogShowLess => 'Mostrar menos';

  @override
  String get catalogShowMore => 'Ver mais';

  @override
  String get catalogSinglesEps => 'Singles e EPs';

  @override
  String get catalogFansAlsoLike => 'Fãs também curtem';

  @override
  String get lyricsPlaySomething => 'Toque alguma coisa para ver a letra.';

  @override
  String get lyricsNone => 'Sem letra para esta música';

  @override
  String get lyricsNoneHint =>
      'Quando tiver um .lrc ou .txt ao lado do arquivo, ela aparece aqui.';

  @override
  String get lyricsFind => 'Buscar letra';

  @override
  String get lyricsFinding => 'Procurando a letra…';

  @override
  String get lyricsNotFound => 'Não achei a letra desta música';

  @override
  String get lyricsSynced => 'Letra sincronizada do arquivo .lrc';

  @override
  String get lyricsUnsynced => 'Letra sem sincronização';

  @override
  String get profileChangePhoto => 'Trocar foto';

  @override
  String get profileNoPhoto => 'Nenhuma foto escolhida';

  @override
  String get profilePhotoTooBig => 'Foto grande demais (até 8 MB)';

  @override
  String get profilePhotoChanged => 'Foto do perfil trocada';

  @override
  String get profilePhotoRemoved => 'Foto removida';

  @override
  String get profileNameSaved => 'Nome do perfil salvo';

  @override
  String get profileRenameTitle => 'Trocar o nome de usuário?';

  @override
  String profileRenameBody(String name) {
    return 'Você passa a entrar como \"$name\" no Pudim, no Jellyfin e nos outros apps (Finamp, Feishin…). Suas Descobertas, Mistura e Retrospectiva vêm junto.';
  }

  @override
  String get profileRenameConfirm => 'Trocar';

  @override
  String profileNowSignedAs(String name) {
    return 'Agora você entra como $name';
  }

  @override
  String get profileEnterNewPassword => 'Digite a senha nova';

  @override
  String get profilePasswordsDiffer => 'As senhas novas não são iguais';

  @override
  String get profilePasswordChanged => 'Senha trocada';

  @override
  String get profileExtrasUnreachable =>
      'Não consegui falar com o servidor de extras; o nome do perfil e o de usuário ficam para depois.';

  @override
  String get profileNameSection => 'Nome no perfil';

  @override
  String get profileNameHelp => 'É como seus contatos veem você nas conversas.';

  @override
  String get profileYourName => 'Seu nome';

  @override
  String get profileUsernameSection => 'Nome de usuário';

  @override
  String get profileUsernameHelp =>
      'O nome para entrar no Jellyfin (aqui e nos outros apps).';

  @override
  String get profileUsernameHint => 'Usuário';

  @override
  String get profileChangeUsername => 'Trocar usuário';

  @override
  String get profilePasswordSection => 'Senha';

  @override
  String get profileCurrentPassword => 'Senha atual';

  @override
  String get profileNewPassword => 'Senha nova';

  @override
  String get profileRepeatPassword => 'Repita a senha nova';

  @override
  String get profileChangePassword => 'Trocar senha';

  @override
  String get loginServerRequired =>
      'Digite o endereço do seu servidor Jellyfin.';

  @override
  String get loginUserRequired => 'Digite seu nome de usuário.';

  @override
  String get loginTitle => 'Entrar no Pudim';

  @override
  String get loginSubtitle => 'Use sua conta do Jellyfin.';

  @override
  String get loginUsername => 'Nome de usuário';

  @override
  String get loginPassword => 'Senha';

  @override
  String get loginShowPassword => 'Mostrar senha';

  @override
  String get loginHidePassword => 'Esconder senha';

  @override
  String get loginSubmit => 'Entrar';

  @override
  String get loginQuickConnect => 'Entrar com Quick Connect';

  @override
  String get loginHideAddresses => 'Esconder endereços';

  @override
  String get loginServerAddress => 'Endereço do servidor';

  @override
  String get loginJellyfinServer => 'Servidor Jellyfin';

  @override
  String get loginJellyfinServerExample => 'Ex.: https://jellyfin.exemplo.com';

  @override
  String get loginLocalNetwork => 'Na rede local (opcional)';

  @override
  String get loginLocalNetworkExample =>
      'Ex.: http://192.168.0.10:8096. Quando responde, o app usa este no lugar do principal.';

  @override
  String get loginExtrasServer => 'Servidor de extras (opcional)';

  @override
  String get loginExtrasServerHint =>
      'Liga chat, Jam, Blend, mixes e Retrospectiva. Deixe vazio se não tiver.';

  @override
  String get loginQcExpired => 'O código expirou. Tente de novo.';

  @override
  String get loginQcInstructions =>
      'Num aparelho em que você já entrou no Jellyfin, abra o seu perfil, toque em Quick Connect e digite este código:';

  @override
  String get loginQcWaiting => 'Esperando a aprovação…';

  @override
  String get homeDownloadedOnDevice => 'Baixadas no aparelho';

  @override
  String get homeTabMusic => 'Música';

  @override
  String get homeMadeFor => 'Feito para';

  @override
  String get homeMixDiscoveries => 'Músicas novas para você, toda semana';

  @override
  String get homeMixWeekly => 'Seus favoritos e parecidos, toda semana';

  @override
  String get homeMixRadar => 'Lançamentos de quem você segue, toda sexta';

  @override
  String get homeMixDaylist => 'Muda ao longo do dia';

  @override
  String get homeMixBlend => 'O gosto de vocês dois junto';

  @override
  String get homeMixAuto => 'Mix automático';

  @override
  String get homeSpotifyPlaylists => 'Suas playlists do Spotify';

  @override
  String get homeFromSpotify => 'Do Spotify';

  @override
  String get homeYourPlaylists => 'Suas playlists';

  @override
  String get homeTopAlbums => 'Seus álbuns mais tocados';

  @override
  String get homeTopArtists => 'Seus artistas favoritos';

  @override
  String get homeRecentlyAdded => 'Adicionados recentemente';

  @override
  String get homeYourPodcasts => 'Seus podcasts';

  @override
  String get homeRadiosTitle => 'Rádios recomendadas';

  @override
  String get homeRadiosSubtitle =>
      'Música sem parar com base nos seus artistas favoritos.';

  @override
  String get homeRadioBadge => 'RÁDIO';

  @override
  String homeRadioWith(String name) {
    return 'Com $name e artistas parecidos';
  }

  @override
  String searchNoResults(String query) {
    return 'Nenhum resultado encontrado para \"$query\"';
  }

  @override
  String get searchNoResultsHint =>
      'Verifique a ortografia ou use menos palavras ou palavras diferentes.';

  @override
  String searchCatalogNoResponse(String error) {
    return 'O catálogo não respondeu: $error';
  }

  @override
  String get searchAlsoCatalog => 'Buscando também no catálogo…';

  @override
  String searchLibraryOnly(String error) {
    return 'Só a biblioteca: o catálogo não respondeu ($error).';
  }

  @override
  String get searchTopResult => 'Melhor resultado';

  @override
  String get searchSpotifyPlaylists => 'Playlists do Spotify';

  @override
  String get searchRecent => 'Buscas recentes';

  @override
  String get searchClear => 'Limpar';

  @override
  String get searchBrowseAll => 'Navegar por todas as seções';

  @override
  String get searchHint => 'O que você quer ouvir?';

  @override
  String get albumDownloadedType => 'Álbum • baixado no aparelho';

  @override
  String albumSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count músicas',
      one: '1 música',
    );
    return '$_temp0, $total';
  }

  @override
  String get albumRemoveFromLibrary => 'Remover da Sua Biblioteca';

  @override
  String get albumSaveToLibrary => 'Salvar na Sua Biblioteca';

  @override
  String albumMoreOptions(String name) {
    return 'Mais opções para $name';
  }

  @override
  String albumDisc(int number) {
    return 'Disco $number';
  }

  @override
  String albumMoreFrom(String name) {
    return 'Mais de $name';
  }

  @override
  String artistAlbumsInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count álbuns na biblioteca',
      one: '1 álbum na biblioteca',
    );
    return '$_temp0';
  }

  @override
  String artistPlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reproduções',
      one: '1 reprodução',
    );
    return '$_temp0';
  }

  @override
  String artistMoreOptions(String name) {
    return 'Mais opções para $name';
  }

  @override
  String get artistPopular => 'Populares';

  @override
  String get artistShowLess => 'Mostrar menos';

  @override
  String get artistShowMore => 'Ver mais';

  @override
  String get artistYouLiked => 'Você curtiu';

  @override
  String artistFrom(String name) {
    return 'De $name';
  }

  @override
  String get artistDiscography => 'Discografia';

  @override
  String get artistPopularReleases => 'Lançamentos populares';

  @override
  String get artistSinglesEps => 'Singles e EPs';

  @override
  String get artistFansAlsoLike => 'Fãs também curtem';

  @override
  String get artistAppearsOn => 'Aparece em';

  @override
  String get artistAbout => 'Sobre';

  @override
  String get playlistOriginSpotify => 'Do Spotify';

  @override
  String get playlistOriginMadeForYou => 'Feita para você';

  @override
  String get playlistOriginAuto => 'Mix automático';

  @override
  String get playlistDownloadedOnDevice => 'Baixada no aparelho';

  @override
  String get playlistOnDevice => 'No aparelho';

  @override
  String get playlistPlaysOffline => 'Tocam sem internet.';

  @override
  String playlistPlaysOfflineDownloading(int count) {
    return 'Tocam sem internet. Baixando mais $count…';
  }

  @override
  String playlistSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count músicas',
      one: '1 música',
    );
    return '$_temp0, $total';
  }

  @override
  String playlistMoreOptions(String name) {
    return 'Mais opções para $name';
  }

  @override
  String get playlistSearchHint => 'Buscar na playlist';

  @override
  String get playlistEmpty => 'Nenhuma música por aqui ainda.';

  @override
  String get playlistErrNoPermission =>
      'Sem permissão para editar essa playlist.';

  @override
  String playlistErrServer(String code) {
    return 'O servidor não aceitou ($code).';
  }

  @override
  String get playlistErrNoResponse => 'sem resposta';

  @override
  String get playlistDownloadFirst =>
      'Baixe a música primeiro para pôr numa playlist';

  @override
  String get playlistAddTo => 'Adicionar à playlist';

  @override
  String get playlistNew => 'Nova playlist';

  @override
  String playlistAddedTo(String name) {
    return 'Adicionada a $name';
  }

  @override
  String get playlistNameHint => 'Nome da playlist';

  @override
  String get playlistCreate => 'Criar';

  @override
  String playlistCreated(String name) {
    return 'Playlist $name criada';
  }

  @override
  String get playlistRemoved => 'Removida da playlist';

  @override
  String get playlistInviteTitle => 'Convidar para editar';

  @override
  String get playlistInviteSubtitle =>
      'A pessoa vê a playlist na biblioteca dela e pode adicionar e tirar músicas.';

  @override
  String get playlistInviteOwnerOnly =>
      'Só quem criou a playlist pode convidar';

  @override
  String playlistInvited(String who, String playlist) {
    return '$who agora pode editar $playlist';
  }

  @override
  String playlistCollaborative(String members) {
    return 'Colaborativa · $members';
  }

  @override
  String get playlistSmartShuffleTooltip =>
      'Smart Shuffle: aleatório com recomendações';

  @override
  String get playlistSmartShuffleOn =>
      'Smart Shuffle ligado: recomendações marcadas com ✦';

  @override
  String get playlistAddedToThis => 'Adicionada à playlist';

  @override
  String get playlistRecommendation => 'Recomendação do Smart Shuffle';

  @override
  String get playlistPutIn => 'Pôr na playlist';

  @override
  String get settingsSectionAccount => 'Conta';

  @override
  String get settingsProfileSubtitle => 'Nome, usuário e senha';

  @override
  String settingsConnectedAt(String url) {
    return 'Conectado em $url';
  }

  @override
  String get settingsSignOut => 'Sair';

  @override
  String get accountsTitle => 'Contas';

  @override
  String get accountsAdd => 'Adicionar conta ou servidor';

  @override
  String get accountsSwitch => 'Trocar';

  @override
  String get accountsInUse => 'Em uso';

  @override
  String accountsOn(String user, String host) {
    return '$user em $host';
  }

  @override
  String get loginBackToAccount => 'Voltar para a conta atual';

  @override
  String get settingsSectionServer => 'Servidor';

  @override
  String get settingsLocalNetwork => 'Na rede local';

  @override
  String get settingsServerNote =>
      'Para trocar os endereços do Jellyfin, saia da conta e abra \"Endereço do servidor\" na tela de entrada.';

  @override
  String get settingsExtrasServer => 'Servidor de extras';

  @override
  String get settingsExtrasNotConfigured =>
      'Não configurado (chat, Jam, Blend, mixes e Retrospectiva ficam escondidos)';

  @override
  String get settingsConfigure => 'Configurar';

  @override
  String get settingsChange => 'Trocar';

  @override
  String get settingsSectionPlayback => 'Reprodução';

  @override
  String get settingsQualityWifi => 'Qualidade no Wi-Fi';

  @override
  String get settingsQualityWifiSubtitle =>
      'Original toca o arquivo como está na biblioteca.';

  @override
  String get settingsQualityMobile => 'Qualidade nos dados móveis';

  @override
  String get settingsQualityMobileSubtitle =>
      'Uma qualidade menor gasta menos internet do celular.';

  @override
  String get settingsQualityOriginal => 'Original';

  @override
  String get settingsAppliesNextSong => 'Vale a partir da próxima música';

  @override
  String get settingsSectionAbout => 'Sobre';

  @override
  String settingsBuild(int build) {
    return 'Build $build';
  }

  @override
  String get settingsExtrasEmptyHint => 'Deixe vazio para desligar os extras.';

  @override
  String get settingsAutoplay => 'Reprodução automática';

  @override
  String get settingsAutoplaySubtitle =>
      'Quando a fila acabar, continua tocando músicas parecidas (mix do Jellyfin).';

  @override
  String get settingsNormalize => 'Normalizar o volume';

  @override
  String get settingsNormalizeSubtitle =>
      'Deixa todas as músicas no mesmo volume, com a análise feita pelo Jellyfin.';

  @override
  String get settingsScrobble => 'Scrobble';

  @override
  String get settingsLoading => 'Carregando…';

  @override
  String get settingsLastfmNoKey =>
      'O servidor de extras ainda não tem uma chave da API do Last.fm configurada.';

  @override
  String settingsConnectedAs(String name) {
    return 'Conectado como $name';
  }

  @override
  String get settingsLastfmConnectedSubtitle =>
      'Tudo que você ouve no Pudim vai para o seu perfil do Last.fm.';

  @override
  String get settingsDisconnect => 'Desconectar';

  @override
  String get settingsLastfmAuthorize => 'Autorize na página do Last.fm';

  @override
  String get settingsLastfmAuthorizeSubtitle =>
      'Depois de clicar em \"Yes, allow access\" lá, volte e toque em Concluir.';

  @override
  String get settingsFinish => 'Concluir';

  @override
  String get settingsLastfmConnected => 'Last.fm conectado';

  @override
  String get settingsLastfmScrobbleSubtitle =>
      'Registra no seu Last.fm cada música que você ouve.';

  @override
  String get settingsConnect => 'Conectar';

  @override
  String get sidebarOpenLibrary => 'Abrir Sua Biblioteca';

  @override
  String get sidebarCollapseLibrary => 'Recolher Sua Biblioteca';

  @override
  String sidebarOnDeviceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count músicas',
      one: '1 música',
    );
    return 'No aparelho • $_temp0';
  }

  @override
  String sidebarPlaylistCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count músicas',
      one: '1 música',
    );
    return 'Playlist • $_temp0';
  }

  @override
  String sidebarAlbumBy(String artist) {
    return 'Álbum • $artist';
  }

  @override
  String get sidebarSearchLibrary => 'Buscar na Sua Biblioteca';

  @override
  String get sidebarSortBy => 'Ordenar por';

  @override
  String get sidebarSortRecents => 'Recentes';

  @override
  String get sidebarSortAdded => 'Adicionados recentemente';

  @override
  String get sidebarSortAlpha => 'Alfabética';

  @override
  String get sidebarSortCreator => 'Criador';

  @override
  String get topBarSearchHint => 'O que você quer ouvir?';

  @override
  String get topBarClearSearch => 'Limpar campo de busca';

  @override
  String get topBarBrowse => 'Navegar';

  @override
  String get topBarMenu => 'Menu';

  @override
  String get topBarLogoutAccount => 'Sair da conta';

  @override
  String get topBarQuit => 'Fechar o Pudim';

  @override
  String get topBarLogout => 'Sair';

  @override
  String get playerBarSmartShuffleOff => 'Desativar o Smart Shuffle';

  @override
  String get playerBarSmartShuffleOn => 'Ativar o Smart Shuffle';

  @override
  String get playerBarShuffleOff => 'Desativar a ordem aleatória';

  @override
  String get playerBarShuffleOn => 'Ativar a ordem aleatória';

  @override
  String get playerBarPlay => 'Play';

  @override
  String get playerBarForward => 'Avançar';

  @override
  String get playerBarRepeatOn => 'Ativar a repetição';

  @override
  String get playerBarRepeatOne => 'Ativar a repetição de uma faixa';

  @override
  String get playerBarRepeatOff => 'Desativar a repetição';

  @override
  String get playerBarNowPlayingView => 'Tela Tocando agora';

  @override
  String get playerBarLyrics => 'Letra';

  @override
  String get playerBarUnmute => 'Com som';

  @override
  String get playerBarMute => 'Mudo';

  @override
  String get rightPanelNothingPlaying =>
      'Toque alguma coisa para ver aqui o que está tocando.';

  @override
  String get rightPanelLyricsPreview => 'Prévia da letra';

  @override
  String get rightPanelAboutArtist => 'Sobre o artista';

  @override
  String get rightPanelNextUp => 'A seguir';

  @override
  String get rightPanelOpenQueue => 'Abrir fila';

  @override
  String get rightPanelQueueEmptyTitle => 'Adicione à fila';

  @override
  String get rightPanelQueueEmptyHint =>
      'Clique em \"Adicionar à fila\" no menu de uma faixa para incluí-la aqui';

  @override
  String get rightPanelNowPlaying => 'Tocando agora';

  @override
  String get rightPanelNextInQueue => 'A seguir na fila';

  @override
  String rightPanelNextFrom(String name) {
    return 'Próximas de: $name';
  }

  @override
  String get nowPlayingPlayingFrom => 'TOCANDO DE';

  @override
  String get nowPlayingMoreOptions => 'Mais opções';

  @override
  String get chatChats => 'Conversas';

  @override
  String chatYouSaid(String text) {
    return 'Você: $text';
  }

  @override
  String get chatContacts => 'Contatos';

  @override
  String get chatServerUnreachable =>
      'Não consegui falar com o servidor de extras.';

  @override
  String get chatMessageHint => 'Mensagem';

  @override
  String chatJoinedJam(String title) {
    return 'Você entrou na $title';
  }

  @override
  String chatCouldNotPlay(String error) {
    return 'Não consegui tocar: $error';
  }

  @override
  String get chatJamCardSubtitle => 'Ouvir junto, com a mesma fila';

  @override
  String get chatInJam => 'Na Jam';

  @override
  String get chatJoin => 'Entrar';

  @override
  String get chatNoOtherAccounts => 'Nenhuma outra conta no servidor.';

  @override
  String chatSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count músicas',
      one: '1 música',
    );
    return '$_temp0';
  }

  @override
  String chatSentTo(String name) {
    return 'Enviado para $name';
  }

  @override
  String chatShareTitle(String title) {
    return 'Compartilhar $title';
  }

  @override
  String get chatNoteHint => 'Recado (opcional)';

  @override
  String get blendWorking => 'Misturando…';

  @override
  String blendAffinityButton(int affinity) {
    return 'Blend $affinity%';
  }

  @override
  String get blendCreate => 'Criar Blend';

  @override
  String blendWith(String name) {
    return 'Blend com $name';
  }

  @override
  String get blendExplain =>
      'Uma playlist igual para vocês dois, com o que os dois ouvem, os artistas em comum e um pouco do que cada um mais gosta. Mostra a afinidade de vocês e se atualiza todo dia.';

  @override
  String get blendNotNow => 'Agora não';

  @override
  String blendAffinityTitle(int affinity) {
    return 'Vocês têm $affinity% de afinidade';
  }

  @override
  String blendInCommon(String artists) {
    return 'Em comum: $artists';
  }

  @override
  String blendOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Abrir o Blend ($count músicas)',
      one: 'Abrir o Blend (1 música)',
    );
    return '$_temp0';
  }

  @override
  String get blendRefreshNow => 'Atualizar agora';

  @override
  String get blendUndo => 'Desfazer Blend';

  @override
  String get blendRefreshing => 'Atualizando o Blend…';

  @override
  String get blendUndoTitle => 'Desfazer o Blend?';

  @override
  String blendUndoBody(String name) {
    return 'A playlist some para você e para $name.';
  }

  @override
  String get blendUndoConfirm => 'Desfazer';

  @override
  String get blendUndone => 'Blend desfeito';

  @override
  String get jamStart => 'Iniciar uma Jam';

  @override
  String jamTooltip(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jam ($count pessoas)',
      one: 'Jam (1 pessoa)',
    );
    return '$_temp0';
  }

  @override
  String get jamSubIdle => 'Ouça junto com outras contas, na mesma fila.';

  @override
  String get jamSubHost => 'Você está no comando. Todos podem pedir músicas.';

  @override
  String get jamSubGuest => 'Seus botões e músicas vão para a fila de todos.';

  @override
  String get jamPlayFirst => 'Toque alguma coisa antes de começar a Jam.';

  @override
  String jamMembers(int count) {
    return 'Na Jam ($count)';
  }

  @override
  String jamYouSuffix(String name) {
    return '$name (você)';
  }

  @override
  String get jamHost => 'Anfitrião';

  @override
  String get jamInvite => 'Convidar';

  @override
  String get jamInviteTitle => 'Convidar para a Jam';

  @override
  String get jamInviteSubtitle => 'O convite chega no chat da pessoa.';

  @override
  String jamInviteSent(String name) {
    return 'Convite enviado para $name';
  }

  @override
  String get jamEnd => 'Encerrar a Jam';

  @override
  String get jamLeave => 'Sair da Jam';

  @override
  String recapTitle(int year) {
    return 'Sua Retrospectiva $year';
  }

  @override
  String get recapShort => 'Retrospectiva';

  @override
  String recapBannerBody(String minutes) {
    return '$minutes minutos de música este ano. Veja o que mais tocou.';
  }

  @override
  String get recapEmpty =>
      'Ainda não tem reproduções para montar a Retrospectiva.';

  @override
  String get recapShareCards => 'Compartilhar cartões';

  @override
  String get recapBigMinutes => 'minutos ouvindo';

  @override
  String get recapBigSongs => 'músicas diferentes';

  @override
  String get recapBigArtists => 'artistas';

  @override
  String get recapBigDays => 'dias com música';

  @override
  String get recapBigStreak => 'dias seguidos, seu recorde';

  @override
  String get recapTopArtists => 'Seus artistas do ano';

  @override
  String recapMinutesValue(String minutes) {
    return '$minutes minutos';
  }

  @override
  String get recapTopSongs => 'Suas músicas do ano';

  @override
  String recapPlaysLine(String artist, String plays) {
    return '$artist • $plays vezes';
  }

  @override
  String get recapSongGone => 'Essa música não está mais na biblioteca';

  @override
  String get recapTopAlbums => 'Seus álbuns do ano';

  @override
  String get recapTopGenres => 'Gêneros que mais tocaram';

  @override
  String recapGenreLine(String genre, String minutes) {
    return '$genre • $minutes min';
  }

  @override
  String get recapMonthly => 'Mês a mês';

  @override
  String recapMonthTooltip(String month, String minutes) {
    return '$month: $minutes min';
  }

  @override
  String get recapListeningStyle => 'Seu jeito de ouvir';

  @override
  String recapFavHour(String hour) {
    return 'Hora favorita: ${hour}h';
  }

  @override
  String recapFavWeekday(String day) {
    return 'Dia da semana favorito: $day';
  }

  @override
  String recapBiggestDay(String date, String minutes) {
    return 'Seu maior dia: $date, $minutes minutos';
  }

  @override
  String recapNewArtists(int count, String n) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$n artistas novos para você',
      one: '$n artista novo para você',
    );
    return '$_temp0';
  }

  @override
  String recapSpotifyAdded(String added) {
    return '$added reproduções do Spotify entraram.';
  }

  @override
  String recapSpotifyAddedDup(String added, String dup) {
    return '$added reproduções do Spotify entraram ($dup já estavam pelo Pudim).';
  }

  @override
  String get recapSpotifyRemoveTitle => 'Tirar o histórico do Spotify?';

  @override
  String get recapSpotifyRemoveBody =>
      'A Retrospectiva volta a contar só o que tocou no Pudim/Jellyfin. Dá para importar de novo depois.';

  @override
  String get recapSpotifyRemoveConfirm => 'Tirar';

  @override
  String recapSpotifyRemoved(String count) {
    return '$count reproduções do Spotify removidas';
  }

  @override
  String get recapSpotifyTitle => 'Histórico do Spotify';

  @override
  String recapSpotifyHasData(String count, String from, String to) {
    return '$count reproduções do Spotify na sua Retrospectiva ($from a $to). Pode mandar um arquivo mais novo: o que já entrou não repete.';
  }

  @override
  String get recapSpotifyIntro =>
      'Traga os anos de antes do Pudim. No Spotify, vá em Conta > Privacidade > Baixe seus dados e marque \"Histórico de streaming estendido\". Quando o e-mail chegar, escolha aqui o my_spotify_data.zip.';

  @override
  String get recapSpotifyImportAnother => 'Importar outro arquivo';

  @override
  String get recapSpotifyImport => 'Importar histórico';

  @override
  String get recapSpotifyRemoveBtn => 'Tirar da Retrospectiva';

  @override
  String get recapShareSaveDialog => 'Salvar cartão';

  @override
  String get recapShareSaved => 'Cartão salvo';

  @override
  String recapShareSaveFailed(String error) {
    return 'Não consegui salvar: $error';
  }

  @override
  String recapShareShareFailed(String error) {
    return 'Não consegui compartilhar: $error';
  }

  @override
  String recapShareText(int year) {
    return 'Minha Retrospectiva $year no Pudim';
  }

  @override
  String get recapShareMyArtists => 'Meus artistas do ano';

  @override
  String get recapShareMySongs => 'Minhas músicas do ano';

  @override
  String recapMinShort(String minutes) {
    return '$minutes min';
  }

  @override
  String get recapShareSaveImage => 'Salvar imagem';

  @override
  String get recapShareButton => 'Compartilhar';

  @override
  String recapBrand(int year) {
    return 'Retrospectiva $year';
  }

  @override
  String get recapShareMyYear => 'Meu ano em música';

  @override
  String recapShareYearOf(String name) {
    return 'O ano de $name em música';
  }

  @override
  String get recapShareTopArtist => 'meu artista do ano';

  @override
  String recapShareGenres(String genres) {
    return 'Gêneros: $genres';
  }

  @override
  String get widgetActionsAddedToLiked => 'Adicionada a Músicas curtidas';

  @override
  String get widgetActionsRemovedFromLiked => 'Removida de Músicas curtidas';

  @override
  String get widgetActionsUnfollowed => 'Deixou de seguir';

  @override
  String get widgetActionsSavedToLibrary => 'Salvo na Sua Biblioteca';

  @override
  String get widgetActionsRemovedFromLibrary => 'Removido da Sua Biblioteca';

  @override
  String get widgetActionsAddToQueue => 'Adicionar à fila';

  @override
  String get widgetActionsAddedToQueue => 'Adicionado à fila';

  @override
  String get widgetActionsPlayNext => 'Tocar em seguida';

  @override
  String get widgetActionsGoToPodcast => 'Ir para o podcast';

  @override
  String get widgetActionsRemoveFromQueue => 'Remover da fila';

  @override
  String get widgetActionsAddToPlaylist => 'Adicionar à playlist';

  @override
  String get widgetActionsRemoveFromThisPlaylist => 'Remover desta playlist';

  @override
  String get widgetActionsInviteToEdit => 'Convidar para editar';

  @override
  String get widgetActionsKeepInPlaylist => 'Manter na playlist';

  @override
  String get widgetActionsDownloadTrack => 'Baixar música';

  @override
  String get widgetActionsDownloadAlbum => 'Baixar álbum';

  @override
  String get widgetActionsDownloadDiscography => 'Baixar discografia';

  @override
  String get widgetActionsSearchAlbums => 'Buscar álbuns';

  @override
  String widgetActionsImproveQuality(int count) {
    return 'Melhorar qualidade ($count)';
  }

  @override
  String widgetActionsImprovingAlbums(int count) {
    return 'Procurando versões melhores de $count álbuns';
  }

  @override
  String get widgetActionsShare => 'Compartilhar';

  @override
  String get widgetActionsSearchFlac => 'Buscar em FLAC';

  @override
  String widgetActionsSearchingFlac(String name) {
    return 'Procurando $name em FLAC; se achar, troca o MP3';
  }

  @override
  String get widgetActionsTrackRemovedFromDevice => 'Removida do aparelho';

  @override
  String get widgetActionsRemovedFromDevice => 'Removido do aparelho';

  @override
  String get widgetActionsDownloadingToDevice =>
      'Baixando no aparelho para ouvir sem internet';

  @override
  String get widgetActionsUnfollow => 'Deixar de seguir';

  @override
  String get widgetActionsRemoveFromLibrary => 'Remover da Sua Biblioteca';

  @override
  String get widgetActionsAddToLibrary => 'Adicionar à Sua Biblioteca';

  @override
  String get widgetActionsGoToSongRadio => 'Ir para a rádio da música';

  @override
  String get widgetActionsStartMix => 'Ligar mix';

  @override
  String widgetActionsMixOf(String name) {
    return 'Mix de $name';
  }

  @override
  String get widgetActionsGoToArtist => 'Ir para o artista';

  @override
  String get widgetActionsGoToAlbum => 'Ir para o álbum';

  @override
  String get widgetActionsCopyName => 'Copiar nome';

  @override
  String get widgetActionsCopied => 'Copiado';

  @override
  String widgetDownloadsBellDownloading(int count) {
    return '$count baixando';
  }

  @override
  String get widgetDownloadsBellEmpty =>
      'Nada por aqui. Toque uma música com nuvem ou use \"Baixar\" no menu ⋯ para trazer do catálogo para a biblioteca.';

  @override
  String get widgetDownloadsBellKindDiscography => 'Discografia';

  @override
  String get widgetDownloadsBellKindFlac => 'Em FLAC';

  @override
  String get widgetDownloadsBellKindQuality => 'Qualidade';

  @override
  String get widgetDownloadsBellOptions => 'Opções';

  @override
  String get widgetDownloadsBellCancelled => 'Download cancelado';

  @override
  String get widgetDownloadsBellRetrying => 'Tentando de novo';

  @override
  String get widgetDownloadsBellRemovedFromList => 'Removido da lista';

  @override
  String get widgetDownloadsBellDetails => 'Ver detalhes';

  @override
  String get widgetDownloadsBellRemoveFromList => 'Remover da lista';

  @override
  String get widgetMixSearchingReleases => 'Procurando lançamentos…';

  @override
  String get widgetMixBuildingDaylist => 'Montando sua daylist…';

  @override
  String get widgetMixNewDiscoveriesTitle => 'Novas Descobertas da semana?';

  @override
  String get widgetMixNewMixTitle => 'Nova Mistura da semana?';

  @override
  String get widgetMixNewDiscoveriesBody =>
      'As músicas que você ainda não ouviu saem da playlist e umas 30 novas começam a chegar. Toda segunda isso já acontece sozinho.';

  @override
  String get widgetMixNewMixBody =>
      'Monta de novo com os seus favoritos, o que você mais ouve e músicas parecidas. Toda segunda isso já acontece sozinho.';

  @override
  String get widgetMixNotNow => 'Agora não';

  @override
  String get widgetMixBuildingDiscoveries => 'Montando suas Descobertas…';

  @override
  String get widgetMixBuildingMix => 'Montando sua Mistura…';

  @override
  String widgetMixBuiltOn(String date) {
    return 'Montada em $date';
  }

  @override
  String get widgetMixRedo => 'Refazer';

  @override
  String get widgetMixRefresh => 'Atualizar';

  @override
  String get widgetMixCreateDiscoveries => 'Criar suas Descobertas da semana';

  @override
  String get widgetMixCreateMix => 'Criar sua Mistura da semana';

  @override
  String get widgetMixCreateRadar => 'Criar seu Radar de Novidades';

  @override
  String get widgetMixCreateDaylist => 'Criar sua daylist';

  @override
  String get widgetOfflineBanner =>
      'Sem internet · mostrando o que está guardado no aparelho';

  @override
  String widgetOfflineDownloadingProgress(int done, int total) {
    return 'Baixando $done de $total';
  }

  @override
  String get widgetUpdateReady => 'Nova versão do Pudim pronta';

  @override
  String widgetUpdateReadyNotes(String notes) {
    return 'Nova versão do Pudim · $notes';
  }

  @override
  String get widgetUpdateAction => 'Atualizar';

  @override
  String widgetSleepShortMinutes(int count) {
    return '$count min';
  }

  @override
  String widgetSleepShortSeconds(int count) {
    return '$count s';
  }

  @override
  String get widgetSleepStopsAtEnd => 'Para no fim da música';

  @override
  String widgetSleepStopsIn(String time) {
    return 'Para em $time';
  }

  @override
  String get widgetSleepTimer => 'Timer para dormir';

  @override
  String get widgetSleepTurnOff => 'Desligar o timer';

  @override
  String get widgetSleepOneHour => '1 hora';

  @override
  String get widgetSleepOneAndHalfHours => '1 hora e meia';

  @override
  String get widgetSleepEndOfSong => 'Fim da música';

  @override
  String get widgetSleepTurnedOff => 'Timer desligado';

  @override
  String get widgetSleepStopsWhenSongEnds => 'A música para quando esta acabar';

  @override
  String widgetSleepSongStopsIn(String time) {
    return 'A música para em $time';
  }

  @override
  String get widgetSpeedPodcast => 'Velocidade do podcast';

  @override
  String get widgetCommonCatalogBadge =>
      'Do catálogo: ainda não está na biblioteca';

  @override
  String get widgetCommonShowAll => 'Mostrar tudo';

  @override
  String get widgetCommonSomethingWentWrong => 'Algo deu errado';

  @override
  String get widgetCommonListenDownloaded => 'Ouvir as músicas baixadas';

  @override
  String get widgetTracksTitle => 'Título';

  @override
  String get widgetTracksDateAdded => 'Adicionada em';

  @override
  String widgetTracksAddedBy(String name) {
    return 'por $name';
  }

  @override
  String get widgetTracksMoreOptions => 'Mais opções';

  @override
  String widgetTracksAddedDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get castTooltip => 'Transmitir';

  @override
  String get castTitle => 'Tocar em';

  @override
  String get castThisDevice => 'Este aparelho';

  @override
  String get castSearching => 'Procurando aparelhos na rede…';

  @override
  String get castNone =>
      'Nenhum Chromecast achado. Ele precisa estar no mesmo Wi-Fi.';

  @override
  String get castSearchAgain => 'Procurar de novo';

  @override
  String get castStop => 'Parar de transmitir';

  @override
  String castPlayingOn(String name) {
    return 'Tocando em $name';
  }

  @override
  String castFailed(String name) {
    return 'Não deu para conectar em $name';
  }

  @override
  String get settingsSectionAppearance => 'Aparência';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSubtitle => 'Muda as cores na hora.';

  @override
  String get themeNightDesc =>
      'Escuro, cards arredondados e mini player flutuante.';

  @override
  String get themeRedDesc =>
      'Preto puro com vermelho, capas grandes e quadradas, mini player colado na barra.';

  @override
  String get themeWaveDesc =>
      'Roxo com gradientes, letras fortes e mini player em pílula.';

  @override
  String get themeRetroDesc =>
      'Janela cinza em relevo, display verde com título rolando e listas em texto.';

  @override
  String get themeClassicDesc =>
      'Azul e preto com brilho de vidro, botão em esfera, visualizador e listas em tabela.';

  @override
  String get settingsCheckUpdates => 'Verificar atualizações';

  @override
  String get updateChecking => 'Verificando…';

  @override
  String updateUpToDate(int build) {
    return 'Você está na versão mais nova (build $build).';
  }

  @override
  String updateDownloading(int build, int percent) {
    return 'Baixando a build $build… $percent%';
  }

  @override
  String updateFailed(String error) {
    return 'Não deu para verificar: $error';
  }

  @override
  String get updateUnavailable => 'Sem servidor de extras configurado.';

  @override
  String get settingsHistory => 'Histórico';

  @override
  String get settingsHistorySubtitle =>
      'Retrospectivas dos anos anteriores e tudo o que você ouviu';

  @override
  String get historyRecaps => 'Retrospectivas';

  @override
  String get historyPlays => 'Reproduções';

  @override
  String get historyWholeYear => 'Ano todo';

  @override
  String get historyLoadMore => 'Carregar mais';

  @override
  String get historyEmpty => 'Nada tocado ainda';

  @override
  String get historyImported => 'importado';

  @override
  String widgetMixRadarDone(int count) {
    return 'Radar de Novidades: $count músicas';
  }

  @override
  String widgetMixRadarQueued(int count, String list) {
    return 'Baixando $count lançamento(s): $list';
  }

  @override
  String widgetMixRadarFailed(String error) {
    return 'O Radar não atualizou: $error';
  }
}
