import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  /// No description provided for @languageTitle.
  ///
  /// In pt, this message translates to:
  /// **'Idioma'**
  String get languageTitle;

  /// No description provided for @languageSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Idioma da interface'**
  String get languageSubtitle;

  /// Language option that follows the device language
  ///
  /// In pt, this message translates to:
  /// **'Padrão do sistema'**
  String get languageSystem;

  /// No description provided for @commonCancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get commonCancel;

  /// No description provided for @commonClose.
  ///
  /// In pt, this message translates to:
  /// **'Fechar'**
  String get commonClose;

  /// No description provided for @commonBack.
  ///
  /// In pt, this message translates to:
  /// **'Voltar'**
  String get commonBack;

  /// No description provided for @commonSave.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get commonSave;

  /// No description provided for @commonEdit.
  ///
  /// In pt, this message translates to:
  /// **'Editar'**
  String get commonEdit;

  /// No description provided for @commonDelete.
  ///
  /// In pt, this message translates to:
  /// **'Excluir'**
  String get commonDelete;

  /// No description provided for @commonRemove.
  ///
  /// In pt, this message translates to:
  /// **'Remover'**
  String get commonRemove;

  /// No description provided for @commonOk.
  ///
  /// In pt, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonRetry.
  ///
  /// In pt, this message translates to:
  /// **'Tentar de novo'**
  String get commonRetry;

  /// No description provided for @commonQueue.
  ///
  /// In pt, this message translates to:
  /// **'Fila'**
  String get commonQueue;

  /// No description provided for @commonAlbum.
  ///
  /// In pt, this message translates to:
  /// **'Álbum'**
  String get commonAlbum;

  /// No description provided for @commonAlbums.
  ///
  /// In pt, this message translates to:
  /// **'Álbuns'**
  String get commonAlbums;

  /// No description provided for @commonArtist.
  ///
  /// In pt, this message translates to:
  /// **'Artista'**
  String get commonArtist;

  /// No description provided for @commonArtists.
  ///
  /// In pt, this message translates to:
  /// **'Artistas'**
  String get commonArtists;

  /// No description provided for @commonSong.
  ///
  /// In pt, this message translates to:
  /// **'Música'**
  String get commonSong;

  /// No description provided for @commonSongs.
  ///
  /// In pt, this message translates to:
  /// **'Músicas'**
  String get commonSongs;

  /// No description provided for @commonPlaylist.
  ///
  /// In pt, this message translates to:
  /// **'Playlist'**
  String get commonPlaylist;

  /// No description provided for @commonPlaylists.
  ///
  /// In pt, this message translates to:
  /// **'Playlists'**
  String get commonPlaylists;

  /// No description provided for @commonSingle.
  ///
  /// In pt, this message translates to:
  /// **'Single'**
  String get commonSingle;

  /// No description provided for @commonLikedSongs.
  ///
  /// In pt, this message translates to:
  /// **'Músicas curtidas'**
  String get commonLikedSongs;

  /// No description provided for @commonAddToLiked.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar a Músicas curtidas'**
  String get commonAddToLiked;

  /// No description provided for @commonRemoveFromLiked.
  ///
  /// In pt, this message translates to:
  /// **'Remover das Músicas curtidas'**
  String get commonRemoveFromLiked;

  /// No description provided for @commonShufflePlay.
  ///
  /// In pt, this message translates to:
  /// **'Tocar em ordem aleatória'**
  String get commonShufflePlay;

  /// No description provided for @commonPlay.
  ///
  /// In pt, this message translates to:
  /// **'Tocar'**
  String get commonPlay;

  /// No description provided for @commonPause.
  ///
  /// In pt, this message translates to:
  /// **'Pausar'**
  String get commonPause;

  /// No description provided for @commonFollow.
  ///
  /// In pt, this message translates to:
  /// **'Seguir'**
  String get commonFollow;

  /// No description provided for @commonFollowing.
  ///
  /// In pt, this message translates to:
  /// **'Seguindo'**
  String get commonFollowing;

  /// No description provided for @commonDownloadToDevice.
  ///
  /// In pt, this message translates to:
  /// **'Baixar no aparelho'**
  String get commonDownloadToDevice;

  /// No description provided for @commonRemoveFromDevice.
  ///
  /// In pt, this message translates to:
  /// **'Remover do aparelho'**
  String get commonRemoveFromDevice;

  /// No description provided for @commonDownloaded.
  ///
  /// In pt, this message translates to:
  /// **'Baixadas'**
  String get commonDownloaded;

  /// No description provided for @commonDownloads.
  ///
  /// In pt, this message translates to:
  /// **'Downloads'**
  String get commonDownloads;

  /// No description provided for @commonAll.
  ///
  /// In pt, this message translates to:
  /// **'Tudo'**
  String get commonAll;

  /// No description provided for @commonRecentlyPlayed.
  ///
  /// In pt, this message translates to:
  /// **'Tocadas recentemente'**
  String get commonRecentlyPlayed;

  /// No description provided for @commonYourLibrary.
  ///
  /// In pt, this message translates to:
  /// **'Sua Biblioteca'**
  String get commonYourLibrary;

  /// No description provided for @commonHome.
  ///
  /// In pt, this message translates to:
  /// **'Início'**
  String get commonHome;

  /// No description provided for @commonSearch.
  ///
  /// In pt, this message translates to:
  /// **'Buscar'**
  String get commonSearch;

  /// No description provided for @commonProfile.
  ///
  /// In pt, this message translates to:
  /// **'Perfil'**
  String get commonProfile;

  /// No description provided for @commonSettings.
  ///
  /// In pt, this message translates to:
  /// **'Configurações'**
  String get commonSettings;

  /// No description provided for @commonBuilding.
  ///
  /// In pt, this message translates to:
  /// **'Montando…'**
  String get commonBuilding;

  /// No description provided for @commonBuildNow.
  ///
  /// In pt, this message translates to:
  /// **'Montar agora'**
  String get commonBuildNow;

  /// No description provided for @commonShows.
  ///
  /// In pt, this message translates to:
  /// **'Shows'**
  String get commonShows;

  /// No description provided for @commonPodcasts.
  ///
  /// In pt, this message translates to:
  /// **'Podcasts'**
  String get commonPodcasts;

  /// No description provided for @commonSongCount.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =0{Nenhuma música} =1{1 música} other{{count} músicas}}'**
  String commonSongCount(int count);

  /// No description provided for @commonMinutes.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{1 minuto} other{{count} minutos}}'**
  String commonMinutes(int count);

  /// No description provided for @commonError.
  ///
  /// In pt, this message translates to:
  /// **'Erro: {error}'**
  String commonError(String error);

  /// No description provided for @apiStatusQueued.
  ///
  /// In pt, this message translates to:
  /// **'Na fila'**
  String get apiStatusQueued;

  /// No description provided for @apiStatusDownloading.
  ///
  /// In pt, this message translates to:
  /// **'Baixando'**
  String get apiStatusDownloading;

  /// No description provided for @apiStatusDone.
  ///
  /// In pt, this message translates to:
  /// **'Chegou na biblioteca'**
  String get apiStatusDone;

  /// No description provided for @apiStatusUpToDate.
  ///
  /// In pt, this message translates to:
  /// **'Já estava na biblioteca'**
  String get apiStatusUpToDate;

  /// No description provided for @apiStatusPartial.
  ///
  /// In pt, this message translates to:
  /// **'Chegou em parte'**
  String get apiStatusPartial;

  /// No description provided for @apiStatusNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Não encontrado'**
  String get apiStatusNotFound;

  /// No description provided for @apiStatusCancelled.
  ///
  /// In pt, this message translates to:
  /// **'Cancelado'**
  String get apiStatusCancelled;

  /// No description provided for @apiStatusInterrupted.
  ///
  /// In pt, this message translates to:
  /// **'Interrompido'**
  String get apiStatusInterrupted;

  /// No description provided for @apiStatusFailed.
  ///
  /// In pt, this message translates to:
  /// **'Falhou'**
  String get apiStatusFailed;

  /// No description provided for @apiExtrasNoResponse.
  ///
  /// In pt, this message translates to:
  /// **'O servidor de extras não respondeu.'**
  String get apiExtrasNoResponse;

  /// No description provided for @apiAlbumListFailed.
  ///
  /// In pt, this message translates to:
  /// **'Não consegui listar os álbuns.'**
  String get apiAlbumListFailed;

  /// No description provided for @apiPlaylistSaved.
  ///
  /// In pt, this message translates to:
  /// **'Playlist na Sua Biblioteca ({found} de {total} músicas)'**
  String apiPlaylistSaved(int found, int total);

  /// No description provided for @apiPlaylistDownloading.
  ///
  /// In pt, this message translates to:
  /// **'Playlist na Sua Biblioteca; baixando mais {count, plural, =1{1 música} other{{count} músicas}}'**
  String apiPlaylistDownloading(int count);

  /// No description provided for @apiBadCredentials.
  ///
  /// In pt, this message translates to:
  /// **'Usuário ou senha incorretos.'**
  String get apiBadCredentials;

  /// No description provided for @apiServerUnreachable.
  ///
  /// In pt, this message translates to:
  /// **'Não consegui falar com o servidor.'**
  String get apiServerUnreachable;

  /// No description provided for @apiQuickConnectOff.
  ///
  /// In pt, this message translates to:
  /// **'O Quick Connect está desligado neste servidor.'**
  String get apiQuickConnectOff;

  /// No description provided for @apiWrongCurrentPassword.
  ///
  /// In pt, this message translates to:
  /// **'A senha atual não confere.'**
  String get apiWrongCurrentPassword;

  /// No description provided for @stateChatShared.
  ///
  /// In pt, this message translates to:
  /// **'Compartilhou {title}'**
  String stateChatShared(String title);

  /// No description provided for @stateDownloadingName.
  ///
  /// In pt, this message translates to:
  /// **'Baixando {name}'**
  String stateDownloadingName(String name);

  /// No description provided for @stateDownloadingRequests.
  ///
  /// In pt, this message translates to:
  /// **'Baixando {count} pedidos'**
  String stateDownloadingRequests(int count);

  /// No description provided for @stateDownloadArrived.
  ///
  /// In pt, this message translates to:
  /// **'{name} chegou na biblioteca'**
  String stateDownloadArrived(String name);

  /// No description provided for @stateDownloadPartial.
  ///
  /// In pt, this message translates to:
  /// **'{name} chegou em parte'**
  String stateDownloadPartial(String name);

  /// No description provided for @stateDownloadEnded.
  ///
  /// In pt, this message translates to:
  /// **'{name}: {status}'**
  String stateDownloadEnded(String name, String status);

  /// No description provided for @stateNotFromCatalog.
  ///
  /// In pt, this message translates to:
  /// **'Esse item não veio do catálogo.'**
  String get stateNotFromCatalog;

  /// No description provided for @stateAlreadyDownloading.
  ///
  /// In pt, this message translates to:
  /// **'{kind, select, album{Já está baixando o álbum.} artist{Já está baixando a discografia.} other{Já está baixando a música.}}'**
  String stateAlreadyDownloading(String kind);

  /// No description provided for @stateDownloadRequested.
  ///
  /// In pt, this message translates to:
  /// **'{kind, select, album{Baixando o álbum. Aparece no sino quando chegar.} artist{Baixando a discografia. Aparece no sino quando chegar.} other{Baixando a música. Aparece no sino quando chegar.}}'**
  String stateDownloadRequested(String kind);

  /// No description provided for @stateNotifyDownloadsChannel.
  ///
  /// In pt, this message translates to:
  /// **'Downloads'**
  String get stateNotifyDownloadsChannel;

  /// No description provided for @stateNotifyDownloadsChannelDesc.
  ///
  /// In pt, this message translates to:
  /// **'Progresso das músicas baixando'**
  String get stateNotifyDownloadsChannelDesc;

  /// No description provided for @stateNotifyNewsChannel.
  ///
  /// In pt, this message translates to:
  /// **'Novidades'**
  String get stateNotifyNewsChannel;

  /// No description provided for @stateNotifyNewsChannelDesc.
  ///
  /// In pt, this message translates to:
  /// **'Músicas que chegaram, lançamentos, Descobertas e Mistura'**
  String get stateNotifyNewsChannelDesc;

  /// No description provided for @stateOfflineLoose.
  ///
  /// In pt, this message translates to:
  /// **'Baixadas uma a uma'**
  String get stateOfflineLoose;

  /// No description provided for @stateOfflineDoneTitle.
  ///
  /// In pt, this message translates to:
  /// **'Baixadas no aparelho'**
  String get stateOfflineDoneTitle;

  /// No description provided for @stateOfflineDoneBody.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{1 música pronta para ouvir sem internet} other{{count} músicas prontas para ouvir sem internet}}'**
  String stateOfflineDoneBody(int count);

  /// No description provided for @stateOfflineProgressTitle.
  ///
  /// In pt, this message translates to:
  /// **'Baixando no aparelho'**
  String get stateOfflineProgressTitle;

  /// No description provided for @stateOfflineProgressBody.
  ///
  /// In pt, this message translates to:
  /// **'{done} de {total} • {name}'**
  String stateOfflineProgressBody(int done, int total, String name);

  /// No description provided for @stateServerNoReply.
  ///
  /// In pt, this message translates to:
  /// **'O servidor não respondeu. Confira o endereço.'**
  String get stateServerNoReply;

  /// No description provided for @stateServerNoReplyBoth.
  ///
  /// In pt, this message translates to:
  /// **'O servidor não respondeu em nenhum dos dois endereços.'**
  String get stateServerNoReplyBoth;

  /// No description provided for @stateTokenStoreUnsupported.
  ///
  /// In pt, this message translates to:
  /// **'Por enquanto o Pudim só guarda login no Windows e no Android.'**
  String get stateTokenStoreUnsupported;

  /// No description provided for @stateQualityPoor.
  ///
  /// In pt, this message translates to:
  /// **'som fraco'**
  String get stateQualityPoor;

  /// No description provided for @stateQualityPartial.
  ///
  /// In pt, this message translates to:
  /// **'incompleto'**
  String get stateQualityPartial;

  /// No description provided for @audioPlaybackChannel.
  ///
  /// In pt, this message translates to:
  /// **'Reprodução'**
  String get audioPlaybackChannel;

  /// No description provided for @audioRecentAlbums.
  ///
  /// In pt, this message translates to:
  /// **'Álbuns recentes'**
  String get audioRecentAlbums;

  /// No description provided for @audioSearchContext.
  ///
  /// In pt, this message translates to:
  /// **'Busca: {query}'**
  String audioSearchContext(String query);

  /// No description provided for @audioRadioContext.
  ///
  /// In pt, this message translates to:
  /// **'Rádio de {name}'**
  String audioRadioContext(String name);

  /// No description provided for @podcastsMonthShort.
  ///
  /// In pt, this message translates to:
  /// **'{m, select, m1{jan} m2{fev} m3{mar} m4{abr} m5{mai} m6{jun} m7{jul} m8{ago} m9{set} m10{out} m11{nov} other{dez}}'**
  String podcastsMonthShort(String m);

  /// No description provided for @podcastsDateThisYear.
  ///
  /// In pt, this message translates to:
  /// **'{day} de {month}'**
  String podcastsDateThisYear(int day, String month);

  /// No description provided for @podcastsDateOtherYear.
  ///
  /// In pt, this message translates to:
  /// **'{day} de {month} de {year}'**
  String podcastsDateOtherYear(int day, String month, int year);

  /// No description provided for @podcastsHoursMin.
  ///
  /// In pt, this message translates to:
  /// **'{h} h {min} min'**
  String podcastsHoursMin(int h, int min);

  /// No description provided for @podcastsMin.
  ///
  /// In pt, this message translates to:
  /// **'{min} min'**
  String podcastsMin(int min);

  /// No description provided for @podcastsPlayed.
  ///
  /// In pt, this message translates to:
  /// **'ouvido'**
  String get podcastsPlayed;

  /// No description provided for @podcastsTimeLeft.
  ///
  /// In pt, this message translates to:
  /// **'faltam {time}'**
  String podcastsTimeLeft(String time);

  /// No description provided for @podcastsSearchHint.
  ///
  /// In pt, this message translates to:
  /// **'Buscar podcasts'**
  String get podcastsSearchHint;

  /// No description provided for @podcastsNothingFound.
  ///
  /// In pt, this message translates to:
  /// **'Nada encontrado.'**
  String get podcastsNothingFound;

  /// No description provided for @podcastsYours.
  ///
  /// In pt, this message translates to:
  /// **'Seus podcasts'**
  String get podcastsYours;

  /// No description provided for @podcastsNewEpisodes.
  ///
  /// In pt, this message translates to:
  /// **'Episódios novos'**
  String get podcastsNewEpisodes;

  /// No description provided for @podcastsTrendingBrazil.
  ///
  /// In pt, this message translates to:
  /// **'Em alta no Brasil'**
  String get podcastsTrendingBrazil;

  /// No description provided for @podcastsLoadFailed.
  ///
  /// In pt, this message translates to:
  /// **'Não carregou. Tentar de novo'**
  String get podcastsLoadFailed;

  /// No description provided for @podcastsNoEpisodes.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum episódio no feed.'**
  String get podcastsNoEpisodes;

  /// No description provided for @podcastsNoEpisodeMatch.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum episódio com \"{q}\".'**
  String podcastsNoEpisodeMatch(String q);

  /// No description provided for @podcastsKind.
  ///
  /// In pt, this message translates to:
  /// **'Podcast'**
  String get podcastsKind;

  /// No description provided for @podcastsEpisodes.
  ///
  /// In pt, this message translates to:
  /// **'Episódios'**
  String get podcastsEpisodes;

  /// No description provided for @podcastsEpisodesCount.
  ///
  /// In pt, this message translates to:
  /// **'Episódios ({total})'**
  String podcastsEpisodesCount(int total);

  /// No description provided for @podcastsFindEpisode.
  ///
  /// In pt, this message translates to:
  /// **'Procurar episódio'**
  String get podcastsFindEpisode;

  /// No description provided for @showsMonthName.
  ///
  /// In pt, this message translates to:
  /// **'{m, select, m1{janeiro} m2{fevereiro} m3{março} m4{abril} m5{maio} m6{junho} m7{julho} m8{agosto} m9{setembro} m10{outubro} m11{novembro} other{dezembro}}'**
  String showsMonthName(String m);

  /// No description provided for @showsMonthYear.
  ///
  /// In pt, this message translates to:
  /// **'{month} de {year}'**
  String showsMonthYear(String month, int year);

  /// No description provided for @showsWeekdayShort.
  ///
  /// In pt, this message translates to:
  /// **'{m, select, w1{seg} w2{ter} w3{qua} w4{qui} w5{sex} w6{sáb} other{dom}}'**
  String showsWeekdayShort(String m);

  /// No description provided for @showsFollowingNone.
  ///
  /// In pt, this message translates to:
  /// **'Dos artistas que você segue'**
  String get showsFollowingNone;

  /// No description provided for @showsFollowingCount.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{Do 1 artista que você segue} other{Dos {count} artistas que você segue}}'**
  String showsFollowingCount(int count);

  /// No description provided for @showsSearchingFor.
  ///
  /// In pt, this message translates to:
  /// **'procurando shows de {count}…'**
  String showsSearchingFor(int count);

  /// No description provided for @showsUpcoming.
  ///
  /// In pt, this message translates to:
  /// **'Próximos'**
  String get showsUpcoming;

  /// No description provided for @showsPast.
  ///
  /// In pt, this message translates to:
  /// **'Já aconteceram'**
  String get showsPast;

  /// No description provided for @showsInBrazil.
  ///
  /// In pt, this message translates to:
  /// **'No Brasil'**
  String get showsInBrazil;

  /// No description provided for @showsEmptyFollow.
  ///
  /// In pt, this message translates to:
  /// **'Siga artistas (botão Seguir na página do artista) para ver os shows deles aqui.'**
  String get showsEmptyFollow;

  /// No description provided for @showsNonePast.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum show registrado ainda.'**
  String get showsNonePast;

  /// No description provided for @showsNoneUpcoming.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum show marcado por enquanto.'**
  String get showsNoneUpcoming;

  /// No description provided for @showsStillSearching.
  ///
  /// In pt, this message translates to:
  /// **'Ainda procurando…'**
  String get showsStillSearching;

  /// No description provided for @showsSource.
  ///
  /// In pt, this message translates to:
  /// **'Datas do MusicBrainz (feito por fãs); shows novos podem demorar a aparecer.'**
  String get showsSource;

  /// No description provided for @showsCancelled.
  ///
  /// In pt, this message translates to:
  /// **'cancelado'**
  String get showsCancelled;

  /// No description provided for @showsFestival.
  ///
  /// In pt, this message translates to:
  /// **'festival'**
  String get showsFestival;

  /// No description provided for @catalogKindAlbum.
  ///
  /// In pt, this message translates to:
  /// **'Álbum'**
  String get catalogKindAlbum;

  /// No description provided for @catalogKindSingle.
  ///
  /// In pt, this message translates to:
  /// **'Single'**
  String get catalogKindSingle;

  /// No description provided for @catalogKindBroadcast.
  ///
  /// In pt, this message translates to:
  /// **'Transmissão'**
  String get catalogKindBroadcast;

  /// No description provided for @catalogKindOther.
  ///
  /// In pt, this message translates to:
  /// **'Outro'**
  String get catalogKindOther;

  /// No description provided for @catalogSecLive.
  ///
  /// In pt, this message translates to:
  /// **'ao vivo'**
  String get catalogSecLive;

  /// No description provided for @catalogSecCompilation.
  ///
  /// In pt, this message translates to:
  /// **'coletânea'**
  String get catalogSecCompilation;

  /// No description provided for @catalogSecSoundtrack.
  ///
  /// In pt, this message translates to:
  /// **'trilha sonora'**
  String get catalogSecSoundtrack;

  /// No description provided for @catalogSecMixtape.
  ///
  /// In pt, this message translates to:
  /// **'mixtape'**
  String get catalogSecMixtape;

  /// No description provided for @catalogSecInterview.
  ///
  /// In pt, this message translates to:
  /// **'entrevista'**
  String get catalogSecInterview;

  /// No description provided for @catalogSecSpokenword.
  ///
  /// In pt, this message translates to:
  /// **'falado'**
  String get catalogSecSpokenword;

  /// No description provided for @catalogDownloadingOne.
  ///
  /// In pt, this message translates to:
  /// **'Baixando {title}'**
  String catalogDownloadingOne(String title);

  /// No description provided for @catalogDownloadingMany.
  ///
  /// In pt, this message translates to:
  /// **'Baixando {count} álbuns de {artist}'**
  String catalogDownloadingMany(int count, String artist);

  /// No description provided for @catalogCheckingDiscography.
  ///
  /// In pt, this message translates to:
  /// **'Conferindo a discografia… {seconds}s'**
  String catalogCheckingDiscography(int seconds);

  /// No description provided for @catalogToDownload.
  ///
  /// In pt, this message translates to:
  /// **'{count} para baixar'**
  String catalogToDownload(int count);

  /// No description provided for @catalogInLibraryCount.
  ///
  /// In pt, this message translates to:
  /// **'{count} já na biblioteca'**
  String catalogInLibraryCount(int count);

  /// No description provided for @catalogSkippedOneSong.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{1 de 1 música fica de fora} other{{count} de 1 música ficam de fora}}'**
  String catalogSkippedOneSong(int count);

  /// No description provided for @catalogPickAll.
  ///
  /// In pt, this message translates to:
  /// **'Todos'**
  String get catalogPickAll;

  /// No description provided for @catalogPickStudio.
  ///
  /// In pt, this message translates to:
  /// **'Estúdio'**
  String get catalogPickStudio;

  /// No description provided for @catalogPickNone.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum'**
  String get catalogPickNone;

  /// No description provided for @catalogDownloadSelected.
  ///
  /// In pt, this message translates to:
  /// **'Baixar selecionados'**
  String get catalogDownloadSelected;

  /// No description provided for @catalogDownloadNSelected.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{Baixar 1 selecionado} other{Baixar {count} selecionados}}'**
  String catalogDownloadNSelected(int count);

  /// No description provided for @catalogNothingMissing.
  ///
  /// In pt, this message translates to:
  /// **'Nada faltando.'**
  String get catalogNothingMissing;

  /// No description provided for @catalogPartial.
  ///
  /// In pt, this message translates to:
  /// **'parcial'**
  String get catalogPartial;

  /// No description provided for @catalogDownload.
  ///
  /// In pt, this message translates to:
  /// **'Baixar'**
  String get catalogDownload;

  /// No description provided for @catalogAddToLibrary.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar à Sua Biblioteca'**
  String get catalogAddToLibrary;

  /// No description provided for @catalogInYourLibrary.
  ///
  /// In pt, this message translates to:
  /// **'Na Sua Biblioteca'**
  String get catalogInYourLibrary;

  /// No description provided for @catalogAllInLibrary.
  ///
  /// In pt, this message translates to:
  /// **'tudo na biblioteca'**
  String get catalogAllInLibrary;

  /// No description provided for @catalogNInLibrary.
  ///
  /// In pt, this message translates to:
  /// **'{count} na biblioteca'**
  String catalogNInLibrary(int count);

  /// No description provided for @catalogDownloadAlbum.
  ///
  /// In pt, this message translates to:
  /// **'Baixar álbum'**
  String get catalogDownloadAlbum;

  /// No description provided for @catalogArtistNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Artista não encontrado.'**
  String get catalogArtistNotFound;

  /// No description provided for @catalogFromCatalog.
  ///
  /// In pt, this message translates to:
  /// **'Do catálogo: ainda não está na biblioteca'**
  String get catalogFromCatalog;

  /// No description provided for @catalogDownloadAll.
  ///
  /// In pt, this message translates to:
  /// **'Baixar tudo'**
  String get catalogDownloadAll;

  /// No description provided for @catalogDownloadDiscography.
  ///
  /// In pt, this message translates to:
  /// **'Baixar discografia'**
  String get catalogDownloadDiscography;

  /// No description provided for @catalogPopular.
  ///
  /// In pt, this message translates to:
  /// **'Populares'**
  String get catalogPopular;

  /// No description provided for @catalogShowLess.
  ///
  /// In pt, this message translates to:
  /// **'Mostrar menos'**
  String get catalogShowLess;

  /// No description provided for @catalogShowMore.
  ///
  /// In pt, this message translates to:
  /// **'Ver mais'**
  String get catalogShowMore;

  /// No description provided for @catalogSinglesEps.
  ///
  /// In pt, this message translates to:
  /// **'Singles e EPs'**
  String get catalogSinglesEps;

  /// No description provided for @catalogFansAlsoLike.
  ///
  /// In pt, this message translates to:
  /// **'Fãs também curtem'**
  String get catalogFansAlsoLike;

  /// No description provided for @lyricsPlaySomething.
  ///
  /// In pt, this message translates to:
  /// **'Toque alguma coisa para ver a letra.'**
  String get lyricsPlaySomething;

  /// No description provided for @lyricsNone.
  ///
  /// In pt, this message translates to:
  /// **'Sem letra para esta música'**
  String get lyricsNone;

  /// No description provided for @lyricsNoneHint.
  ///
  /// In pt, this message translates to:
  /// **'Quando tiver um .lrc ou .txt ao lado do arquivo, ela aparece aqui.'**
  String get lyricsNoneHint;

  /// No description provided for @lyricsSynced.
  ///
  /// In pt, this message translates to:
  /// **'Letra sincronizada do arquivo .lrc'**
  String get lyricsSynced;

  /// No description provided for @lyricsUnsynced.
  ///
  /// In pt, this message translates to:
  /// **'Letra sem sincronização'**
  String get lyricsUnsynced;

  /// No description provided for @profileChangePhoto.
  ///
  /// In pt, this message translates to:
  /// **'Trocar foto'**
  String get profileChangePhoto;

  /// No description provided for @profileNoPhoto.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma foto escolhida'**
  String get profileNoPhoto;

  /// No description provided for @profilePhotoTooBig.
  ///
  /// In pt, this message translates to:
  /// **'Foto grande demais (até 8 MB)'**
  String get profilePhotoTooBig;

  /// No description provided for @profilePhotoChanged.
  ///
  /// In pt, this message translates to:
  /// **'Foto do perfil trocada'**
  String get profilePhotoChanged;

  /// No description provided for @profilePhotoRemoved.
  ///
  /// In pt, this message translates to:
  /// **'Foto removida'**
  String get profilePhotoRemoved;

  /// No description provided for @profileNameSaved.
  ///
  /// In pt, this message translates to:
  /// **'Nome do perfil salvo'**
  String get profileNameSaved;

  /// No description provided for @profileRenameTitle.
  ///
  /// In pt, this message translates to:
  /// **'Trocar o nome de usuário?'**
  String get profileRenameTitle;

  /// No description provided for @profileRenameBody.
  ///
  /// In pt, this message translates to:
  /// **'Você passa a entrar como \"{name}\" no Pudim, no Jellyfin e nos outros apps (Finamp, Feishin…). Suas Descobertas, Mistura e Retrospectiva vêm junto.'**
  String profileRenameBody(String name);

  /// No description provided for @profileRenameConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Trocar'**
  String get profileRenameConfirm;

  /// No description provided for @profileNowSignedAs.
  ///
  /// In pt, this message translates to:
  /// **'Agora você entra como {name}'**
  String profileNowSignedAs(String name);

  /// No description provided for @profileEnterNewPassword.
  ///
  /// In pt, this message translates to:
  /// **'Digite a senha nova'**
  String get profileEnterNewPassword;

  /// No description provided for @profilePasswordsDiffer.
  ///
  /// In pt, this message translates to:
  /// **'As senhas novas não são iguais'**
  String get profilePasswordsDiffer;

  /// No description provided for @profilePasswordChanged.
  ///
  /// In pt, this message translates to:
  /// **'Senha trocada'**
  String get profilePasswordChanged;

  /// No description provided for @profileExtrasUnreachable.
  ///
  /// In pt, this message translates to:
  /// **'Não consegui falar com o servidor de extras; o nome do perfil e o de usuário ficam para depois.'**
  String get profileExtrasUnreachable;

  /// No description provided for @profileNameSection.
  ///
  /// In pt, this message translates to:
  /// **'Nome no perfil'**
  String get profileNameSection;

  /// No description provided for @profileNameHelp.
  ///
  /// In pt, this message translates to:
  /// **'É como seus contatos veem você nas conversas.'**
  String get profileNameHelp;

  /// No description provided for @profileYourName.
  ///
  /// In pt, this message translates to:
  /// **'Seu nome'**
  String get profileYourName;

  /// No description provided for @profileUsernameSection.
  ///
  /// In pt, this message translates to:
  /// **'Nome de usuário'**
  String get profileUsernameSection;

  /// No description provided for @profileUsernameHelp.
  ///
  /// In pt, this message translates to:
  /// **'O nome para entrar no Jellyfin (aqui e nos outros apps).'**
  String get profileUsernameHelp;

  /// No description provided for @profileUsernameHint.
  ///
  /// In pt, this message translates to:
  /// **'Usuário'**
  String get profileUsernameHint;

  /// No description provided for @profileChangeUsername.
  ///
  /// In pt, this message translates to:
  /// **'Trocar usuário'**
  String get profileChangeUsername;

  /// No description provided for @profilePasswordSection.
  ///
  /// In pt, this message translates to:
  /// **'Senha'**
  String get profilePasswordSection;

  /// No description provided for @profileCurrentPassword.
  ///
  /// In pt, this message translates to:
  /// **'Senha atual'**
  String get profileCurrentPassword;

  /// No description provided for @profileNewPassword.
  ///
  /// In pt, this message translates to:
  /// **'Senha nova'**
  String get profileNewPassword;

  /// No description provided for @profileRepeatPassword.
  ///
  /// In pt, this message translates to:
  /// **'Repita a senha nova'**
  String get profileRepeatPassword;

  /// No description provided for @profileChangePassword.
  ///
  /// In pt, this message translates to:
  /// **'Trocar senha'**
  String get profileChangePassword;

  /// No description provided for @loginServerRequired.
  ///
  /// In pt, this message translates to:
  /// **'Digite o endereço do seu servidor Jellyfin.'**
  String get loginServerRequired;

  /// No description provided for @loginUserRequired.
  ///
  /// In pt, this message translates to:
  /// **'Digite seu nome de usuário.'**
  String get loginUserRequired;

  /// No description provided for @loginTitle.
  ///
  /// In pt, this message translates to:
  /// **'Entrar no Pudim'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Use sua conta do Jellyfin.'**
  String get loginSubtitle;

  /// No description provided for @loginUsername.
  ///
  /// In pt, this message translates to:
  /// **'Nome de usuário'**
  String get loginUsername;

  /// No description provided for @loginPassword.
  ///
  /// In pt, this message translates to:
  /// **'Senha'**
  String get loginPassword;

  /// No description provided for @loginShowPassword.
  ///
  /// In pt, this message translates to:
  /// **'Mostrar senha'**
  String get loginShowPassword;

  /// No description provided for @loginHidePassword.
  ///
  /// In pt, this message translates to:
  /// **'Esconder senha'**
  String get loginHidePassword;

  /// No description provided for @loginSubmit.
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get loginSubmit;

  /// No description provided for @loginQuickConnect.
  ///
  /// In pt, this message translates to:
  /// **'Entrar com Quick Connect'**
  String get loginQuickConnect;

  /// No description provided for @loginHideAddresses.
  ///
  /// In pt, this message translates to:
  /// **'Esconder endereços'**
  String get loginHideAddresses;

  /// No description provided for @loginServerAddress.
  ///
  /// In pt, this message translates to:
  /// **'Endereço do servidor'**
  String get loginServerAddress;

  /// No description provided for @loginJellyfinServer.
  ///
  /// In pt, this message translates to:
  /// **'Servidor Jellyfin'**
  String get loginJellyfinServer;

  /// No description provided for @loginJellyfinServerExample.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: https://jellyfin.exemplo.com'**
  String get loginJellyfinServerExample;

  /// No description provided for @loginLocalNetwork.
  ///
  /// In pt, this message translates to:
  /// **'Na rede local (opcional)'**
  String get loginLocalNetwork;

  /// No description provided for @loginLocalNetworkExample.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: http://192.168.0.10:8096. Quando responde, o app usa este no lugar do principal.'**
  String get loginLocalNetworkExample;

  /// No description provided for @loginExtrasServer.
  ///
  /// In pt, this message translates to:
  /// **'Servidor de extras (opcional)'**
  String get loginExtrasServer;

  /// No description provided for @loginExtrasServerHint.
  ///
  /// In pt, this message translates to:
  /// **'Liga chat, Jam, Blend, mixes e Retrospectiva. Deixe vazio se não tiver.'**
  String get loginExtrasServerHint;

  /// No description provided for @loginQcExpired.
  ///
  /// In pt, this message translates to:
  /// **'O código expirou. Tente de novo.'**
  String get loginQcExpired;

  /// No description provided for @loginQcInstructions.
  ///
  /// In pt, this message translates to:
  /// **'Num aparelho em que você já entrou no Jellyfin, abra o seu perfil, toque em Quick Connect e digite este código:'**
  String get loginQcInstructions;

  /// No description provided for @loginQcWaiting.
  ///
  /// In pt, this message translates to:
  /// **'Esperando a aprovação…'**
  String get loginQcWaiting;

  /// No description provided for @homeDownloadedOnDevice.
  ///
  /// In pt, this message translates to:
  /// **'Baixadas no aparelho'**
  String get homeDownloadedOnDevice;

  /// No description provided for @homeTabMusic.
  ///
  /// In pt, this message translates to:
  /// **'Música'**
  String get homeTabMusic;

  /// No description provided for @homeMadeFor.
  ///
  /// In pt, this message translates to:
  /// **'Feito para'**
  String get homeMadeFor;

  /// No description provided for @homeMixDiscoveries.
  ///
  /// In pt, this message translates to:
  /// **'Músicas novas para você, toda semana'**
  String get homeMixDiscoveries;

  /// No description provided for @homeMixWeekly.
  ///
  /// In pt, this message translates to:
  /// **'Seus favoritos e parecidos, toda semana'**
  String get homeMixWeekly;

  /// No description provided for @homeMixRadar.
  ///
  /// In pt, this message translates to:
  /// **'Lançamentos de quem você segue, toda sexta'**
  String get homeMixRadar;

  /// No description provided for @homeMixDaylist.
  ///
  /// In pt, this message translates to:
  /// **'Muda ao longo do dia'**
  String get homeMixDaylist;

  /// No description provided for @homeMixBlend.
  ///
  /// In pt, this message translates to:
  /// **'O gosto de vocês dois junto'**
  String get homeMixBlend;

  /// No description provided for @homeMixAuto.
  ///
  /// In pt, this message translates to:
  /// **'Mix automático'**
  String get homeMixAuto;

  /// No description provided for @homeSpotifyPlaylists.
  ///
  /// In pt, this message translates to:
  /// **'Suas playlists do Spotify'**
  String get homeSpotifyPlaylists;

  /// No description provided for @homeFromSpotify.
  ///
  /// In pt, this message translates to:
  /// **'Do Spotify'**
  String get homeFromSpotify;

  /// No description provided for @homeYourPlaylists.
  ///
  /// In pt, this message translates to:
  /// **'Suas playlists'**
  String get homeYourPlaylists;

  /// No description provided for @homeTopAlbums.
  ///
  /// In pt, this message translates to:
  /// **'Seus álbuns mais tocados'**
  String get homeTopAlbums;

  /// No description provided for @homeTopArtists.
  ///
  /// In pt, this message translates to:
  /// **'Seus artistas favoritos'**
  String get homeTopArtists;

  /// No description provided for @homeRecentlyAdded.
  ///
  /// In pt, this message translates to:
  /// **'Adicionados recentemente'**
  String get homeRecentlyAdded;

  /// No description provided for @homeYourPodcasts.
  ///
  /// In pt, this message translates to:
  /// **'Seus podcasts'**
  String get homeYourPodcasts;

  /// No description provided for @homeRadiosTitle.
  ///
  /// In pt, this message translates to:
  /// **'Rádios recomendadas'**
  String get homeRadiosTitle;

  /// No description provided for @homeRadiosSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Música sem parar com base nos seus artistas favoritos.'**
  String get homeRadiosSubtitle;

  /// No description provided for @homeRadioBadge.
  ///
  /// In pt, this message translates to:
  /// **'RÁDIO'**
  String get homeRadioBadge;

  /// No description provided for @homeRadioWith.
  ///
  /// In pt, this message translates to:
  /// **'Com {name} e artistas parecidos'**
  String homeRadioWith(String name);

  /// No description provided for @searchNoResults.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum resultado encontrado para \"{query}\"'**
  String searchNoResults(String query);

  /// No description provided for @searchNoResultsHint.
  ///
  /// In pt, this message translates to:
  /// **'Verifique a ortografia ou use menos palavras ou palavras diferentes.'**
  String get searchNoResultsHint;

  /// No description provided for @searchCatalogNoResponse.
  ///
  /// In pt, this message translates to:
  /// **'O catálogo não respondeu: {error}'**
  String searchCatalogNoResponse(String error);

  /// No description provided for @searchAlsoCatalog.
  ///
  /// In pt, this message translates to:
  /// **'Buscando também no catálogo…'**
  String get searchAlsoCatalog;

  /// No description provided for @searchLibraryOnly.
  ///
  /// In pt, this message translates to:
  /// **'Só a biblioteca: o catálogo não respondeu ({error}).'**
  String searchLibraryOnly(String error);

  /// No description provided for @searchTopResult.
  ///
  /// In pt, this message translates to:
  /// **'Melhor resultado'**
  String get searchTopResult;

  /// No description provided for @searchSpotifyPlaylists.
  ///
  /// In pt, this message translates to:
  /// **'Playlists do Spotify'**
  String get searchSpotifyPlaylists;

  /// No description provided for @searchRecent.
  ///
  /// In pt, this message translates to:
  /// **'Buscas recentes'**
  String get searchRecent;

  /// No description provided for @searchClear.
  ///
  /// In pt, this message translates to:
  /// **'Limpar'**
  String get searchClear;

  /// No description provided for @searchBrowseAll.
  ///
  /// In pt, this message translates to:
  /// **'Navegar por todas as seções'**
  String get searchBrowseAll;

  /// No description provided for @searchHint.
  ///
  /// In pt, this message translates to:
  /// **'O que você quer ouvir?'**
  String get searchHint;

  /// No description provided for @albumDownloadedType.
  ///
  /// In pt, this message translates to:
  /// **'Álbum • baixado no aparelho'**
  String get albumDownloadedType;

  /// No description provided for @albumSongsAndTime.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{1 música} other{{count} músicas}}, {total}'**
  String albumSongsAndTime(int count, String total);

  /// No description provided for @albumRemoveFromLibrary.
  ///
  /// In pt, this message translates to:
  /// **'Remover da Sua Biblioteca'**
  String get albumRemoveFromLibrary;

  /// No description provided for @albumSaveToLibrary.
  ///
  /// In pt, this message translates to:
  /// **'Salvar na Sua Biblioteca'**
  String get albumSaveToLibrary;

  /// No description provided for @albumMoreOptions.
  ///
  /// In pt, this message translates to:
  /// **'Mais opções para {name}'**
  String albumMoreOptions(String name);

  /// No description provided for @albumDisc.
  ///
  /// In pt, this message translates to:
  /// **'Disco {number}'**
  String albumDisc(int number);

  /// No description provided for @albumMoreFrom.
  ///
  /// In pt, this message translates to:
  /// **'Mais de {name}'**
  String albumMoreFrom(String name);

  /// No description provided for @artistAlbumsInLibrary.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{1 álbum na biblioteca} other{{count} álbuns na biblioteca}}'**
  String artistAlbumsInLibrary(int count);

  /// No description provided for @artistPlays.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{1 reprodução} other{{count} reproduções}}'**
  String artistPlays(int count);

  /// No description provided for @artistMoreOptions.
  ///
  /// In pt, this message translates to:
  /// **'Mais opções para {name}'**
  String artistMoreOptions(String name);

  /// No description provided for @artistPopular.
  ///
  /// In pt, this message translates to:
  /// **'Populares'**
  String get artistPopular;

  /// No description provided for @artistShowLess.
  ///
  /// In pt, this message translates to:
  /// **'Mostrar menos'**
  String get artistShowLess;

  /// No description provided for @artistShowMore.
  ///
  /// In pt, this message translates to:
  /// **'Ver mais'**
  String get artistShowMore;

  /// No description provided for @artistYouLiked.
  ///
  /// In pt, this message translates to:
  /// **'Você curtiu'**
  String get artistYouLiked;

  /// No description provided for @artistFrom.
  ///
  /// In pt, this message translates to:
  /// **'De {name}'**
  String artistFrom(String name);

  /// No description provided for @artistDiscography.
  ///
  /// In pt, this message translates to:
  /// **'Discografia'**
  String get artistDiscography;

  /// No description provided for @artistPopularReleases.
  ///
  /// In pt, this message translates to:
  /// **'Lançamentos populares'**
  String get artistPopularReleases;

  /// No description provided for @artistSinglesEps.
  ///
  /// In pt, this message translates to:
  /// **'Singles e EPs'**
  String get artistSinglesEps;

  /// No description provided for @artistFansAlsoLike.
  ///
  /// In pt, this message translates to:
  /// **'Fãs também curtem'**
  String get artistFansAlsoLike;

  /// No description provided for @artistAppearsOn.
  ///
  /// In pt, this message translates to:
  /// **'Aparece em'**
  String get artistAppearsOn;

  /// No description provided for @artistAbout.
  ///
  /// In pt, this message translates to:
  /// **'Sobre'**
  String get artistAbout;

  /// No description provided for @playlistOriginSpotify.
  ///
  /// In pt, this message translates to:
  /// **'Do Spotify'**
  String get playlistOriginSpotify;

  /// No description provided for @playlistOriginMadeForYou.
  ///
  /// In pt, this message translates to:
  /// **'Feita para você'**
  String get playlistOriginMadeForYou;

  /// No description provided for @playlistOriginAuto.
  ///
  /// In pt, this message translates to:
  /// **'Mix automático'**
  String get playlistOriginAuto;

  /// No description provided for @playlistDownloadedOnDevice.
  ///
  /// In pt, this message translates to:
  /// **'Baixada no aparelho'**
  String get playlistDownloadedOnDevice;

  /// No description provided for @playlistOnDevice.
  ///
  /// In pt, this message translates to:
  /// **'No aparelho'**
  String get playlistOnDevice;

  /// No description provided for @playlistPlaysOffline.
  ///
  /// In pt, this message translates to:
  /// **'Tocam sem internet.'**
  String get playlistPlaysOffline;

  /// No description provided for @playlistPlaysOfflineDownloading.
  ///
  /// In pt, this message translates to:
  /// **'Tocam sem internet. Baixando mais {count}…'**
  String playlistPlaysOfflineDownloading(int count);

  /// No description provided for @playlistSongsAndTime.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{1 música} other{{count} músicas}}, {total}'**
  String playlistSongsAndTime(int count, String total);

  /// No description provided for @playlistMoreOptions.
  ///
  /// In pt, this message translates to:
  /// **'Mais opções para {name}'**
  String playlistMoreOptions(String name);

  /// No description provided for @playlistSearchHint.
  ///
  /// In pt, this message translates to:
  /// **'Buscar na playlist'**
  String get playlistSearchHint;

  /// No description provided for @playlistEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma música por aqui ainda.'**
  String get playlistEmpty;

  /// No description provided for @playlistErrNoPermission.
  ///
  /// In pt, this message translates to:
  /// **'Sem permissão para editar essa playlist.'**
  String get playlistErrNoPermission;

  /// No description provided for @playlistErrServer.
  ///
  /// In pt, this message translates to:
  /// **'O servidor não aceitou ({code}).'**
  String playlistErrServer(String code);

  /// No description provided for @playlistErrNoResponse.
  ///
  /// In pt, this message translates to:
  /// **'sem resposta'**
  String get playlistErrNoResponse;

  /// No description provided for @playlistDownloadFirst.
  ///
  /// In pt, this message translates to:
  /// **'Baixe a música primeiro para pôr numa playlist'**
  String get playlistDownloadFirst;

  /// No description provided for @playlistAddTo.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar à playlist'**
  String get playlistAddTo;

  /// No description provided for @playlistNew.
  ///
  /// In pt, this message translates to:
  /// **'Nova playlist'**
  String get playlistNew;

  /// No description provided for @playlistAddedTo.
  ///
  /// In pt, this message translates to:
  /// **'Adicionada a {name}'**
  String playlistAddedTo(String name);

  /// No description provided for @playlistNameHint.
  ///
  /// In pt, this message translates to:
  /// **'Nome da playlist'**
  String get playlistNameHint;

  /// No description provided for @playlistCreate.
  ///
  /// In pt, this message translates to:
  /// **'Criar'**
  String get playlistCreate;

  /// No description provided for @playlistCreated.
  ///
  /// In pt, this message translates to:
  /// **'Playlist {name} criada'**
  String playlistCreated(String name);

  /// No description provided for @playlistRemoved.
  ///
  /// In pt, this message translates to:
  /// **'Removida da playlist'**
  String get playlistRemoved;

  /// No description provided for @playlistInviteTitle.
  ///
  /// In pt, this message translates to:
  /// **'Convidar para editar'**
  String get playlistInviteTitle;

  /// No description provided for @playlistInviteSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'A pessoa vê a playlist na biblioteca dela e pode adicionar e tirar músicas.'**
  String get playlistInviteSubtitle;

  /// No description provided for @playlistInviteOwnerOnly.
  ///
  /// In pt, this message translates to:
  /// **'Só quem criou a playlist pode convidar'**
  String get playlistInviteOwnerOnly;

  /// No description provided for @playlistInvited.
  ///
  /// In pt, this message translates to:
  /// **'{who} agora pode editar {playlist}'**
  String playlistInvited(String who, String playlist);

  /// No description provided for @playlistCollaborative.
  ///
  /// In pt, this message translates to:
  /// **'Colaborativa · {members}'**
  String playlistCollaborative(String members);

  /// No description provided for @playlistSmartShuffleTooltip.
  ///
  /// In pt, this message translates to:
  /// **'Smart Shuffle: aleatório com recomendações'**
  String get playlistSmartShuffleTooltip;

  /// No description provided for @playlistSmartShuffleOn.
  ///
  /// In pt, this message translates to:
  /// **'Smart Shuffle ligado: recomendações marcadas com ✦'**
  String get playlistSmartShuffleOn;

  /// No description provided for @playlistAddedToThis.
  ///
  /// In pt, this message translates to:
  /// **'Adicionada à playlist'**
  String get playlistAddedToThis;

  /// No description provided for @playlistRecommendation.
  ///
  /// In pt, this message translates to:
  /// **'Recomendação do Smart Shuffle'**
  String get playlistRecommendation;

  /// No description provided for @playlistPutIn.
  ///
  /// In pt, this message translates to:
  /// **'Pôr na playlist'**
  String get playlistPutIn;

  /// No description provided for @settingsSectionAccount.
  ///
  /// In pt, this message translates to:
  /// **'Conta'**
  String get settingsSectionAccount;

  /// No description provided for @settingsProfileSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Nome, usuário e senha'**
  String get settingsProfileSubtitle;

  /// No description provided for @settingsConnectedAt.
  ///
  /// In pt, this message translates to:
  /// **'Conectado em {url}'**
  String settingsConnectedAt(String url);

  /// No description provided for @settingsSignOut.
  ///
  /// In pt, this message translates to:
  /// **'Sair'**
  String get settingsSignOut;

  /// No description provided for @settingsSectionServer.
  ///
  /// In pt, this message translates to:
  /// **'Servidor'**
  String get settingsSectionServer;

  /// No description provided for @settingsLocalNetwork.
  ///
  /// In pt, this message translates to:
  /// **'Na rede local'**
  String get settingsLocalNetwork;

  /// No description provided for @settingsServerNote.
  ///
  /// In pt, this message translates to:
  /// **'Para trocar os endereços do Jellyfin, saia da conta e abra \"Endereço do servidor\" na tela de entrada.'**
  String get settingsServerNote;

  /// No description provided for @settingsExtrasServer.
  ///
  /// In pt, this message translates to:
  /// **'Servidor de extras'**
  String get settingsExtrasServer;

  /// No description provided for @settingsExtrasNotConfigured.
  ///
  /// In pt, this message translates to:
  /// **'Não configurado (chat, Jam, Blend, mixes e Retrospectiva ficam escondidos)'**
  String get settingsExtrasNotConfigured;

  /// No description provided for @settingsConfigure.
  ///
  /// In pt, this message translates to:
  /// **'Configurar'**
  String get settingsConfigure;

  /// No description provided for @settingsChange.
  ///
  /// In pt, this message translates to:
  /// **'Trocar'**
  String get settingsChange;

  /// No description provided for @settingsSectionPlayback.
  ///
  /// In pt, this message translates to:
  /// **'Reprodução'**
  String get settingsSectionPlayback;

  /// No description provided for @settingsQualityWifi.
  ///
  /// In pt, this message translates to:
  /// **'Qualidade no Wi-Fi'**
  String get settingsQualityWifi;

  /// No description provided for @settingsQualityWifiSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Original toca o arquivo como está na biblioteca.'**
  String get settingsQualityWifiSubtitle;

  /// No description provided for @settingsQualityMobile.
  ///
  /// In pt, this message translates to:
  /// **'Qualidade nos dados móveis'**
  String get settingsQualityMobile;

  /// No description provided for @settingsQualityMobileSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Uma qualidade menor gasta menos internet do celular.'**
  String get settingsQualityMobileSubtitle;

  /// No description provided for @settingsQualityOriginal.
  ///
  /// In pt, this message translates to:
  /// **'Original'**
  String get settingsQualityOriginal;

  /// No description provided for @settingsAppliesNextSong.
  ///
  /// In pt, this message translates to:
  /// **'Vale a partir da próxima música'**
  String get settingsAppliesNextSong;

  /// No description provided for @settingsSectionAbout.
  ///
  /// In pt, this message translates to:
  /// **'Sobre'**
  String get settingsSectionAbout;

  /// No description provided for @settingsBuild.
  ///
  /// In pt, this message translates to:
  /// **'Build {build}'**
  String settingsBuild(int build);

  /// No description provided for @settingsExtrasEmptyHint.
  ///
  /// In pt, this message translates to:
  /// **'Deixe vazio para desligar os extras.'**
  String get settingsExtrasEmptyHint;

  /// No description provided for @settingsAutoplay.
  ///
  /// In pt, this message translates to:
  /// **'Reprodução automática'**
  String get settingsAutoplay;

  /// No description provided for @settingsAutoplaySubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Quando a fila acabar, continua tocando músicas parecidas (mix do Jellyfin).'**
  String get settingsAutoplaySubtitle;

  /// No description provided for @settingsNormalize.
  ///
  /// In pt, this message translates to:
  /// **'Normalizar o volume'**
  String get settingsNormalize;

  /// No description provided for @settingsNormalizeSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Deixa todas as músicas no mesmo volume, com a análise feita pelo Jellyfin.'**
  String get settingsNormalizeSubtitle;

  /// No description provided for @settingsScrobble.
  ///
  /// In pt, this message translates to:
  /// **'Scrobble'**
  String get settingsScrobble;

  /// No description provided for @settingsLoading.
  ///
  /// In pt, this message translates to:
  /// **'Carregando…'**
  String get settingsLoading;

  /// No description provided for @settingsLastfmNoKey.
  ///
  /// In pt, this message translates to:
  /// **'O servidor de extras ainda não tem uma chave da API do Last.fm configurada.'**
  String get settingsLastfmNoKey;

  /// No description provided for @settingsConnectedAs.
  ///
  /// In pt, this message translates to:
  /// **'Conectado como {name}'**
  String settingsConnectedAs(String name);

  /// No description provided for @settingsLastfmConnectedSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Tudo que você ouve no Pudim vai para o seu perfil do Last.fm.'**
  String get settingsLastfmConnectedSubtitle;

  /// No description provided for @settingsDisconnect.
  ///
  /// In pt, this message translates to:
  /// **'Desconectar'**
  String get settingsDisconnect;

  /// No description provided for @settingsLastfmAuthorize.
  ///
  /// In pt, this message translates to:
  /// **'Autorize na página do Last.fm'**
  String get settingsLastfmAuthorize;

  /// No description provided for @settingsLastfmAuthorizeSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Depois de clicar em \"Yes, allow access\" lá, volte e toque em Concluir.'**
  String get settingsLastfmAuthorizeSubtitle;

  /// No description provided for @settingsFinish.
  ///
  /// In pt, this message translates to:
  /// **'Concluir'**
  String get settingsFinish;

  /// No description provided for @settingsLastfmConnected.
  ///
  /// In pt, this message translates to:
  /// **'Last.fm conectado'**
  String get settingsLastfmConnected;

  /// No description provided for @settingsLastfmScrobbleSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Registra no seu Last.fm cada música que você ouve.'**
  String get settingsLastfmScrobbleSubtitle;

  /// No description provided for @settingsConnect.
  ///
  /// In pt, this message translates to:
  /// **'Conectar'**
  String get settingsConnect;

  /// No description provided for @sidebarOpenLibrary.
  ///
  /// In pt, this message translates to:
  /// **'Abrir Sua Biblioteca'**
  String get sidebarOpenLibrary;

  /// No description provided for @sidebarCollapseLibrary.
  ///
  /// In pt, this message translates to:
  /// **'Recolher Sua Biblioteca'**
  String get sidebarCollapseLibrary;

  /// No description provided for @sidebarOnDeviceCount.
  ///
  /// In pt, this message translates to:
  /// **'No aparelho • {count, plural, =1{1 música} other{{count} músicas}}'**
  String sidebarOnDeviceCount(int count);

  /// No description provided for @sidebarPlaylistCount.
  ///
  /// In pt, this message translates to:
  /// **'Playlist • {count, plural, =1{1 música} other{{count} músicas}}'**
  String sidebarPlaylistCount(int count);

  /// No description provided for @sidebarAlbumBy.
  ///
  /// In pt, this message translates to:
  /// **'Álbum • {artist}'**
  String sidebarAlbumBy(String artist);

  /// No description provided for @sidebarSearchLibrary.
  ///
  /// In pt, this message translates to:
  /// **'Buscar na Sua Biblioteca'**
  String get sidebarSearchLibrary;

  /// No description provided for @sidebarSortBy.
  ///
  /// In pt, this message translates to:
  /// **'Ordenar por'**
  String get sidebarSortBy;

  /// No description provided for @sidebarSortRecents.
  ///
  /// In pt, this message translates to:
  /// **'Recentes'**
  String get sidebarSortRecents;

  /// No description provided for @sidebarSortAdded.
  ///
  /// In pt, this message translates to:
  /// **'Adicionados recentemente'**
  String get sidebarSortAdded;

  /// No description provided for @sidebarSortAlpha.
  ///
  /// In pt, this message translates to:
  /// **'Alfabética'**
  String get sidebarSortAlpha;

  /// No description provided for @sidebarSortCreator.
  ///
  /// In pt, this message translates to:
  /// **'Criador'**
  String get sidebarSortCreator;

  /// No description provided for @topBarSearchHint.
  ///
  /// In pt, this message translates to:
  /// **'O que você quer ouvir?'**
  String get topBarSearchHint;

  /// No description provided for @topBarClearSearch.
  ///
  /// In pt, this message translates to:
  /// **'Limpar campo de busca'**
  String get topBarClearSearch;

  /// No description provided for @topBarBrowse.
  ///
  /// In pt, this message translates to:
  /// **'Navegar'**
  String get topBarBrowse;

  /// No description provided for @topBarMenu.
  ///
  /// In pt, this message translates to:
  /// **'Menu'**
  String get topBarMenu;

  /// No description provided for @topBarLogoutAccount.
  ///
  /// In pt, this message translates to:
  /// **'Sair da conta'**
  String get topBarLogoutAccount;

  /// No description provided for @topBarQuit.
  ///
  /// In pt, this message translates to:
  /// **'Fechar o Pudim'**
  String get topBarQuit;

  /// No description provided for @topBarLogout.
  ///
  /// In pt, this message translates to:
  /// **'Sair'**
  String get topBarLogout;

  /// No description provided for @playerBarSmartShuffleOff.
  ///
  /// In pt, this message translates to:
  /// **'Desativar o Smart Shuffle'**
  String get playerBarSmartShuffleOff;

  /// No description provided for @playerBarSmartShuffleOn.
  ///
  /// In pt, this message translates to:
  /// **'Ativar o Smart Shuffle'**
  String get playerBarSmartShuffleOn;

  /// No description provided for @playerBarShuffleOff.
  ///
  /// In pt, this message translates to:
  /// **'Desativar a ordem aleatória'**
  String get playerBarShuffleOff;

  /// No description provided for @playerBarShuffleOn.
  ///
  /// In pt, this message translates to:
  /// **'Ativar a ordem aleatória'**
  String get playerBarShuffleOn;

  /// No description provided for @playerBarPlay.
  ///
  /// In pt, this message translates to:
  /// **'Play'**
  String get playerBarPlay;

  /// No description provided for @playerBarForward.
  ///
  /// In pt, this message translates to:
  /// **'Avançar'**
  String get playerBarForward;

  /// No description provided for @playerBarRepeatOn.
  ///
  /// In pt, this message translates to:
  /// **'Ativar a repetição'**
  String get playerBarRepeatOn;

  /// No description provided for @playerBarRepeatOne.
  ///
  /// In pt, this message translates to:
  /// **'Ativar a repetição de uma faixa'**
  String get playerBarRepeatOne;

  /// No description provided for @playerBarRepeatOff.
  ///
  /// In pt, this message translates to:
  /// **'Desativar a repetição'**
  String get playerBarRepeatOff;

  /// No description provided for @playerBarNowPlayingView.
  ///
  /// In pt, this message translates to:
  /// **'Tela Tocando agora'**
  String get playerBarNowPlayingView;

  /// No description provided for @playerBarLyrics.
  ///
  /// In pt, this message translates to:
  /// **'Letra'**
  String get playerBarLyrics;

  /// No description provided for @playerBarUnmute.
  ///
  /// In pt, this message translates to:
  /// **'Com som'**
  String get playerBarUnmute;

  /// No description provided for @playerBarMute.
  ///
  /// In pt, this message translates to:
  /// **'Mudo'**
  String get playerBarMute;

  /// No description provided for @rightPanelNothingPlaying.
  ///
  /// In pt, this message translates to:
  /// **'Toque alguma coisa para ver aqui o que está tocando.'**
  String get rightPanelNothingPlaying;

  /// No description provided for @rightPanelLyricsPreview.
  ///
  /// In pt, this message translates to:
  /// **'Prévia da letra'**
  String get rightPanelLyricsPreview;

  /// No description provided for @rightPanelAboutArtist.
  ///
  /// In pt, this message translates to:
  /// **'Sobre o artista'**
  String get rightPanelAboutArtist;

  /// No description provided for @rightPanelNextUp.
  ///
  /// In pt, this message translates to:
  /// **'A seguir'**
  String get rightPanelNextUp;

  /// No description provided for @rightPanelOpenQueue.
  ///
  /// In pt, this message translates to:
  /// **'Abrir fila'**
  String get rightPanelOpenQueue;

  /// No description provided for @rightPanelQueueEmptyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Adicione à fila'**
  String get rightPanelQueueEmptyTitle;

  /// No description provided for @rightPanelQueueEmptyHint.
  ///
  /// In pt, this message translates to:
  /// **'Clique em \"Adicionar à fila\" no menu de uma faixa para incluí-la aqui'**
  String get rightPanelQueueEmptyHint;

  /// No description provided for @rightPanelNowPlaying.
  ///
  /// In pt, this message translates to:
  /// **'Tocando agora'**
  String get rightPanelNowPlaying;

  /// No description provided for @rightPanelNextInQueue.
  ///
  /// In pt, this message translates to:
  /// **'A seguir na fila'**
  String get rightPanelNextInQueue;

  /// No description provided for @rightPanelNextFrom.
  ///
  /// In pt, this message translates to:
  /// **'Próximas de: {name}'**
  String rightPanelNextFrom(String name);

  /// No description provided for @nowPlayingPlayingFrom.
  ///
  /// In pt, this message translates to:
  /// **'TOCANDO DE'**
  String get nowPlayingPlayingFrom;

  /// No description provided for @nowPlayingMoreOptions.
  ///
  /// In pt, this message translates to:
  /// **'Mais opções'**
  String get nowPlayingMoreOptions;

  /// No description provided for @chatChats.
  ///
  /// In pt, this message translates to:
  /// **'Conversas'**
  String get chatChats;

  /// No description provided for @chatYouSaid.
  ///
  /// In pt, this message translates to:
  /// **'Você: {text}'**
  String chatYouSaid(String text);

  /// No description provided for @chatContacts.
  ///
  /// In pt, this message translates to:
  /// **'Contatos'**
  String get chatContacts;

  /// No description provided for @chatServerUnreachable.
  ///
  /// In pt, this message translates to:
  /// **'Não consegui falar com o servidor de extras.'**
  String get chatServerUnreachable;

  /// No description provided for @chatMessageHint.
  ///
  /// In pt, this message translates to:
  /// **'Mensagem'**
  String get chatMessageHint;

  /// No description provided for @chatJoinedJam.
  ///
  /// In pt, this message translates to:
  /// **'Você entrou na {title}'**
  String chatJoinedJam(String title);

  /// No description provided for @chatCouldNotPlay.
  ///
  /// In pt, this message translates to:
  /// **'Não consegui tocar: {error}'**
  String chatCouldNotPlay(String error);

  /// No description provided for @chatJamCardSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Ouvir junto, com a mesma fila'**
  String get chatJamCardSubtitle;

  /// No description provided for @chatInJam.
  ///
  /// In pt, this message translates to:
  /// **'Na Jam'**
  String get chatInJam;

  /// No description provided for @chatJoin.
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get chatJoin;

  /// No description provided for @chatNoOtherAccounts.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma outra conta no servidor.'**
  String get chatNoOtherAccounts;

  /// No description provided for @chatSongsCount.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{1 música} other{{count} músicas}}'**
  String chatSongsCount(int count);

  /// No description provided for @chatSentTo.
  ///
  /// In pt, this message translates to:
  /// **'Enviado para {name}'**
  String chatSentTo(String name);

  /// No description provided for @chatShareTitle.
  ///
  /// In pt, this message translates to:
  /// **'Compartilhar {title}'**
  String chatShareTitle(String title);

  /// No description provided for @chatNoteHint.
  ///
  /// In pt, this message translates to:
  /// **'Recado (opcional)'**
  String get chatNoteHint;

  /// No description provided for @blendWorking.
  ///
  /// In pt, this message translates to:
  /// **'Misturando…'**
  String get blendWorking;

  /// No description provided for @blendAffinityButton.
  ///
  /// In pt, this message translates to:
  /// **'Blend {affinity}%'**
  String blendAffinityButton(int affinity);

  /// No description provided for @blendCreate.
  ///
  /// In pt, this message translates to:
  /// **'Criar Blend'**
  String get blendCreate;

  /// No description provided for @blendWith.
  ///
  /// In pt, this message translates to:
  /// **'Blend com {name}'**
  String blendWith(String name);

  /// No description provided for @blendExplain.
  ///
  /// In pt, this message translates to:
  /// **'Uma playlist igual para vocês dois, com o que os dois ouvem, os artistas em comum e um pouco do que cada um mais gosta. Mostra a afinidade de vocês e se atualiza todo dia.'**
  String get blendExplain;

  /// No description provided for @blendNotNow.
  ///
  /// In pt, this message translates to:
  /// **'Agora não'**
  String get blendNotNow;

  /// No description provided for @blendAffinityTitle.
  ///
  /// In pt, this message translates to:
  /// **'Vocês têm {affinity}% de afinidade'**
  String blendAffinityTitle(int affinity);

  /// No description provided for @blendInCommon.
  ///
  /// In pt, this message translates to:
  /// **'Em comum: {artists}'**
  String blendInCommon(String artists);

  /// No description provided for @blendOpen.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{Abrir o Blend (1 música)} other{Abrir o Blend ({count} músicas)}}'**
  String blendOpen(int count);

  /// No description provided for @blendRefreshNow.
  ///
  /// In pt, this message translates to:
  /// **'Atualizar agora'**
  String get blendRefreshNow;

  /// No description provided for @blendUndo.
  ///
  /// In pt, this message translates to:
  /// **'Desfazer Blend'**
  String get blendUndo;

  /// No description provided for @blendRefreshing.
  ///
  /// In pt, this message translates to:
  /// **'Atualizando o Blend…'**
  String get blendRefreshing;

  /// No description provided for @blendUndoTitle.
  ///
  /// In pt, this message translates to:
  /// **'Desfazer o Blend?'**
  String get blendUndoTitle;

  /// No description provided for @blendUndoBody.
  ///
  /// In pt, this message translates to:
  /// **'A playlist some para você e para {name}.'**
  String blendUndoBody(String name);

  /// No description provided for @blendUndoConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Desfazer'**
  String get blendUndoConfirm;

  /// No description provided for @blendUndone.
  ///
  /// In pt, this message translates to:
  /// **'Blend desfeito'**
  String get blendUndone;

  /// No description provided for @jamStart.
  ///
  /// In pt, this message translates to:
  /// **'Iniciar uma Jam'**
  String get jamStart;

  /// No description provided for @jamTooltip.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{Jam (1 pessoa)} other{Jam ({count} pessoas)}}'**
  String jamTooltip(int count);

  /// No description provided for @jamSubIdle.
  ///
  /// In pt, this message translates to:
  /// **'Ouça junto com outras contas, na mesma fila.'**
  String get jamSubIdle;

  /// No description provided for @jamSubHost.
  ///
  /// In pt, this message translates to:
  /// **'Você está no comando. Todos podem pedir músicas.'**
  String get jamSubHost;

  /// No description provided for @jamSubGuest.
  ///
  /// In pt, this message translates to:
  /// **'Seus botões e músicas vão para a fila de todos.'**
  String get jamSubGuest;

  /// No description provided for @jamPlayFirst.
  ///
  /// In pt, this message translates to:
  /// **'Toque alguma coisa antes de começar a Jam.'**
  String get jamPlayFirst;

  /// No description provided for @jamMembers.
  ///
  /// In pt, this message translates to:
  /// **'Na Jam ({count})'**
  String jamMembers(int count);

  /// No description provided for @jamYouSuffix.
  ///
  /// In pt, this message translates to:
  /// **'{name} (você)'**
  String jamYouSuffix(String name);

  /// No description provided for @jamHost.
  ///
  /// In pt, this message translates to:
  /// **'Anfitrião'**
  String get jamHost;

  /// No description provided for @jamInvite.
  ///
  /// In pt, this message translates to:
  /// **'Convidar'**
  String get jamInvite;

  /// No description provided for @jamInviteTitle.
  ///
  /// In pt, this message translates to:
  /// **'Convidar para a Jam'**
  String get jamInviteTitle;

  /// No description provided for @jamInviteSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'O convite chega no chat da pessoa.'**
  String get jamInviteSubtitle;

  /// No description provided for @jamInviteSent.
  ///
  /// In pt, this message translates to:
  /// **'Convite enviado para {name}'**
  String jamInviteSent(String name);

  /// No description provided for @jamEnd.
  ///
  /// In pt, this message translates to:
  /// **'Encerrar a Jam'**
  String get jamEnd;

  /// No description provided for @jamLeave.
  ///
  /// In pt, this message translates to:
  /// **'Sair da Jam'**
  String get jamLeave;

  /// No description provided for @recapTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sua Retrospectiva {year}'**
  String recapTitle(int year);

  /// No description provided for @recapShort.
  ///
  /// In pt, this message translates to:
  /// **'Retrospectiva'**
  String get recapShort;

  /// No description provided for @recapBannerBody.
  ///
  /// In pt, this message translates to:
  /// **'{minutes} minutos de música este ano. Veja o que mais tocou.'**
  String recapBannerBody(String minutes);

  /// No description provided for @recapEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Ainda não tem reproduções para montar a Retrospectiva.'**
  String get recapEmpty;

  /// No description provided for @recapShareCards.
  ///
  /// In pt, this message translates to:
  /// **'Compartilhar cartões'**
  String get recapShareCards;

  /// No description provided for @recapBigMinutes.
  ///
  /// In pt, this message translates to:
  /// **'minutos ouvindo'**
  String get recapBigMinutes;

  /// No description provided for @recapBigSongs.
  ///
  /// In pt, this message translates to:
  /// **'músicas diferentes'**
  String get recapBigSongs;

  /// No description provided for @recapBigArtists.
  ///
  /// In pt, this message translates to:
  /// **'artistas'**
  String get recapBigArtists;

  /// No description provided for @recapBigDays.
  ///
  /// In pt, this message translates to:
  /// **'dias com música'**
  String get recapBigDays;

  /// No description provided for @recapBigStreak.
  ///
  /// In pt, this message translates to:
  /// **'dias seguidos, seu recorde'**
  String get recapBigStreak;

  /// No description provided for @recapTopArtists.
  ///
  /// In pt, this message translates to:
  /// **'Seus artistas do ano'**
  String get recapTopArtists;

  /// No description provided for @recapMinutesValue.
  ///
  /// In pt, this message translates to:
  /// **'{minutes} minutos'**
  String recapMinutesValue(String minutes);

  /// No description provided for @recapTopSongs.
  ///
  /// In pt, this message translates to:
  /// **'Suas músicas do ano'**
  String get recapTopSongs;

  /// No description provided for @recapPlaysLine.
  ///
  /// In pt, this message translates to:
  /// **'{artist} • {plays} vezes'**
  String recapPlaysLine(String artist, String plays);

  /// No description provided for @recapSongGone.
  ///
  /// In pt, this message translates to:
  /// **'Essa música não está mais na biblioteca'**
  String get recapSongGone;

  /// No description provided for @recapTopAlbums.
  ///
  /// In pt, this message translates to:
  /// **'Seus álbuns do ano'**
  String get recapTopAlbums;

  /// No description provided for @recapTopGenres.
  ///
  /// In pt, this message translates to:
  /// **'Gêneros que mais tocaram'**
  String get recapTopGenres;

  /// No description provided for @recapGenreLine.
  ///
  /// In pt, this message translates to:
  /// **'{genre} • {minutes} min'**
  String recapGenreLine(String genre, String minutes);

  /// No description provided for @recapMonthly.
  ///
  /// In pt, this message translates to:
  /// **'Mês a mês'**
  String get recapMonthly;

  /// No description provided for @recapMonthTooltip.
  ///
  /// In pt, this message translates to:
  /// **'{month}: {minutes} min'**
  String recapMonthTooltip(String month, String minutes);

  /// No description provided for @recapListeningStyle.
  ///
  /// In pt, this message translates to:
  /// **'Seu jeito de ouvir'**
  String get recapListeningStyle;

  /// No description provided for @recapFavHour.
  ///
  /// In pt, this message translates to:
  /// **'Hora favorita: {hour}h'**
  String recapFavHour(String hour);

  /// No description provided for @recapFavWeekday.
  ///
  /// In pt, this message translates to:
  /// **'Dia da semana favorito: {day}'**
  String recapFavWeekday(String day);

  /// No description provided for @recapBiggestDay.
  ///
  /// In pt, this message translates to:
  /// **'Seu maior dia: {date}, {minutes} minutos'**
  String recapBiggestDay(String date, String minutes);

  /// No description provided for @recapNewArtists.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{{n} artista novo para você} other{{n} artistas novos para você}}'**
  String recapNewArtists(int count, String n);

  /// No description provided for @recapSpotifyAdded.
  ///
  /// In pt, this message translates to:
  /// **'{added} reproduções do Spotify entraram.'**
  String recapSpotifyAdded(String added);

  /// No description provided for @recapSpotifyAddedDup.
  ///
  /// In pt, this message translates to:
  /// **'{added} reproduções do Spotify entraram ({dup} já estavam pelo Pudim).'**
  String recapSpotifyAddedDup(String added, String dup);

  /// No description provided for @recapSpotifyRemoveTitle.
  ///
  /// In pt, this message translates to:
  /// **'Tirar o histórico do Spotify?'**
  String get recapSpotifyRemoveTitle;

  /// No description provided for @recapSpotifyRemoveBody.
  ///
  /// In pt, this message translates to:
  /// **'A Retrospectiva volta a contar só o que tocou no Pudim/Jellyfin. Dá para importar de novo depois.'**
  String get recapSpotifyRemoveBody;

  /// No description provided for @recapSpotifyRemoveConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Tirar'**
  String get recapSpotifyRemoveConfirm;

  /// No description provided for @recapSpotifyRemoved.
  ///
  /// In pt, this message translates to:
  /// **'{count} reproduções do Spotify removidas'**
  String recapSpotifyRemoved(String count);

  /// No description provided for @recapSpotifyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Histórico do Spotify'**
  String get recapSpotifyTitle;

  /// No description provided for @recapSpotifyHasData.
  ///
  /// In pt, this message translates to:
  /// **'{count} reproduções do Spotify na sua Retrospectiva ({from} a {to}). Pode mandar um arquivo mais novo: o que já entrou não repete.'**
  String recapSpotifyHasData(String count, String from, String to);

  /// No description provided for @recapSpotifyIntro.
  ///
  /// In pt, this message translates to:
  /// **'Traga os anos de antes do Pudim. No Spotify, vá em Conta > Privacidade > Baixe seus dados e marque \"Histórico de streaming estendido\". Quando o e-mail chegar, escolha aqui o my_spotify_data.zip.'**
  String get recapSpotifyIntro;

  /// No description provided for @recapSpotifyImportAnother.
  ///
  /// In pt, this message translates to:
  /// **'Importar outro arquivo'**
  String get recapSpotifyImportAnother;

  /// No description provided for @recapSpotifyImport.
  ///
  /// In pt, this message translates to:
  /// **'Importar histórico'**
  String get recapSpotifyImport;

  /// No description provided for @recapSpotifyRemoveBtn.
  ///
  /// In pt, this message translates to:
  /// **'Tirar da Retrospectiva'**
  String get recapSpotifyRemoveBtn;

  /// No description provided for @recapShareSaveDialog.
  ///
  /// In pt, this message translates to:
  /// **'Salvar cartão'**
  String get recapShareSaveDialog;

  /// No description provided for @recapShareSaved.
  ///
  /// In pt, this message translates to:
  /// **'Cartão salvo'**
  String get recapShareSaved;

  /// No description provided for @recapShareSaveFailed.
  ///
  /// In pt, this message translates to:
  /// **'Não consegui salvar: {error}'**
  String recapShareSaveFailed(String error);

  /// No description provided for @recapShareShareFailed.
  ///
  /// In pt, this message translates to:
  /// **'Não consegui compartilhar: {error}'**
  String recapShareShareFailed(String error);

  /// No description provided for @recapShareText.
  ///
  /// In pt, this message translates to:
  /// **'Minha Retrospectiva {year} no Pudim'**
  String recapShareText(int year);

  /// No description provided for @recapShareMyArtists.
  ///
  /// In pt, this message translates to:
  /// **'Meus artistas do ano'**
  String get recapShareMyArtists;

  /// No description provided for @recapShareMySongs.
  ///
  /// In pt, this message translates to:
  /// **'Minhas músicas do ano'**
  String get recapShareMySongs;

  /// No description provided for @recapMinShort.
  ///
  /// In pt, this message translates to:
  /// **'{minutes} min'**
  String recapMinShort(String minutes);

  /// No description provided for @recapShareSaveImage.
  ///
  /// In pt, this message translates to:
  /// **'Salvar imagem'**
  String get recapShareSaveImage;

  /// No description provided for @recapShareButton.
  ///
  /// In pt, this message translates to:
  /// **'Compartilhar'**
  String get recapShareButton;

  /// No description provided for @recapBrand.
  ///
  /// In pt, this message translates to:
  /// **'Retrospectiva {year}'**
  String recapBrand(int year);

  /// No description provided for @recapShareMyYear.
  ///
  /// In pt, this message translates to:
  /// **'Meu ano em música'**
  String get recapShareMyYear;

  /// No description provided for @recapShareYearOf.
  ///
  /// In pt, this message translates to:
  /// **'O ano de {name} em música'**
  String recapShareYearOf(String name);

  /// No description provided for @recapShareTopArtist.
  ///
  /// In pt, this message translates to:
  /// **'meu artista do ano'**
  String get recapShareTopArtist;

  /// No description provided for @recapShareGenres.
  ///
  /// In pt, this message translates to:
  /// **'Gêneros: {genres}'**
  String recapShareGenres(String genres);

  /// No description provided for @widgetActionsAddedToLiked.
  ///
  /// In pt, this message translates to:
  /// **'Adicionada a Músicas curtidas'**
  String get widgetActionsAddedToLiked;

  /// No description provided for @widgetActionsRemovedFromLiked.
  ///
  /// In pt, this message translates to:
  /// **'Removida de Músicas curtidas'**
  String get widgetActionsRemovedFromLiked;

  /// No description provided for @widgetActionsUnfollowed.
  ///
  /// In pt, this message translates to:
  /// **'Deixou de seguir'**
  String get widgetActionsUnfollowed;

  /// No description provided for @widgetActionsSavedToLibrary.
  ///
  /// In pt, this message translates to:
  /// **'Salvo na Sua Biblioteca'**
  String get widgetActionsSavedToLibrary;

  /// No description provided for @widgetActionsRemovedFromLibrary.
  ///
  /// In pt, this message translates to:
  /// **'Removido da Sua Biblioteca'**
  String get widgetActionsRemovedFromLibrary;

  /// No description provided for @widgetActionsAddToQueue.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar à fila'**
  String get widgetActionsAddToQueue;

  /// No description provided for @widgetActionsAddedToQueue.
  ///
  /// In pt, this message translates to:
  /// **'Adicionado à fila'**
  String get widgetActionsAddedToQueue;

  /// No description provided for @widgetActionsPlayNext.
  ///
  /// In pt, this message translates to:
  /// **'Tocar em seguida'**
  String get widgetActionsPlayNext;

  /// No description provided for @widgetActionsGoToPodcast.
  ///
  /// In pt, this message translates to:
  /// **'Ir para o podcast'**
  String get widgetActionsGoToPodcast;

  /// No description provided for @widgetActionsRemoveFromQueue.
  ///
  /// In pt, this message translates to:
  /// **'Remover da fila'**
  String get widgetActionsRemoveFromQueue;

  /// No description provided for @widgetActionsAddToPlaylist.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar à playlist'**
  String get widgetActionsAddToPlaylist;

  /// No description provided for @widgetActionsRemoveFromThisPlaylist.
  ///
  /// In pt, this message translates to:
  /// **'Remover desta playlist'**
  String get widgetActionsRemoveFromThisPlaylist;

  /// No description provided for @widgetActionsInviteToEdit.
  ///
  /// In pt, this message translates to:
  /// **'Convidar para editar'**
  String get widgetActionsInviteToEdit;

  /// No description provided for @widgetActionsKeepInPlaylist.
  ///
  /// In pt, this message translates to:
  /// **'Manter na playlist'**
  String get widgetActionsKeepInPlaylist;

  /// No description provided for @widgetActionsDownloadTrack.
  ///
  /// In pt, this message translates to:
  /// **'Baixar música'**
  String get widgetActionsDownloadTrack;

  /// No description provided for @widgetActionsDownloadAlbum.
  ///
  /// In pt, this message translates to:
  /// **'Baixar álbum'**
  String get widgetActionsDownloadAlbum;

  /// No description provided for @widgetActionsDownloadDiscography.
  ///
  /// In pt, this message translates to:
  /// **'Baixar discografia'**
  String get widgetActionsDownloadDiscography;

  /// No description provided for @widgetActionsSearchAlbums.
  ///
  /// In pt, this message translates to:
  /// **'Buscar álbuns'**
  String get widgetActionsSearchAlbums;

  /// No description provided for @widgetActionsImproveQuality.
  ///
  /// In pt, this message translates to:
  /// **'Melhorar qualidade ({count})'**
  String widgetActionsImproveQuality(int count);

  /// No description provided for @widgetActionsImprovingAlbums.
  ///
  /// In pt, this message translates to:
  /// **'Procurando versões melhores de {count} álbuns'**
  String widgetActionsImprovingAlbums(int count);

  /// No description provided for @widgetActionsShare.
  ///
  /// In pt, this message translates to:
  /// **'Compartilhar'**
  String get widgetActionsShare;

  /// No description provided for @widgetActionsSearchFlac.
  ///
  /// In pt, this message translates to:
  /// **'Buscar em FLAC'**
  String get widgetActionsSearchFlac;

  /// No description provided for @widgetActionsSearchingFlac.
  ///
  /// In pt, this message translates to:
  /// **'Procurando {name} em FLAC; se achar, troca o MP3'**
  String widgetActionsSearchingFlac(String name);

  /// No description provided for @widgetActionsTrackRemovedFromDevice.
  ///
  /// In pt, this message translates to:
  /// **'Removida do aparelho'**
  String get widgetActionsTrackRemovedFromDevice;

  /// No description provided for @widgetActionsRemovedFromDevice.
  ///
  /// In pt, this message translates to:
  /// **'Removido do aparelho'**
  String get widgetActionsRemovedFromDevice;

  /// No description provided for @widgetActionsDownloadingToDevice.
  ///
  /// In pt, this message translates to:
  /// **'Baixando no aparelho para ouvir sem internet'**
  String get widgetActionsDownloadingToDevice;

  /// No description provided for @widgetActionsUnfollow.
  ///
  /// In pt, this message translates to:
  /// **'Deixar de seguir'**
  String get widgetActionsUnfollow;

  /// No description provided for @widgetActionsRemoveFromLibrary.
  ///
  /// In pt, this message translates to:
  /// **'Remover da Sua Biblioteca'**
  String get widgetActionsRemoveFromLibrary;

  /// No description provided for @widgetActionsAddToLibrary.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar à Sua Biblioteca'**
  String get widgetActionsAddToLibrary;

  /// No description provided for @widgetActionsGoToSongRadio.
  ///
  /// In pt, this message translates to:
  /// **'Ir para a rádio da música'**
  String get widgetActionsGoToSongRadio;

  /// No description provided for @widgetActionsStartMix.
  ///
  /// In pt, this message translates to:
  /// **'Ligar mix'**
  String get widgetActionsStartMix;

  /// No description provided for @widgetActionsMixOf.
  ///
  /// In pt, this message translates to:
  /// **'Mix de {name}'**
  String widgetActionsMixOf(String name);

  /// No description provided for @widgetActionsGoToArtist.
  ///
  /// In pt, this message translates to:
  /// **'Ir para o artista'**
  String get widgetActionsGoToArtist;

  /// No description provided for @widgetActionsGoToAlbum.
  ///
  /// In pt, this message translates to:
  /// **'Ir para o álbum'**
  String get widgetActionsGoToAlbum;

  /// No description provided for @widgetActionsCopyName.
  ///
  /// In pt, this message translates to:
  /// **'Copiar nome'**
  String get widgetActionsCopyName;

  /// No description provided for @widgetActionsCopied.
  ///
  /// In pt, this message translates to:
  /// **'Copiado'**
  String get widgetActionsCopied;

  /// No description provided for @widgetDownloadsBellDownloading.
  ///
  /// In pt, this message translates to:
  /// **'{count} baixando'**
  String widgetDownloadsBellDownloading(int count);

  /// No description provided for @widgetDownloadsBellEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nada por aqui. Toque uma música com nuvem ou use \"Baixar\" no menu ⋯ para trazer do catálogo para a biblioteca.'**
  String get widgetDownloadsBellEmpty;

  /// No description provided for @widgetDownloadsBellKindDiscography.
  ///
  /// In pt, this message translates to:
  /// **'Discografia'**
  String get widgetDownloadsBellKindDiscography;

  /// No description provided for @widgetDownloadsBellKindFlac.
  ///
  /// In pt, this message translates to:
  /// **'Em FLAC'**
  String get widgetDownloadsBellKindFlac;

  /// No description provided for @widgetDownloadsBellKindQuality.
  ///
  /// In pt, this message translates to:
  /// **'Qualidade'**
  String get widgetDownloadsBellKindQuality;

  /// No description provided for @widgetDownloadsBellOptions.
  ///
  /// In pt, this message translates to:
  /// **'Opções'**
  String get widgetDownloadsBellOptions;

  /// No description provided for @widgetDownloadsBellCancelled.
  ///
  /// In pt, this message translates to:
  /// **'Download cancelado'**
  String get widgetDownloadsBellCancelled;

  /// No description provided for @widgetDownloadsBellRetrying.
  ///
  /// In pt, this message translates to:
  /// **'Tentando de novo'**
  String get widgetDownloadsBellRetrying;

  /// No description provided for @widgetDownloadsBellRemovedFromList.
  ///
  /// In pt, this message translates to:
  /// **'Removido da lista'**
  String get widgetDownloadsBellRemovedFromList;

  /// No description provided for @widgetDownloadsBellDetails.
  ///
  /// In pt, this message translates to:
  /// **'Ver detalhes'**
  String get widgetDownloadsBellDetails;

  /// No description provided for @widgetDownloadsBellRemoveFromList.
  ///
  /// In pt, this message translates to:
  /// **'Remover da lista'**
  String get widgetDownloadsBellRemoveFromList;

  /// No description provided for @widgetMixSearchingReleases.
  ///
  /// In pt, this message translates to:
  /// **'Procurando lançamentos…'**
  String get widgetMixSearchingReleases;

  /// No description provided for @widgetMixBuildingDaylist.
  ///
  /// In pt, this message translates to:
  /// **'Montando sua daylist…'**
  String get widgetMixBuildingDaylist;

  /// No description provided for @widgetMixNewDiscoveriesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Novas Descobertas da semana?'**
  String get widgetMixNewDiscoveriesTitle;

  /// No description provided for @widgetMixNewMixTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nova Mistura da semana?'**
  String get widgetMixNewMixTitle;

  /// No description provided for @widgetMixNewDiscoveriesBody.
  ///
  /// In pt, this message translates to:
  /// **'As músicas que você ainda não ouviu saem da playlist e umas 30 novas começam a chegar. Toda segunda isso já acontece sozinho.'**
  String get widgetMixNewDiscoveriesBody;

  /// No description provided for @widgetMixNewMixBody.
  ///
  /// In pt, this message translates to:
  /// **'Monta de novo com os seus favoritos, o que você mais ouve e músicas parecidas. Toda segunda isso já acontece sozinho.'**
  String get widgetMixNewMixBody;

  /// No description provided for @widgetMixNotNow.
  ///
  /// In pt, this message translates to:
  /// **'Agora não'**
  String get widgetMixNotNow;

  /// No description provided for @widgetMixBuildingDiscoveries.
  ///
  /// In pt, this message translates to:
  /// **'Montando suas Descobertas…'**
  String get widgetMixBuildingDiscoveries;

  /// No description provided for @widgetMixBuildingMix.
  ///
  /// In pt, this message translates to:
  /// **'Montando sua Mistura…'**
  String get widgetMixBuildingMix;

  /// No description provided for @widgetMixBuiltOn.
  ///
  /// In pt, this message translates to:
  /// **'Montada em {date}'**
  String widgetMixBuiltOn(String date);

  /// No description provided for @widgetMixRedo.
  ///
  /// In pt, this message translates to:
  /// **'Refazer'**
  String get widgetMixRedo;

  /// No description provided for @widgetMixRefresh.
  ///
  /// In pt, this message translates to:
  /// **'Atualizar'**
  String get widgetMixRefresh;

  /// No description provided for @widgetMixCreateDiscoveries.
  ///
  /// In pt, this message translates to:
  /// **'Criar suas Descobertas da semana'**
  String get widgetMixCreateDiscoveries;

  /// No description provided for @widgetMixCreateMix.
  ///
  /// In pt, this message translates to:
  /// **'Criar sua Mistura da semana'**
  String get widgetMixCreateMix;

  /// No description provided for @widgetMixCreateRadar.
  ///
  /// In pt, this message translates to:
  /// **'Criar seu Radar de Novidades'**
  String get widgetMixCreateRadar;

  /// No description provided for @widgetMixCreateDaylist.
  ///
  /// In pt, this message translates to:
  /// **'Criar sua daylist'**
  String get widgetMixCreateDaylist;

  /// No description provided for @widgetOfflineBanner.
  ///
  /// In pt, this message translates to:
  /// **'Sem internet · mostrando o que está guardado no aparelho'**
  String get widgetOfflineBanner;

  /// No description provided for @widgetOfflineDownloadingProgress.
  ///
  /// In pt, this message translates to:
  /// **'Baixando {done} de {total}'**
  String widgetOfflineDownloadingProgress(int done, int total);

  /// No description provided for @widgetUpdateReady.
  ///
  /// In pt, this message translates to:
  /// **'Nova versão do Pudim pronta'**
  String get widgetUpdateReady;

  /// No description provided for @widgetUpdateReadyNotes.
  ///
  /// In pt, this message translates to:
  /// **'Nova versão do Pudim · {notes}'**
  String widgetUpdateReadyNotes(String notes);

  /// No description provided for @widgetUpdateAction.
  ///
  /// In pt, this message translates to:
  /// **'Atualizar'**
  String get widgetUpdateAction;

  /// No description provided for @widgetSleepShortMinutes.
  ///
  /// In pt, this message translates to:
  /// **'{count} min'**
  String widgetSleepShortMinutes(int count);

  /// No description provided for @widgetSleepShortSeconds.
  ///
  /// In pt, this message translates to:
  /// **'{count} s'**
  String widgetSleepShortSeconds(int count);

  /// No description provided for @widgetSleepStopsAtEnd.
  ///
  /// In pt, this message translates to:
  /// **'Para no fim da música'**
  String get widgetSleepStopsAtEnd;

  /// No description provided for @widgetSleepStopsIn.
  ///
  /// In pt, this message translates to:
  /// **'Para em {time}'**
  String widgetSleepStopsIn(String time);

  /// No description provided for @widgetSleepTimer.
  ///
  /// In pt, this message translates to:
  /// **'Timer para dormir'**
  String get widgetSleepTimer;

  /// No description provided for @widgetSleepTurnOff.
  ///
  /// In pt, this message translates to:
  /// **'Desligar o timer'**
  String get widgetSleepTurnOff;

  /// No description provided for @widgetSleepOneHour.
  ///
  /// In pt, this message translates to:
  /// **'1 hora'**
  String get widgetSleepOneHour;

  /// No description provided for @widgetSleepOneAndHalfHours.
  ///
  /// In pt, this message translates to:
  /// **'1 hora e meia'**
  String get widgetSleepOneAndHalfHours;

  /// No description provided for @widgetSleepEndOfSong.
  ///
  /// In pt, this message translates to:
  /// **'Fim da música'**
  String get widgetSleepEndOfSong;

  /// No description provided for @widgetSleepTurnedOff.
  ///
  /// In pt, this message translates to:
  /// **'Timer desligado'**
  String get widgetSleepTurnedOff;

  /// No description provided for @widgetSleepStopsWhenSongEnds.
  ///
  /// In pt, this message translates to:
  /// **'A música para quando esta acabar'**
  String get widgetSleepStopsWhenSongEnds;

  /// No description provided for @widgetSleepSongStopsIn.
  ///
  /// In pt, this message translates to:
  /// **'A música para em {time}'**
  String widgetSleepSongStopsIn(String time);

  /// No description provided for @widgetSpeedPodcast.
  ///
  /// In pt, this message translates to:
  /// **'Velocidade do podcast'**
  String get widgetSpeedPodcast;

  /// No description provided for @widgetCommonCatalogBadge.
  ///
  /// In pt, this message translates to:
  /// **'Do catálogo: ainda não está na biblioteca'**
  String get widgetCommonCatalogBadge;

  /// No description provided for @widgetCommonShowAll.
  ///
  /// In pt, this message translates to:
  /// **'Mostrar tudo'**
  String get widgetCommonShowAll;

  /// No description provided for @widgetCommonSomethingWentWrong.
  ///
  /// In pt, this message translates to:
  /// **'Algo deu errado'**
  String get widgetCommonSomethingWentWrong;

  /// No description provided for @widgetCommonListenDownloaded.
  ///
  /// In pt, this message translates to:
  /// **'Ouvir as músicas baixadas'**
  String get widgetCommonListenDownloaded;

  /// No description provided for @widgetTracksTitle.
  ///
  /// In pt, this message translates to:
  /// **'Título'**
  String get widgetTracksTitle;

  /// No description provided for @widgetTracksDateAdded.
  ///
  /// In pt, this message translates to:
  /// **'Adicionada em'**
  String get widgetTracksDateAdded;

  /// No description provided for @widgetTracksAddedBy.
  ///
  /// In pt, this message translates to:
  /// **'por {name}'**
  String widgetTracksAddedBy(String name);

  /// No description provided for @widgetTracksMoreOptions.
  ///
  /// In pt, this message translates to:
  /// **'Mais opções'**
  String get widgetTracksMoreOptions;

  /// No description provided for @widgetTracksAddedDate.
  ///
  /// In pt, this message translates to:
  /// **'{date}'**
  String widgetTracksAddedDate(DateTime date);
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return L10nEn();
    case 'es':
      return L10nEs();
    case 'pt':
      return L10nPt();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
