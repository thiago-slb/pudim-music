// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class L10nPl extends L10n {
  L10nPl([String locale = 'pl']) : super(locale);

  @override
  String get languageTitle => 'Język';

  @override
  String get languageSubtitle => 'Język interfejsu';

  @override
  String get languageSystem => 'Domyślny systemowy';

  @override
  String get commonCancel => 'Anuluj';

  @override
  String get commonClose => 'Zamknij';

  @override
  String get commonBack => 'Wstecz';

  @override
  String get commonSave => 'Zapisz';

  @override
  String get commonEdit => 'Edytuj';

  @override
  String get commonDelete => 'Usuń';

  @override
  String get commonRemove => 'Usuń';

  @override
  String get commonOk => 'OK';

  @override
  String get commonRetry => 'Spróbuj ponownie';

  @override
  String get commonQueue => 'Kolejka';

  @override
  String get commonAlbum => 'Album';

  @override
  String get commonAlbums => 'Albumy';

  @override
  String get commonArtist => 'Wykonawca';

  @override
  String get commonArtists => 'Wykonawcy';

  @override
  String get commonSong => 'Utwór';

  @override
  String get commonSongs => 'Utwory';

  @override
  String get commonPlaylist => 'Playlista';

  @override
  String get commonPlaylists => 'Playlisty';

  @override
  String get commonSingle => 'Singiel';

  @override
  String get commonLikedSongs => 'Polubione utwory';

  @override
  String get commonAddToLiked => 'Dodaj do polubionych utworów';

  @override
  String get commonRemoveFromLiked => 'Usuń z polubionych utworów';

  @override
  String get commonShufflePlay => 'Odtwarzaj losowo';

  @override
  String get commonPlay => 'Odtwórz';

  @override
  String get commonPause => 'Wstrzymaj';

  @override
  String get commonFollow => 'Obserwuj';

  @override
  String get commonFollowing => 'Obserwujesz';

  @override
  String get commonDownloadToDevice => 'Pobierz na urządzenie';

  @override
  String get commonRemoveFromDevice => 'Usuń z urządzenia';

  @override
  String get commonDownloaded => 'Pobrane';

  @override
  String get commonDownloads => 'Pobrane pliki';

  @override
  String get commonAll => 'Wszystko';

  @override
  String get commonRecentlyPlayed => 'Ostatnio odtwarzane';

  @override
  String get commonYourLibrary => 'Twoja biblioteka';

  @override
  String get commonHome => 'Strona główna';

  @override
  String get commonSearch => 'Szukaj';

  @override
  String get commonProfile => 'Profil';

  @override
  String get commonSettings => 'Ustawienia';

  @override
  String get commonBuilding => 'Tworzenie…';

  @override
  String get commonBuildNow => 'Utwórz teraz';

  @override
  String get commonShows => 'Koncerty';

  @override
  String get commonPodcasts => 'Podcasty';

  @override
  String commonSongCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count utworu',
      many: '$count utworów',
      few: '$count utwory',
      one: '1 utwór',
      zero: 'Brak utworów',
    );
    return '$_temp0';
  }

  @override
  String commonMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minuty',
      many: '$count minut',
      few: '$count minuty',
      one: '1 minuta',
    );
    return '$_temp0';
  }

  @override
  String commonError(String error) {
    return 'Błąd: $error';
  }

  @override
  String get apiStatusQueued => 'W kolejce';

  @override
  String get apiStatusDownloading => 'Pobieranie';

  @override
  String get apiStatusDone => 'Dodano do biblioteki';

  @override
  String get apiStatusUpToDate => 'Już w bibliotece';

  @override
  String get apiStatusPartial => 'Dodano częściowo';

  @override
  String get apiStatusNotFound => 'Nie znaleziono';

  @override
  String get apiStatusCancelled => 'Anulowano';

  @override
  String get apiStatusInterrupted => 'Przerwano';

  @override
  String get apiStatusFailed => 'Nie udało się';

  @override
  String get apiExtrasNoResponse => 'Serwer dodatków nie odpowiedział.';

  @override
  String get apiAlbumListFailed => 'Nie udało się wyświetlić albumów.';

  @override
  String apiPlaylistSaved(int found, int total) {
    return 'Playlista w Twojej bibliotece ($found z $total utworów)';
  }

  @override
  String apiPlaylistDownloading(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count utworu',
      many: '$count utworów',
      few: '$count utworów',
      one: '1 utworu',
    );
    return 'Playlista w Twojej bibliotece; pobieranie jeszcze $_temp0';
  }

  @override
  String get apiBadCredentials => 'Nieprawidłowa nazwa użytkownika lub hasło.';

  @override
  String get apiServerUnreachable => 'Nie udało się połączyć z serwerem.';

  @override
  String get apiQuickConnectOff =>
      'Quick Connect jest wyłączony na tym serwerze.';

  @override
  String get apiWrongCurrentPassword => 'Obecne hasło jest nieprawidłowe.';

  @override
  String stateChatShared(String title) {
    return 'Udostępniono: $title';
  }

  @override
  String stateDownloadingName(String name) {
    return 'Pobieranie: $name';
  }

  @override
  String stateDownloadingRequests(int count) {
    return 'Pobieranie próśb: $count';
  }

  @override
  String stateDownloadArrived(String name) {
    return 'Dodano do biblioteki: $name';
  }

  @override
  String stateDownloadPartial(String name) {
    return 'Dodano częściowo: $name';
  }

  @override
  String stateDownloadEnded(String name, String status) {
    return '$name: $status';
  }

  @override
  String get stateNotFromCatalog => 'Ta pozycja nie pochodzi z katalogu.';

  @override
  String stateAlreadyDownloading(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Album jest już pobierany.',
      'artist': 'Dyskografia jest już pobierana.',
      'other': 'Utwór jest już pobierany.',
    });
    return '$_temp0';
  }

  @override
  String stateDownloadRequested(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Pobieranie albumu. Gdy będzie gotowy, pojawi się w dzwonku.',
      'artist':
          'Pobieranie dyskografii. Gdy będzie gotowa, pojawi się w dzwonku.',
      'other': 'Pobieranie utworu. Gdy będzie gotowy, pojawi się w dzwonku.',
    });
    return '$_temp0';
  }

  @override
  String get stateNotifyDownloadsChannel => 'Pobrane pliki';

  @override
  String get stateNotifyDownloadsChannelDesc => 'Postęp pobierania utworów';

  @override
  String get stateNotifyNewsChannel => 'Nowości';

  @override
  String get stateNotifyNewsChannelDesc =>
      'Nowe pozycje, premiery, Descobertas i Mistura';

  @override
  String get stateOfflineLoose => 'Pobrane pojedynczo';

  @override
  String get stateOfflineDoneTitle => 'Pobrano na to urządzenie';

  @override
  String stateOfflineDoneBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count utworu gotowego do słuchania offline',
      many: '$count utworów gotowych do słuchania offline',
      few: '$count utwory gotowe do słuchania offline',
      one: '1 utwór gotowy do słuchania offline',
    );
    return '$_temp0';
  }

  @override
  String get stateOfflineProgressTitle => 'Pobieranie na to urządzenie';

  @override
  String stateOfflineProgressBody(int done, int total, String name) {
    return '$done z $total • $name';
  }

  @override
  String get stateServerNoReply => 'Serwer nie odpowiedział. Sprawdź adres.';

  @override
  String get stateServerNoReplyBoth =>
      'Serwer nie odpowiedział pod żadnym z adresów.';

  @override
  String get stateTokenStoreUnsupported =>
      'Na razie Pudim może zapisać logowanie tylko w systemach Windows i Android.';

  @override
  String get stateQualityPoor => 'niska jakość';

  @override
  String get stateQualityPartial => 'niekompletne';

  @override
  String get audioPlaybackChannel => 'Odtwarzanie';

  @override
  String get audioRecentAlbums => 'Ostatnie albumy';

  @override
  String audioSearchContext(String query) {
    return 'Wyszukiwanie: $query';
  }

  @override
  String audioRadioContext(String name) {
    return 'Radio: $name';
  }

  @override
  String podcastsMonthShort(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': 'sty',
      'm2': 'lut',
      'm3': 'mar',
      'm4': 'kwi',
      'm5': 'maj',
      'm6': 'cze',
      'm7': 'lip',
      'm8': 'sie',
      'm9': 'wrz',
      'm10': 'paź',
      'm11': 'lis',
      'other': 'gru',
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
    return '$h godz. $min min';
  }

  @override
  String podcastsMin(int min) {
    return '$min min';
  }

  @override
  String get podcastsPlayed => 'odtworzono';

  @override
  String podcastsTimeLeft(String time) {
    return 'Pozostało $time';
  }

  @override
  String get podcastsSearchHint => 'Szukaj podcastów';

  @override
  String get podcastsNothingFound => 'Nic nie znaleziono.';

  @override
  String get podcastsYours => 'Twoje podcasty';

  @override
  String get podcastsNewEpisodes => 'Nowe odcinki';

  @override
  String get podcastsTrendingBrazil => 'Na topie w Brazylii';

  @override
  String get podcastsLoadFailed => 'Nie udało się wczytać. Spróbuj ponownie';

  @override
  String get podcastsNoEpisodes => 'Brak odcinków w kanale.';

  @override
  String podcastsNoEpisodeMatch(String q) {
    return 'Brak odcinków pasujących do „$q”.';
  }

  @override
  String get podcastsKind => 'Podcast';

  @override
  String get podcastsEpisodes => 'Odcinki';

  @override
  String podcastsEpisodesCount(int total) {
    return 'Odcinki ($total)';
  }

  @override
  String get podcastsFindEpisode => 'Szukaj odcinków';

  @override
  String showsMonthName(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': 'styczeń',
      'm2': 'luty',
      'm3': 'marzec',
      'm4': 'kwiecień',
      'm5': 'maj',
      'm6': 'czerwiec',
      'm7': 'lipiec',
      'm8': 'sierpień',
      'm9': 'wrzesień',
      'm10': 'październik',
      'm11': 'listopad',
      'other': 'grudzień',
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
      'w1': 'pon.',
      'w2': 'wt.',
      'w3': 'śr.',
      'w4': 'czw.',
      'w5': 'pt.',
      'w6': 'sob.',
      'other': 'niedz.',
    });
    return '$_temp0';
  }

  @override
  String get showsFollowingNone => 'Od obserwowanych wykonawców';

  @override
  String showsFollowingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Od $count obserwowanych wykonawców',
      many: 'Od $count obserwowanych wykonawców',
      few: 'Od $count obserwowanych wykonawców',
      one: 'Od $count obserwowanego wykonawcy',
    );
    return '$_temp0';
  }

  @override
  String showsSearchingFor(int count) {
    return 'szukam koncertów (wykonawców: $count)…';
  }

  @override
  String get showsUpcoming => 'Nadchodzące';

  @override
  String get showsPast => 'Minione';

  @override
  String get showsInBrazil => 'W Brazylii';

  @override
  String get showsEmptyFollow =>
      'Obserwuj wykonawców (przycisk Obserwuj na stronie wykonawcy), aby zobaczyć tu ich koncerty.';

  @override
  String get showsNonePast => 'Nie zapisano jeszcze żadnych koncertów.';

  @override
  String get showsNoneUpcoming => 'Na razie brak zaplanowanych koncertów.';

  @override
  String get showsStillSearching => 'Wciąż szukam…';

  @override
  String get showsSource =>
      'Daty z MusicBrainz (tworzone przez fanów); nowe koncerty mogą pojawiać się z opóźnieniem.';

  @override
  String get showsCancelled => 'odwołany';

  @override
  String get showsFestival => 'festiwal';

  @override
  String get catalogKindAlbum => 'Album';

  @override
  String get catalogKindSingle => 'Singiel';

  @override
  String get catalogKindBroadcast => 'Audycja';

  @override
  String get catalogKindOther => 'Inne';

  @override
  String get catalogSecLive => 'na żywo';

  @override
  String get catalogSecCompilation => 'kompilacja';

  @override
  String get catalogSecSoundtrack => 'ścieżka dźwiękowa';

  @override
  String get catalogSecMixtape => 'mixtape';

  @override
  String get catalogSecInterview => 'wywiad';

  @override
  String get catalogSecSpokenword => 'spoken word';

  @override
  String catalogDownloadingOne(String title) {
    return 'Pobieranie: $title';
  }

  @override
  String catalogDownloadingMany(int count, String artist) {
    return 'Pobieranie albumów ($count) wykonawcy $artist';
  }

  @override
  String catalogCheckingDiscography(int seconds) {
    return 'Sprawdzanie dyskografii… $seconds s';
  }

  @override
  String catalogToDownload(int count) {
    return 'Do pobrania: $count';
  }

  @override
  String catalogInLibraryCount(int count) {
    return 'Już w bibliotece: $count';
  }

  @override
  String catalogSkippedOneSong(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pominięto $count wydawnictwa z jednym utworem',
      many: 'Pominięto $count wydawnictw z jednym utworem',
      few: 'Pominięto $count wydawnictwa z jednym utworem',
      one: 'Pominięto 1 wydawnictwo z jednym utworem',
    );
    return '$_temp0';
  }

  @override
  String get catalogPickAll => 'Wszystkie';

  @override
  String get catalogPickStudio => 'Studyjne';

  @override
  String get catalogPickNone => 'Żadne';

  @override
  String get catalogDownloadSelected => 'Pobierz zaznaczone';

  @override
  String catalogDownloadNSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pobierz $count zaznaczonych',
      many: 'Pobierz $count zaznaczonych',
      few: 'Pobierz $count zaznaczone',
      one: 'Pobierz 1 zaznaczony',
    );
    return '$_temp0';
  }

  @override
  String get catalogNothingMissing => 'Niczego nie brakuje.';

  @override
  String get catalogPartial => 'częściowo';

  @override
  String get catalogDownload => 'Pobierz';

  @override
  String get catalogAddToLibrary => 'Dodaj do Twojej biblioteki';

  @override
  String get catalogInYourLibrary => 'W Twojej bibliotece';

  @override
  String get catalogAllInLibrary => 'wszystko w bibliotece';

  @override
  String catalogNInLibrary(int count) {
    return '$count w bibliotece';
  }

  @override
  String get catalogDownloadAlbum => 'Pobierz album';

  @override
  String get catalogArtistNotFound => 'Nie znaleziono wykonawcy.';

  @override
  String get catalogFromCatalog => 'Z katalogu: jeszcze nie w bibliotece';

  @override
  String get catalogDownloadAll => 'Pobierz wszystko';

  @override
  String get catalogDownloadDiscography => 'Pobierz dyskografię';

  @override
  String get catalogPopular => 'Popularne';

  @override
  String get catalogShowLess => 'Pokaż mniej';

  @override
  String get catalogShowMore => 'Pokaż więcej';

  @override
  String get catalogSinglesEps => 'Single i EP-ki';

  @override
  String get catalogFansAlsoLike => 'Fani lubią też';

  @override
  String get lyricsPlaySomething => 'Odtwórz coś, aby zobaczyć tekst.';

  @override
  String get lyricsNone => 'Brak tekstu tego utworu';

  @override
  String get lyricsNoneHint =>
      'Jeśli obok pliku znajduje się plik .lrc lub .txt, tekst pojawi się tutaj.';

  @override
  String get lyricsFind => 'Znajdź tekst';

  @override
  String get lyricsFinding => 'Szukam tekstu…';

  @override
  String get lyricsNotFound => 'Nie znaleziono tekstu tego utworu';

  @override
  String get lyricsSynced => 'Zsynchronizowany tekst z pliku .lrc';

  @override
  String get lyricsUnsynced => 'Tekst bez synchronizacji';

  @override
  String get profileChangePhoto => 'Zmień zdjęcie';

  @override
  String get profileNoPhoto => 'Nie wybrano zdjęcia';

  @override
  String get profilePhotoTooBig => 'Zdjęcie jest za duże (maks. 8 MB)';

  @override
  String get profilePhotoChanged => 'Zmieniono zdjęcie profilowe';

  @override
  String get profilePhotoRemoved => 'Usunięto zdjęcie';

  @override
  String get profileNameSaved => 'Zapisano nazwę profilu';

  @override
  String get profileRenameTitle => 'Zmienić nazwę użytkownika?';

  @override
  String profileRenameBody(String name) {
    return 'Będziesz się logować jako „$name” w Pudim, Jellyfin i innych aplikacjach (Finamp, Feishin…). Twoje Odkrycia, Mix i Rewind zostaną zachowane.';
  }

  @override
  String get profileRenameConfirm => 'Zmień';

  @override
  String profileNowSignedAs(String name) {
    return 'Teraz logujesz się jako $name';
  }

  @override
  String get profileEnterNewPassword => 'Wpisz nowe hasło';

  @override
  String get profilePasswordsDiffer => 'Nowe hasła nie są takie same';

  @override
  String get profilePasswordChanged => 'Zmieniono hasło';

  @override
  String get profileExtrasUnreachable =>
      'Nie udało się połączyć z serwerem dodatków; nazwa profilu i nazwa użytkownika muszą poczekać.';

  @override
  String get profileNameSection => 'Nazwa profilu';

  @override
  String get profileNameHelp => 'Tak widzą Cię Twoje kontakty na czacie.';

  @override
  String get profileYourName => 'Twoje imię';

  @override
  String get profileUsernameSection => 'Nazwa użytkownika';

  @override
  String get profileUsernameHelp =>
      'Nazwa, której używasz do logowania w Jellyfin (tutaj i w innych aplikacjach).';

  @override
  String get profileUsernameHint => 'Nazwa użytkownika';

  @override
  String get profileChangeUsername => 'Zmień nazwę użytkownika';

  @override
  String get profilePasswordSection => 'Hasło';

  @override
  String get profileCurrentPassword => 'Obecne hasło';

  @override
  String get profileNewPassword => 'Nowe hasło';

  @override
  String get profileRepeatPassword => 'Powtórz nowe hasło';

  @override
  String get profileChangePassword => 'Zmień hasło';

  @override
  String get loginServerRequired => 'Wpisz adres swojego serwera Jellyfin.';

  @override
  String get loginUserRequired => 'Wpisz nazwę użytkownika.';

  @override
  String get loginTitle => 'Zaloguj się do Pudim';

  @override
  String get loginSubtitle => 'Użyj konta Jellyfin.';

  @override
  String get loginUsername => 'Nazwa użytkownika';

  @override
  String get loginPassword => 'Hasło';

  @override
  String get loginShowPassword => 'Pokaż hasło';

  @override
  String get loginHidePassword => 'Ukryj hasło';

  @override
  String get loginSubmit => 'Zaloguj się';

  @override
  String get loginQuickConnect => 'Zaloguj się przez Quick Connect';

  @override
  String get loginHideAddresses => 'Ukryj adresy';

  @override
  String get loginServerAddress => 'Adres serwera';

  @override
  String get loginJellyfinServer => 'Serwer Jellyfin';

  @override
  String get loginJellyfinServerExample => 'Np. https://jellyfin.exemplo.com';

  @override
  String get loginLocalNetwork => 'W sieci lokalnej (opcjonalnie)';

  @override
  String get loginLocalNetworkExample =>
      'Np. http://192.168.0.10:8096. Gdy odpowie, aplikacja użyje go zamiast głównego.';

  @override
  String get loginExtrasServer => 'Serwer dodatków (opcjonalnie)';

  @override
  String get loginExtrasServerHint =>
      'Włącza czat, Jam, Blend, miksy i Rewind. Zostaw puste, jeśli go nie masz.';

  @override
  String get loginQcExpired => 'Kod wygasł. Spróbuj ponownie.';

  @override
  String get loginQcInstructions =>
      'Na urządzeniu, na którym jesteś już zalogowany w Jellyfin, otwórz swój profil, wybierz Quick Connect i wpisz ten kod:';

  @override
  String get loginQcWaiting => 'Oczekiwanie na zatwierdzenie…';

  @override
  String get homeDownloadedOnDevice => 'Pobrane na to urządzenie';

  @override
  String get homeTabMusic => 'Muzyka';

  @override
  String get homeMadeFor => 'Stworzone dla';

  @override
  String get homeMixDiscoveries => 'Nowa muzyka dla Ciebie, co tydzień';

  @override
  String get homeMixWeekly => 'Twoje ulubione i podobne utwory, co tydzień';

  @override
  String get homeMixRadar =>
      'Nowości od obserwowanych wykonawców, w każdy piątek';

  @override
  String get homeMixDaylist => 'Zmienia się w ciągu dnia';

  @override
  String get homeMixBlend => 'Wasze gusta razem';

  @override
  String get homeMixAuto => 'Miks automatyczny';

  @override
  String get homeSpotifyPlaylists => 'Twoje playlisty ze Spotify';

  @override
  String get homeFromSpotify => 'Ze Spotify';

  @override
  String get homeYourPlaylists => 'Twoje playlisty';

  @override
  String get homeTopAlbums => 'Twoje najczęściej odtwarzane albumy';

  @override
  String get homeTopArtists => 'Twoi ulubieni wykonawcy';

  @override
  String get homeRecentlyAdded => 'Ostatnio dodane';

  @override
  String get homeYourPodcasts => 'Twoje podcasty';

  @override
  String get homeRadiosTitle => 'Polecane radia';

  @override
  String get homeRadiosSubtitle =>
      'Muzyka bez przerwy, oparta na Twoich ulubionych wykonawcach.';

  @override
  String get homeRadioBadge => 'RADIO';

  @override
  String homeRadioWith(String name) {
    return 'Z $name i podobnymi wykonawcami';
  }

  @override
  String searchNoResults(String query) {
    return 'Brak wyników dla „$query”';
  }

  @override
  String get searchNoResultsHint =>
      'Sprawdź pisownię lub użyj mniejszej liczby albo innych słów.';

  @override
  String searchCatalogNoResponse(String error) {
    return 'Katalog nie odpowiedział: $error';
  }

  @override
  String get searchAlsoCatalog => 'Przeszukiwanie także katalogu…';

  @override
  String searchLibraryOnly(String error) {
    return 'Tylko biblioteka: katalog nie odpowiedział ($error).';
  }

  @override
  String get searchTopResult => 'Najlepszy wynik';

  @override
  String get searchSpotifyPlaylists => 'Playlisty ze Spotify';

  @override
  String get searchRecent => 'Ostatnie wyszukiwania';

  @override
  String get searchClear => 'Wyczyść';

  @override
  String get searchBrowseAll => 'Przeglądaj wszystko';

  @override
  String get searchHint => 'Czego chcesz posłuchać?';

  @override
  String get albumDownloadedType => 'Album • pobrany na to urządzenie';

  @override
  String albumSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count utworu',
      many: '$count utworów',
      few: '$count utwory',
      one: '1 utwór',
    );
    return '$_temp0, $total';
  }

  @override
  String get albumRemoveFromLibrary => 'Usuń z Twojej biblioteki';

  @override
  String get albumSaveToLibrary => 'Zapisz w Twojej bibliotece';

  @override
  String albumMoreOptions(String name) {
    return 'Więcej opcji dla: $name';
  }

  @override
  String albumDisc(int number) {
    return 'Dysk $number';
  }

  @override
  String albumMoreFrom(String name) {
    return 'Więcej od: $name';
  }

  @override
  String artistAlbumsInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count albumu w Twojej bibliotece',
      many: '$count albumów w Twojej bibliotece',
      few: '$count albumy w Twojej bibliotece',
      one: '1 album w Twojej bibliotece',
    );
    return '$_temp0';
  }

  @override
  String artistPlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count odtworzenia',
      many: '$count odtworzeń',
      few: '$count odtworzenia',
      one: '1 odtworzenie',
    );
    return '$_temp0';
  }

  @override
  String artistMoreOptions(String name) {
    return 'Więcej opcji dla: $name';
  }

  @override
  String get artistPopular => 'Popularne';

  @override
  String get artistShowLess => 'Pokaż mniej';

  @override
  String get artistShowMore => 'Zobacz więcej';

  @override
  String get artistYouLiked => 'Polubione przez Ciebie';

  @override
  String artistFrom(String name) {
    return 'Od: $name';
  }

  @override
  String get artistDiscography => 'Dyskografia';

  @override
  String get artistPopularReleases => 'Popularne wydawnictwa';

  @override
  String get artistSinglesEps => 'Single i EP-ki';

  @override
  String get artistFansAlsoLike => 'Fani lubią też';

  @override
  String get artistAppearsOn => 'Pojawia się na';

  @override
  String get artistAbout => 'Informacje';

  @override
  String get playlistOriginSpotify => 'Ze Spotify';

  @override
  String get playlistOriginMadeForYou => 'Stworzone dla Ciebie';

  @override
  String get playlistOriginAuto => 'Miks automatyczny';

  @override
  String get playlistDownloadedOnDevice => 'Pobrane na to urządzenie';

  @override
  String get playlistOnDevice => 'Na tym urządzeniu';

  @override
  String get playlistPlaysOffline => 'Gra bez internetu.';

  @override
  String playlistPlaysOfflineDownloading(int count) {
    return 'Gra bez internetu. Pobieranie jeszcze: $count…';
  }

  @override
  String playlistSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count utworu',
      many: '$count utworów',
      few: '$count utwory',
      one: '1 utwór',
    );
    return '$_temp0, $total';
  }

  @override
  String playlistMoreOptions(String name) {
    return 'Więcej opcji dla: $name';
  }

  @override
  String get playlistSearchHint => 'Szukaj w playliście';

  @override
  String get playlistEmpty => 'Brak tu jeszcze utworów.';

  @override
  String get playlistErrNoPermission =>
      'Nie masz uprawnień do edycji tej playlisty.';

  @override
  String playlistErrServer(String code) {
    return 'Serwer odrzucił żądanie ($code).';
  }

  @override
  String get playlistErrNoResponse => 'brak odpowiedzi';

  @override
  String get playlistDownloadFirst =>
      'Najpierw pobierz utwór, aby dodać go do playlisty';

  @override
  String get playlistAddTo => 'Dodaj do playlisty';

  @override
  String get playlistNew => 'Nowa playlista';

  @override
  String playlistAddedTo(String name) {
    return 'Dodano do: $name';
  }

  @override
  String get playlistNameHint => 'Nazwa playlisty';

  @override
  String get playlistCreate => 'Utwórz';

  @override
  String playlistCreated(String name) {
    return 'Utworzono playlistę $name';
  }

  @override
  String get playlistRemoved => 'Usunięto z playlisty';

  @override
  String get playlistInviteTitle => 'Zaproś do edycji';

  @override
  String get playlistInviteSubtitle =>
      'Zobaczą playlistę w swojej bibliotece i będą mogli dodawać oraz usuwać utwory.';

  @override
  String get playlistInviteOwnerOnly => 'Zapraszać może tylko twórca playlisty';

  @override
  String playlistInvited(String who, String playlist) {
    return '$who może teraz edytować: $playlist';
  }

  @override
  String playlistCollaborative(String members) {
    return 'Wspólna · $members';
  }

  @override
  String get playlistSmartShuffleTooltip =>
      'Smart Shuffle: losowe odtwarzanie z rekomendacjami';

  @override
  String get playlistSmartShuffleOn =>
      'Smart Shuffle włączony: rekomendacje są oznaczone ✦';

  @override
  String get playlistAddedToThis => 'Dodano do playlisty';

  @override
  String get playlistRecommendation => 'Rekomendacja Smart Shuffle';

  @override
  String get playlistPutIn => 'Dodaj do playlisty';

  @override
  String get settingsSectionAccount => 'Konto';

  @override
  String get settingsProfileSubtitle => 'Nazwa, nazwa użytkownika i hasło';

  @override
  String settingsConnectedAt(String url) {
    return 'Połączono z $url';
  }

  @override
  String get settingsSignOut => 'Wyloguj się';

  @override
  String get accountsTitle => 'Konta';

  @override
  String get accountsAdd => 'Dodaj konto lub serwer';

  @override
  String get accountsSwitch => 'Przełącz';

  @override
  String get accountsInUse => 'W użyciu';

  @override
  String accountsOn(String user, String host) {
    return '$user na $host';
  }

  @override
  String get loginBackToAccount => 'Wróć do bieżącego konta';

  @override
  String get settingsSectionServer => 'Serwer';

  @override
  String get settingsLocalNetwork => 'W sieci lokalnej';

  @override
  String get settingsServerNote =>
      'Aby zmienić adresy Jellyfin, wyloguj się i otwórz „Adres serwera” na ekranie logowania.';

  @override
  String get settingsExtrasServer => 'Serwer dodatków';

  @override
  String get settingsExtrasNotConfigured =>
      'Nie skonfigurowano (czat, Jam, Blend, miksy i Recap pozostają ukryte)';

  @override
  String get settingsConfigure => 'Skonfiguruj';

  @override
  String get settingsChange => 'Zmień';

  @override
  String get settingsSectionPlayback => 'Odtwarzanie';

  @override
  String get settingsQualityWifi => 'Jakość przez Wi-Fi';

  @override
  String get settingsQualityWifiSubtitle =>
      'Oryginalna odtwarza plik tak, jak jest w bibliotece.';

  @override
  String get settingsQualityMobile => 'Jakość przez dane komórkowe';

  @override
  String get settingsQualityMobileSubtitle =>
      'Niższa jakość zużywa mniej danych komórkowych.';

  @override
  String get settingsQualityOriginal => 'Oryginalna';

  @override
  String get settingsAppliesNextSong => 'Obowiązuje od następnego utworu';

  @override
  String get settingsSectionAbout => 'Informacje';

  @override
  String settingsBuild(int build) {
    return 'Kompilacja $build';
  }

  @override
  String get settingsExtrasEmptyHint => 'Zostaw puste, aby wyłączyć dodatki.';

  @override
  String get settingsAutoplay => 'Autoodtwarzanie';

  @override
  String get settingsAutoplaySubtitle =>
      'Gdy kolejka się skończy, odtwarza dalej podobne utwory (miks Jellyfin).';

  @override
  String get settingsNormalize => 'Normalizuj głośność';

  @override
  String get settingsNormalizeSubtitle =>
      'Odtwarza wszystkie utwory z taką samą głośnością, na podstawie analizy Jellyfin.';

  @override
  String get settingsScrobble => 'Scrobbling';

  @override
  String get settingsLoading => 'Wczytywanie…';

  @override
  String get settingsLastfmNoKey =>
      'Serwer dodatków nie ma jeszcze skonfigurowanego klucza API Last.fm.';

  @override
  String settingsConnectedAs(String name) {
    return 'Połączono jako $name';
  }

  @override
  String get settingsLastfmConnectedSubtitle =>
      'Wszystko, czego słuchasz w Pudim, trafia do Twojego profilu Last.fm.';

  @override
  String get settingsDisconnect => 'Rozłącz';

  @override
  String get settingsLastfmAuthorize => 'Autoryzuj na stronie Last.fm';

  @override
  String get settingsLastfmAuthorizeSubtitle =>
      'Po kliknięciu tam „Yes, allow access” wróć i dotknij Gotowe.';

  @override
  String get settingsFinish => 'Gotowe';

  @override
  String get settingsLastfmConnected => 'Połączono z Last.fm';

  @override
  String get settingsLastfmScrobbleSubtitle =>
      'Zapisuje w Last.fm każdy utwór, którego słuchasz.';

  @override
  String get settingsConnect => 'Połącz';

  @override
  String get sidebarOpenLibrary => 'Otwórz Twoją bibliotekę';

  @override
  String get sidebarCollapseLibrary => 'Zwiń Twoją bibliotekę';

  @override
  String sidebarOnDeviceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count utworu',
      many: '$count utworów',
      few: '$count utwory',
      one: '1 utwór',
    );
    return 'Na urządzeniu • $_temp0';
  }

  @override
  String sidebarPlaylistCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count utworu',
      many: '$count utworów',
      few: '$count utwory',
      one: '1 utwór',
    );
    return 'Playlista • $_temp0';
  }

  @override
  String sidebarAlbumBy(String artist) {
    return 'Album • $artist';
  }

  @override
  String get sidebarSearchLibrary => 'Szukaj w Twojej bibliotece';

  @override
  String get sidebarSortBy => 'Sortuj według';

  @override
  String get sidebarSortRecents => 'Ostatnie';

  @override
  String get sidebarSortAdded => 'Ostatnio dodane';

  @override
  String get sidebarSortAlpha => 'Alfabetycznie';

  @override
  String get sidebarSortCreator => 'Twórca';

  @override
  String get topBarSearchHint => 'Co chcesz odtworzyć?';

  @override
  String get topBarClearSearch => 'Wyczyść pole wyszukiwania';

  @override
  String get topBarBrowse => 'Przeglądaj';

  @override
  String get topBarMenu => 'Menu';

  @override
  String get topBarLogoutAccount => 'Wyloguj się';

  @override
  String get topBarQuit => 'Zamknij Pudim';

  @override
  String get topBarLogout => 'Wyloguj się';

  @override
  String get playerBarSmartShuffleOff => 'Wyłącz Smart Shuffle';

  @override
  String get playerBarSmartShuffleOn => 'Włącz Smart Shuffle';

  @override
  String get playerBarShuffleOff => 'Wyłącz losowe odtwarzanie';

  @override
  String get playerBarShuffleOn => 'Włącz losowe odtwarzanie';

  @override
  String get playerBarPlay => 'Odtwórz';

  @override
  String get playerBarForward => 'Następny';

  @override
  String get playerBarRepeatOn => 'Włącz powtarzanie';

  @override
  String get playerBarRepeatOne => 'Włącz powtarzanie jednego utworu';

  @override
  String get playerBarRepeatOff => 'Wyłącz powtarzanie';

  @override
  String get playerBarNowPlayingView => 'Widok odtwarzania';

  @override
  String get playerBarLyrics => 'Tekst';

  @override
  String get playerBarUnmute => 'Włącz dźwięk';

  @override
  String get playerBarMute => 'Wycisz';

  @override
  String get rightPanelNothingPlaying =>
      'Odtwórz coś, aby zobaczyć tutaj, co leci.';

  @override
  String get rightPanelLyricsPreview => 'Podgląd tekstu';

  @override
  String get rightPanelAboutArtist => 'O wykonawcy';

  @override
  String get rightPanelNextUp => 'Następne w kolejce';

  @override
  String get rightPanelOpenQueue => 'Otwórz kolejkę';

  @override
  String get rightPanelQueueEmptyTitle => 'Dodaj do kolejki';

  @override
  String get rightPanelQueueEmptyHint =>
      'Kliknij „Dodaj do kolejki” w menu utworu, aby umieścić go tutaj';

  @override
  String get rightPanelNowPlaying => 'Teraz odtwarzane';

  @override
  String get rightPanelNextInQueue => 'Następny w kolejce';

  @override
  String rightPanelNextFrom(String name) {
    return 'Następne z: $name';
  }

  @override
  String get nowPlayingPlayingFrom => 'ODTWARZANE Z';

  @override
  String get nowPlayingMoreOptions => 'Więcej opcji';

  @override
  String get chatChats => 'Czaty';

  @override
  String chatYouSaid(String text) {
    return 'Ty: $text';
  }

  @override
  String get chatContacts => 'Kontakty';

  @override
  String get chatServerUnreachable =>
      'Nie udało się połączyć z serwerem dodatków.';

  @override
  String get chatMessageHint => 'Wiadomość';

  @override
  String chatJoinedJam(String title) {
    return 'Dołączono do: $title';
  }

  @override
  String chatCouldNotPlay(String error) {
    return 'Nie udało się odtworzyć: $error';
  }

  @override
  String get chatJamCardSubtitle => 'Słuchajcie razem, w jednej kolejce';

  @override
  String get chatInJam => 'W Jam';

  @override
  String get chatJoin => 'Dołącz';

  @override
  String get chatNoOtherAccounts => 'Brak innych kont na serwerze.';

  @override
  String chatSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count utworu',
      many: '$count utworów',
      few: '$count utwory',
      one: '1 utwór',
    );
    return '$_temp0';
  }

  @override
  String chatSentTo(String name) {
    return 'Wysłano do: $name';
  }

  @override
  String chatShareTitle(String title) {
    return 'Udostępnij: $title';
  }

  @override
  String get chatNoteHint => 'Notatka (opcjonalnie)';

  @override
  String get blendWorking => 'Tworzenie Blend…';

  @override
  String blendAffinityButton(int affinity) {
    return 'Blend $affinity%';
  }

  @override
  String get blendCreate => 'Utwórz Blend';

  @override
  String blendWith(String name) {
    return 'Blend z: $name';
  }

  @override
  String get blendExplain =>
      'Jedna playlista dla was obojga, z tym, czego słuchacie razem, wspólnymi wykonawcami i odrobiną tego, co każde z was kocha najbardziej. Pokazuje, jak bardzo pasują do siebie wasze gusta, i aktualizuje się codziennie.';

  @override
  String get blendNotNow => 'Nie teraz';

  @override
  String blendAffinityTitle(int affinity) {
    return 'Zgodność: $affinity%';
  }

  @override
  String blendInCommon(String artists) {
    return 'Wspólne: $artists';
  }

  @override
  String blendOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Otwórz Blend ($count utworu)',
      many: 'Otwórz Blend ($count utworów)',
      few: 'Otwórz Blend ($count utwory)',
      one: 'Otwórz Blend (1 utwór)',
    );
    return '$_temp0';
  }

  @override
  String get blendRefreshNow => 'Odśwież teraz';

  @override
  String get blendUndo => 'Usuń Blend';

  @override
  String get blendRefreshing => 'Odświeżanie Blend…';

  @override
  String get blendUndoTitle => 'Usunąć Blend?';

  @override
  String blendUndoBody(String name) {
    return 'Playlista zniknie dla Ciebie i dla: $name.';
  }

  @override
  String get blendUndoConfirm => 'Usuń';

  @override
  String get blendUndone => 'Usunięto Blend';

  @override
  String get jamStart => 'Rozpocznij Jam';

  @override
  String jamTooltip(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jam ($count osoby)',
      many: 'Jam ($count osób)',
      few: 'Jam ($count osoby)',
      one: 'Jam (1 osoba)',
    );
    return '$_temp0';
  }

  @override
  String get jamSubIdle =>
      'Słuchajcie razem z innymi kontami, w jednej kolejce.';

  @override
  String get jamSubHost => 'Ty rządzisz. Wszyscy mogą proponować utwory.';

  @override
  String get jamSubGuest =>
      'Twoje sterowanie i utwory trafiają do kolejki wszystkich.';

  @override
  String get jamPlayFirst => 'Odtwórz coś przed rozpoczęciem Jam.';

  @override
  String jamMembers(int count) {
    return 'W Jam ($count)';
  }

  @override
  String jamYouSuffix(String name) {
    return '$name (Ty)';
  }

  @override
  String get jamHost => 'Gospodarz';

  @override
  String get jamInvite => 'Zaproś';

  @override
  String get jamInviteTitle => 'Zaproś do Jam';

  @override
  String get jamInviteSubtitle => 'Zaproszenie trafi na czat.';

  @override
  String jamInviteSent(String name) {
    return 'Wysłano zaproszenie do: $name';
  }

  @override
  String get jamEnd => 'Zakończ Jam';

  @override
  String get jamLeave => 'Opuść Jam';

  @override
  String recapTitle(int year) {
    return 'Twoje Wrapped $year';
  }

  @override
  String get recapShort => 'Wrapped';

  @override
  String recapBannerBody(String minutes) {
    return '$minutes minut muzyki w tym roku. Zobacz, czego słuchałeś najczęściej.';
  }

  @override
  String get recapEmpty =>
      'Nie ma jeszcze odtworzeń, z których można by stworzyć Twoje Wrapped.';

  @override
  String get recapShareCards => 'Udostępnij karty';

  @override
  String get recapBigMinutes => 'minut słuchania';

  @override
  String get recapBigSongs => 'różnych utworów';

  @override
  String get recapBigArtists => 'wykonawców';

  @override
  String get recapBigDays => 'dni z muzyką';

  @override
  String get recapBigStreak => 'dni z rzędu, Twój rekord';

  @override
  String get recapTopArtists => 'Twoi najczęściej słuchani wykonawcy roku';

  @override
  String recapMinutesValue(String minutes) {
    return '$minutes minut';
  }

  @override
  String get recapTopSongs => 'Twoje najczęściej słuchane utwory roku';

  @override
  String recapPlaysLine(String artist, String plays) {
    return '$artist • odtworzeń: $plays';
  }

  @override
  String get recapSongGone => 'Tego utworu nie ma już w bibliotece';

  @override
  String get recapTopAlbums => 'Twoje najczęściej słuchane albumy roku';

  @override
  String get recapTopGenres => 'Twoje najczęściej odtwarzane gatunki';

  @override
  String recapGenreLine(String genre, String minutes) {
    return '$genre • $minutes min';
  }

  @override
  String get recapMonthly => 'Miesiąc po miesiącu';

  @override
  String recapMonthTooltip(String month, String minutes) {
    return '$month: $minutes min';
  }

  @override
  String get recapListeningStyle => 'Jak słuchasz';

  @override
  String recapFavHour(String hour) {
    return 'Ulubiona godzina: $hour:00';
  }

  @override
  String recapFavWeekday(String day) {
    return 'Ulubiony dzień tygodnia: $day';
  }

  @override
  String recapBiggestDay(String date, String minutes) {
    return 'Twój rekordowy dzień: $date, $minutes minut';
  }

  @override
  String recapNewArtists(int count, String n) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$n nowego wykonawcy dla Ciebie',
      many: '$n nowych wykonawców dla Ciebie',
      few: '$n nowych wykonawców dla Ciebie',
      one: '$n nowy wykonawca dla Ciebie',
    );
    return '$_temp0';
  }

  @override
  String recapSpotifyAdded(String added) {
    return 'Dodano odtworzeń ze Spotify: $added.';
  }

  @override
  String recapSpotifyAddedDup(String added, String dup) {
    return 'Dodano odtworzeń ze Spotify: $added (kolejne $dup były już w Pudim).';
  }

  @override
  String get recapSpotifyRemoveTitle => 'Usunąć historię ze Spotify?';

  @override
  String get recapSpotifyRemoveBody =>
      'Twoje Wrapped wróci do liczenia tylko tego, co odtworzyłeś w Pudim/Jellyfin. Możesz zaimportować ją ponownie później.';

  @override
  String get recapSpotifyRemoveConfirm => 'Usuń';

  @override
  String recapSpotifyRemoved(String count) {
    return 'Usunięto odtworzeń ze Spotify: $count';
  }

  @override
  String get recapSpotifyTitle => 'Historia ze Spotify';

  @override
  String recapSpotifyHasData(String count, String from, String to) {
    return 'Odtworzeń ze Spotify w Twoim Wrapped: $count ($from – $to). Możesz wgrać nowszy plik: to, co już jest, nie zostanie policzone dwa razy.';
  }

  @override
  String get recapSpotifyIntro =>
      'Dodaj lata sprzed Pudim. W Spotify wybierz Konto > Prywatność > Pobierz swoje dane i zaznacz „Extended streaming history”. Gdy przyjdzie e-mail, wybierz tutaj plik my_spotify_data.zip.';

  @override
  String get recapSpotifyImportAnother => 'Importuj kolejny plik';

  @override
  String get recapSpotifyImport => 'Importuj historię';

  @override
  String get recapSpotifyRemoveBtn => 'Usuń z Wrapped';

  @override
  String get recapShareSaveDialog => 'Zapisz kartę';

  @override
  String get recapShareSaved => 'Zapisano kartę';

  @override
  String recapShareSaveFailed(String error) {
    return 'Nie udało się zapisać: $error';
  }

  @override
  String recapShareShareFailed(String error) {
    return 'Nie udało się udostępnić: $error';
  }

  @override
  String recapShareText(int year) {
    return 'Moje Wrapped $year w Pudim';
  }

  @override
  String get recapShareMyArtists => 'Moi najczęściej słuchani wykonawcy roku';

  @override
  String get recapShareMySongs => 'Moje najczęściej słuchane utwory roku';

  @override
  String recapMinShort(String minutes) {
    return '$minutes min';
  }

  @override
  String get recapShareSaveImage => 'Zapisz obraz';

  @override
  String get recapShareButton => 'Udostępnij';

  @override
  String recapBrand(int year) {
    return 'Wrapped $year';
  }

  @override
  String get recapShareMyYear => 'Mój rok w muzyce';

  @override
  String recapShareYearOf(String name) {
    return 'Rok w muzyce: $name';
  }

  @override
  String get recapShareTopArtist => 'mój wykonawca roku';

  @override
  String recapShareGenres(String genres) {
    return 'Gatunki: $genres';
  }

  @override
  String get widgetActionsAddedToLiked => 'Dodano do polubionych utworów';

  @override
  String get widgetActionsRemovedFromLiked => 'Usunięto z polubionych utworów';

  @override
  String get widgetActionsUnfollowed => 'Przestano obserwować';

  @override
  String get widgetActionsSavedToLibrary => 'Zapisano w Twojej bibliotece';

  @override
  String get widgetActionsRemovedFromLibrary => 'Usunięto z Twojej biblioteki';

  @override
  String get widgetActionsAddToQueue => 'Dodaj do kolejki';

  @override
  String get widgetActionsAddedToQueue => 'Dodano do kolejki';

  @override
  String get widgetActionsPlayNext => 'Odtwórz jako następny';

  @override
  String get widgetActionsGoToPodcast => 'Przejdź do podcastu';

  @override
  String get widgetActionsRemoveFromQueue => 'Usuń z kolejki';

  @override
  String get widgetActionsAddToPlaylist => 'Dodaj do playlisty';

  @override
  String get widgetActionsRemoveFromThisPlaylist => 'Usuń z tej playlisty';

  @override
  String get widgetActionsInviteToEdit => 'Zaproś do edycji';

  @override
  String get widgetActionsKeepInPlaylist => 'Zostaw na playliście';

  @override
  String get widgetActionsDownloadTrack => 'Pobierz utwór';

  @override
  String get widgetActionsDownloadAlbum => 'Pobierz album';

  @override
  String get widgetActionsDownloadDiscography => 'Pobierz dyskografię';

  @override
  String get widgetActionsSearchAlbums => 'Znajdź albumy';

  @override
  String widgetActionsImproveQuality(int count) {
    return 'Popraw jakość ($count)';
  }

  @override
  String widgetActionsImprovingAlbums(int count) {
    return 'Szukanie lepszych wersji albumów: $count';
  }

  @override
  String get widgetActionsShare => 'Udostępnij';

  @override
  String get widgetActionsSearchFlac => 'Znajdź w FLAC';

  @override
  String widgetActionsSearchingFlac(String name) {
    return 'Szukanie „$name” w FLAC; jeśli się znajdzie, zastąpi MP3';
  }

  @override
  String get widgetActionsTrackRemovedFromDevice => 'Usunięto z urządzenia';

  @override
  String get widgetActionsRemovedFromDevice => 'Usunięto z urządzenia';

  @override
  String get widgetActionsDownloadingToDevice =>
      'Pobieranie na urządzenie do słuchania offline';

  @override
  String get widgetActionsUnfollow => 'Przestań obserwować';

  @override
  String get widgetActionsRemoveFromLibrary => 'Usuń z Twojej biblioteki';

  @override
  String get widgetActionsAddToLibrary => 'Dodaj do Twojej biblioteki';

  @override
  String get widgetActionsGoToSongRadio => 'Przejdź do radia utworu';

  @override
  String get widgetActionsStartMix => 'Uruchom miks';

  @override
  String widgetActionsMixOf(String name) {
    return 'Miks: $name';
  }

  @override
  String get widgetActionsGoToArtist => 'Przejdź do wykonawcy';

  @override
  String get widgetActionsGoToAlbum => 'Przejdź do albumu';

  @override
  String get widgetActionsCopyName => 'Kopiuj nazwę';

  @override
  String get widgetActionsCopied => 'Skopiowano';

  @override
  String widgetDownloadsBellDownloading(int count) {
    return 'Pobieranie: $count';
  }

  @override
  String get widgetDownloadsBellEmpty =>
      'Na razie nic tu nie ma. Odtwórz utwór z ikoną chmury albo użyj „Pobierz” w menu ⋯, aby przenieść go z katalogu do biblioteki.';

  @override
  String get widgetDownloadsBellKindDiscography => 'Dyskografia';

  @override
  String get widgetDownloadsBellKindFlac => 'W FLAC';

  @override
  String get widgetDownloadsBellKindQuality => 'Jakość';

  @override
  String get widgetDownloadsBellOptions => 'Opcje';

  @override
  String get widgetDownloadsBellCancelled => 'Anulowano pobieranie';

  @override
  String get widgetDownloadsBellRetrying => 'Ponowna próba';

  @override
  String get widgetDownloadsBellRemovedFromList => 'Usunięto z listy';

  @override
  String get widgetDownloadsBellDetails => 'Zobacz szczegóły';

  @override
  String get widgetDownloadsBellRemoveFromList => 'Usuń z listy';

  @override
  String get widgetMixSearchingReleases => 'Szukanie nowości…';

  @override
  String get widgetMixBuildingDaylist => 'Tworzenie Twojej daylist…';

  @override
  String get widgetMixNewDiscoveriesTitle => 'Nowe Cotygodniowe Odkrycia?';

  @override
  String get widgetMixNewMixTitle => 'Nowy Cotygodniowy Miks?';

  @override
  String get widgetMixNewDiscoveriesBody =>
      'Utwory, których jeszcze nie słuchałeś, opuszczą playlistę, a w ich miejsce pojawi się około 30 nowych. Dzieje się to już automatycznie w każdy poniedziałek.';

  @override
  String get widgetMixNewMixBody =>
      'Tworzy go od nowa z Twoich ulubionych, najczęściej słuchanych i podobnych utworów. Dzieje się to już automatycznie w każdy poniedziałek.';

  @override
  String get widgetMixNotNow => 'Nie teraz';

  @override
  String get widgetMixBuildingDiscoveries => 'Tworzenie Twoich Odkryć…';

  @override
  String get widgetMixBuildingMix => 'Tworzenie Twojego Miksu…';

  @override
  String widgetMixBuiltOn(String date) {
    return 'Utworzono $date';
  }

  @override
  String get widgetMixRedo => 'Utwórz od nowa';

  @override
  String get widgetMixRefresh => 'Odśwież';

  @override
  String get widgetMixCreateDiscoveries => 'Utwórz swoje Cotygodniowe Odkrycia';

  @override
  String get widgetMixCreateMix => 'Utwórz swój Cotygodniowy Miks';

  @override
  String get widgetMixCreateRadar => 'Utwórz swój Radar Nowości';

  @override
  String get widgetMixCreateDaylist => 'Utwórz swoją daylist';

  @override
  String get widgetOfflineBanner =>
      'Brak internetu · wyświetlane są zapisane na urządzeniu';

  @override
  String widgetOfflineDownloadingProgress(int done, int total) {
    return 'Pobieranie $done z $total';
  }

  @override
  String get widgetUpdateReady => 'Nowa wersja Pudim gotowa';

  @override
  String widgetUpdateReadyNotes(String notes) {
    return 'Nowa wersja Pudim · $notes';
  }

  @override
  String get widgetUpdateAction => 'Aktualizuj';

  @override
  String widgetSleepShortMinutes(int count) {
    return '$count min';
  }

  @override
  String widgetSleepShortSeconds(int count) {
    return '$count s';
  }

  @override
  String get widgetSleepStopsAtEnd => 'Zatrzyma się na końcu utworu';

  @override
  String widgetSleepStopsIn(String time) {
    return 'Zatrzyma się za $time';
  }

  @override
  String get widgetSleepTimer => 'Wyłącznik czasowy';

  @override
  String get widgetSleepTurnOff => 'Wyłącz timer';

  @override
  String get widgetSleepOneHour => '1 godzina';

  @override
  String get widgetSleepOneAndHalfHours => '1 godzina 30 minut';

  @override
  String get widgetSleepEndOfSong => 'Koniec utworu';

  @override
  String get widgetSleepTurnedOff => 'Wyłączono timer';

  @override
  String get widgetSleepStopsWhenSongEnds =>
      'Muzyka zatrzyma się, gdy skończy się ten utwór';

  @override
  String widgetSleepSongStopsIn(String time) {
    return 'Muzyka zatrzyma się za $time';
  }

  @override
  String get widgetSpeedPodcast => 'Prędkość podcastu';

  @override
  String get widgetCommonCatalogBadge =>
      'Z katalogu: jeszcze nie w Twojej bibliotece';

  @override
  String get widgetCommonShowAll => 'Pokaż wszystko';

  @override
  String get widgetCommonSomethingWentWrong => 'Coś poszło nie tak';

  @override
  String get widgetCommonListenDownloaded => 'Słuchaj pobranych utworów';

  @override
  String get widgetTracksTitle => 'Tytuł';

  @override
  String get widgetTracksDateAdded => 'Data dodania';

  @override
  String widgetTracksAddedBy(String name) {
    return 'przez: $name';
  }

  @override
  String get widgetTracksMoreOptions => 'Więcej opcji';

  @override
  String widgetTracksAddedDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get castTooltip => 'Przesyłaj';

  @override
  String get castTitle => 'Odtwarzaj na';

  @override
  String get castThisDevice => 'To urządzenie';

  @override
  String get castSearching => 'Szukam urządzeń w sieci…';

  @override
  String get castNone =>
      'Nie znaleziono Chromecasta. Musi być w tej samej sieci Wi-Fi.';

  @override
  String get castSearchAgain => 'Szukaj ponownie';

  @override
  String get castStop => 'Zatrzymaj przesyłanie';

  @override
  String castPlayingOn(String name) {
    return 'Odtwarzanie na $name';
  }

  @override
  String castFailed(String name) {
    return 'Nie udało się połączyć z $name';
  }

  @override
  String get settingsSectionAppearance => 'Wygląd';

  @override
  String get settingsTheme => 'Motyw';

  @override
  String get settingsThemeSubtitle => 'Zmienia kolory od razu.';

  @override
  String get themeNightDesc =>
      'Ciemny, zaokrąglone karty i pływający miniodtwarzacz.';

  @override
  String get themeRedDesc =>
      'Czysta czerń z czerwienią, duże kwadratowe okładki, miniodtwarzacz przy pasku.';

  @override
  String get themeWaveDesc =>
      'Fioletowe gradienty, mocne litery i miniodtwarzacz w kształcie pigułki.';

  @override
  String get themeRetroDesc =>
      'Szare okno z wypukłą ramką, zielony wyświetlacz z przewijanym tytułem i listy tekstowe.';

  @override
  String get themeClassicDesc =>
      'Błyszczące niebiesko-czarne szkło, przycisk kula, wizualizacja i listy w tabeli.';

  @override
  String get settingsCheckUpdates => 'Sprawdź aktualizacje';

  @override
  String get updateChecking => 'Sprawdzanie…';

  @override
  String updateUpToDate(int build) {
    return 'Masz najnowszą wersję (build $build).';
  }

  @override
  String updateDownloading(int build, int percent) {
    return 'Pobieranie buildu $build… $percent%';
  }

  @override
  String updateFailed(String error) {
    return 'Nie udało się sprawdzić: $error';
  }

  @override
  String get updateUnavailable => 'Brak skonfigurowanego serwera dodatków.';

  @override
  String get settingsHistory => 'Historia';

  @override
  String get settingsHistorySubtitle =>
      'Podsumowania z poprzednich lat i wszystko, czego słuchałeś';

  @override
  String get historyRecaps => 'Podsumowania';

  @override
  String get historyPlays => 'Odtworzenia';

  @override
  String get historyWholeYear => 'Cały rok';

  @override
  String get historyLoadMore => 'Wczytaj więcej';

  @override
  String get historyEmpty => 'Jeszcze nic nie odtworzono';

  @override
  String get historyImported => 'zaimportowane';

  @override
  String widgetMixRadarDone(int count) {
    return 'Radar nowości: $count utworów';
  }

  @override
  String widgetMixRadarQueued(int count, String list) {
    return 'Pobieranie nowości ($count): $list';
  }

  @override
  String widgetMixRadarFailed(String error) {
    return 'Radar nie został odświeżony: $error';
  }

  @override
  String get visualsFullscreen => 'Pełny ekran';

  @override
  String get visualsSwitch => 'Zmień wizualizację';

  @override
  String get visualsWaves => 'Fale';

  @override
  String get visualsSwirl => 'Wir';

  @override
  String get visualsBars => 'Słupki';

  @override
  String get visualsNebula => 'Mgławica';

  @override
  String get stateNotifyChatChannel => 'Wiadomości';

  @override
  String get stateNotifyChatChannelDesc =>
      'Wiadomości na czacie i zaproszenia do Jam';
}
