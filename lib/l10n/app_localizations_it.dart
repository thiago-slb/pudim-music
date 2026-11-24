// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class L10nIt extends L10n {
  L10nIt([String locale = 'it']) : super(locale);

  @override
  String get languageTitle => 'Lingua';

  @override
  String get languageSubtitle => 'Lingua dell’interfaccia';

  @override
  String get languageSystem => 'Predefinita di sistema';

  @override
  String get commonCancel => 'Annulla';

  @override
  String get commonClose => 'Chiudi';

  @override
  String get commonBack => 'Indietro';

  @override
  String get commonSave => 'Salva';

  @override
  String get commonEdit => 'Modifica';

  @override
  String get commonDelete => 'Elimina';

  @override
  String get commonRemove => 'Rimuovi';

  @override
  String get commonOk => 'OK';

  @override
  String get commonRetry => 'Riprova';

  @override
  String get commonQueue => 'Coda';

  @override
  String get commonAlbum => 'Album';

  @override
  String get commonAlbums => 'Album';

  @override
  String get commonArtist => 'Artista';

  @override
  String get commonArtists => 'Artisti';

  @override
  String get commonSong => 'Brano';

  @override
  String get commonSongs => 'Brani';

  @override
  String get commonPlaylist => 'Playlist';

  @override
  String get commonPlaylists => 'Playlist';

  @override
  String get commonSingle => 'Singolo';

  @override
  String get commonLikedSongs => 'Brani che ti piacciono';

  @override
  String get commonAddToLiked => 'Aggiungi ai brani che ti piacciono';

  @override
  String get commonRemoveFromLiked => 'Rimuovi dai brani che ti piacciono';

  @override
  String get commonShufflePlay => 'Riproduzione casuale';

  @override
  String get commonPlay => 'Riproduci';

  @override
  String get commonPause => 'Pausa';

  @override
  String get commonFollow => 'Segui';

  @override
  String get commonFollowing => 'Segui già';

  @override
  String get commonDownloadToDevice => 'Scarica sul dispositivo';

  @override
  String get commonRemoveFromDevice => 'Rimuovi dal dispositivo';

  @override
  String get commonDownloaded => 'Scaricato';

  @override
  String get commonDownloads => 'Download';

  @override
  String get commonAll => 'Tutti';

  @override
  String get commonRecentlyPlayed => 'Ascoltati di recente';

  @override
  String get commonYourLibrary => 'La tua libreria';

  @override
  String get commonHome => 'Home';

  @override
  String get commonSearch => 'Cerca';

  @override
  String get commonProfile => 'Profilo';

  @override
  String get commonSettings => 'Impostazioni';

  @override
  String get commonBuilding => 'Creazione in corso…';

  @override
  String get commonBuildNow => 'Crea ora';

  @override
  String get commonShows => 'Concerti';

  @override
  String get commonPodcasts => 'Podcast';

  @override
  String commonSongCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count brani',
      one: '1 brano',
      zero: 'Nessun brano',
    );
    return '$_temp0';
  }

  @override
  String commonMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuti',
      one: '1 minuto',
    );
    return '$_temp0';
  }

  @override
  String commonError(String error) {
    return 'Errore: $error';
  }

  @override
  String get apiStatusQueued => 'In coda';

  @override
  String get apiStatusDownloading => 'Download in corso';

  @override
  String get apiStatusDone => 'Aggiunto alla libreria';

  @override
  String get apiStatusUpToDate => 'Già nella libreria';

  @override
  String get apiStatusPartial => 'Aggiunto in parte';

  @override
  String get apiStatusNotFound => 'Non trovato';

  @override
  String get apiStatusCancelled => 'Annullato';

  @override
  String get apiStatusInterrupted => 'Interrotto';

  @override
  String get apiStatusFailed => 'Non riuscito';

  @override
  String get apiExtrasNoResponse => 'Il server extra non ha risposto.';

  @override
  String get apiAlbumListFailed => 'Impossibile elencare gli album.';

  @override
  String apiPlaylistSaved(int found, int total) {
    return 'Playlist nella tua libreria ($found brani su $total)';
  }

  @override
  String apiPlaylistDownloading(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'scaricamento di altri $count brani',
      one: 'scaricamento di 1 altro brano',
    );
    return 'Playlist nella tua libreria; $_temp0';
  }

  @override
  String get apiBadCredentials => 'Nome utente o password errati.';

  @override
  String get apiServerUnreachable => 'Impossibile raggiungere il server.';

  @override
  String get apiQuickConnectOff =>
      'Quick Connect è disattivato su questo server.';

  @override
  String get apiWrongCurrentPassword => 'La password attuale non è corretta.';

  @override
  String stateChatShared(String title) {
    return 'Hai condiviso $title';
  }

  @override
  String stateDownloadingName(String name) {
    return 'Download di $name in corso';
  }

  @override
  String stateDownloadingRequests(int count) {
    return 'Download di $count richieste in corso';
  }

  @override
  String stateDownloadArrived(String name) {
    return '$name è stato aggiunto alla libreria';
  }

  @override
  String stateDownloadPartial(String name) {
    return '$name è stato aggiunto in parte';
  }

  @override
  String stateDownloadEnded(String name, String status) {
    return '$name: $status';
  }

  @override
  String get stateNotFromCatalog =>
      'Questo elemento non proviene dal catalogo.';

  @override
  String stateAlreadyDownloading(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'L’album è già in download.',
      'artist': 'La discografia è già in download.',
      'other': 'Il brano è già in download.',
    });
    return '$_temp0';
  }

  @override
  String stateDownloadRequested(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Download dell’album in corso. Lo vedrai nella campanella quando arriva.',
      'artist': 'Download della discografia in corso. La vedrai nella campanella quando arriva.',
      'other': 'Download del brano in corso. Lo vedrai nella campanella quando arriva.',
    });
    return '$_temp0';
  }

  @override
  String get stateNotifyDownloadsChannel => 'Download';

  @override
  String get stateNotifyDownloadsChannelDesc =>
      'Avanzamento dei brani in download';

  @override
  String get stateNotifyNewsChannel => 'Novità';

  @override
  String get stateNotifyNewsChannelDesc =>
      'Nuovi arrivi, uscite, Descobertas e Mistura';

  @override
  String get stateOfflineLoose => 'Scaricati singolarmente';

  @override
  String get stateOfflineDoneTitle => 'Scaricato su questo dispositivo';

  @override
  String stateOfflineDoneBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count brani pronti da ascoltare offline',
      one: '1 brano pronto da ascoltare offline',
    );
    return '$_temp0';
  }

  @override
  String get stateOfflineProgressTitle => 'Download su questo dispositivo';

  @override
  String stateOfflineProgressBody(int done, int total, String name) {
    return '$done di $total • $name';
  }

  @override
  String get stateServerNoReply =>
      'Il server non ha risposto. Controlla l’indirizzo.';

  @override
  String get stateServerNoReplyBoth =>
      'Il server non ha risposto a nessuno dei due indirizzi.';

  @override
  String get stateTokenStoreUnsupported =>
      'Per ora Pudim può salvare l’accesso solo su Windows e Android.';

  @override
  String get stateQualityPoor => 'bassa qualità';

  @override
  String get stateQualityPartial => 'incompleto';

  @override
  String get audioPlaybackChannel => 'Riproduzione';

  @override
  String get audioRecentAlbums => 'Album recenti';

  @override
  String audioSearchContext(String query) {
    return 'Ricerca: $query';
  }

  @override
  String audioRadioContext(String name) {
    return 'Radio di $name';
  }

  @override
  String podcastsMonthShort(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': 'gen',
      'm2': 'feb',
      'm3': 'mar',
      'm4': 'apr',
      'm5': 'mag',
      'm6': 'giu',
      'm7': 'lug',
      'm8': 'ago',
      'm9': 'set',
      'm10': 'ott',
      'm11': 'nov',
      'other': 'dic',
    });
    return '$_temp0';
  }

  @override
  String podcastsDateThisYear(int day, String month) {
    return '$day $month';
  }

  @override
  String podcastsDateOtherYear(int day, String month, int year) {
    return '$day $month $year';
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
  String get podcastsPlayed => 'ascoltato';

  @override
  String podcastsTimeLeft(String time) {
    return '$time rimanenti';
  }

  @override
  String get podcastsSearchHint => 'Cerca podcast';

  @override
  String get podcastsNothingFound => 'Nessun risultato.';

  @override
  String get podcastsYours => 'I tuoi podcast';

  @override
  String get podcastsNewEpisodes => 'Nuovi episodi';

  @override
  String get podcastsTrendingBrazil => 'Di tendenza in Brasile';

  @override
  String get podcastsLoadFailed => 'Caricamento non riuscito. Riprova';

  @override
  String get podcastsNoEpisodes => 'Nessun episodio nel feed.';

  @override
  String podcastsNoEpisodeMatch(String q) {
    return 'Nessun episodio corrispondente a “$q”.';
  }

  @override
  String get podcastsKind => 'Podcast';

  @override
  String get podcastsEpisodes => 'Episodi';

  @override
  String podcastsEpisodesCount(int total) {
    return 'Episodi ($total)';
  }

  @override
  String get podcastsFindEpisode => 'Cerca episodi';

  @override
  String showsMonthName(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': 'gennaio',
      'm2': 'febbraio',
      'm3': 'marzo',
      'm4': 'aprile',
      'm5': 'maggio',
      'm6': 'giugno',
      'm7': 'luglio',
      'm8': 'agosto',
      'm9': 'settembre',
      'm10': 'ottobre',
      'm11': 'novembre',
      'other': 'dicembre',
    });
    return '$_temp0';
  }

  @override
  String showsMonthYear(String month, int year) {
    return '$month $year';
  }

  @override
  String showsWeekdayShort(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'w1': 'lun',
      'w2': 'mar',
      'w3': 'mer',
      'w4': 'gio',
      'w5': 'ven',
      'w6': 'sab',
      'other': 'dom',
    });
    return '$_temp0';
  }

  @override
  String get showsFollowingNone => 'Dagli artisti che segui';

  @override
  String showsFollowingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dai $count artisti che segui',
      one: 'Dall’artista che segui',
    );
    return '$_temp0';
  }

  @override
  String showsSearchingFor(int count) {
    return 'ricerca dei concerti di $count…';
  }

  @override
  String get showsUpcoming => 'In programma';

  @override
  String get showsPast => 'Passati';

  @override
  String get showsInBrazil => 'In Brasile';

  @override
  String get showsEmptyFollow =>
      'Segui degli artisti (pulsante Segui nella pagina dell’artista) per vedere qui i loro concerti.';

  @override
  String get showsNonePast => 'Ancora nessun concerto registrato.';

  @override
  String get showsNoneUpcoming => 'Nessun concerto in programma per ora.';

  @override
  String get showsStillSearching => 'Ricerca in corso…';

  @override
  String get showsSource =>
      'Date da MusicBrainz (curato dai fan); i nuovi concerti possono impiegare un po’ ad apparire.';

  @override
  String get showsCancelled => 'annullato';

  @override
  String get showsFestival => 'festival';

  @override
  String get catalogKindAlbum => 'Album';

  @override
  String get catalogKindSingle => 'Singolo';

  @override
  String get catalogKindBroadcast => 'Trasmissione';

  @override
  String get catalogKindOther => 'Altro';

  @override
  String get catalogSecLive => 'live';

  @override
  String get catalogSecCompilation => 'raccolta';

  @override
  String get catalogSecSoundtrack => 'colonna sonora';

  @override
  String get catalogSecMixtape => 'mixtape';

  @override
  String get catalogSecInterview => 'intervista';

  @override
  String get catalogSecSpokenword => 'spoken word';

  @override
  String catalogDownloadingOne(String title) {
    return 'Download di $title in corso';
  }

  @override
  String catalogDownloadingMany(int count, String artist) {
    return 'Download di $count album di $artist in corso';
  }

  @override
  String catalogCheckingDiscography(int seconds) {
    return 'Controllo della discografia… $seconds s';
  }

  @override
  String catalogToDownload(int count) {
    return '$count da scaricare';
  }

  @override
  String catalogInLibraryCount(int count) {
    return '$count già nella libreria';
  }

  @override
  String catalogSkippedOneSong(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uscite da un solo brano escluse',
      one: '1 uscita da un solo brano esclusa',
    );
    return '$_temp0';
  }

  @override
  String get catalogPickAll => 'Tutti';

  @override
  String get catalogPickStudio => 'Studio';

  @override
  String get catalogPickNone => 'Nessuno';

  @override
  String get catalogDownloadSelected => 'Scarica selezionati';

  @override
  String catalogDownloadNSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Scarica $count selezionati',
      one: 'Scarica 1 selezionato',
    );
    return '$_temp0';
  }

  @override
  String get catalogNothingMissing => 'Non manca nulla.';

  @override
  String get catalogPartial => 'parziale';

  @override
  String get catalogDownload => 'Scarica';

  @override
  String get catalogAddToLibrary => 'Aggiungi alla tua libreria';

  @override
  String get catalogInYourLibrary => 'Nella tua libreria';

  @override
  String get catalogAllInLibrary => 'tutti nella libreria';

  @override
  String catalogNInLibrary(int count) {
    return '$count nella libreria';
  }

  @override
  String get catalogDownloadAlbum => 'Scarica album';

  @override
  String get catalogArtistNotFound => 'Artista non trovato.';

  @override
  String get catalogFromCatalog => 'Dal catalogo: non ancora nella libreria';

  @override
  String get catalogDownloadAll => 'Scarica tutto';

  @override
  String get catalogDownloadDiscography => 'Scarica discografia';

  @override
  String get catalogPopular => 'Popolari';

  @override
  String get catalogShowLess => 'Mostra meno';

  @override
  String get catalogShowMore => 'Mostra altro';

  @override
  String get catalogSinglesEps => 'Singoli ed EP';

  @override
  String get catalogFansAlsoLike => 'Ai fan piace anche';

  @override
  String get lyricsPlaySomething => 'Riproduci qualcosa per vedere il testo.';

  @override
  String get lyricsNone => 'Nessun testo per questo brano';

  @override
  String get lyricsNoneHint =>
      'Se accanto al file c’è un .lrc o un .txt, compare qui.';

  @override
  String get lyricsSynced => 'Testo sincronizzato dal file .lrc';

  @override
  String get lyricsUnsynced => 'Testo non sincronizzato';

  @override
  String get profileChangePhoto => 'Cambia foto';

  @override
  String get profileNoPhoto => 'Nessuna foto scelta';

  @override
  String get profilePhotoTooBig => 'Foto troppo grande (fino a 8 MB)';

  @override
  String get profilePhotoChanged => 'Foto del profilo cambiata';

  @override
  String get profilePhotoRemoved => 'Foto rimossa';

  @override
  String get profileNameSaved => 'Nome del profilo salvato';

  @override
  String get profileRenameTitle => 'Cambiare il nome utente?';

  @override
  String profileRenameBody(String name) {
    return 'Accederai come “$name” in Pudim, Jellyfin e nelle altre app (Finamp, Feishin…). Le tue Descobertas, il tuo Mix e il tuo Rewind restano con te.';
  }

  @override
  String get profileRenameConfirm => 'Cambia';

  @override
  String profileNowSignedAs(String name) {
    return 'Ora accedi come $name';
  }

  @override
  String get profileEnterNewPassword => 'Inserisci la nuova password';

  @override
  String get profilePasswordsDiffer => 'Le nuove password non coincidono';

  @override
  String get profilePasswordChanged => 'Password cambiata';

  @override
  String get profileExtrasUnreachable =>
      'Impossibile raggiungere il server extra; nome del profilo e nome utente dovranno aspettare.';

  @override
  String get profileNameSection => 'Nome del profilo';

  @override
  String get profileNameHelp =>
      'È il nome con cui i tuoi contatti ti vedono nelle chat.';

  @override
  String get profileYourName => 'Il tuo nome';

  @override
  String get profileUsernameSection => 'Nome utente';

  @override
  String get profileUsernameHelp =>
      'Il nome che usi per accedere a Jellyfin (qui e in altre app).';

  @override
  String get profileUsernameHint => 'Nome utente';

  @override
  String get profileChangeUsername => 'Cambia nome utente';

  @override
  String get profilePasswordSection => 'Password';

  @override
  String get profileCurrentPassword => 'Password attuale';

  @override
  String get profileNewPassword => 'Nuova password';

  @override
  String get profileRepeatPassword => 'Ripeti la nuova password';

  @override
  String get profileChangePassword => 'Cambia password';

  @override
  String get loginServerRequired =>
      'Inserisci l’indirizzo del tuo server Jellyfin.';

  @override
  String get loginUserRequired => 'Inserisci il tuo nome utente.';

  @override
  String get loginTitle => 'Accedi a Pudim';

  @override
  String get loginSubtitle => 'Usa il tuo account Jellyfin.';

  @override
  String get loginUsername => 'Nome utente';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginShowPassword => 'Mostra password';

  @override
  String get loginHidePassword => 'Nascondi password';

  @override
  String get loginSubmit => 'Accedi';

  @override
  String get loginQuickConnect => 'Accedi con Quick Connect';

  @override
  String get loginHideAddresses => 'Nascondi indirizzi';

  @override
  String get loginServerAddress => 'Indirizzo del server';

  @override
  String get loginJellyfinServer => 'Server Jellyfin';

  @override
  String get loginJellyfinServerExample => 'Es. https://jellyfin.exemplo.com';

  @override
  String get loginLocalNetwork => 'Sulla rete locale (facoltativo)';

  @override
  String get loginLocalNetworkExample =>
      'Es. http://192.168.0.10:8096. Quando risponde, l’app lo usa al posto di quello principale.';

  @override
  String get loginExtrasServer => 'Server extra (facoltativo)';

  @override
  String get loginExtrasServerHint =>
      'Attiva chat, Jam, Blend, mix e Rewind. Lascia vuoto se non ne hai uno.';

  @override
  String get loginQcExpired => 'Il codice è scaduto. Riprova.';

  @override
  String get loginQcInstructions =>
      'Su un dispositivo dove hai già effettuato l’accesso a Jellyfin, apri il tuo profilo, tocca Quick Connect e inserisci questo codice:';

  @override
  String get loginQcWaiting => 'In attesa di approvazione…';

  @override
  String get homeDownloadedOnDevice => 'Scaricati su questo dispositivo';

  @override
  String get homeTabMusic => 'Musica';

  @override
  String get homeMadeFor => 'Creato per';

  @override
  String get homeMixDiscoveries => 'Nuova musica per te, ogni settimana';

  @override
  String get homeMixWeekly => 'I tuoi preferiti e brani simili, ogni settimana';

  @override
  String get homeMixRadar =>
      'Nuove uscite degli artisti che segui, ogni venerdì';

  @override
  String get homeMixDaylist => 'Cambia durante la giornata';

  @override
  String get homeMixBlend => 'I gusti di entrambi, insieme';

  @override
  String get homeMixAuto => 'Mix automatico';

  @override
  String get homeSpotifyPlaylists => 'Le tue playlist di Spotify';

  @override
  String get homeFromSpotify => 'Da Spotify';

  @override
  String get homeYourPlaylists => 'Le tue playlist';

  @override
  String get homeTopAlbums => 'I tuoi album più ascoltati';

  @override
  String get homeTopArtists => 'I tuoi artisti preferiti';

  @override
  String get homeRecentlyAdded => 'Aggiunti di recente';

  @override
  String get homeYourPodcasts => 'I tuoi podcast';

  @override
  String get homeRadiosTitle => 'Radio consigliate';

  @override
  String get homeRadiosSubtitle =>
      'Musica senza interruzioni basata sui tuoi artisti preferiti.';

  @override
  String get homeRadioBadge => 'RADIO';

  @override
  String homeRadioWith(String name) {
    return 'Con $name e artisti simili';
  }

  @override
  String searchNoResults(String query) {
    return 'Nessun risultato per “$query”';
  }

  @override
  String get searchNoResultsHint =>
      'Controlla l’ortografia o usa meno parole o parole diverse.';

  @override
  String searchCatalogNoResponse(String error) {
    return 'Il catalogo non ha risposto: $error';
  }

  @override
  String get searchAlsoCatalog => 'Cerco anche nel catalogo…';

  @override
  String searchLibraryOnly(String error) {
    return 'Solo libreria: il catalogo non ha risposto ($error).';
  }

  @override
  String get searchTopResult => 'Risultato principale';

  @override
  String get searchSpotifyPlaylists => 'Playlist di Spotify';

  @override
  String get searchRecent => 'Ricerche recenti';

  @override
  String get searchClear => 'Cancella';

  @override
  String get searchBrowseAll => 'Sfoglia tutto';

  @override
  String get searchHint => 'Cosa vuoi ascoltare?';

  @override
  String get albumDownloadedType => 'Album • scaricato su questo dispositivo';

  @override
  String albumSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count brani',
      one: '1 brano',
    );
    return '$_temp0, $total';
  }

  @override
  String get albumRemoveFromLibrary => 'Rimuovi dalla tua libreria';

  @override
  String get albumSaveToLibrary => 'Salva nella tua libreria';

  @override
  String albumMoreOptions(String name) {
    return 'Altre opzioni per $name';
  }

  @override
  String albumDisc(int number) {
    return 'Disco $number';
  }

  @override
  String albumMoreFrom(String name) {
    return 'Altro di $name';
  }

  @override
  String artistAlbumsInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count album nella tua libreria',
      one: '1 album nella tua libreria',
    );
    return '$_temp0';
  }

  @override
  String artistPlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count riproduzioni',
      one: '1 riproduzione',
    );
    return '$_temp0';
  }

  @override
  String artistMoreOptions(String name) {
    return 'Altre opzioni per $name';
  }

  @override
  String get artistPopular => 'Popolari';

  @override
  String get artistShowLess => 'Mostra meno';

  @override
  String get artistShowMore => 'Mostra altro';

  @override
  String get artistYouLiked => 'Ti sono piaciuti';

  @override
  String artistFrom(String name) {
    return 'Da $name';
  }

  @override
  String get artistDiscography => 'Discografia';

  @override
  String get artistPopularReleases => 'Uscite popolari';

  @override
  String get artistSinglesEps => 'Singoli ed EP';

  @override
  String get artistFansAlsoLike => 'Ai fan piace anche';

  @override
  String get artistAppearsOn => 'Compare in';

  @override
  String get artistAbout => 'Informazioni';

  @override
  String get playlistOriginSpotify => 'Da Spotify';

  @override
  String get playlistOriginMadeForYou => 'Creato per te';

  @override
  String get playlistOriginAuto => 'Mix automatico';

  @override
  String get playlistDownloadedOnDevice => 'Scaricata su questo dispositivo';

  @override
  String get playlistOnDevice => 'Su questo dispositivo';

  @override
  String get playlistPlaysOffline => 'Si ascolta senza internet.';

  @override
  String playlistPlaysOfflineDownloading(int count) {
    return 'Si ascolta senza internet. Download di altri $count in corso…';
  }

  @override
  String playlistSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count brani',
      one: '1 brano',
    );
    return '$_temp0, $total';
  }

  @override
  String playlistMoreOptions(String name) {
    return 'Altre opzioni per $name';
  }

  @override
  String get playlistSearchHint => 'Cerca nella playlist';

  @override
  String get playlistEmpty => 'Ancora nessun brano qui.';

  @override
  String get playlistErrNoPermission =>
      'Non hai il permesso di modificare questa playlist.';

  @override
  String playlistErrServer(String code) {
    return 'Il server ha rifiutato la richiesta ($code).';
  }

  @override
  String get playlistErrNoResponse => 'nessuna risposta';

  @override
  String get playlistDownloadFirst =>
      'Scarica prima il brano per aggiungerlo a una playlist';

  @override
  String get playlistAddTo => 'Aggiungi alla playlist';

  @override
  String get playlistNew => 'Nuova playlist';

  @override
  String playlistAddedTo(String name) {
    return 'Aggiunto a $name';
  }

  @override
  String get playlistNameHint => 'Nome della playlist';

  @override
  String get playlistCreate => 'Crea';

  @override
  String playlistCreated(String name) {
    return 'Playlist $name creata';
  }

  @override
  String get playlistRemoved => 'Rimosso dalla playlist';

  @override
  String get playlistInviteTitle => 'Invita a modificare';

  @override
  String get playlistInviteSubtitle =>
      'Vedranno la playlist nella loro libreria e potranno aggiungere e rimuovere brani.';

  @override
  String get playlistInviteOwnerOnly =>
      'Solo chi ha creato la playlist può invitare';

  @override
  String playlistInvited(String who, String playlist) {
    return '$who ora può modificare $playlist';
  }

  @override
  String playlistCollaborative(String members) {
    return 'Collaborativa · $members';
  }

  @override
  String get playlistSmartShuffleTooltip =>
      'Smart Shuffle: riproduzione casuale con consigli';

  @override
  String get playlistSmartShuffleOn =>
      'Smart Shuffle attivo: i consigli sono segnati con ✦';

  @override
  String get playlistAddedToThis => 'Aggiunto alla playlist';

  @override
  String get playlistRecommendation => 'Consiglio di Smart Shuffle';

  @override
  String get playlistPutIn => 'Aggiungi alla playlist';

  @override
  String get settingsSectionAccount => 'Account';

  @override
  String get settingsProfileSubtitle => 'Nome, nome utente e password';

  @override
  String settingsConnectedAt(String url) {
    return 'Connesso a $url';
  }

  @override
  String get settingsSignOut => 'Esci';

  @override
  String get accountsTitle => 'Account';

  @override
  String get accountsAdd => 'Aggiungi account o server';

  @override
  String get accountsSwitch => 'Cambia';

  @override
  String get accountsInUse => 'In uso';

  @override
  String accountsOn(String user, String host) {
    return '$user su $host';
  }

  @override
  String get loginBackToAccount => 'Torna all’account attuale';

  @override
  String get settingsSectionServer => 'Server';

  @override
  String get settingsLocalNetwork => 'Sulla rete locale';

  @override
  String get settingsServerNote =>
      'Per cambiare gli indirizzi di Jellyfin, esci e apri “Indirizzo del server” nella schermata di accesso.';

  @override
  String get settingsExtrasServer => 'Server extra';

  @override
  String get settingsExtrasNotConfigured =>
      'Non configurato (chat, Jam, Blend, mix e Recap restano nascosti)';

  @override
  String get settingsConfigure => 'Configura';

  @override
  String get settingsChange => 'Cambia';

  @override
  String get settingsSectionPlayback => 'Riproduzione';

  @override
  String get settingsQualityWifi => 'Qualità con Wi-Fi';

  @override
  String get settingsQualityWifiSubtitle =>
      'Originale riproduce il file così com’è nella libreria.';

  @override
  String get settingsQualityMobile => 'Qualità con dati mobili';

  @override
  String get settingsQualityMobileSubtitle =>
      'Una qualità più bassa consuma meno dati mobili.';

  @override
  String get settingsQualityOriginal => 'Originale';

  @override
  String get settingsAppliesNextSong => 'Si applica dal prossimo brano';

  @override
  String get settingsSectionAbout => 'Informazioni';

  @override
  String settingsBuild(int build) {
    return 'Build $build';
  }

  @override
  String get settingsExtrasEmptyHint =>
      'Lascia vuoto per disattivare gli extra.';

  @override
  String get settingsAutoplay => 'Riproduzione automatica';

  @override
  String get settingsAutoplaySubtitle =>
      'Quando la coda finisce, continua con brani simili (mix di Jellyfin).';

  @override
  String get settingsNormalize => 'Normalizza volume';

  @override
  String get settingsNormalizeSubtitle =>
      'Riproduce tutti i brani allo stesso volume, in base all’analisi di Jellyfin.';

  @override
  String get settingsScrobble => 'Scrobbling';

  @override
  String get settingsLoading => 'Caricamento…';

  @override
  String get settingsLastfmNoKey =>
      'Il server extra non ha ancora una chiave API di Last.fm configurata.';

  @override
  String settingsConnectedAs(String name) {
    return 'Connesso come $name';
  }

  @override
  String get settingsLastfmConnectedSubtitle =>
      'Tutto ciò che ascolti su Pudim va sul tuo profilo Last.fm.';

  @override
  String get settingsDisconnect => 'Disconnetti';

  @override
  String get settingsLastfmAuthorize => 'Autorizza nella pagina di Last.fm';

  @override
  String get settingsLastfmAuthorizeSubtitle =>
      'Dopo aver cliccato “Sì, consenti l’accesso” lì, torna qui e tocca Fine.';

  @override
  String get settingsFinish => 'Fine';

  @override
  String get settingsLastfmConnected => 'Last.fm connesso';

  @override
  String get settingsLastfmScrobbleSubtitle =>
      'Registra su Last.fm ogni brano che ascolti.';

  @override
  String get settingsConnect => 'Connetti';

  @override
  String get sidebarOpenLibrary => 'Apri La tua libreria';

  @override
  String get sidebarCollapseLibrary => 'Comprimi La tua libreria';

  @override
  String sidebarOnDeviceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count brani',
      one: '1 brano',
    );
    return 'Sul dispositivo • $_temp0';
  }

  @override
  String sidebarPlaylistCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count brani',
      one: '1 brano',
    );
    return 'Playlist • $_temp0';
  }

  @override
  String sidebarAlbumBy(String artist) {
    return 'Album • $artist';
  }

  @override
  String get sidebarSearchLibrary => 'Cerca nella tua libreria';

  @override
  String get sidebarSortBy => 'Ordina per';

  @override
  String get sidebarSortRecents => 'Recenti';

  @override
  String get sidebarSortAdded => 'Aggiunti di recente';

  @override
  String get sidebarSortAlpha => 'Ordine alfabetico';

  @override
  String get sidebarSortCreator => 'Creatore';

  @override
  String get topBarSearchHint => 'Cosa vuoi riprodurre?';

  @override
  String get topBarClearSearch => 'Cancella il campo di ricerca';

  @override
  String get topBarBrowse => 'Sfoglia';

  @override
  String get topBarMenu => 'Menu';

  @override
  String get topBarLogoutAccount => 'Esci';

  @override
  String get topBarQuit => 'Chiudi Pudim';

  @override
  String get topBarLogout => 'Esci';

  @override
  String get playerBarSmartShuffleOff => 'Disattiva Smart Shuffle';

  @override
  String get playerBarSmartShuffleOn => 'Attiva Smart Shuffle';

  @override
  String get playerBarShuffleOff => 'Disattiva riproduzione casuale';

  @override
  String get playerBarShuffleOn => 'Attiva riproduzione casuale';

  @override
  String get playerBarPlay => 'Riproduci';

  @override
  String get playerBarForward => 'Avanti';

  @override
  String get playerBarRepeatOn => 'Attiva ripetizione';

  @override
  String get playerBarRepeatOne => 'Ripeti un brano';

  @override
  String get playerBarRepeatOff => 'Disattiva ripetizione';

  @override
  String get playerBarNowPlayingView => 'Vista In riproduzione';

  @override
  String get playerBarLyrics => 'Testo';

  @override
  String get playerBarUnmute => 'Riattiva audio';

  @override
  String get playerBarMute => 'Disattiva audio';

  @override
  String get rightPanelNothingPlaying =>
      'Riproduci qualcosa per vedere qui cosa sta suonando.';

  @override
  String get rightPanelLyricsPreview => 'Anteprima del testo';

  @override
  String get rightPanelAboutArtist => 'Informazioni sull’artista';

  @override
  String get rightPanelNextUp => 'A seguire';

  @override
  String get rightPanelOpenQueue => 'Apri coda';

  @override
  String get rightPanelQueueEmptyTitle => 'Aggiungi alla coda';

  @override
  String get rightPanelQueueEmptyHint =>
      'Fai clic su “Aggiungi alla coda” nel menu di un brano per metterlo qui';

  @override
  String get rightPanelNowPlaying => 'In riproduzione';

  @override
  String get rightPanelNextInQueue => 'Prossimo in coda';

  @override
  String rightPanelNextFrom(String name) {
    return 'A seguire da: $name';
  }

  @override
  String get nowPlayingPlayingFrom => 'IN RIPRODUZIONE DA';

  @override
  String get nowPlayingMoreOptions => 'Altre opzioni';

  @override
  String get chatChats => 'Chat';

  @override
  String chatYouSaid(String text) {
    return 'Tu: $text';
  }

  @override
  String get chatContacts => 'Contatti';

  @override
  String get chatServerUnreachable =>
      'Impossibile raggiungere il server extra.';

  @override
  String get chatMessageHint => 'Messaggio';

  @override
  String chatJoinedJam(String title) {
    return 'Sei entrato in $title';
  }

  @override
  String chatCouldNotPlay(String error) {
    return 'Impossibile riprodurre: $error';
  }

  @override
  String get chatJamCardSubtitle => 'Ascoltate insieme, stessa coda';

  @override
  String get chatInJam => 'Nella Jam';

  @override
  String get chatJoin => 'Unisciti';

  @override
  String get chatNoOtherAccounts => 'Nessun altro account sul server.';

  @override
  String chatSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count brani',
      one: '1 brano',
    );
    return '$_temp0';
  }

  @override
  String chatSentTo(String name) {
    return 'Inviato a $name';
  }

  @override
  String chatShareTitle(String title) {
    return 'Condividi $title';
  }

  @override
  String get chatNoteHint => 'Nota (facoltativa)';

  @override
  String get blendWorking => 'Creazione del Blend…';

  @override
  String blendAffinityButton(int affinity) {
    return 'Blend $affinity%';
  }

  @override
  String get blendCreate => 'Crea Blend';

  @override
  String blendWith(String name) {
    return 'Blend con $name';
  }

  @override
  String get blendExplain =>
      'Una playlist per entrambi, con ciò che ascoltate tutti e due, gli artisti in comune e un po’ di ciò che ognuno ama di più. Mostra quanto i vostri gusti coincidono e si aggiorna ogni giorno.';

  @override
  String get blendNotNow => 'Non ora';

  @override
  String blendAffinityTitle(int affinity) {
    return 'Avete il $affinity% di affinità';
  }

  @override
  String blendInCommon(String artists) {
    return 'In comune: $artists';
  }

  @override
  String blendOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Apri Blend ($count brani)',
      one: 'Apri Blend (1 brano)',
    );
    return '$_temp0';
  }

  @override
  String get blendRefreshNow => 'Aggiorna ora';

  @override
  String get blendUndo => 'Rimuovi Blend';

  @override
  String get blendRefreshing => 'Aggiornamento del Blend…';

  @override
  String get blendUndoTitle => 'Rimuovere il Blend?';

  @override
  String blendUndoBody(String name) {
    return 'La playlist scomparirà per te e per $name.';
  }

  @override
  String get blendUndoConfirm => 'Rimuovi';

  @override
  String get blendUndone => 'Blend rimosso';

  @override
  String get jamStart => 'Avvia una Jam';

  @override
  String jamTooltip(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jam ($count persone)',
      one: 'Jam (1 persona)',
    );
    return '$_temp0';
  }

  @override
  String get jamSubIdle =>
      'Ascolta insieme ad altri account, nella stessa coda.';

  @override
  String get jamSubHost => 'Sei tu a decidere. Tutti possono richiedere brani.';

  @override
  String get jamSubGuest =>
      'I tuoi controlli e i tuoi brani vanno nella coda di tutti.';

  @override
  String get jamPlayFirst => 'Riproduci qualcosa prima di avviare la Jam.';

  @override
  String jamMembers(int count) {
    return 'Nella Jam ($count)';
  }

  @override
  String jamYouSuffix(String name) {
    return '$name (tu)';
  }

  @override
  String get jamHost => 'Host';

  @override
  String get jamInvite => 'Invita';

  @override
  String get jamInviteTitle => 'Invita alla Jam';

  @override
  String get jamInviteSubtitle => 'L’invito arriva nella loro chat.';

  @override
  String jamInviteSent(String name) {
    return 'Invito inviato a $name';
  }

  @override
  String get jamEnd => 'Termina la Jam';

  @override
  String get jamLeave => 'Esci dalla Jam';

  @override
  String recapTitle(int year) {
    return 'Il tuo Wrapped $year';
  }

  @override
  String get recapShort => 'Wrapped';

  @override
  String recapBannerBody(String minutes) {
    return '$minutes minuti di musica quest’anno. Scopri cosa hai ascoltato di più.';
  }

  @override
  String get recapEmpty =>
      'Non ci sono ancora ascolti per creare il tuo Wrapped.';

  @override
  String get recapShareCards => 'Condividi le card';

  @override
  String get recapBigMinutes => 'minuti ascoltati';

  @override
  String get recapBigSongs => 'brani diversi';

  @override
  String get recapBigArtists => 'artisti';

  @override
  String get recapBigDays => 'giorni con musica';

  @override
  String get recapBigStreak => 'giorni di fila, il tuo record';

  @override
  String get recapTopArtists => 'I tuoi artisti top dell’anno';

  @override
  String recapMinutesValue(String minutes) {
    return '$minutes minuti';
  }

  @override
  String get recapTopSongs => 'I tuoi brani top dell’anno';

  @override
  String recapPlaysLine(String artist, String plays) {
    return '$artist • $plays riproduzioni';
  }

  @override
  String get recapSongGone => 'Questo brano non è più nella libreria';

  @override
  String get recapTopAlbums => 'I tuoi album top dell’anno';

  @override
  String get recapTopGenres => 'I tuoi generi più ascoltati';

  @override
  String recapGenreLine(String genre, String minutes) {
    return '$genre • $minutes min';
  }

  @override
  String get recapMonthly => 'Mese per mese';

  @override
  String recapMonthTooltip(String month, String minutes) {
    return '$month: $minutes min';
  }

  @override
  String get recapListeningStyle => 'Come ascolti';

  @override
  String recapFavHour(String hour) {
    return 'Ora preferita: $hour:00';
  }

  @override
  String recapFavWeekday(String day) {
    return 'Giorno della settimana preferito: $day';
  }

  @override
  String recapBiggestDay(String date, String minutes) {
    return 'Il tuo giorno record: $date, $minutes minuti';
  }

  @override
  String recapNewArtists(int count, String n) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$n nuovi artisti per te',
      one: '$n nuovo artista per te',
    );
    return '$_temp0';
  }

  @override
  String recapSpotifyAdded(String added) {
    return '$added riproduzioni di Spotify aggiunte.';
  }

  @override
  String recapSpotifyAddedDup(String added, String dup) {
    return '$added riproduzioni di Spotify aggiunte ($dup erano già presenti da Pudim).';
  }

  @override
  String get recapSpotifyRemoveTitle => 'Rimuovere la cronologia di Spotify?';

  @override
  String get recapSpotifyRemoveBody =>
      'Il tuo Wrapped tornerà a contare solo ciò che hai ascoltato su Pudim/Jellyfin. Potrai importarla di nuovo in seguito.';

  @override
  String get recapSpotifyRemoveConfirm => 'Rimuovi';

  @override
  String recapSpotifyRemoved(String count) {
    return '$count riproduzioni di Spotify rimosse';
  }

  @override
  String get recapSpotifyTitle => 'Cronologia di Spotify';

  @override
  String recapSpotifyHasData(String count, String from, String to) {
    return '$count riproduzioni di Spotify nel tuo Wrapped (dal $from al $to). Puoi caricare un file più recente: ciò che c’è già non verrà contato due volte.';
  }

  @override
  String get recapSpotifyIntro =>
      'Porta qui gli anni prima di Pudim. In Spotify vai su Account > Privacy > Scarica i tuoi dati e seleziona “Cronologia di streaming estesa”. Quando arriva l’e-mail, scegli qui my_spotify_data.zip.';

  @override
  String get recapSpotifyImportAnother => 'Importa un altro file';

  @override
  String get recapSpotifyImport => 'Importa cronologia';

  @override
  String get recapSpotifyRemoveBtn => 'Rimuovi dal Wrapped';

  @override
  String get recapShareSaveDialog => 'Salva card';

  @override
  String get recapShareSaved => 'Card salvata';

  @override
  String recapShareSaveFailed(String error) {
    return 'Impossibile salvare: $error';
  }

  @override
  String recapShareShareFailed(String error) {
    return 'Impossibile condividere: $error';
  }

  @override
  String recapShareText(int year) {
    return 'Il mio Wrapped $year su Pudim';
  }

  @override
  String get recapShareMyArtists => 'I miei artisti top dell’anno';

  @override
  String get recapShareMySongs => 'I miei brani top dell’anno';

  @override
  String recapMinShort(String minutes) {
    return '$minutes min';
  }

  @override
  String get recapShareSaveImage => 'Salva immagine';

  @override
  String get recapShareButton => 'Condividi';

  @override
  String recapBrand(int year) {
    return 'Wrapped $year';
  }

  @override
  String get recapShareMyYear => 'Il mio anno in musica';

  @override
  String recapShareYearOf(String name) {
    return 'L’anno in musica di $name';
  }

  @override
  String get recapShareTopArtist => 'il mio artista top dell’anno';

  @override
  String recapShareGenres(String genres) {
    return 'Generi: $genres';
  }

  @override
  String get widgetActionsAddedToLiked => 'Aggiunto ai brani che ti piacciono';

  @override
  String get widgetActionsRemovedFromLiked =>
      'Rimosso dai brani che ti piacciono';

  @override
  String get widgetActionsUnfollowed => 'Non segui più';

  @override
  String get widgetActionsSavedToLibrary => 'Salvato nella tua libreria';

  @override
  String get widgetActionsRemovedFromLibrary => 'Rimosso dalla tua libreria';

  @override
  String get widgetActionsAddToQueue => 'Aggiungi alla coda';

  @override
  String get widgetActionsAddedToQueue => 'Aggiunto alla coda';

  @override
  String get widgetActionsPlayNext => 'Riproduci come prossimo';

  @override
  String get widgetActionsGoToPodcast => 'Vai al podcast';

  @override
  String get widgetActionsRemoveFromQueue => 'Rimuovi dalla coda';

  @override
  String get widgetActionsAddToPlaylist => 'Aggiungi alla playlist';

  @override
  String get widgetActionsRemoveFromThisPlaylist =>
      'Rimuovi da questa playlist';

  @override
  String get widgetActionsInviteToEdit => 'Invita a modificare';

  @override
  String get widgetActionsKeepInPlaylist => 'Mantieni nella playlist';

  @override
  String get widgetActionsDownloadTrack => 'Scarica brano';

  @override
  String get widgetActionsDownloadAlbum => 'Scarica album';

  @override
  String get widgetActionsDownloadDiscography => 'Scarica discografia';

  @override
  String get widgetActionsSearchAlbums => 'Trova album';

  @override
  String widgetActionsImproveQuality(int count) {
    return 'Migliora la qualità ($count)';
  }

  @override
  String widgetActionsImprovingAlbums(int count) {
    return 'Ricerca di versioni migliori di $count album';
  }

  @override
  String get widgetActionsShare => 'Condividi';

  @override
  String get widgetActionsSearchFlac => 'Cerca in FLAC';

  @override
  String widgetActionsSearchingFlac(String name) {
    return 'Ricerca di $name in FLAC; se trovato, sostituisce l’MP3';
  }

  @override
  String get widgetActionsTrackRemovedFromDevice => 'Rimosso dal dispositivo';

  @override
  String get widgetActionsRemovedFromDevice => 'Rimosso dal dispositivo';

  @override
  String get widgetActionsDownloadingToDevice =>
      'Download sul tuo dispositivo per l’ascolto offline';

  @override
  String get widgetActionsUnfollow => 'Non seguire più';

  @override
  String get widgetActionsRemoveFromLibrary => 'Rimuovi dalla tua libreria';

  @override
  String get widgetActionsAddToLibrary => 'Aggiungi alla tua libreria';

  @override
  String get widgetActionsGoToSongRadio => 'Vai alla radio del brano';

  @override
  String get widgetActionsStartMix => 'Avvia mix';

  @override
  String widgetActionsMixOf(String name) {
    return 'Mix di $name';
  }

  @override
  String get widgetActionsGoToArtist => 'Vai all’artista';

  @override
  String get widgetActionsGoToAlbum => 'Vai all’album';

  @override
  String get widgetActionsCopyName => 'Copia nome';

  @override
  String get widgetActionsCopied => 'Copiato';

  @override
  String widgetDownloadsBellDownloading(int count) {
    return '$count in download';
  }

  @override
  String get widgetDownloadsBellEmpty =>
      'Ancora niente qui. Riproduci un brano con l’icona della nuvola o usa “Scarica” nel menu ⋯ per portarlo dal catalogo alla tua libreria.';

  @override
  String get widgetDownloadsBellKindDiscography => 'Discografia';

  @override
  String get widgetDownloadsBellKindFlac => 'In FLAC';

  @override
  String get widgetDownloadsBellKindQuality => 'Qualità';

  @override
  String get widgetDownloadsBellOptions => 'Opzioni';

  @override
  String get widgetDownloadsBellCancelled => 'Download annullato';

  @override
  String get widgetDownloadsBellRetrying => 'Nuovo tentativo';

  @override
  String get widgetDownloadsBellRemovedFromList => 'Rimosso dall’elenco';

  @override
  String get widgetDownloadsBellDetails => 'Mostra dettagli';

  @override
  String get widgetDownloadsBellRemoveFromList => 'Rimuovi dall’elenco';

  @override
  String get widgetMixSearchingReleases => 'Ricerca di nuove uscite…';

  @override
  String get widgetMixBuildingDaylist => 'Creazione della tua daylist…';

  @override
  String get widgetMixNewDiscoveriesTitle => 'Nuove Descobertas settimanali?';

  @override
  String get widgetMixNewMixTitle => 'Nuovo Mix settimanale?';

  @override
  String get widgetMixNewDiscoveriesBody =>
      'I brani che non hai ancora ascoltato escono dalla playlist e ne arrivano circa 30 nuovi. Succede già da solo ogni lunedì.';

  @override
  String get widgetMixNewMixBody =>
      'Lo ricostruisce con i tuoi preferiti, ciò che ascolti di più e brani simili. Succede già da solo ogni lunedì.';

  @override
  String get widgetMixNotNow => 'Non ora';

  @override
  String get widgetMixBuildingDiscoveries => 'Creazione delle tue Descobertas…';

  @override
  String get widgetMixBuildingMix => 'Creazione del tuo Mix…';

  @override
  String widgetMixBuiltOn(String date) {
    return 'Creato il $date';
  }

  @override
  String get widgetMixRedo => 'Ricrea';

  @override
  String get widgetMixRefresh => 'Aggiorna';

  @override
  String get widgetMixCreateDiscoveries =>
      'Crea le tue Descobertas settimanali';

  @override
  String get widgetMixCreateMix => 'Crea il tuo Mix settimanale';

  @override
  String get widgetMixCreateRadar => 'Crea il tuo Radar delle novità';

  @override
  String get widgetMixCreateDaylist => 'Crea la tua daylist';

  @override
  String get widgetOfflineBanner =>
      'Nessuna connessione · mostra ciò che è salvato sul dispositivo';

  @override
  String widgetOfflineDownloadingProgress(int done, int total) {
    return 'Download di $done su $total';
  }

  @override
  String get widgetUpdateReady => 'Nuova versione di Pudim pronta';

  @override
  String widgetUpdateReadyNotes(String notes) {
    return 'Nuova versione di Pudim · $notes';
  }

  @override
  String get widgetUpdateAction => 'Aggiorna';

  @override
  String widgetSleepShortMinutes(int count) {
    return '$count min';
  }

  @override
  String widgetSleepShortSeconds(int count) {
    return '$count s';
  }

  @override
  String get widgetSleepStopsAtEnd => 'Si ferma a fine brano';

  @override
  String widgetSleepStopsIn(String time) {
    return 'Si ferma tra $time';
  }

  @override
  String get widgetSleepTimer => 'Timer di spegnimento';

  @override
  String get widgetSleepTurnOff => 'Disattiva timer';

  @override
  String get widgetSleepOneHour => '1 ora';

  @override
  String get widgetSleepOneAndHalfHours => '1 ora e 30 minuti';

  @override
  String get widgetSleepEndOfSong => 'Fine del brano';

  @override
  String get widgetSleepTurnedOff => 'Timer disattivato';

  @override
  String get widgetSleepStopsWhenSongEnds =>
      'La musica si ferma quando finisce questo brano';

  @override
  String widgetSleepSongStopsIn(String time) {
    return 'La musica si ferma tra $time';
  }

  @override
  String get widgetSpeedPodcast => 'Velocità del podcast';

  @override
  String get widgetCommonCatalogBadge =>
      'Dal catalogo: non ancora nella tua libreria';

  @override
  String get widgetCommonShowAll => 'Mostra tutto';

  @override
  String get widgetCommonSomethingWentWrong => 'Qualcosa è andato storto';

  @override
  String get widgetCommonListenDownloaded => 'Ascolta i brani scaricati';

  @override
  String get widgetTracksTitle => 'Titolo';

  @override
  String get widgetTracksDateAdded => 'Data di aggiunta';

  @override
  String widgetTracksAddedBy(String name) {
    return 'da $name';
  }

  @override
  String get widgetTracksMoreOptions => 'Altre opzioni';

  @override
  String widgetTracksAddedDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get castTooltip => 'Trasmetti';

  @override
  String get castTitle => 'Riproduci su';

  @override
  String get castThisDevice => 'Questo dispositivo';

  @override
  String get castSearching => 'Ricerca dispositivi in rete…';

  @override
  String get castNone =>
      'Nessun Chromecast trovato. Deve essere sulla stessa rete Wi-Fi.';

  @override
  String get castSearchAgain => 'Cerca di nuovo';

  @override
  String get castStop => 'Interrompi trasmissione';

  @override
  String castPlayingOn(String name) {
    return 'In riproduzione su $name';
  }

  @override
  String castFailed(String name) {
    return 'Impossibile connettersi a $name';
  }

  @override
  String get settingsSectionAppearance => 'Aspetto';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSubtitle => 'Cambia subito i colori.';

  @override
  String get themeNightDesc =>
      'Scuro, schede arrotondate e mini player fluttuante.';

  @override
  String get themeRedDesc =>
      'Nero puro e rosso, copertine grandi e quadrate, mini player attaccato alla barra.';

  @override
  String get themeWaveDesc =>
      'Viola con sfumature, caratteri decisi e mini player a pillola.';

  @override
  String get themeRetroDesc =>
      'Finestra grigia in rilievo, display verde con titolo scorrevole e liste di testo.';

  @override
  String get themeClassicDesc =>
      'Blu e nero effetto vetro, pulsante sferico, visualizzatore e liste a tabella.';

  @override
  String get settingsCheckUpdates => 'Cerca aggiornamenti';

  @override
  String get updateChecking => 'Verifica…';

  @override
  String updateUpToDate(int build) {
    return 'Hai la versione più recente (build $build).';
  }

  @override
  String updateDownloading(int build, int percent) {
    return 'Download della build $build… $percent%';
  }

  @override
  String updateFailed(String error) {
    return 'Impossibile verificare: $error';
  }

  @override
  String get updateUnavailable => 'Nessun server extra configurato.';

  @override
  String get settingsHistory => 'Cronologia';

  @override
  String get settingsHistorySubtitle =>
      'Riepiloghi degli anni precedenti e tutto ciò che hai ascoltato';

  @override
  String get historyRecaps => 'Riepiloghi';

  @override
  String get historyPlays => 'Ascolti';

  @override
  String get historyWholeYear => 'Tutto l’anno';

  @override
  String get historyLoadMore => 'Carica altro';

  @override
  String get historyEmpty => 'Ancora nessun ascolto';

  @override
  String get historyImported => 'importato';
}
