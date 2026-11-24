// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class L10nNl extends L10n {
  L10nNl([String locale = 'nl']) : super(locale);

  @override
  String get languageTitle => 'Taal';

  @override
  String get languageSubtitle => 'Taal van de interface';

  @override
  String get languageSystem => 'Systeemstandaard';

  @override
  String get commonCancel => 'Annuleren';

  @override
  String get commonClose => 'Sluiten';

  @override
  String get commonBack => 'Terug';

  @override
  String get commonSave => 'Opslaan';

  @override
  String get commonEdit => 'Bewerken';

  @override
  String get commonDelete => 'Verwijderen';

  @override
  String get commonRemove => 'Verwijderen';

  @override
  String get commonOk => 'OK';

  @override
  String get commonRetry => 'Opnieuw proberen';

  @override
  String get commonQueue => 'Wachtrij';

  @override
  String get commonAlbum => 'Album';

  @override
  String get commonAlbums => 'Albums';

  @override
  String get commonArtist => 'Artiest';

  @override
  String get commonArtists => 'Artiesten';

  @override
  String get commonSong => 'Nummer';

  @override
  String get commonSongs => 'Nummers';

  @override
  String get commonPlaylist => 'Afspeellijst';

  @override
  String get commonPlaylists => 'Afspeellijsten';

  @override
  String get commonSingle => 'Single';

  @override
  String get commonLikedSongs => 'Leuk gevonden nummers';

  @override
  String get commonAddToLiked => 'Toevoegen aan Leuk gevonden nummers';

  @override
  String get commonRemoveFromLiked => 'Verwijderen uit Leuk gevonden nummers';

  @override
  String get commonShufflePlay => 'Willekeurig afspelen';

  @override
  String get commonPlay => 'Afspelen';

  @override
  String get commonPause => 'Pauzeren';

  @override
  String get commonFollow => 'Volgen';

  @override
  String get commonFollowing => 'Volgend';

  @override
  String get commonDownloadToDevice => 'Downloaden naar apparaat';

  @override
  String get commonRemoveFromDevice => 'Verwijderen van apparaat';

  @override
  String get commonDownloaded => 'Gedownload';

  @override
  String get commonDownloads => 'Downloads';

  @override
  String get commonAll => 'Alles';

  @override
  String get commonRecentlyPlayed => 'Recent afgespeeld';

  @override
  String get commonYourLibrary => 'Jouw bibliotheek';

  @override
  String get commonHome => 'Home';

  @override
  String get commonSearch => 'Zoeken';

  @override
  String get commonProfile => 'Profiel';

  @override
  String get commonSettings => 'Instellingen';

  @override
  String get commonBuilding => 'Bezig met maken…';

  @override
  String get commonBuildNow => 'Nu maken';

  @override
  String get commonShows => 'Concerten';

  @override
  String get commonPodcasts => 'Podcasts';

  @override
  String commonSongCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nummers',
      one: '1 nummer',
      zero: 'Geen nummers',
    );
    return '$_temp0';
  }

  @override
  String commonMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuten',
      one: '1 minuut',
    );
    return '$_temp0';
  }

  @override
  String commonError(String error) {
    return 'Fout: $error';
  }

  @override
  String get apiStatusQueued => 'In de wachtrij';

  @override
  String get apiStatusDownloading => 'Bezig met downloaden';

  @override
  String get apiStatusDone => 'Toegevoegd aan de bibliotheek';

  @override
  String get apiStatusUpToDate => 'Al in de bibliotheek';

  @override
  String get apiStatusPartial => 'Gedeeltelijk toegevoegd';

  @override
  String get apiStatusNotFound => 'Niet gevonden';

  @override
  String get apiStatusCancelled => 'Geannuleerd';

  @override
  String get apiStatusInterrupted => 'Onderbroken';

  @override
  String get apiStatusFailed => 'Mislukt';

  @override
  String get apiExtrasNoResponse => 'De extra-server reageert niet.';

  @override
  String get apiAlbumListFailed => 'Kan de albums niet ophalen.';

  @override
  String apiPlaylistSaved(int found, int total) {
    return 'Afspeellijst in Jouw bibliotheek ($found van $total nummers)';
  }

  @override
  String apiPlaylistDownloading(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nummers',
      one: '1 nummer',
    );
    return 'Afspeellijst in Jouw bibliotheek; nog $_temp0 aan het downloaden';
  }

  @override
  String get apiBadCredentials => 'Onjuiste gebruikersnaam of wachtwoord.';

  @override
  String get apiServerUnreachable => 'Kan de server niet bereiken.';

  @override
  String get apiQuickConnectOff =>
      'Quick Connect is uitgeschakeld op deze server.';

  @override
  String get apiWrongCurrentPassword => 'Het huidige wachtwoord is onjuist.';

  @override
  String stateChatShared(String title) {
    return '$title gedeeld';
  }

  @override
  String stateDownloadingName(String name) {
    return '$name wordt gedownload';
  }

  @override
  String stateDownloadingRequests(int count) {
    return '$count verzoeken worden gedownload';
  }

  @override
  String stateDownloadArrived(String name) {
    return '$name is toegevoegd aan de bibliotheek';
  }

  @override
  String stateDownloadPartial(String name) {
    return '$name is gedeeltelijk toegevoegd';
  }

  @override
  String stateDownloadEnded(String name, String status) {
    return '$name: $status';
  }

  @override
  String get stateNotFromCatalog => 'Dit item komt niet uit de catalogus.';

  @override
  String stateAlreadyDownloading(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Het album wordt al gedownload.',
      'artist': 'De discografie wordt al gedownload.',
      'other': 'Het nummer wordt al gedownload.',
    });
    return '$_temp0';
  }

  @override
  String stateDownloadRequested(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Het album wordt gedownload. Het verschijnt in de bel zodra het binnen is.',
      'artist': 'De discografie wordt gedownload. Die verschijnt in de bel zodra ze binnen is.',
      'other': 'Het nummer wordt gedownload. Het verschijnt in de bel zodra het binnen is.',
    });
    return '$_temp0';
  }

  @override
  String get stateNotifyDownloadsChannel => 'Downloads';

  @override
  String get stateNotifyDownloadsChannelDesc =>
      'Voortgang van nummers die worden gedownload';

  @override
  String get stateNotifyNewsChannel => 'Nieuw';

  @override
  String get stateNotifyNewsChannelDesc =>
      'Nieuwe aanwinsten, releases, Descobertas en Mistura';

  @override
  String get stateOfflineLoose => 'Los gedownload';

  @override
  String get stateOfflineDoneTitle => 'Gedownload naar dit apparaat';

  @override
  String stateOfflineDoneBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nummers klaar om offline te beluisteren',
      one: '1 nummer klaar om offline te beluisteren',
    );
    return '$_temp0';
  }

  @override
  String get stateOfflineProgressTitle => 'Downloaden naar dit apparaat';

  @override
  String stateOfflineProgressBody(int done, int total, String name) {
    return '$done van $total • $name';
  }

  @override
  String get stateServerNoReply =>
      'De server reageert niet. Controleer het adres.';

  @override
  String get stateServerNoReplyBoth =>
      'De server reageert op geen van beide adressen.';

  @override
  String get stateTokenStoreUnsupported =>
      'Pudim kan je login voorlopig alleen opslaan op Windows en Android.';

  @override
  String get stateQualityPoor => 'lage kwaliteit';

  @override
  String get stateQualityPartial => 'onvolledig';

  @override
  String get audioPlaybackChannel => 'Afspelen';

  @override
  String get audioRecentAlbums => 'Recente albums';

  @override
  String audioSearchContext(String query) {
    return 'Zoeken: $query';
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
      'm3': 'mrt',
      'm4': 'apr',
      'm5': 'mei',
      'm6': 'jun',
      'm7': 'jul',
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
    return '$h u $min min';
  }

  @override
  String podcastsMin(int min) {
    return '$min min';
  }

  @override
  String get podcastsPlayed => 'afgespeeld';

  @override
  String podcastsTimeLeft(String time) {
    return '$time resterend';
  }

  @override
  String get podcastsSearchHint => 'Zoek podcasts';

  @override
  String get podcastsNothingFound => 'Niets gevonden.';

  @override
  String get podcastsYours => 'Jouw podcasts';

  @override
  String get podcastsNewEpisodes => 'Nieuwe afleveringen';

  @override
  String get podcastsTrendingBrazil => 'Trending in Brazilië';

  @override
  String get podcastsLoadFailed => 'Laden mislukt. Probeer het opnieuw';

  @override
  String get podcastsNoEpisodes => 'Geen afleveringen in de feed.';

  @override
  String podcastsNoEpisodeMatch(String q) {
    return 'Geen afleveringen gevonden voor \"$q\".';
  }

  @override
  String get podcastsKind => 'Podcast';

  @override
  String get podcastsEpisodes => 'Afleveringen';

  @override
  String podcastsEpisodesCount(int total) {
    return 'Afleveringen ($total)';
  }

  @override
  String get podcastsFindEpisode => 'Zoek afleveringen';

  @override
  String showsMonthName(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': 'januari',
      'm2': 'februari',
      'm3': 'maart',
      'm4': 'april',
      'm5': 'mei',
      'm6': 'juni',
      'm7': 'juli',
      'm8': 'augustus',
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
      'w1': 'ma',
      'w2': 'di',
      'w3': 'wo',
      'w4': 'do',
      'w5': 'vr',
      'w6': 'za',
      'other': 'zo',
    });
    return '$_temp0';
  }

  @override
  String get showsFollowingNone => 'Van artiesten die je volgt';

  @override
  String showsFollowingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Van de $count artiesten die je volgt',
      one: 'Van de 1 artiest die je volgt',
    );
    return '$_temp0';
  }

  @override
  String showsSearchingFor(int count) {
    return 'zoeken naar concerten van $count…';
  }

  @override
  String get showsUpcoming => 'Aankomend';

  @override
  String get showsPast => 'Afgelopen';

  @override
  String get showsInBrazil => 'In Brazilië';

  @override
  String get showsEmptyFollow =>
      'Volg artiesten (knop Volgen op de artiestenpagina) om hun concerten hier te zien.';

  @override
  String get showsNonePast => 'Nog geen concerten geregistreerd.';

  @override
  String get showsNoneUpcoming => 'Voorlopig geen concerten gepland.';

  @override
  String get showsStillSearching => 'Nog aan het zoeken…';

  @override
  String get showsSource =>
      'Data van MusicBrainz (door fans gemaakt); nieuwe concerten kunnen even duren voor ze verschijnen.';

  @override
  String get showsCancelled => 'geannuleerd';

  @override
  String get showsFestival => 'festival';

  @override
  String get catalogKindAlbum => 'Album';

  @override
  String get catalogKindSingle => 'Single';

  @override
  String get catalogKindBroadcast => 'Uitzending';

  @override
  String get catalogKindOther => 'Overig';

  @override
  String get catalogSecLive => 'live';

  @override
  String get catalogSecCompilation => 'compilatie';

  @override
  String get catalogSecSoundtrack => 'soundtrack';

  @override
  String get catalogSecMixtape => 'mixtape';

  @override
  String get catalogSecInterview => 'interview';

  @override
  String get catalogSecSpokenword => 'spoken word';

  @override
  String catalogDownloadingOne(String title) {
    return '$title wordt gedownload';
  }

  @override
  String catalogDownloadingMany(int count, String artist) {
    return '$count albums van $artist worden gedownload';
  }

  @override
  String catalogCheckingDiscography(int seconds) {
    return 'Discografie controleren… $seconds s';
  }

  @override
  String catalogToDownload(int count) {
    return '$count te downloaden';
  }

  @override
  String catalogInLibraryCount(int count) {
    return '$count al in de bibliotheek';
  }

  @override
  String catalogSkippedOneSong(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count releases met één nummer weggelaten',
      one: '1 release met één nummer weggelaten',
    );
    return '$_temp0';
  }

  @override
  String get catalogPickAll => 'Alles';

  @override
  String get catalogPickStudio => 'Studio';

  @override
  String get catalogPickNone => 'Geen';

  @override
  String get catalogDownloadSelected => 'Selectie downloaden';

  @override
  String catalogDownloadNSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count geselecteerde items downloaden',
      one: '1 geselecteerd item downloaden',
    );
    return '$_temp0';
  }

  @override
  String get catalogNothingMissing => 'Er ontbreekt niets.';

  @override
  String get catalogPartial => 'gedeeltelijk';

  @override
  String get catalogDownload => 'Downloaden';

  @override
  String get catalogAddToLibrary => 'Toevoegen aan Jouw bibliotheek';

  @override
  String get catalogInYourLibrary => 'In Jouw bibliotheek';

  @override
  String get catalogAllInLibrary => 'alles in de bibliotheek';

  @override
  String catalogNInLibrary(int count) {
    return '$count in de bibliotheek';
  }

  @override
  String get catalogDownloadAlbum => 'Album downloaden';

  @override
  String get catalogArtistNotFound => 'Artiest niet gevonden.';

  @override
  String get catalogFromCatalog =>
      'Uit de catalogus: nog niet in de bibliotheek';

  @override
  String get catalogDownloadAll => 'Alles downloaden';

  @override
  String get catalogDownloadDiscography => 'Discografie downloaden';

  @override
  String get catalogPopular => 'Populair';

  @override
  String get catalogShowLess => 'Minder tonen';

  @override
  String get catalogShowMore => 'Meer tonen';

  @override
  String get catalogSinglesEps => 'Singles en ep’s';

  @override
  String get catalogFansAlsoLike => 'Fans vinden ook leuk';

  @override
  String get lyricsPlaySomething => 'Speel iets af om de songtekst te zien.';

  @override
  String get lyricsNone => 'Geen songtekst voor dit nummer';

  @override
  String get lyricsNoneHint =>
      'Als er een .lrc- of .txt-bestand naast het bestand staat, verschijnt het hier.';

  @override
  String get lyricsSynced => 'Gesynchroniseerde songtekst uit het .lrc-bestand';

  @override
  String get lyricsUnsynced => 'Niet-gesynchroniseerde songtekst';

  @override
  String get profileChangePhoto => 'Foto wijzigen';

  @override
  String get profileNoPhoto => 'Geen foto gekozen';

  @override
  String get profilePhotoTooBig => 'Foto te groot (maximaal 8 MB)';

  @override
  String get profilePhotoChanged => 'Profielfoto gewijzigd';

  @override
  String get profilePhotoRemoved => 'Foto verwijderd';

  @override
  String get profileNameSaved => 'Profielnaam opgeslagen';

  @override
  String get profileRenameTitle => 'Je gebruikersnaam wijzigen?';

  @override
  String profileRenameBody(String name) {
    return 'Je logt voortaan in als \"$name\" in Pudim, Jellyfin en de andere apps (Finamp, Feishin…). Je Descobertas, Mix en Rewind gaan mee.';
  }

  @override
  String get profileRenameConfirm => 'Wijzigen';

  @override
  String profileNowSignedAs(String name) {
    return 'Je logt nu in als $name';
  }

  @override
  String get profileEnterNewPassword => 'Voer het nieuwe wachtwoord in';

  @override
  String get profilePasswordsDiffer =>
      'De nieuwe wachtwoorden komen niet overeen';

  @override
  String get profilePasswordChanged => 'Wachtwoord gewijzigd';

  @override
  String get profileExtrasUnreachable =>
      'Kan de extra-server niet bereiken; profielnaam en gebruikersnaam moeten even wachten.';

  @override
  String get profileNameSection => 'Profielnaam';

  @override
  String get profileNameHelp => 'Zo zien je contacten je in chats.';

  @override
  String get profileYourName => 'Je naam';

  @override
  String get profileUsernameSection => 'Gebruikersnaam';

  @override
  String get profileUsernameHelp =>
      'De naam waarmee je inlogt bij Jellyfin (hier en in andere apps).';

  @override
  String get profileUsernameHint => 'Gebruikersnaam';

  @override
  String get profileChangeUsername => 'Gebruikersnaam wijzigen';

  @override
  String get profilePasswordSection => 'Wachtwoord';

  @override
  String get profileCurrentPassword => 'Huidig wachtwoord';

  @override
  String get profileNewPassword => 'Nieuw wachtwoord';

  @override
  String get profileRepeatPassword => 'Herhaal het nieuwe wachtwoord';

  @override
  String get profileChangePassword => 'Wachtwoord wijzigen';

  @override
  String get loginServerRequired => 'Voer het adres van je Jellyfin-server in.';

  @override
  String get loginUserRequired => 'Voer je gebruikersnaam in.';

  @override
  String get loginTitle => 'Inloggen bij Pudim';

  @override
  String get loginSubtitle => 'Gebruik je Jellyfin-account.';

  @override
  String get loginUsername => 'Gebruikersnaam';

  @override
  String get loginPassword => 'Wachtwoord';

  @override
  String get loginShowPassword => 'Wachtwoord tonen';

  @override
  String get loginHidePassword => 'Wachtwoord verbergen';

  @override
  String get loginSubmit => 'Inloggen';

  @override
  String get loginQuickConnect => 'Inloggen met Quick Connect';

  @override
  String get loginHideAddresses => 'Adressen verbergen';

  @override
  String get loginServerAddress => 'Serveradres';

  @override
  String get loginJellyfinServer => 'Jellyfin-server';

  @override
  String get loginJellyfinServerExample => 'Bijv. https://jellyfin.exemplo.com';

  @override
  String get loginLocalNetwork => 'Op het lokale netwerk (optioneel)';

  @override
  String get loginLocalNetworkExample =>
      'Bijv. http://192.168.0.10:8096. Als dit adres reageert, gebruikt de app het in plaats van het hoofdadres.';

  @override
  String get loginExtrasServer => 'Extra-server (optioneel)';

  @override
  String get loginExtrasServerHint =>
      'Schakelt chat, Jam, Blend, mixes en Rewind in. Laat leeg als je er geen hebt.';

  @override
  String get loginQcExpired => 'De code is verlopen. Probeer het opnieuw.';

  @override
  String get loginQcInstructions =>
      'Open op een apparaat waarop je al bent ingelogd bij Jellyfin je profiel, tik op Quick Connect en voer deze code in:';

  @override
  String get loginQcWaiting => 'Wachten op goedkeuring…';

  @override
  String get homeDownloadedOnDevice => 'Gedownload op dit apparaat';

  @override
  String get homeTabMusic => 'Muziek';

  @override
  String get homeMadeFor => 'Gemaakt voor';

  @override
  String get homeMixDiscoveries => 'Elke week nieuwe muziek voor jou';

  @override
  String get homeMixWeekly =>
      'Je favorieten en vergelijkbare nummers, elke week';

  @override
  String get homeMixRadar =>
      'Nieuwe releases van artiesten die je volgt, elke vrijdag';

  @override
  String get homeMixDaylist => 'Verandert de hele dag door';

  @override
  String get homeMixBlend => 'Jullie smaken samen';

  @override
  String get homeMixAuto => 'Automatische mix';

  @override
  String get homeSpotifyPlaylists => 'Je Spotify-afspeellijsten';

  @override
  String get homeFromSpotify => 'Van Spotify';

  @override
  String get homeYourPlaylists => 'Je afspeellijsten';

  @override
  String get homeTopAlbums => 'Je meest afgespeelde albums';

  @override
  String get homeTopArtists => 'Je favoriete artiesten';

  @override
  String get homeRecentlyAdded => 'Recent toegevoegd';

  @override
  String get homeYourPodcasts => 'Je podcasts';

  @override
  String get homeRadiosTitle => 'Aanbevolen radiostations';

  @override
  String get homeRadiosSubtitle =>
      'Non-stop muziek op basis van je favoriete artiesten.';

  @override
  String get homeRadioBadge => 'RADIO';

  @override
  String homeRadioWith(String name) {
    return 'Met $name en vergelijkbare artiesten';
  }

  @override
  String searchNoResults(String query) {
    return 'Geen resultaten voor \"$query\"';
  }

  @override
  String get searchNoResultsHint =>
      'Controleer de spelling of gebruik minder of andere woorden.';

  @override
  String searchCatalogNoResponse(String error) {
    return 'De catalogus reageerde niet: $error';
  }

  @override
  String get searchAlsoCatalog => 'Ook de catalogus doorzoeken…';

  @override
  String searchLibraryOnly(String error) {
    return 'Alleen bibliotheek: de catalogus reageerde niet ($error).';
  }

  @override
  String get searchTopResult => 'Beste resultaat';

  @override
  String get searchSpotifyPlaylists => 'Spotify-afspeellijsten';

  @override
  String get searchRecent => 'Recente zoekopdrachten';

  @override
  String get searchClear => 'Wissen';

  @override
  String get searchBrowseAll => 'Alles bekijken';

  @override
  String get searchHint => 'Wat wil je luisteren?';

  @override
  String get albumDownloadedType => 'Album • gedownload op dit apparaat';

  @override
  String albumSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nummers',
      one: '1 nummer',
    );
    return '$_temp0, $total';
  }

  @override
  String get albumRemoveFromLibrary => 'Verwijderen uit Jouw bibliotheek';

  @override
  String get albumSaveToLibrary => 'Opslaan in Jouw bibliotheek';

  @override
  String albumMoreOptions(String name) {
    return 'Meer opties voor $name';
  }

  @override
  String albumDisc(int number) {
    return 'Schijf $number';
  }

  @override
  String albumMoreFrom(String name) {
    return 'Meer van $name';
  }

  @override
  String artistAlbumsInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count albums in je bibliotheek',
      one: '1 album in je bibliotheek',
    );
    return '$_temp0';
  }

  @override
  String artistPlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count keer afgespeeld',
      one: '1 keer afgespeeld',
    );
    return '$_temp0';
  }

  @override
  String artistMoreOptions(String name) {
    return 'Meer opties voor $name';
  }

  @override
  String get artistPopular => 'Populair';

  @override
  String get artistShowLess => 'Minder tonen';

  @override
  String get artistShowMore => 'Meer tonen';

  @override
  String get artistYouLiked => 'Door jou leuk gevonden';

  @override
  String artistFrom(String name) {
    return 'Van $name';
  }

  @override
  String get artistDiscography => 'Discografie';

  @override
  String get artistPopularReleases => 'Populaire releases';

  @override
  String get artistSinglesEps => 'Singles en ep’s';

  @override
  String get artistFansAlsoLike => 'Fans vinden ook leuk';

  @override
  String get artistAppearsOn => 'Te horen op';

  @override
  String get artistAbout => 'Over';

  @override
  String get playlistOriginSpotify => 'Van Spotify';

  @override
  String get playlistOriginMadeForYou => 'Voor jou gemaakt';

  @override
  String get playlistOriginAuto => 'Automatische mix';

  @override
  String get playlistDownloadedOnDevice => 'Gedownload op dit apparaat';

  @override
  String get playlistOnDevice => 'Op dit apparaat';

  @override
  String get playlistPlaysOffline => 'Speelt af zonder internet.';

  @override
  String playlistPlaysOfflineDownloading(int count) {
    return 'Speelt af zonder internet. Nog $count aan het downloaden…';
  }

  @override
  String playlistSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nummers',
      one: '1 nummer',
    );
    return '$_temp0, $total';
  }

  @override
  String playlistMoreOptions(String name) {
    return 'Meer opties voor $name';
  }

  @override
  String get playlistSearchHint => 'Zoeken in afspeellijst';

  @override
  String get playlistEmpty => 'Nog geen nummers.';

  @override
  String get playlistErrNoPermission =>
      'Je hebt geen toestemming om deze afspeellijst te bewerken.';

  @override
  String playlistErrServer(String code) {
    return 'De server heeft het verzoek geweigerd ($code).';
  }

  @override
  String get playlistErrNoResponse => 'geen reactie';

  @override
  String get playlistDownloadFirst =>
      'Download het nummer eerst om het aan een afspeellijst toe te voegen';

  @override
  String get playlistAddTo => 'Toevoegen aan afspeellijst';

  @override
  String get playlistNew => 'Nieuwe afspeellijst';

  @override
  String playlistAddedTo(String name) {
    return 'Toegevoegd aan $name';
  }

  @override
  String get playlistNameHint => 'Naam van afspeellijst';

  @override
  String get playlistCreate => 'Maken';

  @override
  String playlistCreated(String name) {
    return 'Afspeellijst $name gemaakt';
  }

  @override
  String get playlistRemoved => 'Verwijderd uit afspeellijst';

  @override
  String get playlistInviteTitle => 'Uitnodigen om te bewerken';

  @override
  String get playlistInviteSubtitle =>
      'Ze zien de afspeellijst in hun bibliotheek en kunnen nummers toevoegen en verwijderen.';

  @override
  String get playlistInviteOwnerOnly =>
      'Alleen de maker van de afspeellijst kan uitnodigen';

  @override
  String playlistInvited(String who, String playlist) {
    return '$who kan nu $playlist bewerken';
  }

  @override
  String playlistCollaborative(String members) {
    return 'Gezamenlijk · $members';
  }

  @override
  String get playlistSmartShuffleTooltip =>
      'Smart Shuffle: willekeurig afspelen met aanbevelingen';

  @override
  String get playlistSmartShuffleOn =>
      'Smart Shuffle aan: aanbevelingen zijn gemarkeerd met ✦';

  @override
  String get playlistAddedToThis => 'Toegevoegd aan afspeellijst';

  @override
  String get playlistRecommendation => 'Smart Shuffle-aanbeveling';

  @override
  String get playlistPutIn => 'Toevoegen aan afspeellijst';

  @override
  String get settingsSectionAccount => 'Account';

  @override
  String get settingsProfileSubtitle => 'Naam, gebruikersnaam en wachtwoord';

  @override
  String settingsConnectedAt(String url) {
    return 'Verbonden met $url';
  }

  @override
  String get settingsSignOut => 'Uitloggen';

  @override
  String get accountsTitle => 'Accounts';

  @override
  String get accountsAdd => 'Account of server toevoegen';

  @override
  String get accountsSwitch => 'Wisselen';

  @override
  String get accountsInUse => 'In gebruik';

  @override
  String accountsOn(String user, String host) {
    return '$user op $host';
  }

  @override
  String get loginBackToAccount => 'Terug naar huidig account';

  @override
  String get settingsSectionServer => 'Server';

  @override
  String get settingsLocalNetwork => 'Op het lokale netwerk';

  @override
  String get settingsServerNote =>
      'Om de Jellyfin-adressen te wijzigen, log je uit en open je \"Serveradres\" op het inlogscherm.';

  @override
  String get settingsExtrasServer => 'Extra-server';

  @override
  String get settingsExtrasNotConfigured =>
      'Niet ingesteld (chat, Jam, Blend, mixes en Terugblik blijven verborgen)';

  @override
  String get settingsConfigure => 'Instellen';

  @override
  String get settingsChange => 'Wijzigen';

  @override
  String get settingsSectionPlayback => 'Afspelen';

  @override
  String get settingsQualityWifi => 'Kwaliteit via wifi';

  @override
  String get settingsQualityWifiSubtitle =>
      'Origineel speelt het bestand af zoals het in de bibliotheek staat.';

  @override
  String get settingsQualityMobile => 'Kwaliteit via mobiele data';

  @override
  String get settingsQualityMobileSubtitle =>
      'Een lagere kwaliteit gebruikt minder mobiele data.';

  @override
  String get settingsQualityOriginal => 'Origineel';

  @override
  String get settingsAppliesNextSong => 'Geldt vanaf het volgende nummer';

  @override
  String get settingsSectionAbout => 'Over';

  @override
  String settingsBuild(int build) {
    return 'Build $build';
  }

  @override
  String get settingsExtrasEmptyHint =>
      'Laat leeg om extra’s uit te schakelen.';

  @override
  String get settingsAutoplay => 'Autoplay';

  @override
  String get settingsAutoplaySubtitle =>
      'Als de wachtrij op is, gaat het afspelen door met vergelijkbare nummers (Jellyfin-mix).';

  @override
  String get settingsNormalize => 'Volume normaliseren';

  @override
  String get settingsNormalizeSubtitle =>
      'Speelt alle nummers op hetzelfde volume af, op basis van de analyse van Jellyfin.';

  @override
  String get settingsScrobble => 'Scrobblen';

  @override
  String get settingsLoading => 'Laden…';

  @override
  String get settingsLastfmNoKey =>
      'De extra-server heeft nog geen Last.fm API-sleutel ingesteld.';

  @override
  String settingsConnectedAs(String name) {
    return 'Verbonden als $name';
  }

  @override
  String get settingsLastfmConnectedSubtitle =>
      'Alles wat je op Pudim beluistert, gaat naar je Last.fm-profiel.';

  @override
  String get settingsDisconnect => 'Verbinding verbreken';

  @override
  String get settingsLastfmAuthorize => 'Autoriseren op de Last.fm-pagina';

  @override
  String get settingsLastfmAuthorizeSubtitle =>
      'Klik daar op \"Yes, allow access\", kom terug en tik op Klaar.';

  @override
  String get settingsFinish => 'Klaar';

  @override
  String get settingsLastfmConnected => 'Last.fm verbonden';

  @override
  String get settingsLastfmScrobbleSubtitle =>
      'Registreert elk nummer dat je beluistert op je Last.fm.';

  @override
  String get settingsConnect => 'Verbinden';

  @override
  String get sidebarOpenLibrary => 'Jouw bibliotheek openen';

  @override
  String get sidebarCollapseLibrary => 'Jouw bibliotheek invouwen';

  @override
  String sidebarOnDeviceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nummers',
      one: '1 nummer',
    );
    return 'Op apparaat • $_temp0';
  }

  @override
  String sidebarPlaylistCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nummers',
      one: '1 nummer',
    );
    return 'Afspeellijst • $_temp0';
  }

  @override
  String sidebarAlbumBy(String artist) {
    return 'Album • $artist';
  }

  @override
  String get sidebarSearchLibrary => 'Zoeken in Jouw bibliotheek';

  @override
  String get sidebarSortBy => 'Sorteren op';

  @override
  String get sidebarSortRecents => 'Recent';

  @override
  String get sidebarSortAdded => 'Recent toegevoegd';

  @override
  String get sidebarSortAlpha => 'Alfabetisch';

  @override
  String get sidebarSortCreator => 'Maker';

  @override
  String get topBarSearchHint => 'Wat wil je afspelen?';

  @override
  String get topBarClearSearch => 'Zoekveld wissen';

  @override
  String get topBarBrowse => 'Bladeren';

  @override
  String get topBarMenu => 'Menu';

  @override
  String get topBarLogoutAccount => 'Uitloggen';

  @override
  String get topBarQuit => 'Pudim afsluiten';

  @override
  String get topBarLogout => 'Uitloggen';

  @override
  String get playerBarSmartShuffleOff => 'Smart Shuffle uitschakelen';

  @override
  String get playerBarSmartShuffleOn => 'Smart Shuffle inschakelen';

  @override
  String get playerBarShuffleOff => 'Willekeurig afspelen uitschakelen';

  @override
  String get playerBarShuffleOn => 'Willekeurig afspelen inschakelen';

  @override
  String get playerBarPlay => 'Afspelen';

  @override
  String get playerBarForward => 'Volgende';

  @override
  String get playerBarRepeatOn => 'Herhalen inschakelen';

  @override
  String get playerBarRepeatOne => 'Eén nummer herhalen';

  @override
  String get playerBarRepeatOff => 'Herhalen uitschakelen';

  @override
  String get playerBarNowPlayingView => 'Weergave Nu aan het spelen';

  @override
  String get playerBarLyrics => 'Songtekst';

  @override
  String get playerBarUnmute => 'Geluid aan';

  @override
  String get playerBarMute => 'Geluid uit';

  @override
  String get rightPanelNothingPlaying =>
      'Speel iets af om hier te zien wat er speelt.';

  @override
  String get rightPanelLyricsPreview => 'Voorbeeld van songtekst';

  @override
  String get rightPanelAboutArtist => 'Over de artiest';

  @override
  String get rightPanelNextUp => 'Hierna';

  @override
  String get rightPanelOpenQueue => 'Wachtrij openen';

  @override
  String get rightPanelQueueEmptyTitle => 'Toevoegen aan wachtrij';

  @override
  String get rightPanelQueueEmptyHint =>
      'Klik in het menu van een nummer op \"Toevoegen aan wachtrij\" om het hier te zetten';

  @override
  String get rightPanelNowPlaying => 'Nu aan het spelen';

  @override
  String get rightPanelNextInQueue => 'Volgende in wachtrij';

  @override
  String rightPanelNextFrom(String name) {
    return 'Hierna uit: $name';
  }

  @override
  String get nowPlayingPlayingFrom => 'AFSPELEN VANUIT';

  @override
  String get nowPlayingMoreOptions => 'Meer opties';

  @override
  String get chatChats => 'Chats';

  @override
  String chatYouSaid(String text) {
    return 'Jij: $text';
  }

  @override
  String get chatContacts => 'Contacten';

  @override
  String get chatServerUnreachable => 'Kan de extra-server niet bereiken.';

  @override
  String get chatMessageHint => 'Bericht';

  @override
  String chatJoinedJam(String title) {
    return 'Je bent lid geworden van $title';
  }

  @override
  String chatCouldNotPlay(String error) {
    return 'Afspelen mislukt: $error';
  }

  @override
  String get chatJamCardSubtitle => 'Samen luisteren, dezelfde wachtrij';

  @override
  String get chatInJam => 'In de Jam';

  @override
  String get chatJoin => 'Deelnemen';

  @override
  String get chatNoOtherAccounts => 'Geen andere accounts op de server.';

  @override
  String chatSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nummers',
      one: '1 nummer',
    );
    return '$_temp0';
  }

  @override
  String chatSentTo(String name) {
    return 'Verzonden naar $name';
  }

  @override
  String chatShareTitle(String title) {
    return '$title delen';
  }

  @override
  String get chatNoteHint => 'Notitie (optioneel)';

  @override
  String get blendWorking => 'Blend maken…';

  @override
  String blendAffinityButton(int affinity) {
    return 'Blend $affinity%';
  }

  @override
  String get blendCreate => 'Blend maken';

  @override
  String blendWith(String name) {
    return 'Blend met $name';
  }

  @override
  String get blendExplain =>
      'Eén afspeellijst voor jullie allebei, met wat jullie allebei beluisteren, de artiesten die jullie gemeen hebben en een beetje van wat jullie elk het mooiste vinden. Je ziet hoe goed jullie smaak overeenkomt en de lijst wordt elke dag bijgewerkt.';

  @override
  String get blendNotNow => 'Niet nu';

  @override
  String blendAffinityTitle(int affinity) {
    return 'Jullie hebben $affinity% overeenkomst';
  }

  @override
  String blendInCommon(String artists) {
    return 'Gemeenschappelijk: $artists';
  }

  @override
  String blendOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Blend openen ($count nummers)',
      one: 'Blend openen (1 nummer)',
    );
    return '$_temp0';
  }

  @override
  String get blendRefreshNow => 'Nu vernieuwen';

  @override
  String get blendUndo => 'Blend verwijderen';

  @override
  String get blendRefreshing => 'Blend vernieuwen…';

  @override
  String get blendUndoTitle => 'Blend verwijderen?';

  @override
  String blendUndoBody(String name) {
    return 'De afspeellijst verdwijnt voor jou en $name.';
  }

  @override
  String get blendUndoConfirm => 'Verwijderen';

  @override
  String get blendUndone => 'Blend verwijderd';

  @override
  String get jamStart => 'Een Jam starten';

  @override
  String jamTooltip(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jam ($count personen)',
      one: 'Jam (1 persoon)',
    );
    return '$_temp0';
  }

  @override
  String get jamSubIdle =>
      'Luister samen met andere accounts, met dezelfde wachtrij.';

  @override
  String get jamSubHost => 'Jij bent de baas. Iedereen kan nummers aanvragen.';

  @override
  String get jamSubGuest =>
      'Jouw bediening en nummers gaan naar ieders wachtrij.';

  @override
  String get jamPlayFirst => 'Speel iets af voordat je de Jam start.';

  @override
  String jamMembers(int count) {
    return 'In de Jam ($count)';
  }

  @override
  String jamYouSuffix(String name) {
    return '$name (jij)';
  }

  @override
  String get jamHost => 'Host';

  @override
  String get jamInvite => 'Uitnodigen';

  @override
  String get jamInviteTitle => 'Uitnodigen voor de Jam';

  @override
  String get jamInviteSubtitle => 'De uitnodiging komt aan in hun chat.';

  @override
  String jamInviteSent(String name) {
    return 'Uitnodiging verzonden naar $name';
  }

  @override
  String get jamEnd => 'De Jam beëindigen';

  @override
  String get jamLeave => 'De Jam verlaten';

  @override
  String recapTitle(int year) {
    return 'Jouw Wrapped $year';
  }

  @override
  String get recapShort => 'Wrapped';

  @override
  String recapBannerBody(String minutes) {
    return '$minutes minuten muziek dit jaar. Bekijk wat je het vaakst hebt afgespeeld.';
  }

  @override
  String get recapEmpty =>
      'Er zijn nog geen afspeelacties om je Wrapped mee te maken.';

  @override
  String get recapShareCards => 'Kaarten delen';

  @override
  String get recapBigMinutes => 'minuten geluisterd';

  @override
  String get recapBigSongs => 'verschillende nummers';

  @override
  String get recapBigArtists => 'artiesten';

  @override
  String get recapBigDays => 'dagen met muziek';

  @override
  String get recapBigStreak => 'dagen op rij, jouw record';

  @override
  String get recapTopArtists => 'Je topartiesten van het jaar';

  @override
  String recapMinutesValue(String minutes) {
    return '$minutes minuten';
  }

  @override
  String get recapTopSongs => 'Je topnummers van het jaar';

  @override
  String recapPlaysLine(String artist, String plays) {
    return '$artist • $plays keer afgespeeld';
  }

  @override
  String get recapSongGone => 'Dit nummer staat niet meer in de bibliotheek';

  @override
  String get recapTopAlbums => 'Je topalbums van het jaar';

  @override
  String get recapTopGenres => 'Je meest beluisterde genres';

  @override
  String recapGenreLine(String genre, String minutes) {
    return '$genre • $minutes min';
  }

  @override
  String get recapMonthly => 'Maand voor maand';

  @override
  String recapMonthTooltip(String month, String minutes) {
    return '$month: $minutes min';
  }

  @override
  String get recapListeningStyle => 'Hoe je luistert';

  @override
  String recapFavHour(String hour) {
    return 'Favoriet uur: $hour:00';
  }

  @override
  String recapFavWeekday(String day) {
    return 'Favoriete dag van de week: $day';
  }

  @override
  String recapBiggestDay(String date, String minutes) {
    return 'Je grootste dag: $date, $minutes minuten';
  }

  @override
  String recapNewArtists(int count, String n) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$n nieuwe artiesten voor jou',
      one: '$n nieuwe artiest voor jou',
    );
    return '$_temp0';
  }

  @override
  String recapSpotifyAdded(String added) {
    return '$added Spotify-afspeelacties toegevoegd.';
  }

  @override
  String recapSpotifyAddedDup(String added, String dup) {
    return '$added Spotify-afspeelacties toegevoegd ($dup stonden er al via Pudim in).';
  }

  @override
  String get recapSpotifyRemoveTitle => 'Je Spotify-geschiedenis verwijderen?';

  @override
  String get recapSpotifyRemoveBody =>
      'Je Wrapped telt weer alleen wat je op Pudim/Jellyfin hebt afgespeeld. Je kunt het later opnieuw importeren.';

  @override
  String get recapSpotifyRemoveConfirm => 'Verwijderen';

  @override
  String recapSpotifyRemoved(String count) {
    return '$count Spotify-afspeelacties verwijderd';
  }

  @override
  String get recapSpotifyTitle => 'Spotify-geschiedenis';

  @override
  String recapSpotifyHasData(String count, String from, String to) {
    return '$count Spotify-afspeelacties in je Wrapped ($from tot $to). Je kunt een nieuwer bestand uploaden: wat er al in zit, wordt niet dubbel geteld.';
  }

  @override
  String get recapSpotifyIntro =>
      'Haal de jaren van vóór Pudim erbij. Ga in Spotify naar Account > Privacy > Download je gegevens en kies \"Uitgebreide streaminggeschiedenis\". Als de e-mail binnenkomt, kies je hier my_spotify_data.zip.';

  @override
  String get recapSpotifyImportAnother => 'Nog een bestand importeren';

  @override
  String get recapSpotifyImport => 'Geschiedenis importeren';

  @override
  String get recapSpotifyRemoveBtn => 'Verwijderen uit Wrapped';

  @override
  String get recapShareSaveDialog => 'Kaart opslaan';

  @override
  String get recapShareSaved => 'Kaart opgeslagen';

  @override
  String recapShareSaveFailed(String error) {
    return 'Opslaan mislukt: $error';
  }

  @override
  String recapShareShareFailed(String error) {
    return 'Delen mislukt: $error';
  }

  @override
  String recapShareText(int year) {
    return 'Mijn Wrapped $year op Pudim';
  }

  @override
  String get recapShareMyArtists => 'Mijn topartiesten van het jaar';

  @override
  String get recapShareMySongs => 'Mijn topnummers van het jaar';

  @override
  String recapMinShort(String minutes) {
    return '$minutes min';
  }

  @override
  String get recapShareSaveImage => 'Afbeelding opslaan';

  @override
  String get recapShareButton => 'Delen';

  @override
  String recapBrand(int year) {
    return 'Wrapped $year';
  }

  @override
  String get recapShareMyYear => 'Mijn jaar in muziek';

  @override
  String recapShareYearOf(String name) {
    return 'Het jaar in muziek van $name';
  }

  @override
  String get recapShareTopArtist => 'mijn topartiest van het jaar';

  @override
  String recapShareGenres(String genres) {
    return 'Genres: $genres';
  }

  @override
  String get widgetActionsAddedToLiked =>
      'Toegevoegd aan Leuk gevonden nummers';

  @override
  String get widgetActionsRemovedFromLiked =>
      'Verwijderd uit Leuk gevonden nummers';

  @override
  String get widgetActionsUnfollowed => 'Niet meer gevolgd';

  @override
  String get widgetActionsSavedToLibrary => 'Opgeslagen in Jouw bibliotheek';

  @override
  String get widgetActionsRemovedFromLibrary =>
      'Verwijderd uit Jouw bibliotheek';

  @override
  String get widgetActionsAddToQueue => 'Toevoegen aan wachtrij';

  @override
  String get widgetActionsAddedToQueue => 'Toegevoegd aan wachtrij';

  @override
  String get widgetActionsPlayNext => 'Hierna afspelen';

  @override
  String get widgetActionsGoToPodcast => 'Naar podcast';

  @override
  String get widgetActionsRemoveFromQueue => 'Verwijderen uit wachtrij';

  @override
  String get widgetActionsAddToPlaylist => 'Toevoegen aan afspeellijst';

  @override
  String get widgetActionsRemoveFromThisPlaylist =>
      'Verwijderen uit deze afspeellijst';

  @override
  String get widgetActionsInviteToEdit => 'Uitnodigen om te bewerken';

  @override
  String get widgetActionsKeepInPlaylist => 'Houden in afspeellijst';

  @override
  String get widgetActionsDownloadTrack => 'Nummer downloaden';

  @override
  String get widgetActionsDownloadAlbum => 'Album downloaden';

  @override
  String get widgetActionsDownloadDiscography => 'Discografie downloaden';

  @override
  String get widgetActionsSearchAlbums => 'Albums zoeken';

  @override
  String widgetActionsImproveQuality(int count) {
    return 'Kwaliteit verbeteren ($count)';
  }

  @override
  String widgetActionsImprovingAlbums(int count) {
    return 'Betere versies zoeken van $count albums';
  }

  @override
  String get widgetActionsShare => 'Delen';

  @override
  String get widgetActionsSearchFlac => 'Zoeken in FLAC';

  @override
  String widgetActionsSearchingFlac(String name) {
    return '$name zoeken in FLAC; als het gevonden wordt, vervangt het de MP3';
  }

  @override
  String get widgetActionsTrackRemovedFromDevice => 'Verwijderd van apparaat';

  @override
  String get widgetActionsRemovedFromDevice => 'Verwijderd van apparaat';

  @override
  String get widgetActionsDownloadingToDevice =>
      'Downloaden naar je apparaat om offline te luisteren';

  @override
  String get widgetActionsUnfollow => 'Niet meer volgen';

  @override
  String get widgetActionsRemoveFromLibrary =>
      'Verwijderen uit Jouw bibliotheek';

  @override
  String get widgetActionsAddToLibrary => 'Toevoegen aan Jouw bibliotheek';

  @override
  String get widgetActionsGoToSongRadio => 'Naar nummerradio';

  @override
  String get widgetActionsStartMix => 'Mix starten';

  @override
  String widgetActionsMixOf(String name) {
    return '$name-mix';
  }

  @override
  String get widgetActionsGoToArtist => 'Naar artiest';

  @override
  String get widgetActionsGoToAlbum => 'Naar album';

  @override
  String get widgetActionsCopyName => 'Naam kopiëren';

  @override
  String get widgetActionsCopied => 'Gekopieerd';

  @override
  String widgetDownloadsBellDownloading(int count) {
    return '$count aan het downloaden';
  }

  @override
  String get widgetDownloadsBellEmpty =>
      'Nog niets hier. Speel een nummer met een wolkpictogram af of gebruik \"Downloaden\" in het ⋯-menu om het uit de catalogus naar je bibliotheek te halen.';

  @override
  String get widgetDownloadsBellKindDiscography => 'Discografie';

  @override
  String get widgetDownloadsBellKindFlac => 'In FLAC';

  @override
  String get widgetDownloadsBellKindQuality => 'Kwaliteit';

  @override
  String get widgetDownloadsBellOptions => 'Opties';

  @override
  String get widgetDownloadsBellCancelled => 'Download geannuleerd';

  @override
  String get widgetDownloadsBellRetrying => 'Opnieuw proberen';

  @override
  String get widgetDownloadsBellRemovedFromList => 'Verwijderd uit lijst';

  @override
  String get widgetDownloadsBellDetails => 'Details bekijken';

  @override
  String get widgetDownloadsBellRemoveFromList => 'Verwijderen uit lijst';

  @override
  String get widgetMixSearchingReleases => 'Nieuwe releases zoeken…';

  @override
  String get widgetMixBuildingDaylist => 'Je daylist maken…';

  @override
  String get widgetMixNewDiscoveriesTitle => 'Nieuwe Wekelijkse Descobertas?';

  @override
  String get widgetMixNewMixTitle => 'Nieuwe Wekelijkse Mix?';

  @override
  String get widgetMixNewDiscoveriesBody =>
      'Nummers die je nog niet hebt beluisterd verdwijnen uit de afspeellijst en er komen ongeveer 30 nieuwe voor in de plaats. Dit gebeurt al vanzelf elke maandag.';

  @override
  String get widgetMixNewMixBody =>
      'Maakt hem opnieuw met je favorieten, wat je het meest beluistert en vergelijkbare nummers. Dit gebeurt al vanzelf elke maandag.';

  @override
  String get widgetMixNotNow => 'Niet nu';

  @override
  String get widgetMixBuildingDiscoveries => 'Je Descobertas maken…';

  @override
  String get widgetMixBuildingMix => 'Je Mix maken…';

  @override
  String widgetMixBuiltOn(String date) {
    return 'Gemaakt op $date';
  }

  @override
  String get widgetMixRedo => 'Opnieuw maken';

  @override
  String get widgetMixRefresh => 'Vernieuwen';

  @override
  String get widgetMixCreateDiscoveries => 'Maak je Wekelijkse Descobertas';

  @override
  String get widgetMixCreateMix => 'Maak je Wekelijkse Mix';

  @override
  String get widgetMixCreateRadar => 'Maak je Nieuwe Releases-radar';

  @override
  String get widgetMixCreateDaylist => 'Maak je daylist';

  @override
  String get widgetOfflineBanner =>
      'Geen internet · je ziet wat op je apparaat is opgeslagen';

  @override
  String widgetOfflineDownloadingProgress(int done, int total) {
    return 'Downloaden: $done van $total';
  }

  @override
  String get widgetUpdateReady => 'Nieuwe versie van Pudim beschikbaar';

  @override
  String widgetUpdateReadyNotes(String notes) {
    return 'Nieuwe versie van Pudim · $notes';
  }

  @override
  String get widgetUpdateAction => 'Bijwerken';

  @override
  String widgetSleepShortMinutes(int count) {
    return '$count min';
  }

  @override
  String widgetSleepShortSeconds(int count) {
    return '$count s';
  }

  @override
  String get widgetSleepStopsAtEnd => 'Stopt aan het einde van het nummer';

  @override
  String widgetSleepStopsIn(String time) {
    return 'Stopt over $time';
  }

  @override
  String get widgetSleepTimer => 'Slaaptimer';

  @override
  String get widgetSleepTurnOff => 'Timer uitschakelen';

  @override
  String get widgetSleepOneHour => '1 uur';

  @override
  String get widgetSleepOneAndHalfHours => '1 uur 30 minuten';

  @override
  String get widgetSleepEndOfSong => 'Einde van het nummer';

  @override
  String get widgetSleepTurnedOff => 'Timer uitgeschakeld';

  @override
  String get widgetSleepStopsWhenSongEnds =>
      'De muziek stopt als dit nummer afgelopen is';

  @override
  String widgetSleepSongStopsIn(String time) {
    return 'De muziek stopt over $time';
  }

  @override
  String get widgetSpeedPodcast => 'Podcastsnelheid';

  @override
  String get widgetCommonCatalogBadge =>
      'Uit de catalogus: nog niet in je bibliotheek';

  @override
  String get widgetCommonShowAll => 'Alles tonen';

  @override
  String get widgetCommonSomethingWentWrong => 'Er is iets misgegaan';

  @override
  String get widgetCommonListenDownloaded => 'Gedownloade nummers beluisteren';

  @override
  String get widgetTracksTitle => 'Titel';

  @override
  String get widgetTracksDateAdded => 'Datum toegevoegd';

  @override
  String widgetTracksAddedBy(String name) {
    return 'door $name';
  }

  @override
  String get widgetTracksMoreOptions => 'Meer opties';

  @override
  String widgetTracksAddedDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get castTooltip => 'Casten';

  @override
  String get castTitle => 'Afspelen op';

  @override
  String get castThisDevice => 'Dit apparaat';

  @override
  String get castSearching => 'Zoeken naar apparaten in het netwerk…';

  @override
  String get castNone =>
      'Geen Chromecast gevonden. Hij moet op hetzelfde wifi-netwerk zitten.';

  @override
  String get castSearchAgain => 'Opnieuw zoeken';

  @override
  String get castStop => 'Stoppen met casten';

  @override
  String castPlayingOn(String name) {
    return 'Speelt op $name';
  }

  @override
  String castFailed(String name) {
    return 'Kan geen verbinding maken met $name';
  }

  @override
  String get settingsSectionAppearance => 'Weergave';

  @override
  String get settingsTheme => 'Thema';

  @override
  String get settingsThemeSubtitle => 'Wijzigt de kleuren meteen.';

  @override
  String get themeNightDesc =>
      'Standaard. Geïnspireerd op de stijl van Spotify: zwart en groen.';

  @override
  String get themeRedDesc =>
      'Geïnspireerd op YouTube Music: bijna zwart en rood.';

  @override
  String get themeWaveDesc => 'Geïnspireerd op Deezer: donkerviolet en paars.';

  @override
  String get themeRetroDesc =>
      'Geïnspireerd op Winamp: grijze panelen uit de jaren 2000, groen display en niveaubalken.';

  @override
  String get themeClassicDesc =>
      'Geïnspireerd op Windows Media Player: zwart en blauw met glans.';
}
