// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class L10nDe extends L10n {
  L10nDe([String locale = 'de']) : super(locale);

  @override
  String get languageTitle => 'Sprache';

  @override
  String get languageSubtitle => 'Sprache der Oberfläche';

  @override
  String get languageSystem => 'Systemstandard';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonClose => 'Schließen';

  @override
  String get commonBack => 'Zurück';

  @override
  String get commonSave => 'Speichern';

  @override
  String get commonEdit => 'Bearbeiten';

  @override
  String get commonDelete => 'Löschen';

  @override
  String get commonRemove => 'Entfernen';

  @override
  String get commonOk => 'OK';

  @override
  String get commonRetry => 'Erneut versuchen';

  @override
  String get commonQueue => 'Warteschlange';

  @override
  String get commonAlbum => 'Album';

  @override
  String get commonAlbums => 'Alben';

  @override
  String get commonArtist => 'Künstler:in';

  @override
  String get commonArtists => 'Künstler:innen';

  @override
  String get commonSong => 'Song';

  @override
  String get commonSongs => 'Songs';

  @override
  String get commonPlaylist => 'Playlist';

  @override
  String get commonPlaylists => 'Playlists';

  @override
  String get commonSingle => 'Single';

  @override
  String get commonLikedSongs => 'Lieblingssongs';

  @override
  String get commonAddToLiked => 'Zu Lieblingssongs hinzufügen';

  @override
  String get commonRemoveFromLiked => 'Aus Lieblingssongs entfernen';

  @override
  String get commonShufflePlay => 'Zufallswiedergabe';

  @override
  String get commonPlay => 'Abspielen';

  @override
  String get commonPause => 'Pause';

  @override
  String get commonFollow => 'Folgen';

  @override
  String get commonFollowing => 'Gefolgt';

  @override
  String get commonDownloadToDevice => 'Auf Gerät herunterladen';

  @override
  String get commonRemoveFromDevice => 'Vom Gerät entfernen';

  @override
  String get commonDownloaded => 'Heruntergeladen';

  @override
  String get commonDownloads => 'Downloads';

  @override
  String get commonAll => 'Alle';

  @override
  String get commonRecentlyPlayed => 'Zuletzt gespielt';

  @override
  String get commonYourLibrary => 'Deine Bibliothek';

  @override
  String get commonHome => 'Start';

  @override
  String get commonSearch => 'Suche';

  @override
  String get commonProfile => 'Profil';

  @override
  String get commonSettings => 'Einstellungen';

  @override
  String get commonBuilding => 'Wird erstellt …';

  @override
  String get commonBuildNow => 'Jetzt erstellen';

  @override
  String get commonShows => 'Konzerte';

  @override
  String get commonPodcasts => 'Podcasts';

  @override
  String commonSongCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Songs',
      one: '1 Song',
      zero: 'Keine Songs',
    );
    return '$_temp0';
  }

  @override
  String commonMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Minuten',
      one: '1 Minute',
    );
    return '$_temp0';
  }

  @override
  String commonError(String error) {
    return 'Fehler: $error';
  }

  @override
  String get apiStatusQueued => 'In der Warteschlange';

  @override
  String get apiStatusDownloading => 'Wird heruntergeladen';

  @override
  String get apiStatusDone => 'Zur Bibliothek hinzugefügt';

  @override
  String get apiStatusUpToDate => 'Bereits in der Bibliothek';

  @override
  String get apiStatusPartial => 'Teilweise hinzugefügt';

  @override
  String get apiStatusNotFound => 'Nicht gefunden';

  @override
  String get apiStatusCancelled => 'Abgebrochen';

  @override
  String get apiStatusInterrupted => 'Unterbrochen';

  @override
  String get apiStatusFailed => 'Fehlgeschlagen';

  @override
  String get apiExtrasNoResponse => 'Der Extras-Server hat nicht geantwortet.';

  @override
  String get apiAlbumListFailed =>
      'Die Alben konnten nicht aufgelistet werden.';

  @override
  String apiPlaylistSaved(int found, int total) {
    return 'Playlist in Deiner Bibliothek ($found von $total Songs)';
  }

  @override
  String apiPlaylistDownloading(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weitere Songs werden heruntergeladen',
      one: '1 weiterer Song wird heruntergeladen',
    );
    return 'Playlist in Deiner Bibliothek; $_temp0';
  }

  @override
  String get apiBadCredentials => 'Benutzername oder Passwort falsch.';

  @override
  String get apiServerUnreachable => 'Server nicht erreichbar.';

  @override
  String get apiQuickConnectOff =>
      'Quick Connect ist auf diesem Server deaktiviert.';

  @override
  String get apiWrongCurrentPassword => 'Das aktuelle Passwort ist falsch.';

  @override
  String stateChatShared(String title) {
    return '$title geteilt';
  }

  @override
  String stateDownloadingName(String name) {
    return '$name wird heruntergeladen';
  }

  @override
  String stateDownloadingRequests(int count) {
    return '$count Anfragen werden heruntergeladen';
  }

  @override
  String stateDownloadArrived(String name) {
    return '$name wurde zur Bibliothek hinzugefügt';
  }

  @override
  String stateDownloadPartial(String name) {
    return '$name wurde teilweise hinzugefügt';
  }

  @override
  String stateDownloadEnded(String name, String status) {
    return '$name: $status';
  }

  @override
  String get stateNotFromCatalog =>
      'Dieser Eintrag stammt nicht aus dem Katalog.';

  @override
  String stateAlreadyDownloading(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Das Album wird bereits heruntergeladen.',
      'artist': 'Die Diskografie wird bereits heruntergeladen.',
      'other': 'Der Song wird bereits heruntergeladen.',
    });
    return '$_temp0';
  }

  @override
  String stateDownloadRequested(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Das Album wird heruntergeladen. Du siehst es in der Glocke, sobald es da ist.',
      'artist': 'Die Diskografie wird heruntergeladen. Du siehst sie in der Glocke, sobald sie da ist.',
      'other': 'Der Song wird heruntergeladen. Du siehst ihn in der Glocke, sobald er da ist.',
    });
    return '$_temp0';
  }

  @override
  String get stateNotifyDownloadsChannel => 'Downloads';

  @override
  String get stateNotifyDownloadsChannelDesc =>
      'Fortschritt der Song-Downloads';

  @override
  String get stateNotifyNewsChannel => 'Neuigkeiten';

  @override
  String get stateNotifyNewsChannelDesc =>
      'Neuzugänge, Veröffentlichungen, Descobertas und Mistura';

  @override
  String get stateOfflineLoose => 'Einzeln heruntergeladen';

  @override
  String get stateOfflineDoneTitle => 'Auf dieses Gerät heruntergeladen';

  @override
  String stateOfflineDoneBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Songs für die Offline-Wiedergabe bereit',
      one: '1 Song für die Offline-Wiedergabe bereit',
    );
    return '$_temp0';
  }

  @override
  String get stateOfflineProgressTitle =>
      'Wird auf dieses Gerät heruntergeladen';

  @override
  String stateOfflineProgressBody(int done, int total, String name) {
    return '$done von $total • $name';
  }

  @override
  String get stateServerNoReply =>
      'Der Server hat nicht geantwortet. Prüfe die Adresse.';

  @override
  String get stateServerNoReplyBoth =>
      'Der Server hat unter keiner der beiden Adressen geantwortet.';

  @override
  String get stateTokenStoreUnsupported =>
      'Pudim kann deine Anmeldung vorerst nur unter Windows und Android speichern.';

  @override
  String get stateQualityPoor => 'niedrige Qualität';

  @override
  String get stateQualityPartial => 'unvollständig';

  @override
  String get audioPlaybackChannel => 'Wiedergabe';

  @override
  String get audioRecentAlbums => 'Zuletzt gespielte Alben';

  @override
  String audioSearchContext(String query) {
    return 'Suche: $query';
  }

  @override
  String audioRadioContext(String name) {
    return '$name Radio';
  }

  @override
  String podcastsMonthShort(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': 'Jan.',
      'm2': 'Feb.',
      'm3': 'März',
      'm4': 'Apr.',
      'm5': 'Mai',
      'm6': 'Juni',
      'm7': 'Juli',
      'm8': 'Aug.',
      'm9': 'Sep.',
      'm10': 'Okt.',
      'm11': 'Nov.',
      'other': 'Dez.',
    });
    return '$_temp0';
  }

  @override
  String podcastsDateThisYear(int day, String month) {
    return '$day. $month';
  }

  @override
  String podcastsDateOtherYear(int day, String month, int year) {
    return '$day. $month $year';
  }

  @override
  String podcastsHoursMin(int h, int min) {
    return '$h Std. $min Min.';
  }

  @override
  String podcastsMin(int min) {
    return '$min Min.';
  }

  @override
  String get podcastsPlayed => 'gehört';

  @override
  String podcastsTimeLeft(String time) {
    return 'noch $time';
  }

  @override
  String get podcastsSearchHint => 'Podcasts suchen';

  @override
  String get podcastsNothingFound => 'Nichts gefunden.';

  @override
  String get podcastsYours => 'Deine Podcasts';

  @override
  String get podcastsNewEpisodes => 'Neue Folgen';

  @override
  String get podcastsTrendingBrazil => 'Angesagt in Brasilien';

  @override
  String get podcastsLoadFailed => 'Laden fehlgeschlagen. Versuch es erneut';

  @override
  String get podcastsNoEpisodes => 'Keine Folgen im Feed.';

  @override
  String podcastsNoEpisodeMatch(String q) {
    return 'Keine Folgen zu „$q“.';
  }

  @override
  String get podcastsKind => 'Podcast';

  @override
  String get podcastsEpisodes => 'Folgen';

  @override
  String podcastsEpisodesCount(int total) {
    return 'Folgen ($total)';
  }

  @override
  String get podcastsFindEpisode => 'Folgen suchen';

  @override
  String showsMonthName(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': 'Januar',
      'm2': 'Februar',
      'm3': 'März',
      'm4': 'April',
      'm5': 'Mai',
      'm6': 'Juni',
      'm7': 'Juli',
      'm8': 'August',
      'm9': 'September',
      'm10': 'Oktober',
      'm11': 'November',
      'other': 'Dezember',
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
      'w1': 'Mo',
      'w2': 'Di',
      'w3': 'Mi',
      'w4': 'Do',
      'w5': 'Fr',
      'w6': 'Sa',
      'other': 'So',
    });
    return '$_temp0';
  }

  @override
  String get showsFollowingNone => 'Von Künstler:innen, denen du folgst';

  @override
  String showsFollowingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Von $count Künstler:innen, denen du folgst',
      one: 'Von 1 Künstler:in, dem du folgst',
    );
    return '$_temp0';
  }

  @override
  String showsSearchingFor(int count) {
    return 'suche Konzerte von $count …';
  }

  @override
  String get showsUpcoming => 'Demnächst';

  @override
  String get showsPast => 'Vergangen';

  @override
  String get showsInBrazil => 'In Brasilien';

  @override
  String get showsEmptyFollow =>
      'Folge Künstler:innen (Button „Folgen“ auf der Künstlerseite), um hier ihre Konzerte zu sehen.';

  @override
  String get showsNonePast => 'Noch keine Konzerte erfasst.';

  @override
  String get showsNoneUpcoming => 'Aktuell keine Konzerte geplant.';

  @override
  String get showsStillSearching => 'Suche läuft noch …';

  @override
  String get showsSource =>
      'Termine von MusicBrainz (von Fans gepflegt); neue Konzerte brauchen eventuell etwas, bis sie erscheinen.';

  @override
  String get showsCancelled => 'abgesagt';

  @override
  String get showsFestival => 'Festival';

  @override
  String get catalogKindAlbum => 'Album';

  @override
  String get catalogKindSingle => 'Single';

  @override
  String get catalogKindBroadcast => 'Sendung';

  @override
  String get catalogKindOther => 'Sonstiges';

  @override
  String get catalogSecLive => 'Live';

  @override
  String get catalogSecCompilation => 'Compilation';

  @override
  String get catalogSecSoundtrack => 'Soundtrack';

  @override
  String get catalogSecMixtape => 'Mixtape';

  @override
  String get catalogSecInterview => 'Interview';

  @override
  String get catalogSecSpokenword => 'Spoken Word';

  @override
  String catalogDownloadingOne(String title) {
    return '$title wird heruntergeladen';
  }

  @override
  String catalogDownloadingMany(int count, String artist) {
    return '$count Alben von $artist werden heruntergeladen';
  }

  @override
  String catalogCheckingDiscography(int seconds) {
    return 'Diskografie wird geprüft … $seconds s';
  }

  @override
  String catalogToDownload(int count) {
    return '$count zum Herunterladen';
  }

  @override
  String catalogInLibraryCount(int count) {
    return '$count bereits in der Bibliothek';
  }

  @override
  String catalogSkippedOneSong(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Releases mit nur einem Song ausgelassen',
      one: '1 Release mit nur einem Song ausgelassen',
    );
    return '$_temp0';
  }

  @override
  String get catalogPickAll => 'Alle';

  @override
  String get catalogPickStudio => 'Studio';

  @override
  String get catalogPickNone => 'Keine';

  @override
  String get catalogDownloadSelected => 'Auswahl herunterladen';

  @override
  String catalogDownloadNSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Auswahlen herunterladen',
      one: '1 Auswahl herunterladen',
    );
    return '$_temp0';
  }

  @override
  String get catalogNothingMissing => 'Es fehlt nichts.';

  @override
  String get catalogPartial => 'teilweise';

  @override
  String get catalogDownload => 'Herunterladen';

  @override
  String get catalogAddToLibrary => 'Zu Deiner Bibliothek hinzufügen';

  @override
  String get catalogInYourLibrary => 'In Deiner Bibliothek';

  @override
  String get catalogAllInLibrary => 'alle in der Bibliothek';

  @override
  String catalogNInLibrary(int count) {
    return '$count in der Bibliothek';
  }

  @override
  String get catalogDownloadAlbum => 'Album herunterladen';

  @override
  String get catalogArtistNotFound => 'Künstler:in nicht gefunden.';

  @override
  String get catalogFromCatalog =>
      'Aus dem Katalog: noch nicht in der Bibliothek';

  @override
  String get catalogDownloadAll => 'Alle herunterladen';

  @override
  String get catalogDownloadDiscography => 'Diskografie herunterladen';

  @override
  String get catalogPopular => 'Beliebt';

  @override
  String get catalogShowLess => 'Weniger anzeigen';

  @override
  String get catalogShowMore => 'Mehr anzeigen';

  @override
  String get catalogSinglesEps => 'Singles und EPs';

  @override
  String get catalogFansAlsoLike => 'Fans mögen auch';

  @override
  String get lyricsPlaySomething => 'Spiel etwas ab, um den Songtext zu sehen.';

  @override
  String get lyricsNone => 'Kein Songtext für diesen Song';

  @override
  String get lyricsNoneHint =>
      'Liegt neben der Datei eine .lrc- oder .txt-Datei, erscheint sie hier.';

  @override
  String get lyricsFind => 'Songtext suchen';

  @override
  String get lyricsFinding => 'Songtext wird gesucht…';

  @override
  String get lyricsNotFound => 'Kein Songtext für diesen Titel gefunden';

  @override
  String get lyricsSynced => 'Synchronisierter Songtext aus der .lrc-Datei';

  @override
  String get lyricsUnsynced => 'Nicht synchronisierter Songtext';

  @override
  String get profileChangePhoto => 'Foto ändern';

  @override
  String get profileNoPhoto => 'Kein Foto ausgewählt';

  @override
  String get profilePhotoTooBig => 'Foto zu groß (bis 8 MB)';

  @override
  String get profilePhotoChanged => 'Profilfoto geändert';

  @override
  String get profilePhotoRemoved => 'Foto entfernt';

  @override
  String get profileNameSaved => 'Profilname gespeichert';

  @override
  String get profileRenameTitle => 'Benutzernamen ändern?';

  @override
  String profileRenameBody(String name) {
    return 'Du meldest dich in Pudim, Jellyfin und den anderen Apps (Finamp, Feishin …) künftig als „$name“ an. Deine Descobertas, Mixe und dein Rückblick bleiben erhalten.';
  }

  @override
  String get profileRenameConfirm => 'Ändern';

  @override
  String profileNowSignedAs(String name) {
    return 'Du meldest dich jetzt als $name an';
  }

  @override
  String get profileEnterNewPassword => 'Gib das neue Passwort ein';

  @override
  String get profilePasswordsDiffer =>
      'Die neuen Passwörter stimmen nicht überein';

  @override
  String get profilePasswordChanged => 'Passwort geändert';

  @override
  String get profileExtrasUnreachable =>
      'Extras-Server nicht erreichbar; Profilname und Benutzername müssen warten.';

  @override
  String get profileNameSection => 'Profilname';

  @override
  String get profileNameHelp => 'So sehen dich deine Kontakte in Chats.';

  @override
  String get profileYourName => 'Dein Name';

  @override
  String get profileUsernameSection => 'Benutzername';

  @override
  String get profileUsernameHelp =>
      'Der Name, mit dem du dich bei Jellyfin anmeldest (hier und in anderen Apps).';

  @override
  String get profileUsernameHint => 'Benutzername';

  @override
  String get profileChangeUsername => 'Benutzernamen ändern';

  @override
  String get profilePasswordSection => 'Passwort';

  @override
  String get profileCurrentPassword => 'Aktuelles Passwort';

  @override
  String get profileNewPassword => 'Neues Passwort';

  @override
  String get profileRepeatPassword => 'Neues Passwort wiederholen';

  @override
  String get profileChangePassword => 'Passwort ändern';

  @override
  String get loginServerRequired =>
      'Gib die Adresse deines Jellyfin-Servers ein.';

  @override
  String get loginUserRequired => 'Gib deinen Benutzernamen ein.';

  @override
  String get loginTitle => 'Bei Pudim anmelden';

  @override
  String get loginSubtitle => 'Nutze dein Jellyfin-Konto.';

  @override
  String get loginUsername => 'Benutzername';

  @override
  String get loginPassword => 'Passwort';

  @override
  String get loginShowPassword => 'Passwort anzeigen';

  @override
  String get loginHidePassword => 'Passwort verbergen';

  @override
  String get loginSubmit => 'Anmelden';

  @override
  String get loginQuickConnect => 'Mit Quick Connect anmelden';

  @override
  String get loginHideAddresses => 'Adressen ausblenden';

  @override
  String get loginServerAddress => 'Serveradresse';

  @override
  String get loginJellyfinServer => 'Jellyfin-Server';

  @override
  String get loginJellyfinServerExample => 'Z. B. https://jellyfin.exemplo.com';

  @override
  String get loginLocalNetwork => 'Im lokalen Netzwerk (optional)';

  @override
  String get loginLocalNetworkExample =>
      'Z. B. http://192.168.0.10:8096. Antwortet sie, nutzt die App sie statt der Hauptadresse.';

  @override
  String get loginExtrasServer => 'Extras-Server (optional)';

  @override
  String get loginExtrasServerHint =>
      'Aktiviert Chat, Jam, Blend, Mixe und Rückblick. Leer lassen, wenn du keinen hast.';

  @override
  String get loginQcExpired => 'Der Code ist abgelaufen. Versuch es erneut.';

  @override
  String get loginQcInstructions =>
      'Öffne auf einem Gerät, auf dem du bereits bei Jellyfin angemeldet bist, dein Profil, tippe auf Quick Connect und gib diesen Code ein:';

  @override
  String get loginQcWaiting => 'Warte auf Bestätigung …';

  @override
  String get homeDownloadedOnDevice => 'Auf diesem Gerät heruntergeladen';

  @override
  String get homeTabMusic => 'Musik';

  @override
  String get homeMadeFor => 'Zusammengestellt für';

  @override
  String get homeMixDiscoveries => 'Jede Woche neue Musik für dich';

  @override
  String get homeMixWeekly => 'Deine Favoriten und ähnliche Songs, jede Woche';

  @override
  String get homeMixRadar =>
      'Neuheiten von Künstler:innen, denen du folgst, jeden Freitag';

  @override
  String get homeMixDaylist => 'Verändert sich im Lauf des Tages';

  @override
  String get homeMixBlend => 'Euer beider Geschmack zusammen';

  @override
  String get homeMixAuto => 'Automatischer Mix';

  @override
  String get homeSpotifyPlaylists => 'Deine Spotify-Playlists';

  @override
  String get homeFromSpotify => 'Von Spotify';

  @override
  String get homeYourPlaylists => 'Deine Playlists';

  @override
  String get homeTopAlbums => 'Deine meistgespielten Alben';

  @override
  String get homeTopArtists => 'Deine Lieblingskünstler:innen';

  @override
  String get homeRecentlyAdded => 'Zuletzt hinzugefügt';

  @override
  String get homeYourPodcasts => 'Deine Podcasts';

  @override
  String get homeRadiosTitle => 'Empfohlene Radios';

  @override
  String get homeRadiosSubtitle =>
      'Nonstop-Musik basierend auf deinen Lieblingskünstler:innen.';

  @override
  String get homeRadioBadge => 'RADIO';

  @override
  String homeRadioWith(String name) {
    return 'Mit $name und ähnlichen Künstler:innen';
  }

  @override
  String searchNoResults(String query) {
    return 'Keine Ergebnisse für „$query“';
  }

  @override
  String get searchNoResultsHint =>
      'Prüfe die Schreibweise oder nutze weniger oder andere Wörter.';

  @override
  String searchCatalogNoResponse(String error) {
    return 'Der Katalog hat nicht geantwortet: $error';
  }

  @override
  String get searchAlsoCatalog => 'Durchsuche auch den Katalog …';

  @override
  String searchLibraryOnly(String error) {
    return 'Nur Bibliothek: Der Katalog hat nicht geantwortet ($error).';
  }

  @override
  String get searchTopResult => 'Top-Ergebnis';

  @override
  String get searchSpotifyPlaylists => 'Spotify-Playlists';

  @override
  String get searchRecent => 'Letzte Suchen';

  @override
  String get searchClear => 'Löschen';

  @override
  String get searchBrowseAll => 'Alle durchstöbern';

  @override
  String get searchHint => 'Was möchtest du hören?';

  @override
  String get albumDownloadedType => 'Album • auf diesem Gerät heruntergeladen';

  @override
  String albumSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Songs',
      one: '1 Song',
    );
    return '$_temp0, $total';
  }

  @override
  String get albumRemoveFromLibrary => 'Aus Deiner Bibliothek entfernen';

  @override
  String get albumSaveToLibrary => 'In Deiner Bibliothek speichern';

  @override
  String albumMoreOptions(String name) {
    return 'Weitere Optionen für $name';
  }

  @override
  String albumDisc(int number) {
    return 'Disc $number';
  }

  @override
  String albumMoreFrom(String name) {
    return 'Mehr von $name';
  }

  @override
  String artistAlbumsInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Alben in deiner Bibliothek',
      one: '1 Album in deiner Bibliothek',
    );
    return '$_temp0';
  }

  @override
  String artistPlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Wiedergaben',
      one: '1 Wiedergabe',
    );
    return '$_temp0';
  }

  @override
  String artistMoreOptions(String name) {
    return 'Weitere Optionen für $name';
  }

  @override
  String get artistPopular => 'Beliebt';

  @override
  String get artistShowLess => 'Weniger anzeigen';

  @override
  String get artistShowMore => 'Mehr anzeigen';

  @override
  String get artistYouLiked => 'Dir gefällt';

  @override
  String artistFrom(String name) {
    return 'Von $name';
  }

  @override
  String get artistDiscography => 'Diskografie';

  @override
  String get artistPopularReleases => 'Beliebte Veröffentlichungen';

  @override
  String get artistSinglesEps => 'Singles und EPs';

  @override
  String get artistFansAlsoLike => 'Fans mögen auch';

  @override
  String get artistAppearsOn => 'Erscheint auf';

  @override
  String get artistAbout => 'Info';

  @override
  String get playlistOriginSpotify => 'Von Spotify';

  @override
  String get playlistOriginMadeForYou => 'Für dich gemacht';

  @override
  String get playlistOriginAuto => 'Automatischer Mix';

  @override
  String get playlistDownloadedOnDevice => 'Auf diesem Gerät heruntergeladen';

  @override
  String get playlistOnDevice => 'Auf diesem Gerät';

  @override
  String get playlistPlaysOffline => 'Spielt ohne Internet.';

  @override
  String playlistPlaysOfflineDownloading(int count) {
    return 'Spielt ohne Internet. $count weitere werden heruntergeladen …';
  }

  @override
  String playlistSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Songs',
      one: '1 Song',
    );
    return '$_temp0, $total';
  }

  @override
  String playlistMoreOptions(String name) {
    return 'Weitere Optionen für $name';
  }

  @override
  String get playlistSearchHint => 'In Playlist suchen';

  @override
  String get playlistEmpty => 'Noch keine Songs hier.';

  @override
  String get playlistErrNoPermission =>
      'Du darfst diese Playlist nicht bearbeiten.';

  @override
  String playlistErrServer(String code) {
    return 'Der Server hat die Anfrage abgelehnt ($code).';
  }

  @override
  String get playlistErrNoResponse => 'keine Antwort';

  @override
  String get playlistDownloadFirst =>
      'Lade den Song zuerst herunter, um ihn zu einer Playlist hinzuzufügen';

  @override
  String get playlistAddTo => 'Zu Playlist hinzufügen';

  @override
  String get playlistNew => 'Neue Playlist';

  @override
  String playlistAddedTo(String name) {
    return 'Zu $name hinzugefügt';
  }

  @override
  String get playlistNameHint => 'Name der Playlist';

  @override
  String get playlistCreate => 'Erstellen';

  @override
  String playlistCreated(String name) {
    return 'Playlist $name erstellt';
  }

  @override
  String get playlistRemoved => 'Aus Playlist entfernt';

  @override
  String get playlistInviteTitle => 'Zum Bearbeiten einladen';

  @override
  String get playlistInviteSubtitle =>
      'Die Playlist erscheint in ihrer Bibliothek und sie können Songs hinzufügen und entfernen.';

  @override
  String get playlistInviteOwnerOnly =>
      'Nur der oder die Ersteller:in kann einladen';

  @override
  String playlistInvited(String who, String playlist) {
    return '$who kann jetzt $playlist bearbeiten';
  }

  @override
  String playlistCollaborative(String members) {
    return 'Kollaborativ · $members';
  }

  @override
  String get playlistSmartShuffleTooltip =>
      'Smart Shuffle: Zufallswiedergabe mit Empfehlungen';

  @override
  String get playlistSmartShuffleOn =>
      'Smart Shuffle an: Empfehlungen sind mit ✦ markiert';

  @override
  String get playlistAddedToThis => 'Zur Playlist hinzugefügt';

  @override
  String get playlistRecommendation => 'Smart-Shuffle-Empfehlung';

  @override
  String get playlistPutIn => 'Zu Playlist hinzufügen';

  @override
  String get settingsSectionAccount => 'Konto';

  @override
  String get settingsProfileSubtitle => 'Name, Benutzername und Passwort';

  @override
  String settingsConnectedAt(String url) {
    return 'Verbunden mit $url';
  }

  @override
  String get settingsSignOut => 'Abmelden';

  @override
  String get accountsTitle => 'Konten';

  @override
  String get accountsAdd => 'Konto oder Server hinzufügen';

  @override
  String get accountsSwitch => 'Wechseln';

  @override
  String get accountsInUse => 'Aktiv';

  @override
  String accountsOn(String user, String host) {
    return '$user auf $host';
  }

  @override
  String get loginBackToAccount => 'Zurück zum aktuellen Konto';

  @override
  String get settingsSectionServer => 'Server';

  @override
  String get settingsLocalNetwork => 'Im lokalen Netzwerk';

  @override
  String get settingsServerNote =>
      'Um die Jellyfin-Adressen zu ändern, melde dich ab und öffne auf dem Anmeldebildschirm „Serveradresse“.';

  @override
  String get settingsExtrasServer => 'Extras-Server';

  @override
  String get settingsExtrasNotConfigured =>
      'Nicht eingerichtet (Chat, Jam, Blend, Mixe und Rückblick bleiben ausgeblendet)';

  @override
  String get settingsConfigure => 'Einrichten';

  @override
  String get settingsChange => 'Ändern';

  @override
  String get settingsSectionPlayback => 'Wiedergabe';

  @override
  String get settingsQualityWifi => 'WLAN-Qualität';

  @override
  String get settingsQualityWifiSubtitle =>
      'Original spielt die Datei so ab, wie sie in der Bibliothek liegt.';

  @override
  String get settingsQualityMobile => 'Qualität bei mobilen Daten';

  @override
  String get settingsQualityMobileSubtitle =>
      'Niedrigere Qualität verbraucht weniger mobile Daten.';

  @override
  String get settingsQualityOriginal => 'Original';

  @override
  String get settingsAppliesNextSong => 'Gilt ab dem nächsten Song';

  @override
  String get settingsSectionAbout => 'Info';

  @override
  String settingsBuild(int build) {
    return 'Build $build';
  }

  @override
  String get settingsExtrasEmptyHint =>
      'Leer lassen, um Extras zu deaktivieren.';

  @override
  String get settingsAutoplay => 'Autoplay';

  @override
  String get settingsAutoplaySubtitle =>
      'Spielt nach dem Ende der Warteschlange ähnliche Songs weiter (Jellyfin-Mix).';

  @override
  String get settingsNormalize => 'Lautstärke normalisieren';

  @override
  String get settingsNormalizeSubtitle =>
      'Spielt alle Songs gleich laut ab, basierend auf der Analyse von Jellyfin.';

  @override
  String get settingsScrobble => 'Scrobbeln';

  @override
  String get settingsLoading => 'Wird geladen …';

  @override
  String get settingsLastfmNoKey =>
      'Auf dem Extras-Server ist noch kein Last.fm-API-Schlüssel eingerichtet.';

  @override
  String settingsConnectedAs(String name) {
    return 'Verbunden als $name';
  }

  @override
  String get settingsLastfmConnectedSubtitle =>
      'Alles, was du in Pudim hörst, landet in deinem Last.fm-Profil.';

  @override
  String get settingsDisconnect => 'Trennen';

  @override
  String get settingsLastfmAuthorize => 'Auf der Last.fm-Seite autorisieren';

  @override
  String get settingsLastfmAuthorizeSubtitle =>
      'Klicke dort auf „Ja, Zugriff erlauben“, komm dann zurück und tippe auf Fertig.';

  @override
  String get settingsFinish => 'Fertig';

  @override
  String get settingsLastfmConnected => 'Last.fm verbunden';

  @override
  String get settingsLastfmScrobbleSubtitle =>
      'Protokolliert jeden Song, den du hörst, in deinem Last.fm.';

  @override
  String get settingsConnect => 'Verbinden';

  @override
  String get sidebarOpenLibrary => 'Deine Bibliothek öffnen';

  @override
  String get sidebarCollapseLibrary => 'Deine Bibliothek einklappen';

  @override
  String sidebarOnDeviceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Songs',
      one: '1 Song',
    );
    return 'Auf dem Gerät • $_temp0';
  }

  @override
  String sidebarPlaylistCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Songs',
      one: '1 Song',
    );
    return 'Playlist • $_temp0';
  }

  @override
  String sidebarAlbumBy(String artist) {
    return 'Album • $artist';
  }

  @override
  String get sidebarSearchLibrary => 'In Deiner Bibliothek suchen';

  @override
  String get sidebarSortBy => 'Sortieren nach';

  @override
  String get sidebarSortRecents => 'Zuletzt gehört';

  @override
  String get sidebarSortAdded => 'Zuletzt hinzugefügt';

  @override
  String get sidebarSortAlpha => 'Alphabetisch';

  @override
  String get sidebarSortCreator => 'Ersteller:in';

  @override
  String get topBarSearchHint => 'Was möchtest du abspielen?';

  @override
  String get topBarClearSearch => 'Suchfeld leeren';

  @override
  String get topBarBrowse => 'Entdecken';

  @override
  String get topBarMenu => 'Menü';

  @override
  String get topBarLogoutAccount => 'Abmelden';

  @override
  String get topBarQuit => 'Pudim beenden';

  @override
  String get topBarLogout => 'Abmelden';

  @override
  String get playerBarSmartShuffleOff => 'Smart Shuffle deaktivieren';

  @override
  String get playerBarSmartShuffleOn => 'Smart Shuffle aktivieren';

  @override
  String get playerBarShuffleOff => 'Zufallswiedergabe deaktivieren';

  @override
  String get playerBarShuffleOn => 'Zufallswiedergabe aktivieren';

  @override
  String get playerBarPlay => 'Abspielen';

  @override
  String get playerBarForward => 'Weiter';

  @override
  String get playerBarRepeatOn => 'Wiederholen aktivieren';

  @override
  String get playerBarRepeatOne => 'Einzelnen Song wiederholen';

  @override
  String get playerBarRepeatOff => 'Wiederholen deaktivieren';

  @override
  String get playerBarNowPlayingView => 'Ansicht „Aktuelle Wiedergabe“';

  @override
  String get playerBarLyrics => 'Songtext';

  @override
  String get playerBarUnmute => 'Ton einschalten';

  @override
  String get playerBarMute => 'Stummschalten';

  @override
  String get rightPanelNothingPlaying =>
      'Spiel etwas ab, um hier die aktuelle Wiedergabe zu sehen.';

  @override
  String get rightPanelLyricsPreview => 'Songtext-Vorschau';

  @override
  String get rightPanelAboutArtist => 'Über den/die Künstler:in';

  @override
  String get rightPanelNextUp => 'Als Nächstes';

  @override
  String get rightPanelOpenQueue => 'Warteschlange öffnen';

  @override
  String get rightPanelQueueEmptyTitle => 'Zur Warteschlange hinzufügen';

  @override
  String get rightPanelQueueEmptyHint =>
      'Wähle im Menü eines Titels „Zur Warteschlange hinzufügen“, um ihn hier einzureihen';

  @override
  String get rightPanelNowPlaying => 'Aktuelle Wiedergabe';

  @override
  String get rightPanelNextInQueue => 'Als Nächstes in der Warteschlange';

  @override
  String rightPanelNextFrom(String name) {
    return 'Als Nächstes aus: $name';
  }

  @override
  String get nowPlayingPlayingFrom => 'WIEDERGABE VON';

  @override
  String get nowPlayingMoreOptions => 'Weitere Optionen';

  @override
  String get chatChats => 'Chats';

  @override
  String chatYouSaid(String text) {
    return 'Du: $text';
  }

  @override
  String get chatContacts => 'Kontakte';

  @override
  String get chatServerUnreachable => 'Extras-Server nicht erreichbar.';

  @override
  String get chatMessageHint => 'Nachricht';

  @override
  String chatJoinedJam(String title) {
    return 'Du bist $title beigetreten';
  }

  @override
  String chatCouldNotPlay(String error) {
    return 'Wiedergabe nicht möglich: $error';
  }

  @override
  String get chatJamCardSubtitle => 'Gemeinsam hören, dieselbe Warteschlange';

  @override
  String get chatInJam => 'Im Jam';

  @override
  String get chatJoin => 'Beitreten';

  @override
  String get chatNoOtherAccounts => 'Keine weiteren Konten auf dem Server.';

  @override
  String chatSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Songs',
      one: '1 Song',
    );
    return '$_temp0';
  }

  @override
  String chatSentTo(String name) {
    return 'An $name gesendet';
  }

  @override
  String chatShareTitle(String title) {
    return '$title teilen';
  }

  @override
  String get chatNoteHint => 'Notiz (optional)';

  @override
  String get blendWorking => 'Blend wird erstellt …';

  @override
  String blendAffinityButton(int affinity) {
    return 'Blend $affinity %';
  }

  @override
  String get blendCreate => 'Blend erstellen';

  @override
  String blendWith(String name) {
    return 'Blend mit $name';
  }

  @override
  String get blendExplain =>
      'Eine Playlist für euch beide, mit dem, was ihr beide hört, den gemeinsamen Künstler:innen und einem Teil dessen, was jede:r von euch am meisten liebt. Sie zeigt, wie gut euer Geschmack zusammenpasst, und wird jeden Tag aktualisiert.';

  @override
  String get blendNotNow => 'Nicht jetzt';

  @override
  String blendAffinityTitle(int affinity) {
    return 'Ihr passt zu $affinity % zusammen';
  }

  @override
  String blendInCommon(String artists) {
    return 'Gemeinsam: $artists';
  }

  @override
  String blendOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Blend öffnen ($count Songs)',
      one: 'Blend öffnen (1 Song)',
    );
    return '$_temp0';
  }

  @override
  String get blendRefreshNow => 'Jetzt aktualisieren';

  @override
  String get blendUndo => 'Blend entfernen';

  @override
  String get blendRefreshing => 'Blend wird aktualisiert …';

  @override
  String get blendUndoTitle => 'Blend entfernen?';

  @override
  String blendUndoBody(String name) {
    return 'Die Playlist verschwindet für dich und $name.';
  }

  @override
  String get blendUndoConfirm => 'Entfernen';

  @override
  String get blendUndone => 'Blend entfernt';

  @override
  String get jamStart => 'Jam starten';

  @override
  String jamTooltip(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jam ($count Personen)',
      one: 'Jam (1 Person)',
    );
    return '$_temp0';
  }

  @override
  String get jamSubIdle =>
      'Hört gemeinsam mit anderen Konten, mit derselben Warteschlange.';

  @override
  String get jamSubHost =>
      'Du hast die Kontrolle. Alle können Songs vorschlagen.';

  @override
  String get jamSubGuest =>
      'Deine Steuerung und deine Songs gehen in die Warteschlange aller.';

  @override
  String get jamPlayFirst => 'Spiel etwas ab, bevor du den Jam startest.';

  @override
  String jamMembers(int count) {
    return 'Im Jam ($count)';
  }

  @override
  String jamYouSuffix(String name) {
    return '$name (du)';
  }

  @override
  String get jamHost => 'Host';

  @override
  String get jamInvite => 'Einladen';

  @override
  String get jamInviteTitle => 'Zum Jam einladen';

  @override
  String get jamInviteSubtitle => 'Die Einladung landet in ihrem Chat.';

  @override
  String jamInviteSent(String name) {
    return 'Einladung an $name gesendet';
  }

  @override
  String get jamEnd => 'Jam beenden';

  @override
  String get jamLeave => 'Jam verlassen';

  @override
  String recapTitle(int year) {
    return 'Dein Wrapped $year';
  }

  @override
  String get recapShort => 'Wrapped';

  @override
  String recapBannerBody(String minutes) {
    return '$minutes Minuten Musik in diesem Jahr. Sieh dir an, was du am meisten gehört hast.';
  }

  @override
  String get recapEmpty => 'Es gibt noch keine Wiedergaben für dein Wrapped.';

  @override
  String get recapShareCards => 'Karten teilen';

  @override
  String get recapBigMinutes => 'Minuten gehört';

  @override
  String get recapBigSongs => 'verschiedene Songs';

  @override
  String get recapBigArtists => 'Künstler:innen';

  @override
  String get recapBigDays => 'Tage mit Musik';

  @override
  String get recapBigStreak => 'Tage in Folge, dein Rekord';

  @override
  String get recapTopArtists => 'Deine Top-Künstler:innen des Jahres';

  @override
  String recapMinutesValue(String minutes) {
    return '$minutes Minuten';
  }

  @override
  String get recapTopSongs => 'Deine Top-Songs des Jahres';

  @override
  String recapPlaysLine(String artist, String plays) {
    return '$artist • $plays Wiedergaben';
  }

  @override
  String get recapSongGone => 'Dieser Song ist nicht mehr in der Bibliothek';

  @override
  String get recapTopAlbums => 'Deine Top-Alben des Jahres';

  @override
  String get recapTopGenres => 'Deine meistgespielten Genres';

  @override
  String recapGenreLine(String genre, String minutes) {
    return '$genre • $minutes Min.';
  }

  @override
  String get recapMonthly => 'Monat für Monat';

  @override
  String recapMonthTooltip(String month, String minutes) {
    return '$month: $minutes Min.';
  }

  @override
  String get recapListeningStyle => 'Wie du hörst';

  @override
  String recapFavHour(String hour) {
    return 'Lieblingsuhrzeit: $hour:00';
  }

  @override
  String recapFavWeekday(String day) {
    return 'Lieblingstag der Woche: $day';
  }

  @override
  String recapBiggestDay(String date, String minutes) {
    return 'Dein größter Tag: $date, $minutes Minuten';
  }

  @override
  String recapNewArtists(int count, String n) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$n neue Künstler:innen für dich',
      one: '$n neue:r Künstler:in für dich',
    );
    return '$_temp0';
  }

  @override
  String recapSpotifyAdded(String added) {
    return '$added Spotify-Wiedergaben wurden hinzugefügt.';
  }

  @override
  String recapSpotifyAddedDup(String added, String dup) {
    return '$added Spotify-Wiedergaben wurden hinzugefügt ($dup waren bereits von Pudim vorhanden).';
  }

  @override
  String get recapSpotifyRemoveTitle => 'Spotify-Verlauf entfernen?';

  @override
  String get recapSpotifyRemoveBody =>
      'Dein Wrapped zählt dann wieder nur, was du in Pudim/Jellyfin gespielt hast. Du kannst ihn später erneut importieren.';

  @override
  String get recapSpotifyRemoveConfirm => 'Entfernen';

  @override
  String recapSpotifyRemoved(String count) {
    return '$count Spotify-Wiedergaben entfernt';
  }

  @override
  String get recapSpotifyTitle => 'Spotify-Verlauf';

  @override
  String recapSpotifyHasData(String count, String from, String to) {
    return '$count Spotify-Wiedergaben in deinem Wrapped ($from bis $to). Du kannst eine neuere Datei hochladen: Was schon drin ist, wird nicht doppelt gezählt.';
  }

  @override
  String get recapSpotifyIntro =>
      'Hol die Jahre vor Pudim dazu. Gehe in Spotify auf Konto > Datenschutz > Deine Daten herunterladen und wähle „Erweiterter Streaming-Verlauf“. Wenn die E-Mail ankommt, wähle hier my_spotify_data.zip aus.';

  @override
  String get recapSpotifyImportAnother => 'Weitere Datei importieren';

  @override
  String get recapSpotifyImport => 'Verlauf importieren';

  @override
  String get recapSpotifyRemoveBtn => 'Aus Wrapped entfernen';

  @override
  String get recapShareSaveDialog => 'Karte speichern';

  @override
  String get recapShareSaved => 'Karte gespeichert';

  @override
  String recapShareSaveFailed(String error) {
    return 'Speichern nicht möglich: $error';
  }

  @override
  String recapShareShareFailed(String error) {
    return 'Teilen nicht möglich: $error';
  }

  @override
  String recapShareText(int year) {
    return 'Mein Wrapped $year auf Pudim';
  }

  @override
  String get recapShareMyArtists => 'Meine Top-Künstler:innen des Jahres';

  @override
  String get recapShareMySongs => 'Meine Top-Songs des Jahres';

  @override
  String recapMinShort(String minutes) {
    return '$minutes Min.';
  }

  @override
  String get recapShareSaveImage => 'Bild speichern';

  @override
  String get recapShareButton => 'Teilen';

  @override
  String recapBrand(int year) {
    return 'Wrapped $year';
  }

  @override
  String get recapShareMyYear => 'Mein Jahr in Musik';

  @override
  String recapShareYearOf(String name) {
    return 'Das Musikjahr von $name';
  }

  @override
  String get recapShareTopArtist => 'mein:e Top-Künstler:in des Jahres';

  @override
  String recapShareGenres(String genres) {
    return 'Genres: $genres';
  }

  @override
  String get widgetActionsAddedToLiked => 'Zu Lieblingssongs hinzugefügt';

  @override
  String get widgetActionsRemovedFromLiked => 'Aus Lieblingssongs entfernt';

  @override
  String get widgetActionsUnfollowed => 'Nicht mehr gefolgt';

  @override
  String get widgetActionsSavedToLibrary => 'In Deiner Bibliothek gespeichert';

  @override
  String get widgetActionsRemovedFromLibrary =>
      'Aus Deiner Bibliothek entfernt';

  @override
  String get widgetActionsAddToQueue => 'Zur Warteschlange hinzufügen';

  @override
  String get widgetActionsAddedToQueue => 'Zur Warteschlange hinzugefügt';

  @override
  String get widgetActionsPlayNext => 'Als Nächstes spielen';

  @override
  String get widgetActionsGoToPodcast => 'Zum Podcast';

  @override
  String get widgetActionsRemoveFromQueue => 'Aus Warteschlange entfernen';

  @override
  String get widgetActionsAddToPlaylist => 'Zu Playlist hinzufügen';

  @override
  String get widgetActionsRemoveFromThisPlaylist =>
      'Aus dieser Playlist entfernen';

  @override
  String get widgetActionsInviteToEdit => 'Zum Bearbeiten einladen';

  @override
  String get widgetActionsKeepInPlaylist => 'In Playlist behalten';

  @override
  String get widgetActionsDownloadTrack => 'Song herunterladen';

  @override
  String get widgetActionsDownloadAlbum => 'Album herunterladen';

  @override
  String get widgetActionsDownloadDiscography => 'Diskografie herunterladen';

  @override
  String get widgetActionsSearchAlbums => 'Alben suchen';

  @override
  String widgetActionsImproveQuality(int count) {
    return 'Qualität verbessern ($count)';
  }

  @override
  String widgetActionsImprovingAlbums(int count) {
    return 'Suche bessere Versionen von $count Alben';
  }

  @override
  String get widgetActionsShare => 'Teilen';

  @override
  String get widgetActionsSearchFlac => 'In FLAC suchen';

  @override
  String widgetActionsSearchingFlac(String name) {
    return 'Suche $name in FLAC; wenn gefunden, ersetzt es die MP3';
  }

  @override
  String get widgetActionsTrackRemovedFromDevice => 'Vom Gerät entfernt';

  @override
  String get widgetActionsRemovedFromDevice => 'Vom Gerät entfernt';

  @override
  String get widgetActionsDownloadingToDevice =>
      'Wird für die Offline-Wiedergabe auf dein Gerät heruntergeladen';

  @override
  String get widgetActionsUnfollow => 'Nicht mehr folgen';

  @override
  String get widgetActionsRemoveFromLibrary =>
      'Aus Deiner Bibliothek entfernen';

  @override
  String get widgetActionsAddToLibrary => 'Zu Deiner Bibliothek hinzufügen';

  @override
  String get widgetActionsGoToSongRadio => 'Zum Song-Radio';

  @override
  String get widgetActionsStartMix => 'Mix starten';

  @override
  String widgetActionsMixOf(String name) {
    return '$name Mix';
  }

  @override
  String get widgetActionsGoToArtist => 'Zum/zur Künstler:in';

  @override
  String get widgetActionsGoToAlbum => 'Zum Album';

  @override
  String get widgetActionsCopyName => 'Name kopieren';

  @override
  String get widgetActionsCopied => 'Kopiert';

  @override
  String widgetDownloadsBellDownloading(int count) {
    return '$count werden heruntergeladen';
  }

  @override
  String get widgetDownloadsBellEmpty =>
      'Noch nichts hier. Spiel einen Song mit Wolkensymbol ab oder nutze „Herunterladen“ im ⋯-Menü, um ihn aus dem Katalog in deine Bibliothek zu holen.';

  @override
  String get widgetDownloadsBellKindDiscography => 'Diskografie';

  @override
  String get widgetDownloadsBellKindFlac => 'In FLAC';

  @override
  String get widgetDownloadsBellKindQuality => 'Qualität';

  @override
  String get widgetDownloadsBellOptions => 'Optionen';

  @override
  String get widgetDownloadsBellCancelled => 'Download abgebrochen';

  @override
  String get widgetDownloadsBellRetrying => 'Neuer Versuch';

  @override
  String get widgetDownloadsBellRemovedFromList => 'Aus Liste entfernt';

  @override
  String get widgetDownloadsBellDetails => 'Details ansehen';

  @override
  String get widgetDownloadsBellRemoveFromList => 'Aus Liste entfernen';

  @override
  String get widgetMixSearchingReleases => 'Suche nach Neuheiten …';

  @override
  String get widgetMixBuildingDaylist => 'Deine Daylist wird erstellt …';

  @override
  String get widgetMixNewDiscoveriesTitle => 'Neue Wöchentliche Descobertas?';

  @override
  String get widgetMixNewMixTitle => 'Neuer Wöchentlicher Mix?';

  @override
  String get widgetMixNewDiscoveriesBody =>
      'Songs, die du noch nicht gehört hast, verlassen die Playlist und etwa 30 neue kommen dazu. Das passiert ohnehin jeden Montag automatisch.';

  @override
  String get widgetMixNewMixBody =>
      'Erstellt ihn neu mit deinen Favoriten, deinen meistgehörten und ähnlichen Songs. Das passiert ohnehin jeden Montag automatisch.';

  @override
  String get widgetMixNotNow => 'Nicht jetzt';

  @override
  String get widgetMixBuildingDiscoveries =>
      'Deine Descobertas werden erstellt …';

  @override
  String get widgetMixBuildingMix => 'Dein Mix wird erstellt …';

  @override
  String widgetMixBuiltOn(String date) {
    return 'Erstellt am $date';
  }

  @override
  String get widgetMixRedo => 'Neu erstellen';

  @override
  String get widgetMixRefresh => 'Aktualisieren';

  @override
  String get widgetMixCreateDiscoveries => 'Wöchentliche Descobertas erstellen';

  @override
  String get widgetMixCreateMix => 'Wöchentlichen Mix erstellen';

  @override
  String get widgetMixCreateRadar => 'Neuheiten-Radar erstellen';

  @override
  String get widgetMixCreateDaylist => 'Daylist erstellen';

  @override
  String get widgetOfflineBanner =>
      'Kein Internet · zeigt, was auf deinem Gerät gespeichert ist';

  @override
  String widgetOfflineDownloadingProgress(int done, int total) {
    return '$done von $total werden heruntergeladen';
  }

  @override
  String get widgetUpdateReady => 'Neue Version von Pudim bereit';

  @override
  String widgetUpdateReadyNotes(String notes) {
    return 'Neue Version von Pudim · $notes';
  }

  @override
  String get widgetUpdateAction => 'Aktualisieren';

  @override
  String widgetSleepShortMinutes(int count) {
    return '$count Min.';
  }

  @override
  String widgetSleepShortSeconds(int count) {
    return '$count Sek.';
  }

  @override
  String get widgetSleepStopsAtEnd => 'Stoppt am Ende des Songs';

  @override
  String widgetSleepStopsIn(String time) {
    return 'Stoppt in $time';
  }

  @override
  String get widgetSleepTimer => 'Schlaftimer';

  @override
  String get widgetSleepTurnOff => 'Timer ausschalten';

  @override
  String get widgetSleepOneHour => '1 Stunde';

  @override
  String get widgetSleepOneAndHalfHours => '1 Stunde 30 Minuten';

  @override
  String get widgetSleepEndOfSong => 'Ende des Songs';

  @override
  String get widgetSleepTurnedOff => 'Timer ausgeschaltet';

  @override
  String get widgetSleepStopsWhenSongEnds =>
      'Die Musik stoppt, wenn dieser Song endet';

  @override
  String widgetSleepSongStopsIn(String time) {
    return 'Die Musik stoppt in $time';
  }

  @override
  String get widgetSpeedPodcast => 'Podcast-Tempo';

  @override
  String get widgetCommonCatalogBadge =>
      'Aus dem Katalog: noch nicht in deiner Bibliothek';

  @override
  String get widgetCommonShowAll => 'Alle anzeigen';

  @override
  String get widgetCommonSomethingWentWrong => 'Etwas ist schiefgelaufen';

  @override
  String get widgetCommonListenDownloaded => 'Heruntergeladene Songs hören';

  @override
  String get widgetTracksTitle => 'Titel';

  @override
  String get widgetTracksDateAdded => 'Hinzugefügt am';

  @override
  String widgetTracksAddedBy(String name) {
    return 'von $name';
  }

  @override
  String get widgetTracksMoreOptions => 'Weitere Optionen';

  @override
  String widgetTracksAddedDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get castTooltip => 'Streamen';

  @override
  String get castTitle => 'Abspielen auf';

  @override
  String get castThisDevice => 'Dieses Gerät';

  @override
  String get castSearching => 'Suche nach Geräten im Netzwerk…';

  @override
  String get castNone =>
      'Kein Chromecast gefunden. Er muss im selben WLAN sein.';

  @override
  String get castSearchAgain => 'Erneut suchen';

  @override
  String get castStop => 'Streaming beenden';

  @override
  String castPlayingOn(String name) {
    return 'Läuft auf $name';
  }

  @override
  String castFailed(String name) {
    return 'Verbindung mit $name fehlgeschlagen';
  }

  @override
  String get settingsSectionAppearance => 'Darstellung';

  @override
  String get settingsTheme => 'Design';

  @override
  String get settingsThemeSubtitle => 'Ändert die Farben sofort.';

  @override
  String get themeNightDesc =>
      'Dunkel, abgerundete Karten und schwebender Mini-Player.';

  @override
  String get themeRedDesc =>
      'Reines Schwarz mit Rot, große quadratische Cover, Mini-Player an der Leiste.';

  @override
  String get themeWaveDesc =>
      'Lila Verläufe, kräftige Schrift und Mini-Player als Pille.';

  @override
  String get themeRetroDesc =>
      'Graues Fenster mit 3D-Rand, grünes Display mit Lauftext und Textlisten.';

  @override
  String get themeClassicDesc =>
      'Blau-schwarzes Glas mit Glanz, Kugel-Taste, Visualizer und Tabellenlisten.';

  @override
  String get settingsCheckUpdates => 'Nach Updates suchen';

  @override
  String get updateChecking => 'Wird geprüft…';

  @override
  String updateUpToDate(int build) {
    return 'Du hast die neueste Version (Build $build).';
  }

  @override
  String updateDownloading(int build, int percent) {
    return 'Build $build wird geladen… $percent %';
  }

  @override
  String updateFailed(String error) {
    return 'Prüfung fehlgeschlagen: $error';
  }

  @override
  String get updateUnavailable => 'Kein Extras-Server eingerichtet.';

  @override
  String get settingsHistory => 'Verlauf';

  @override
  String get settingsHistorySubtitle =>
      'Rückblicke früherer Jahre und alles, was du gehört hast';

  @override
  String get historyRecaps => 'Rückblicke';

  @override
  String get historyPlays => 'Wiedergaben';

  @override
  String get historyWholeYear => 'Ganzes Jahr';

  @override
  String get historyLoadMore => 'Mehr laden';

  @override
  String get historyEmpty => 'Noch nichts gehört';

  @override
  String get historyImported => 'importiert';
}
