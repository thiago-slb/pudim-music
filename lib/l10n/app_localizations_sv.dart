// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class L10nSv extends L10n {
  L10nSv([String locale = 'sv']) : super(locale);

  @override
  String get languageTitle => 'Språk';

  @override
  String get languageSubtitle => 'Appens språk';

  @override
  String get languageSystem => 'Systemstandard';

  @override
  String get commonCancel => 'Avbryt';

  @override
  String get commonClose => 'Stäng';

  @override
  String get commonBack => 'Tillbaka';

  @override
  String get commonSave => 'Spara';

  @override
  String get commonEdit => 'Redigera';

  @override
  String get commonDelete => 'Radera';

  @override
  String get commonRemove => 'Ta bort';

  @override
  String get commonOk => 'OK';

  @override
  String get commonRetry => 'Försök igen';

  @override
  String get commonQueue => 'Kö';

  @override
  String get commonAlbum => 'Album';

  @override
  String get commonAlbums => 'Album';

  @override
  String get commonArtist => 'Artist';

  @override
  String get commonArtists => 'Artister';

  @override
  String get commonSong => 'Låt';

  @override
  String get commonSongs => 'Låtar';

  @override
  String get commonPlaylist => 'Spellista';

  @override
  String get commonPlaylists => 'Spellistor';

  @override
  String get commonSingle => 'Singel';

  @override
  String get commonLikedSongs => 'Gillade låtar';

  @override
  String get commonAddToLiked => 'Lägg till i Gillade låtar';

  @override
  String get commonRemoveFromLiked => 'Ta bort från Gillade låtar';

  @override
  String get commonShufflePlay => 'Blandad uppspelning';

  @override
  String get commonPlay => 'Spela upp';

  @override
  String get commonPause => 'Pausa';

  @override
  String get commonFollow => 'Följ';

  @override
  String get commonFollowing => 'Följer';

  @override
  String get commonDownloadToDevice => 'Ladda ner till enheten';

  @override
  String get commonRemoveFromDevice => 'Ta bort från enheten';

  @override
  String get commonDownloaded => 'Nedladdad';

  @override
  String get commonDownloads => 'Nedladdningar';

  @override
  String get commonAll => 'Alla';

  @override
  String get commonRecentlyPlayed => 'Senast spelat';

  @override
  String get commonYourLibrary => 'Ditt bibliotek';

  @override
  String get commonHome => 'Hem';

  @override
  String get commonSearch => 'Sök';

  @override
  String get commonProfile => 'Profil';

  @override
  String get commonSettings => 'Inställningar';

  @override
  String get commonBuilding => 'Skapar…';

  @override
  String get commonBuildNow => 'Skapa nu';

  @override
  String get commonShows => 'Konserter';

  @override
  String get commonPodcasts => 'Poddar';

  @override
  String commonSongCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count låtar',
      one: '1 låt',
      zero: 'Inga låtar',
    );
    return '$_temp0';
  }

  @override
  String commonMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuter',
      one: '1 minut',
    );
    return '$_temp0';
  }

  @override
  String commonError(String error) {
    return 'Fel: $error';
  }

  @override
  String get apiStatusQueued => 'I kö';

  @override
  String get apiStatusDownloading => 'Laddar ner';

  @override
  String get apiStatusDone => 'Tillagd i biblioteket';

  @override
  String get apiStatusUpToDate => 'Finns redan i biblioteket';

  @override
  String get apiStatusPartial => 'Delvis tillagd';

  @override
  String get apiStatusNotFound => 'Hittades inte';

  @override
  String get apiStatusCancelled => 'Avbruten';

  @override
  String get apiStatusInterrupted => 'Avbruten';

  @override
  String get apiStatusFailed => 'Misslyckades';

  @override
  String get apiExtrasNoResponse => 'Extraservern svarade inte.';

  @override
  String get apiAlbumListFailed => 'Det gick inte att lista albumen.';

  @override
  String apiPlaylistSaved(int found, int total) {
    return 'Spellista i Ditt bibliotek ($found av $total låtar)';
  }

  @override
  String apiPlaylistDownloading(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count låtar till',
      one: '1 låt till',
    );
    return 'Spellista i Ditt bibliotek; laddar ner $_temp0';
  }

  @override
  String get apiBadCredentials => 'Fel användarnamn eller lösenord.';

  @override
  String get apiServerUnreachable => 'Det gick inte att nå servern.';

  @override
  String get apiQuickConnectOff =>
      'Quick Connect är avstängt på den här servern.';

  @override
  String get apiWrongCurrentPassword => 'Det nuvarande lösenordet är fel.';

  @override
  String stateChatShared(String title) {
    return 'Delade $title';
  }

  @override
  String stateDownloadingName(String name) {
    return 'Laddar ner $name';
  }

  @override
  String stateDownloadingRequests(int count) {
    return 'Laddar ner $count förfrågningar';
  }

  @override
  String stateDownloadArrived(String name) {
    return '$name lades till i biblioteket';
  }

  @override
  String stateDownloadPartial(String name) {
    return '$name lades till delvis';
  }

  @override
  String stateDownloadEnded(String name, String status) {
    return '$name: $status';
  }

  @override
  String get stateNotFromCatalog =>
      'Det här objektet kommer inte från katalogen.';

  @override
  String stateAlreadyDownloading(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Albumet laddas redan ner.',
      'artist': 'Diskografin laddas redan ner.',
      'other': 'Låten laddas redan ner.',
    });
    return '$_temp0';
  }

  @override
  String stateDownloadRequested(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Laddar ner albumet. Det visas i klockan när det är klart.',
      'artist': 'Laddar ner diskografin. Den visas i klockan när den är klar.',
      'other': 'Laddar ner låten. Den visas i klockan när den är klar.',
    });
    return '$_temp0';
  }

  @override
  String get stateNotifyDownloadsChannel => 'Nedladdningar';

  @override
  String get stateNotifyDownloadsChannelDesc =>
      'Förlopp för låtar som laddas ner';

  @override
  String get stateNotifyNewsChannel => 'Nytt';

  @override
  String get stateNotifyNewsChannelDesc =>
      'Nyheter, utgivningar, Descobertas och Mistura';

  @override
  String get stateOfflineLoose => 'Nedladdade en och en';

  @override
  String get stateOfflineDoneTitle => 'Nedladdat till den här enheten';

  @override
  String stateOfflineDoneBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count låtar redo att lyssna på offline',
      one: '1 låt redo att lyssna på offline',
    );
    return '$_temp0';
  }

  @override
  String get stateOfflineProgressTitle => 'Laddar ner till den här enheten';

  @override
  String stateOfflineProgressBody(int done, int total, String name) {
    return '$done av $total • $name';
  }

  @override
  String get stateServerNoReply =>
      'Servern svarade inte. Kontrollera adressen.';

  @override
  String get stateServerNoReplyBoth =>
      'Servern svarade inte på någon av adresserna.';

  @override
  String get stateTokenStoreUnsupported =>
      'Just nu kan Pudim bara spara din inloggning på Windows och Android.';

  @override
  String get stateQualityPoor => 'låg kvalitet';

  @override
  String get stateQualityPartial => 'ofullständig';

  @override
  String get audioPlaybackChannel => 'Uppspelning';

  @override
  String get audioRecentAlbums => 'Senaste album';

  @override
  String audioSearchContext(String query) {
    return 'Sökning: $query';
  }

  @override
  String audioRadioContext(String name) {
    return '$name-radio';
  }

  @override
  String podcastsMonthShort(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': 'jan',
      'm2': 'feb',
      'm3': 'mars',
      'm4': 'apr',
      'm5': 'maj',
      'm6': 'juni',
      'm7': 'juli',
      'm8': 'aug',
      'm9': 'sep',
      'm10': 'okt',
      'm11': 'nov',
      'other': 'dec',
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
  String get podcastsPlayed => 'spelat';

  @override
  String podcastsTimeLeft(String time) {
    return '$time kvar';
  }

  @override
  String get podcastsSearchHint => 'Sök poddar';

  @override
  String get podcastsNothingFound => 'Inget hittades.';

  @override
  String get podcastsYours => 'Dina poddar';

  @override
  String get podcastsNewEpisodes => 'Nya avsnitt';

  @override
  String get podcastsTrendingBrazil => 'Populärt i Brasilien';

  @override
  String get podcastsLoadFailed => 'Det gick inte att ladda. Försök igen';

  @override
  String get podcastsNoEpisodes => 'Inga avsnitt i flödet.';

  @override
  String podcastsNoEpisodeMatch(String q) {
    return 'Inga avsnitt som matchar \"$q\".';
  }

  @override
  String get podcastsKind => 'Podd';

  @override
  String get podcastsEpisodes => 'Avsnitt';

  @override
  String podcastsEpisodesCount(int total) {
    return 'Avsnitt ($total)';
  }

  @override
  String get podcastsFindEpisode => 'Sök avsnitt';

  @override
  String showsMonthName(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': 'januari',
      'm2': 'februari',
      'm3': 'mars',
      'm4': 'april',
      'm5': 'maj',
      'm6': 'juni',
      'm7': 'juli',
      'm8': 'augusti',
      'm9': 'september',
      'm10': 'oktober',
      'm11': 'november',
      'other': 'december',
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
      'w1': 'mån',
      'w2': 'tis',
      'w3': 'ons',
      'w4': 'tors',
      'w5': 'fre',
      'w6': 'lör',
      'other': 'sön',
    });
    return '$_temp0';
  }

  @override
  String get showsFollowingNone => 'Från artister du följer';

  @override
  String showsFollowingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Från $count artister du följer',
      one: 'Från 1 artist du följer',
    );
    return '$_temp0';
  }

  @override
  String showsSearchingFor(int count) {
    return 'letar efter konserter från $count…';
  }

  @override
  String get showsUpcoming => 'Kommande';

  @override
  String get showsPast => 'Tidigare';

  @override
  String get showsInBrazil => 'I Brasilien';

  @override
  String get showsEmptyFollow =>
      'Följ artister (knappen Följ på artistsidan) för att se deras konserter här.';

  @override
  String get showsNonePast => 'Inga konserter registrerade ännu.';

  @override
  String get showsNoneUpcoming => 'Inga konserter planerade just nu.';

  @override
  String get showsStillSearching => 'Letar fortfarande…';

  @override
  String get showsSource =>
      'Datum från MusicBrainz (skapat av fans); nya konserter kan ta en stund att dyka upp.';

  @override
  String get showsCancelled => 'inställd';

  @override
  String get showsFestival => 'festival';

  @override
  String get catalogKindAlbum => 'Album';

  @override
  String get catalogKindSingle => 'Singel';

  @override
  String get catalogKindBroadcast => 'Sändning';

  @override
  String get catalogKindOther => 'Övrigt';

  @override
  String get catalogSecLive => 'live';

  @override
  String get catalogSecCompilation => 'samling';

  @override
  String get catalogSecSoundtrack => 'filmmusik';

  @override
  String get catalogSecMixtape => 'mixtape';

  @override
  String get catalogSecInterview => 'intervju';

  @override
  String get catalogSecSpokenword => 'talat ord';

  @override
  String catalogDownloadingOne(String title) {
    return 'Laddar ner $title';
  }

  @override
  String catalogDownloadingMany(int count, String artist) {
    return 'Laddar ner $count album av $artist';
  }

  @override
  String catalogCheckingDiscography(int seconds) {
    return 'Kontrollerar diskografin… $seconds s';
  }

  @override
  String catalogToDownload(int count) {
    return '$count att ladda ner';
  }

  @override
  String catalogInLibraryCount(int count) {
    return '$count finns redan i biblioteket';
  }

  @override
  String catalogSkippedOneSong(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count utgivningar med en låt utelämnades',
      one: '1 utgivning med en låt utelämnades',
    );
    return '$_temp0';
  }

  @override
  String get catalogPickAll => 'Alla';

  @override
  String get catalogPickStudio => 'Studio';

  @override
  String get catalogPickNone => 'Inga';

  @override
  String get catalogDownloadSelected => 'Ladda ner valda';

  @override
  String catalogDownloadNSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ladda ner $count valda',
      one: 'Ladda ner 1 vald',
    );
    return '$_temp0';
  }

  @override
  String get catalogNothingMissing => 'Inget saknas.';

  @override
  String get catalogPartial => 'delvis';

  @override
  String get catalogDownload => 'Ladda ner';

  @override
  String get catalogAddToLibrary => 'Lägg till i Ditt bibliotek';

  @override
  String get catalogInYourLibrary => 'I Ditt bibliotek';

  @override
  String get catalogAllInLibrary => 'alla finns i biblioteket';

  @override
  String catalogNInLibrary(int count) {
    return '$count i biblioteket';
  }

  @override
  String get catalogDownloadAlbum => 'Ladda ner album';

  @override
  String get catalogArtistNotFound => 'Artisten hittades inte.';

  @override
  String get catalogFromCatalog =>
      'Från katalogen: finns inte i biblioteket än';

  @override
  String get catalogDownloadAll => 'Ladda ner alla';

  @override
  String get catalogDownloadDiscography => 'Ladda ner diskografi';

  @override
  String get catalogPopular => 'Populärt';

  @override
  String get catalogShowLess => 'Visa färre';

  @override
  String get catalogShowMore => 'Visa fler';

  @override
  String get catalogSinglesEps => 'Singlar och EP';

  @override
  String get catalogFansAlsoLike => 'Fans gillar också';

  @override
  String get lyricsPlaySomething => 'Spela något för att se texten.';

  @override
  String get lyricsNone => 'Ingen text till den här låten';

  @override
  String get lyricsNoneHint =>
      'När det finns en .lrc- eller .txt-fil bredvid filen visas den här.';

  @override
  String get lyricsSynced => 'Synkad text från .lrc-filen';

  @override
  String get lyricsUnsynced => 'Osynkad text';

  @override
  String get profileChangePhoto => 'Byt foto';

  @override
  String get profileNoPhoto => 'Inget foto valt';

  @override
  String get profilePhotoTooBig => 'Fotot är för stort (max 8 MB)';

  @override
  String get profilePhotoChanged => 'Profilfotot har ändrats';

  @override
  String get profilePhotoRemoved => 'Fotot har tagits bort';

  @override
  String get profileNameSaved => 'Profilnamnet har sparats';

  @override
  String get profileRenameTitle => 'Byta användarnamn?';

  @override
  String profileRenameBody(String name) {
    return 'Du loggar in som \"$name\" i Pudim, Jellyfin och de andra apparna (Finamp, Feishin…). Dina Upptäckter, Mix och Återblick följer med.';
  }

  @override
  String get profileRenameConfirm => 'Byt';

  @override
  String profileNowSignedAs(String name) {
    return 'Du loggar nu in som $name';
  }

  @override
  String get profileEnterNewPassword => 'Ange det nya lösenordet';

  @override
  String get profilePasswordsDiffer => 'De nya lösenorden matchar inte';

  @override
  String get profilePasswordChanged => 'Lösenordet har ändrats';

  @override
  String get profileExtrasUnreachable =>
      'Det gick inte att nå extraservern; profilnamnet och användarnamnet får vänta.';

  @override
  String get profileNameSection => 'Profilnamn';

  @override
  String get profileNameHelp => 'Så ser dina kontakter dig i chattar.';

  @override
  String get profileYourName => 'Ditt namn';

  @override
  String get profileUsernameSection => 'Användarnamn';

  @override
  String get profileUsernameHelp =>
      'Namnet du använder för att logga in på Jellyfin (här och i andra appar).';

  @override
  String get profileUsernameHint => 'Användarnamn';

  @override
  String get profileChangeUsername => 'Byt användarnamn';

  @override
  String get profilePasswordSection => 'Lösenord';

  @override
  String get profileCurrentPassword => 'Nuvarande lösenord';

  @override
  String get profileNewPassword => 'Nytt lösenord';

  @override
  String get profileRepeatPassword => 'Upprepa det nya lösenordet';

  @override
  String get profileChangePassword => 'Byt lösenord';

  @override
  String get loginServerRequired => 'Ange adressen till din Jellyfin-server.';

  @override
  String get loginUserRequired => 'Ange ditt användarnamn.';

  @override
  String get loginTitle => 'Logga in på Pudim';

  @override
  String get loginSubtitle => 'Använd ditt Jellyfin-konto.';

  @override
  String get loginUsername => 'Användarnamn';

  @override
  String get loginPassword => 'Lösenord';

  @override
  String get loginShowPassword => 'Visa lösenord';

  @override
  String get loginHidePassword => 'Dölj lösenord';

  @override
  String get loginSubmit => 'Logga in';

  @override
  String get loginQuickConnect => 'Logga in med Quick Connect';

  @override
  String get loginHideAddresses => 'Dölj adresser';

  @override
  String get loginServerAddress => 'Serveradress';

  @override
  String get loginJellyfinServer => 'Jellyfin-server';

  @override
  String get loginJellyfinServerExample => 'T.ex. https://jellyfin.exemplo.com';

  @override
  String get loginLocalNetwork => 'På det lokala nätverket (valfritt)';

  @override
  String get loginLocalNetworkExample =>
      'T.ex. http://192.168.0.10:8096. När den svarar använder appen den i stället för huvudadressen.';

  @override
  String get loginExtrasServer => 'Extraserver (valfritt)';

  @override
  String get loginExtrasServerHint =>
      'Slår på chatt, Jam, Blend, mixar och Återblick. Lämna tomt om du inte har någon.';

  @override
  String get loginQcExpired => 'Koden har gått ut. Försök igen.';

  @override
  String get loginQcInstructions =>
      'Öppna din profil på en enhet där du redan är inloggad på Jellyfin, tryck på Quick Connect och ange den här koden:';

  @override
  String get loginQcWaiting => 'Väntar på godkännande…';

  @override
  String get homeDownloadedOnDevice => 'Nedladdat på den här enheten';

  @override
  String get homeTabMusic => 'Musik';

  @override
  String get homeMadeFor => 'Skapad för';

  @override
  String get homeMixDiscoveries => 'Ny musik åt dig, varje vecka';

  @override
  String get homeMixWeekly => 'Dina favoriter och liknande låtar, varje vecka';

  @override
  String get homeMixRadar =>
      'Nya utgåvor från artister du följer, varje fredag';

  @override
  String get homeMixDaylist => 'Ändras under dagen';

  @override
  String get homeMixBlend => 'Båda era smaker tillsammans';

  @override
  String get homeMixAuto => 'Automatisk mix';

  @override
  String get homeSpotifyPlaylists => 'Dina Spotify-spellistor';

  @override
  String get homeFromSpotify => 'Från Spotify';

  @override
  String get homeYourPlaylists => 'Dina spellistor';

  @override
  String get homeTopAlbums => 'Dina mest spelade album';

  @override
  String get homeTopArtists => 'Dina favoritartister';

  @override
  String get homeRecentlyAdded => 'Nyligen tillagt';

  @override
  String get homeYourPodcasts => 'Dina poddar';

  @override
  String get homeRadiosTitle => 'Rekommenderade radiostationer';

  @override
  String get homeRadiosSubtitle =>
      'Musik utan avbrott baserad på dina favoritartister.';

  @override
  String get homeRadioBadge => 'RADIO';

  @override
  String homeRadioWith(String name) {
    return 'Med $name och liknande artister';
  }

  @override
  String searchNoResults(String query) {
    return 'Inga resultat hittades för \"$query\"';
  }

  @override
  String get searchNoResultsHint =>
      'Kontrollera stavningen eller använd färre eller andra ord.';

  @override
  String searchCatalogNoResponse(String error) {
    return 'Katalogen svarade inte: $error';
  }

  @override
  String get searchAlsoCatalog => 'Söker även i katalogen…';

  @override
  String searchLibraryOnly(String error) {
    return 'Endast biblioteket: katalogen svarade inte ($error).';
  }

  @override
  String get searchTopResult => 'Toppresultat';

  @override
  String get searchSpotifyPlaylists => 'Spotify-spellistor';

  @override
  String get searchRecent => 'Senaste sökningar';

  @override
  String get searchClear => 'Rensa';

  @override
  String get searchBrowseAll => 'Bläddra bland alla';

  @override
  String get searchHint => 'Vad vill du lyssna på?';

  @override
  String get albumDownloadedType => 'Album • nedladdat på den här enheten';

  @override
  String albumSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count låtar',
      one: '1 låt',
    );
    return '$_temp0, $total';
  }

  @override
  String get albumRemoveFromLibrary => 'Ta bort från Ditt bibliotek';

  @override
  String get albumSaveToLibrary => 'Spara i Ditt bibliotek';

  @override
  String albumMoreOptions(String name) {
    return 'Fler alternativ för $name';
  }

  @override
  String albumDisc(int number) {
    return 'Skiva $number';
  }

  @override
  String albumMoreFrom(String name) {
    return 'Mer från $name';
  }

  @override
  String artistAlbumsInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count album i ditt bibliotek',
      one: '1 album i ditt bibliotek',
    );
    return '$_temp0';
  }

  @override
  String artistPlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lyssningar',
      one: '1 lyssning',
    );
    return '$_temp0';
  }

  @override
  String artistMoreOptions(String name) {
    return 'Fler alternativ för $name';
  }

  @override
  String get artistPopular => 'Populärt';

  @override
  String get artistShowLess => 'Visa färre';

  @override
  String get artistShowMore => 'Visa fler';

  @override
  String get artistYouLiked => 'Du gillade';

  @override
  String artistFrom(String name) {
    return 'Från $name';
  }

  @override
  String get artistDiscography => 'Diskografi';

  @override
  String get artistPopularReleases => 'Populära utgåvor';

  @override
  String get artistSinglesEps => 'Singlar och EP';

  @override
  String get artistFansAlsoLike => 'Fans gillar också';

  @override
  String get artistAppearsOn => 'Medverkar på';

  @override
  String get artistAbout => 'Om';

  @override
  String get playlistOriginSpotify => 'Från Spotify';

  @override
  String get playlistOriginMadeForYou => 'Skapad åt dig';

  @override
  String get playlistOriginAuto => 'Automatisk mix';

  @override
  String get playlistDownloadedOnDevice => 'Nedladdat på den här enheten';

  @override
  String get playlistOnDevice => 'På den här enheten';

  @override
  String get playlistPlaysOffline => 'Spelas utan internet.';

  @override
  String playlistPlaysOfflineDownloading(int count) {
    return 'Spelas utan internet. Laddar ner $count till…';
  }

  @override
  String playlistSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count låtar',
      one: '1 låt',
    );
    return '$_temp0, $total';
  }

  @override
  String playlistMoreOptions(String name) {
    return 'Fler alternativ för $name';
  }

  @override
  String get playlistSearchHint => 'Sök i spellistan';

  @override
  String get playlistEmpty => 'Inga låtar här än.';

  @override
  String get playlistErrNoPermission =>
      'Du har inte behörighet att redigera den här spellistan.';

  @override
  String playlistErrServer(String code) {
    return 'Servern avvisade begäran ($code).';
  }

  @override
  String get playlistErrNoResponse => 'inget svar';

  @override
  String get playlistDownloadFirst =>
      'Ladda ner låten först för att lägga till den i en spellista';

  @override
  String get playlistAddTo => 'Lägg till i spellista';

  @override
  String get playlistNew => 'Ny spellista';

  @override
  String playlistAddedTo(String name) {
    return 'Tillagd i $name';
  }

  @override
  String get playlistNameHint => 'Spellistans namn';

  @override
  String get playlistCreate => 'Skapa';

  @override
  String playlistCreated(String name) {
    return 'Spellistan $name skapades';
  }

  @override
  String get playlistRemoved => 'Borttagen från spellistan';

  @override
  String get playlistInviteTitle => 'Bjud in att redigera';

  @override
  String get playlistInviteSubtitle =>
      'De ser spellistan i sitt bibliotek och kan lägga till och ta bort låtar.';

  @override
  String get playlistInviteOwnerOnly =>
      'Bara den som skapade spellistan kan bjuda in';

  @override
  String playlistInvited(String who, String playlist) {
    return '$who kan nu redigera $playlist';
  }

  @override
  String playlistCollaborative(String members) {
    return 'Gemensam · $members';
  }

  @override
  String get playlistSmartShuffleTooltip =>
      'Smart Shuffle: blandad uppspelning med rekommendationer';

  @override
  String get playlistSmartShuffleOn =>
      'Smart Shuffle på: rekommendationer markeras med ✦';

  @override
  String get playlistAddedToThis => 'Tillagd i spellistan';

  @override
  String get playlistRecommendation => 'Smart Shuffle-rekommendation';

  @override
  String get playlistPutIn => 'Lägg till i spellista';

  @override
  String get settingsSectionAccount => 'Konto';

  @override
  String get settingsProfileSubtitle => 'Namn, användarnamn och lösenord';

  @override
  String settingsConnectedAt(String url) {
    return 'Ansluten till $url';
  }

  @override
  String get settingsSignOut => 'Logga ut';

  @override
  String get accountsTitle => 'Konton';

  @override
  String get accountsAdd => 'Lägg till konto eller server';

  @override
  String get accountsSwitch => 'Byt';

  @override
  String get accountsInUse => 'Används';

  @override
  String accountsOn(String user, String host) {
    return '$user på $host';
  }

  @override
  String get loginBackToAccount => 'Tillbaka till nuvarande konto';

  @override
  String get settingsSectionServer => 'Server';

  @override
  String get settingsLocalNetwork => 'På det lokala nätverket';

  @override
  String get settingsServerNote =>
      'Om du vill ändra Jellyfin-adresserna loggar du ut och öppnar \"Serveradress\" på inloggningsskärmen.';

  @override
  String get settingsExtrasServer => 'Extraserver';

  @override
  String get settingsExtrasNotConfigured =>
      'Inte konfigurerad (chatt, Jam, Blend, mixar och Återblick förblir dolda)';

  @override
  String get settingsConfigure => 'Konfigurera';

  @override
  String get settingsChange => 'Ändra';

  @override
  String get settingsSectionPlayback => 'Uppspelning';

  @override
  String get settingsQualityWifi => 'Kvalitet på Wi-Fi';

  @override
  String get settingsQualityWifiSubtitle =>
      'Original spelar upp filen som den ligger i biblioteket.';

  @override
  String get settingsQualityMobile => 'Kvalitet på mobildata';

  @override
  String get settingsQualityMobileSubtitle =>
      'Lägre kvalitet använder mindre mobildata.';

  @override
  String get settingsQualityOriginal => 'Original';

  @override
  String get settingsAppliesNextSong => 'Gäller från nästa låt';

  @override
  String get settingsSectionAbout => 'Om';

  @override
  String settingsBuild(int build) {
    return 'Bygge $build';
  }

  @override
  String get settingsExtrasEmptyHint =>
      'Lämna tomt för att stänga av extrafunktionerna.';

  @override
  String get settingsAutoplay => 'Autouppspelning';

  @override
  String get settingsAutoplaySubtitle =>
      'När kön tar slut fortsätter appen spela liknande låtar (Jellyfin-mix).';

  @override
  String get settingsNormalize => 'Normalisera volymen';

  @override
  String get settingsNormalizeSubtitle =>
      'Spelar alla låtar med samma volym, med hjälp av Jellyfins analys.';

  @override
  String get settingsScrobble => 'Scrobbla';

  @override
  String get settingsLoading => 'Laddar…';

  @override
  String get settingsLastfmNoKey =>
      'Extraservern har ingen Last.fm API-nyckel konfigurerad än.';

  @override
  String settingsConnectedAs(String name) {
    return 'Ansluten som $name';
  }

  @override
  String get settingsLastfmConnectedSubtitle =>
      'Allt du lyssnar på i Pudim skickas till din Last.fm-profil.';

  @override
  String get settingsDisconnect => 'Koppla från';

  @override
  String get settingsLastfmAuthorize => 'Godkänn på Last.fm-sidan';

  @override
  String get settingsLastfmAuthorizeSubtitle =>
      'När du har klickat på \"Yes, allow access\" där, gå tillbaka och tryck på Klar.';

  @override
  String get settingsFinish => 'Klar';

  @override
  String get settingsLastfmConnected => 'Last.fm ansluten';

  @override
  String get settingsLastfmScrobbleSubtitle =>
      'Loggar varje låt du lyssnar på till ditt Last.fm.';

  @override
  String get settingsConnect => 'Anslut';

  @override
  String get sidebarOpenLibrary => 'Öppna Ditt bibliotek';

  @override
  String get sidebarCollapseLibrary => 'Fäll ihop Ditt bibliotek';

  @override
  String sidebarOnDeviceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count låtar',
      one: '1 låt',
    );
    return 'På enheten • $_temp0';
  }

  @override
  String sidebarPlaylistCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count låtar',
      one: '1 låt',
    );
    return 'Spellista • $_temp0';
  }

  @override
  String sidebarAlbumBy(String artist) {
    return 'Album • $artist';
  }

  @override
  String get sidebarSearchLibrary => 'Sök i Ditt bibliotek';

  @override
  String get sidebarSortBy => 'Sortera efter';

  @override
  String get sidebarSortRecents => 'Senaste';

  @override
  String get sidebarSortAdded => 'Nyligen tillagt';

  @override
  String get sidebarSortAlpha => 'Alfabetisk';

  @override
  String get sidebarSortCreator => 'Skapare';

  @override
  String get topBarSearchHint => 'Vad vill du spela?';

  @override
  String get topBarClearSearch => 'Rensa sökfältet';

  @override
  String get topBarBrowse => 'Bläddra';

  @override
  String get topBarMenu => 'Meny';

  @override
  String get topBarLogoutAccount => 'Logga ut';

  @override
  String get topBarQuit => 'Avsluta Pudim';

  @override
  String get topBarLogout => 'Logga ut';

  @override
  String get playerBarSmartShuffleOff => 'Stäng av Smart Shuffle';

  @override
  String get playerBarSmartShuffleOn => 'Slå på Smart Shuffle';

  @override
  String get playerBarShuffleOff => 'Stäng av blandad uppspelning';

  @override
  String get playerBarShuffleOn => 'Slå på blandad uppspelning';

  @override
  String get playerBarPlay => 'Spela upp';

  @override
  String get playerBarForward => 'Nästa';

  @override
  String get playerBarRepeatOn => 'Slå på upprepning';

  @override
  String get playerBarRepeatOne => 'Upprepa en låt';

  @override
  String get playerBarRepeatOff => 'Stäng av upprepning';

  @override
  String get playerBarNowPlayingView => 'Vy för pågående uppspelning';

  @override
  String get playerBarLyrics => 'Text';

  @override
  String get playerBarUnmute => 'Slå på ljudet';

  @override
  String get playerBarMute => 'Stäng av ljudet';

  @override
  String get rightPanelNothingPlaying =>
      'Spela något för att se vad som spelas här.';

  @override
  String get rightPanelLyricsPreview => 'Förhandsvisning av text';

  @override
  String get rightPanelAboutArtist => 'Om artisten';

  @override
  String get rightPanelNextUp => 'Nästa i kön';

  @override
  String get rightPanelOpenQueue => 'Öppna kön';

  @override
  String get rightPanelQueueEmptyTitle => 'Lägg till i kön';

  @override
  String get rightPanelQueueEmptyHint =>
      'Klicka på \"Lägg till i kön\" i en låts meny för att lägga den här';

  @override
  String get rightPanelNowPlaying => 'Spelas nu';

  @override
  String get rightPanelNextInQueue => 'Nästa i kön';

  @override
  String rightPanelNextFrom(String name) {
    return 'Nästa från: $name';
  }

  @override
  String get nowPlayingPlayingFrom => 'SPELAS FRÅN';

  @override
  String get nowPlayingMoreOptions => 'Fler alternativ';

  @override
  String get chatChats => 'Chattar';

  @override
  String chatYouSaid(String text) {
    return 'Du: $text';
  }

  @override
  String get chatContacts => 'Kontakter';

  @override
  String get chatServerUnreachable => 'Det gick inte att nå extraservern.';

  @override
  String get chatMessageHint => 'Meddelande';

  @override
  String chatJoinedJam(String title) {
    return 'Du gick med i $title';
  }

  @override
  String chatCouldNotPlay(String error) {
    return 'Det gick inte att spela upp: $error';
  }

  @override
  String get chatJamCardSubtitle => 'Lyssna tillsammans, samma kö';

  @override
  String get chatInJam => 'I Jam';

  @override
  String get chatJoin => 'Gå med';

  @override
  String get chatNoOtherAccounts => 'Inga andra konton på servern.';

  @override
  String chatSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count låtar',
      one: '1 låt',
    );
    return '$_temp0';
  }

  @override
  String chatSentTo(String name) {
    return 'Skickad till $name';
  }

  @override
  String chatShareTitle(String title) {
    return 'Dela $title';
  }

  @override
  String get chatNoteHint => 'Anteckning (valfritt)';

  @override
  String get blendWorking => 'Blandar…';

  @override
  String blendAffinityButton(int affinity) {
    return 'Blend $affinity %';
  }

  @override
  String get blendCreate => 'Skapa Blend';

  @override
  String blendWith(String name) {
    return 'Blend med $name';
  }

  @override
  String get blendExplain =>
      'En spellista för er båda, med det ni båda lyssnar på, artisterna ni har gemensamt och lite av det var och en av er älskar mest. Den visar hur väl era smaker matchar och uppdateras varje dag.';

  @override
  String get blendNotNow => 'Inte nu';

  @override
  String blendAffinityTitle(int affinity) {
    return 'Ni matchar till $affinity %';
  }

  @override
  String blendInCommon(String artists) {
    return 'Gemensamt: $artists';
  }

  @override
  String blendOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Öppna Blend ($count låtar)',
      one: 'Öppna Blend (1 låt)',
    );
    return '$_temp0';
  }

  @override
  String get blendRefreshNow => 'Uppdatera nu';

  @override
  String get blendUndo => 'Ta bort Blend';

  @override
  String get blendRefreshing => 'Uppdaterar Blend…';

  @override
  String get blendUndoTitle => 'Ta bort Blend?';

  @override
  String blendUndoBody(String name) {
    return 'Spellistan försvinner för dig och $name.';
  }

  @override
  String get blendUndoConfirm => 'Ta bort';

  @override
  String get blendUndone => 'Blend borttagen';

  @override
  String get jamStart => 'Starta en Jam';

  @override
  String jamTooltip(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jam ($count personer)',
      one: 'Jam (1 person)',
    );
    return '$_temp0';
  }

  @override
  String get jamSubIdle => 'Lyssna tillsammans med andra konton, i samma kö.';

  @override
  String get jamSubHost => 'Du bestämmer. Alla kan önska låtar.';

  @override
  String get jamSubGuest => 'Dina kontroller och låtar går till allas kö.';

  @override
  String get jamPlayFirst => 'Spela något innan du startar Jam.';

  @override
  String jamMembers(int count) {
    return 'I Jam ($count)';
  }

  @override
  String jamYouSuffix(String name) {
    return '$name (du)';
  }

  @override
  String get jamHost => 'Värd';

  @override
  String get jamInvite => 'Bjud in';

  @override
  String get jamInviteTitle => 'Bjud in till Jam';

  @override
  String get jamInviteSubtitle => 'Inbjudan kommer till deras chatt.';

  @override
  String jamInviteSent(String name) {
    return 'Inbjudan skickad till $name';
  }

  @override
  String get jamEnd => 'Avsluta Jam';

  @override
  String get jamLeave => 'Lämna Jam';

  @override
  String recapTitle(int year) {
    return 'Din Wrapped $year';
  }

  @override
  String get recapShort => 'Wrapped';

  @override
  String recapBannerBody(String minutes) {
    return '$minutes minuter musik i år. Se vad du spelade mest.';
  }

  @override
  String get recapEmpty =>
      'Det finns inga lyssningar än att bygga din Wrapped på.';

  @override
  String get recapShareCards => 'Dela kort';

  @override
  String get recapBigMinutes => 'minuter lyssnade';

  @override
  String get recapBigSongs => 'olika låtar';

  @override
  String get recapBigArtists => 'artister';

  @override
  String get recapBigDays => 'dagar med musik';

  @override
  String get recapBigStreak => 'dagar i rad, ditt rekord';

  @override
  String get recapTopArtists => 'Dina toppartister i år';

  @override
  String recapMinutesValue(String minutes) {
    return '$minutes minuter';
  }

  @override
  String get recapTopSongs => 'Dina toppåtar i år';

  @override
  String recapPlaysLine(String artist, String plays) {
    return '$artist • $plays lyssningar';
  }

  @override
  String get recapSongGone => 'Den här låten finns inte längre i biblioteket';

  @override
  String get recapTopAlbums => 'Dina topalbum i år';

  @override
  String get recapTopGenres => 'Dina mest spelade genrer';

  @override
  String recapGenreLine(String genre, String minutes) {
    return '$genre • $minutes min';
  }

  @override
  String get recapMonthly => 'Månad för månad';

  @override
  String recapMonthTooltip(String month, String minutes) {
    return '$month: $minutes min';
  }

  @override
  String get recapListeningStyle => 'Hur du lyssnar';

  @override
  String recapFavHour(String hour) {
    return 'Favorittimme:$hour:00';
  }

  @override
  String recapFavWeekday(String day) {
    return 'Favoritdag i veckan: $day';
  }

  @override
  String recapBiggestDay(String date, String minutes) {
    return 'Din största dag: $date, $minutes minuter';
  }

  @override
  String recapNewArtists(int count, String n) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$n nya artister för dig',
      one: '$n ny artist för dig',
    );
    return '$_temp0';
  }

  @override
  String recapSpotifyAdded(String added) {
    return '$added Spotify-lyssningar lades till.';
  }

  @override
  String recapSpotifyAddedDup(String added, String dup) {
    return '$added Spotify-lyssningar lades till ($dup fanns redan från Pudim).';
  }

  @override
  String get recapSpotifyRemoveTitle => 'Ta bort din Spotify-historik?';

  @override
  String get recapSpotifyRemoveBody =>
      'Din Wrapped går tillbaka till att bara räkna det du spelade i Pudim/Jellyfin. Du kan importera den igen senare.';

  @override
  String get recapSpotifyRemoveConfirm => 'Ta bort';

  @override
  String recapSpotifyRemoved(String count) {
    return '$count Spotify-lyssningar togs bort';
  }

  @override
  String get recapSpotifyTitle => 'Spotify-historik';

  @override
  String recapSpotifyHasData(String count, String from, String to) {
    return '$count Spotify-lyssningar i din Wrapped ($from till $to). Du kan ladda upp en nyare fil: det som redan finns räknas inte två gånger.';
  }

  @override
  String get recapSpotifyIntro =>
      'Ta med åren före Pudim. I Spotify går du till Konto > Integritet > Ladda ner dina data och väljer \"Extended streaming history\". När mejlet kommer väljer du my_spotify_data.zip här.';

  @override
  String get recapSpotifyImportAnother => 'Importera en annan fil';

  @override
  String get recapSpotifyImport => 'Importera historik';

  @override
  String get recapSpotifyRemoveBtn => 'Ta bort från Wrapped';

  @override
  String get recapShareSaveDialog => 'Spara kort';

  @override
  String get recapShareSaved => 'Kortet sparades';

  @override
  String recapShareSaveFailed(String error) {
    return 'Det gick inte att spara: $error';
  }

  @override
  String recapShareShareFailed(String error) {
    return 'Det gick inte att dela: $error';
  }

  @override
  String recapShareText(int year) {
    return 'Min Wrapped $year på Pudim';
  }

  @override
  String get recapShareMyArtists => 'Mina toppartister i år';

  @override
  String get recapShareMySongs => 'Mina toppåtar i år';

  @override
  String recapMinShort(String minutes) {
    return '$minutes min';
  }

  @override
  String get recapShareSaveImage => 'Spara bild';

  @override
  String get recapShareButton => 'Dela';

  @override
  String recapBrand(int year) {
    return 'Wrapped $year';
  }

  @override
  String get recapShareMyYear => 'Mitt musikår';

  @override
  String recapShareYearOf(String name) {
    return '${name}s musikår';
  }

  @override
  String get recapShareTopArtist => 'min toppartist i år';

  @override
  String recapShareGenres(String genres) {
    return 'Genrer: $genres';
  }

  @override
  String get widgetActionsAddedToLiked => 'Tillagd i Gillade låtar';

  @override
  String get widgetActionsRemovedFromLiked => 'Borttagen från Gillade låtar';

  @override
  String get widgetActionsUnfollowed => 'Följer inte längre';

  @override
  String get widgetActionsSavedToLibrary => 'Sparad i Ditt bibliotek';

  @override
  String get widgetActionsRemovedFromLibrary => 'Borttagen från Ditt bibliotek';

  @override
  String get widgetActionsAddToQueue => 'Lägg till i kön';

  @override
  String get widgetActionsAddedToQueue => 'Tillagd i kön';

  @override
  String get widgetActionsPlayNext => 'Spela härnäst';

  @override
  String get widgetActionsGoToPodcast => 'Gå till podd';

  @override
  String get widgetActionsRemoveFromQueue => 'Ta bort från kön';

  @override
  String get widgetActionsAddToPlaylist => 'Lägg till i spellista';

  @override
  String get widgetActionsRemoveFromThisPlaylist =>
      'Ta bort från den här spellistan';

  @override
  String get widgetActionsInviteToEdit => 'Bjud in att redigera';

  @override
  String get widgetActionsKeepInPlaylist => 'Behåll i spellistan';

  @override
  String get widgetActionsDownloadTrack => 'Ladda ner låt';

  @override
  String get widgetActionsDownloadAlbum => 'Ladda ner album';

  @override
  String get widgetActionsDownloadDiscography => 'Ladda ner diskografi';

  @override
  String get widgetActionsSearchAlbums => 'Hitta album';

  @override
  String widgetActionsImproveQuality(int count) {
    return 'Förbättra kvaliteten ($count)';
  }

  @override
  String widgetActionsImprovingAlbums(int count) {
    return 'Letar efter bättre versioner av $count album';
  }

  @override
  String get widgetActionsShare => 'Dela';

  @override
  String get widgetActionsSearchFlac => 'Hitta i FLAC';

  @override
  String widgetActionsSearchingFlac(String name) {
    return 'Letar efter $name i FLAC; om den hittas ersätter den MP3-filen';
  }

  @override
  String get widgetActionsTrackRemovedFromDevice => 'Borttagen från enheten';

  @override
  String get widgetActionsRemovedFromDevice => 'Borttagen från enheten';

  @override
  String get widgetActionsDownloadingToDevice =>
      'Laddar ner till din enhet för offlinelyssning';

  @override
  String get widgetActionsUnfollow => 'Sluta följa';

  @override
  String get widgetActionsRemoveFromLibrary => 'Ta bort från Ditt bibliotek';

  @override
  String get widgetActionsAddToLibrary => 'Lägg till i Ditt bibliotek';

  @override
  String get widgetActionsGoToSongRadio => 'Gå till låtradio';

  @override
  String get widgetActionsStartMix => 'Starta mix';

  @override
  String widgetActionsMixOf(String name) {
    return '$name-mix';
  }

  @override
  String get widgetActionsGoToArtist => 'Gå till artist';

  @override
  String get widgetActionsGoToAlbum => 'Gå till album';

  @override
  String get widgetActionsCopyName => 'Kopiera namn';

  @override
  String get widgetActionsCopied => 'Kopierat';

  @override
  String widgetDownloadsBellDownloading(int count) {
    return '$count laddas ner';
  }

  @override
  String get widgetDownloadsBellEmpty =>
      'Inget här än. Spela en låt med molnikon eller använd \"Ladda ner\" i ⋯-menyn för att hämta den från katalogen till ditt bibliotek.';

  @override
  String get widgetDownloadsBellKindDiscography => 'Diskografi';

  @override
  String get widgetDownloadsBellKindFlac => 'I FLAC';

  @override
  String get widgetDownloadsBellKindQuality => 'Kvalitet';

  @override
  String get widgetDownloadsBellOptions => 'Alternativ';

  @override
  String get widgetDownloadsBellCancelled => 'Nedladdningen avbröts';

  @override
  String get widgetDownloadsBellRetrying => 'Försöker igen';

  @override
  String get widgetDownloadsBellRemovedFromList => 'Borttagen från listan';

  @override
  String get widgetDownloadsBellDetails => 'Visa detaljer';

  @override
  String get widgetDownloadsBellRemoveFromList => 'Ta bort från listan';

  @override
  String get widgetMixSearchingReleases => 'Letar efter nya utgåvor…';

  @override
  String get widgetMixBuildingDaylist => 'Skapar din daylist…';

  @override
  String get widgetMixNewDiscoveriesTitle => 'Nya Veckans upptäckter?';

  @override
  String get widgetMixNewMixTitle => 'Ny Veckans mix?';

  @override
  String get widgetMixNewDiscoveriesBody =>
      'Låtar du inte har lyssnat på än lämnar spellistan och ungefär 30 nya börjar komma in. Det här händer redan av sig självt varje måndag.';

  @override
  String get widgetMixNewMixBody =>
      'Bygger om den med dina favoriter, det du lyssnar mest på och liknande låtar. Det här händer redan av sig självt varje måndag.';

  @override
  String get widgetMixNotNow => 'Inte nu';

  @override
  String get widgetMixBuildingDiscoveries => 'Skapar dina Upptäckter…';

  @override
  String get widgetMixBuildingMix => 'Skapar din Mix…';

  @override
  String widgetMixBuiltOn(String date) {
    return 'Skapad $date';
  }

  @override
  String get widgetMixRedo => 'Skapa om';

  @override
  String get widgetMixRefresh => 'Uppdatera';

  @override
  String get widgetMixCreateDiscoveries => 'Skapa dina Veckans upptäckter';

  @override
  String get widgetMixCreateMix => 'Skapa din Veckans mix';

  @override
  String get widgetMixCreateRadar => 'Skapa din Nyutgivningsradar';

  @override
  String get widgetMixCreateDaylist => 'Skapa din daylist';

  @override
  String get widgetOfflineBanner =>
      'Inget internet · visar det som är sparat på din enhet';

  @override
  String widgetOfflineDownloadingProgress(int done, int total) {
    return 'Laddar ner $done av $total';
  }

  @override
  String get widgetUpdateReady => 'Ny version av Pudim är redo';

  @override
  String widgetUpdateReadyNotes(String notes) {
    return 'Ny version av Pudim · $notes';
  }

  @override
  String get widgetUpdateAction => 'Uppdatera';

  @override
  String widgetSleepShortMinutes(int count) {
    return '$count min';
  }

  @override
  String widgetSleepShortSeconds(int count) {
    return '$count s';
  }

  @override
  String get widgetSleepStopsAtEnd => 'Stannar när låten slutar';

  @override
  String widgetSleepStopsIn(String time) {
    return 'Stannar om $time';
  }

  @override
  String get widgetSleepTimer => 'Sovtimer';

  @override
  String get widgetSleepTurnOff => 'Stäng av timern';

  @override
  String get widgetSleepOneHour => '1 timme';

  @override
  String get widgetSleepOneAndHalfHours => '1 timme 30 minuter';

  @override
  String get widgetSleepEndOfSong => 'Låtens slut';

  @override
  String get widgetSleepTurnedOff => 'Timern avstängd';

  @override
  String get widgetSleepStopsWhenSongEnds =>
      'Musiken stannar när den här låten slutar';

  @override
  String widgetSleepSongStopsIn(String time) {
    return 'Musiken stannar om $time';
  }

  @override
  String get widgetSpeedPodcast => 'Poddhastighet';

  @override
  String get widgetCommonCatalogBadge =>
      'Från katalogen: finns inte i ditt bibliotek än';

  @override
  String get widgetCommonShowAll => 'Visa alla';

  @override
  String get widgetCommonSomethingWentWrong => 'Något gick fel';

  @override
  String get widgetCommonListenDownloaded => 'Lyssna på nedladdade låtar';

  @override
  String get widgetTracksTitle => 'Titel';

  @override
  String get widgetTracksDateAdded => 'Datum tillagd';

  @override
  String widgetTracksAddedBy(String name) {
    return 'av $name';
  }

  @override
  String get widgetTracksMoreOptions => 'Fler alternativ';

  @override
  String widgetTracksAddedDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get castTooltip => 'Casta';

  @override
  String get castTitle => 'Spela på';

  @override
  String get castThisDevice => 'Den här enheten';

  @override
  String get castSearching => 'Söker efter enheter i nätverket…';

  @override
  String get castNone =>
      'Ingen Chromecast hittades. Den måste vara på samma wifi.';

  @override
  String get castSearchAgain => 'Sök igen';

  @override
  String get castStop => 'Sluta casta';

  @override
  String castPlayingOn(String name) {
    return 'Spelas på $name';
  }

  @override
  String castFailed(String name) {
    return 'Kunde inte ansluta till $name';
  }

  @override
  String get settingsSectionAppearance => 'Utseende';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSubtitle => 'Byter färger direkt.';

  @override
  String get themeNightDesc => 'Mörkt, rundade kort och svävande minispelare.';

  @override
  String get themeRedDesc =>
      'Helsvart med rött, stora fyrkantiga omslag, minispelare vid fältet.';

  @override
  String get themeWaveDesc =>
      'Lila toningar, kraftig text och minispelare som piller.';

  @override
  String get themeRetroDesc =>
      'Grått fönster i relief, grön display med rullande titel och textlistor.';

  @override
  String get themeClassicDesc =>
      'Blankt blått och svart glas, klotknapp, visualiserare och tabellistor.';

  @override
  String get settingsCheckUpdates => 'Sök efter uppdateringar';

  @override
  String get updateChecking => 'Söker…';

  @override
  String updateUpToDate(int build) {
    return 'Du har den senaste versionen (build $build).';
  }

  @override
  String updateDownloading(int build, int percent) {
    return 'Laddar ner build $build… $percent %';
  }

  @override
  String updateFailed(String error) {
    return 'Kunde inte söka: $error';
  }

  @override
  String get updateUnavailable => 'Ingen extraserver inställd.';

  @override
  String get settingsHistory => 'Historik';

  @override
  String get settingsHistorySubtitle =>
      'Sammanfattningar från tidigare år och allt du har lyssnat på';

  @override
  String get historyRecaps => 'Sammanfattningar';

  @override
  String get historyPlays => 'Spelningar';

  @override
  String get historyWholeYear => 'Hela året';

  @override
  String get historyLoadMore => 'Ladda fler';

  @override
  String get historyEmpty => 'Inget spelat ännu';

  @override
  String get historyImported => 'importerad';
}
