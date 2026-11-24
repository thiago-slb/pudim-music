// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class L10nUk extends L10n {
  L10nUk([String locale = 'uk']) : super(locale);

  @override
  String get languageTitle => 'Мова';

  @override
  String get languageSubtitle => 'Мова інтерфейсу';

  @override
  String get languageSystem => 'Системна за замовчуванням';

  @override
  String get commonCancel => 'Скасувати';

  @override
  String get commonClose => 'Закрити';

  @override
  String get commonBack => 'Назад';

  @override
  String get commonSave => 'Зберегти';

  @override
  String get commonEdit => 'Редагувати';

  @override
  String get commonDelete => 'Видалити';

  @override
  String get commonRemove => 'Вилучити';

  @override
  String get commonOk => 'OK';

  @override
  String get commonRetry => 'Спробувати знову';

  @override
  String get commonQueue => 'Черга';

  @override
  String get commonAlbum => 'Альбом';

  @override
  String get commonAlbums => 'Альбоми';

  @override
  String get commonArtist => 'Виконавець';

  @override
  String get commonArtists => 'Виконавці';

  @override
  String get commonSong => 'Трек';

  @override
  String get commonSongs => 'Треки';

  @override
  String get commonPlaylist => 'Плейлист';

  @override
  String get commonPlaylists => 'Плейлисти';

  @override
  String get commonSingle => 'Сингл';

  @override
  String get commonLikedSongs => 'Вподобані треки';

  @override
  String get commonAddToLiked => 'Додати до вподобаних треків';

  @override
  String get commonRemoveFromLiked => 'Вилучити з вподобаних треків';

  @override
  String get commonShufflePlay => 'Відтворити у випадковому порядку';

  @override
  String get commonPlay => 'Відтворити';

  @override
  String get commonPause => 'Пауза';

  @override
  String get commonFollow => 'Підписатися';

  @override
  String get commonFollowing => 'Ви підписані';

  @override
  String get commonDownloadToDevice => 'Завантажити на пристрій';

  @override
  String get commonRemoveFromDevice => 'Вилучити з пристрою';

  @override
  String get commonDownloaded => 'Завантажено';

  @override
  String get commonDownloads => 'Завантаження';

  @override
  String get commonAll => 'Усе';

  @override
  String get commonRecentlyPlayed => 'Нещодавно відтворені';

  @override
  String get commonYourLibrary => 'Ваша бібліотека';

  @override
  String get commonHome => 'Головна';

  @override
  String get commonSearch => 'Пошук';

  @override
  String get commonProfile => 'Профіль';

  @override
  String get commonSettings => 'Налаштування';

  @override
  String get commonBuilding => 'Створення…';

  @override
  String get commonBuildNow => 'Створити зараз';

  @override
  String get commonShows => 'Концерти';

  @override
  String get commonPodcasts => 'Подкасти';

  @override
  String commonSongCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count треку',
      many: '$count треків',
      few: '$count треки',
      one: '$count трек',
      zero: 'Немає треків',
    );
    return '$_temp0';
  }

  @override
  String commonMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count хвилини',
      many: '$count хвилин',
      few: '$count хвилини',
      one: '$count хвилина',
    );
    return '$_temp0';
  }

  @override
  String commonError(String error) {
    return 'Помилка: $error';
  }

  @override
  String get apiStatusQueued => 'У черзі';

  @override
  String get apiStatusDownloading => 'Завантаження';

  @override
  String get apiStatusDone => 'Додано до бібліотеки';

  @override
  String get apiStatusUpToDate => 'Уже в бібліотеці';

  @override
  String get apiStatusPartial => 'Додано частково';

  @override
  String get apiStatusNotFound => 'Не знайдено';

  @override
  String get apiStatusCancelled => 'Скасовано';

  @override
  String get apiStatusInterrupted => 'Перервано';

  @override
  String get apiStatusFailed => 'Не вдалося';

  @override
  String get apiExtrasNoResponse => 'Сервер додаткових функцій не відповів.';

  @override
  String get apiAlbumListFailed => 'Не вдалося показати альбоми.';

  @override
  String apiPlaylistSaved(int found, int total) {
    return 'Плейлист у вашій бібліотеці ($found із $total треків)';
  }

  @override
  String apiPlaylistDownloading(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count треку',
      many: '$count треків',
      few: '$count треки',
      one: '$count трек',
    );
    return 'Плейлист у вашій бібліотеці; завантажується ще $_temp0';
  }

  @override
  String get apiBadCredentials => 'Неправильне ім’я користувача або пароль.';

  @override
  String get apiServerUnreachable => 'Не вдалося зв’язатися із сервером.';

  @override
  String get apiQuickConnectOff => 'Quick Connect вимкнено на цьому сервері.';

  @override
  String get apiWrongCurrentPassword => 'Поточний пароль неправильний.';

  @override
  String stateChatShared(String title) {
    return 'Надіслано: $title';
  }

  @override
  String stateDownloadingName(String name) {
    return 'Завантаження: $name';
  }

  @override
  String stateDownloadingRequests(int count) {
    return 'Завантаження запитів: $count';
  }

  @override
  String stateDownloadArrived(String name) {
    return '$name додано до бібліотеки';
  }

  @override
  String stateDownloadPartial(String name) {
    return '$name додано частково';
  }

  @override
  String stateDownloadEnded(String name, String status) {
    return '$name: $status';
  }

  @override
  String get stateNotFromCatalog => 'Цей елемент не з каталогу.';

  @override
  String stateAlreadyDownloading(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Альбом уже завантажується.',
      'artist': 'Дискографія вже завантажується.',
      'other': 'Трек уже завантажується.',
    });
    return '$_temp0';
  }

  @override
  String stateDownloadRequested(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Завантаження альбому. Коли він буде готовий, він з’явиться в дзвіночку.',
      'artist': 'Завантаження дискографії. Коли вона буде готова, вона з’явиться в дзвіночку.',
      'other': 'Завантаження треку. Коли він буде готовий, він з’явиться в дзвіночку.',
    });
    return '$_temp0';
  }

  @override
  String get stateNotifyDownloadsChannel => 'Завантаження';

  @override
  String get stateNotifyDownloadsChannelDesc => 'Прогрес завантаження треків';

  @override
  String get stateNotifyNewsChannel => 'Що нового';

  @override
  String get stateNotifyNewsChannelDesc =>
      'Нові надходження, релізи, Descobertas і Mistura';

  @override
  String get stateOfflineLoose => 'Завантажено окремо';

  @override
  String get stateOfflineDoneTitle => 'Завантажено на цей пристрій';

  @override
  String stateOfflineDoneBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count треку готові для прослуховування офлайн',
      many: '$count треків готові для прослуховування офлайн',
      few: '$count треки готові для прослуховування офлайн',
      one: '$count трек готовий для прослуховування офлайн',
    );
    return '$_temp0';
  }

  @override
  String get stateOfflineProgressTitle => 'Завантаження на цей пристрій';

  @override
  String stateOfflineProgressBody(int done, int total, String name) {
    return '$done із $total • $name';
  }

  @override
  String get stateServerNoReply => 'Сервер не відповів. Перевірте адресу.';

  @override
  String get stateServerNoReplyBoth => 'Сервер не відповів за жодною з адрес.';

  @override
  String get stateTokenStoreUnsupported =>
      'Наразі Pudim може зберігати вхід лише у Windows та Android.';

  @override
  String get stateQualityPoor => 'низька якість';

  @override
  String get stateQualityPartial => 'неповний';

  @override
  String get audioPlaybackChannel => 'Відтворення';

  @override
  String get audioRecentAlbums => 'Нещодавні альбоми';

  @override
  String audioSearchContext(String query) {
    return 'Пошук: $query';
  }

  @override
  String audioRadioContext(String name) {
    return 'Радіо: $name';
  }

  @override
  String podcastsMonthShort(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': 'січ',
      'm2': 'лют',
      'm3': 'бер',
      'm4': 'кві',
      'm5': 'тра',
      'm6': 'чер',
      'm7': 'лип',
      'm8': 'сер',
      'm9': 'вер',
      'm10': 'жов',
      'm11': 'лис',
      'other': 'гру',
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
    return '$h год $min хв';
  }

  @override
  String podcastsMin(int min) {
    return '$min хв';
  }

  @override
  String get podcastsPlayed => 'відтворено';

  @override
  String podcastsTimeLeft(String time) {
    return 'Залишилося $time';
  }

  @override
  String get podcastsSearchHint => 'Пошук подкастів';

  @override
  String get podcastsNothingFound => 'Нічого не знайдено.';

  @override
  String get podcastsYours => 'Ваші подкасти';

  @override
  String get podcastsNewEpisodes => 'Нові випуски';

  @override
  String get podcastsTrendingBrazil => 'У тренді в Бразилії';

  @override
  String get podcastsLoadFailed => 'Не вдалося завантажити. Спробуйте знову';

  @override
  String get podcastsNoEpisodes => 'У стрічці немає випусків.';

  @override
  String podcastsNoEpisodeMatch(String q) {
    return 'Немає випусків за запитом «$q».';
  }

  @override
  String get podcastsKind => 'Подкаст';

  @override
  String get podcastsEpisodes => 'Випуски';

  @override
  String podcastsEpisodesCount(int total) {
    return 'Випуски ($total)';
  }

  @override
  String get podcastsFindEpisode => 'Пошук випусків';

  @override
  String showsMonthName(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': 'січень',
      'm2': 'лютий',
      'm3': 'березень',
      'm4': 'квітень',
      'm5': 'травень',
      'm6': 'червень',
      'm7': 'липень',
      'm8': 'серпень',
      'm9': 'вересень',
      'm10': 'жовтень',
      'm11': 'листопад',
      'other': 'грудень',
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
      'w1': 'пн',
      'w2': 'вт',
      'w3': 'ср',
      'w4': 'чт',
      'w5': 'пт',
      'w6': 'сб',
      'other': 'нд',
    });
    return '$_temp0';
  }

  @override
  String get showsFollowingNone => 'Від виконавців, на яких ви підписані';

  @override
  String showsFollowingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Від $count виконавців, на яких ви підписані',
      many: 'Від $count виконавців, на яких ви підписані',
      few: 'Від $count виконавців, на яких ви підписані',
      one: 'Від $count виконавця, на якого ви підписані',
    );
    return '$_temp0';
  }

  @override
  String showsSearchingFor(int count) {
    return 'шукаємо концерти (виконавців: $count)…';
  }

  @override
  String get showsUpcoming => 'Майбутні';

  @override
  String get showsPast => 'Минулі';

  @override
  String get showsInBrazil => 'У Бразилії';

  @override
  String get showsEmptyFollow =>
      'Підпишіться на виконавців (кнопка «Підписатися» на сторінці виконавця), щоб бачити тут їхні концерти.';

  @override
  String get showsNonePast => 'Концертів ще не записано.';

  @override
  String get showsNoneUpcoming => 'Наразі немає запланованих концертів.';

  @override
  String get showsStillSearching => 'Ще шукаємо…';

  @override
  String get showsSource =>
      'Дати з MusicBrainz (створено фанатами); нові концерти можуть з’являтися із затримкою.';

  @override
  String get showsCancelled => 'скасовано';

  @override
  String get showsFestival => 'фестиваль';

  @override
  String get catalogKindAlbum => 'Альбом';

  @override
  String get catalogKindSingle => 'Сингл';

  @override
  String get catalogKindBroadcast => 'Ефір';

  @override
  String get catalogKindOther => 'Інше';

  @override
  String get catalogSecLive => 'наживо';

  @override
  String get catalogSecCompilation => 'збірка';

  @override
  String get catalogSecSoundtrack => 'саундтрек';

  @override
  String get catalogSecMixtape => 'мікстейп';

  @override
  String get catalogSecInterview => 'інтерв’ю';

  @override
  String get catalogSecSpokenword => 'розмовний жанр';

  @override
  String catalogDownloadingOne(String title) {
    return 'Завантаження: $title';
  }

  @override
  String catalogDownloadingMany(int count, String artist) {
    return 'Завантаження альбомів ($count) виконавця $artist';
  }

  @override
  String catalogCheckingDiscography(int seconds) {
    return 'Перевірка дискографії… $seconds с';
  }

  @override
  String catalogToDownload(int count) {
    return 'Для завантаження: $count';
  }

  @override
  String catalogInLibraryCount(int count) {
    return 'Уже в бібліотеці: $count';
  }

  @override
  String catalogSkippedOneSong(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Пропущено $count релізу з одним треком',
      many: 'Пропущено $count релізів з одним треком',
      few: 'Пропущено $count релізи з одним треком',
      one: 'Пропущено $count реліз з одним треком',
    );
    return '$_temp0';
  }

  @override
  String get catalogPickAll => 'Усі';

  @override
  String get catalogPickStudio => 'Студійні';

  @override
  String get catalogPickNone => 'Жодного';

  @override
  String get catalogDownloadSelected => 'Завантажити вибране';

  @override
  String catalogDownloadNSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Завантажити $count вибраних',
      many: 'Завантажити $count вибраних',
      few: 'Завантажити $count вибрані',
      one: 'Завантажити $count вибраний',
    );
    return '$_temp0';
  }

  @override
  String get catalogNothingMissing => 'Нічого не бракує.';

  @override
  String get catalogPartial => 'частково';

  @override
  String get catalogDownload => 'Завантажити';

  @override
  String get catalogAddToLibrary => 'Додати до вашої бібліотеки';

  @override
  String get catalogInYourLibrary => 'У вашій бібліотеці';

  @override
  String get catalogAllInLibrary => 'усе в бібліотеці';

  @override
  String catalogNInLibrary(int count) {
    return '$count у бібліотеці';
  }

  @override
  String get catalogDownloadAlbum => 'Завантажити альбом';

  @override
  String get catalogArtistNotFound => 'Виконавця не знайдено.';

  @override
  String get catalogFromCatalog => 'З каталогу: ще не в бібліотеці';

  @override
  String get catalogDownloadAll => 'Завантажити все';

  @override
  String get catalogDownloadDiscography => 'Завантажити дискографію';

  @override
  String get catalogPopular => 'Популярне';

  @override
  String get catalogShowLess => 'Показати менше';

  @override
  String get catalogShowMore => 'Показати більше';

  @override
  String get catalogSinglesEps => 'Сингли та EP';

  @override
  String get catalogFansAlsoLike => 'Фанатам також подобається';

  @override
  String get lyricsPlaySomething => 'Увімкніть щось, щоб побачити текст.';

  @override
  String get lyricsNone => 'Для цього треку немає тексту';

  @override
  String get lyricsNoneHint =>
      'Якщо поруч із файлом є .lrc або .txt, текст з’явиться тут.';

  @override
  String get lyricsSynced => 'Синхронізований текст із файлу .lrc';

  @override
  String get lyricsUnsynced => 'Текст без синхронізації';

  @override
  String get profileChangePhoto => 'Змінити фото';

  @override
  String get profileNoPhoto => 'Фото не вибрано';

  @override
  String get profilePhotoTooBig => 'Фото завелике (до 8 МБ)';

  @override
  String get profilePhotoChanged => 'Фото профілю змінено';

  @override
  String get profilePhotoRemoved => 'Фото видалено';

  @override
  String get profileNameSaved => 'Ім’я профілю збережено';

  @override
  String get profileRenameTitle => 'Змінити ім’я користувача?';

  @override
  String profileRenameBody(String name) {
    return 'Ви входитимете як «$name» у Pudim, Jellyfin та інших застосунках (Finamp, Feishin…). Ваші Відкриття, Мікс і Rewind збережуться.';
  }

  @override
  String get profileRenameConfirm => 'Змінити';

  @override
  String profileNowSignedAs(String name) {
    return 'Тепер ви входите як $name';
  }

  @override
  String get profileEnterNewPassword => 'Введіть новий пароль';

  @override
  String get profilePasswordsDiffer => 'Нові паролі не збігаються';

  @override
  String get profilePasswordChanged => 'Пароль змінено';

  @override
  String get profileExtrasUnreachable =>
      'Не вдалося зв’язатися із сервером додаткових функцій; ім’я профілю та ім’я користувача доведеться змінити пізніше.';

  @override
  String get profileNameSection => 'Ім’я профілю';

  @override
  String get profileNameHelp => 'Так вас бачать контакти в чатах.';

  @override
  String get profileYourName => 'Ваше ім’я';

  @override
  String get profileUsernameSection => 'Ім’я користувача';

  @override
  String get profileUsernameHelp =>
      'Ім’я, яке ви використовуєте для входу в Jellyfin (тут і в інших застосунках).';

  @override
  String get profileUsernameHint => 'Ім’я користувача';

  @override
  String get profileChangeUsername => 'Змінити ім’я користувача';

  @override
  String get profilePasswordSection => 'Пароль';

  @override
  String get profileCurrentPassword => 'Поточний пароль';

  @override
  String get profileNewPassword => 'Новий пароль';

  @override
  String get profileRepeatPassword => 'Повторіть новий пароль';

  @override
  String get profileChangePassword => 'Змінити пароль';

  @override
  String get loginServerRequired => 'Введіть адресу вашого сервера Jellyfin.';

  @override
  String get loginUserRequired => 'Введіть ім’я користувача.';

  @override
  String get loginTitle => 'Вхід у Pudim';

  @override
  String get loginSubtitle => 'Використайте свій обліковий запис Jellyfin.';

  @override
  String get loginUsername => 'Ім’я користувача';

  @override
  String get loginPassword => 'Пароль';

  @override
  String get loginShowPassword => 'Показати пароль';

  @override
  String get loginHidePassword => 'Сховати пароль';

  @override
  String get loginSubmit => 'Увійти';

  @override
  String get loginQuickConnect => 'Увійти через Quick Connect';

  @override
  String get loginHideAddresses => 'Сховати адреси';

  @override
  String get loginServerAddress => 'Адреса сервера';

  @override
  String get loginJellyfinServer => 'Сервер Jellyfin';

  @override
  String get loginJellyfinServerExample => 'Напр. https://jellyfin.exemplo.com';

  @override
  String get loginLocalNetwork => 'У локальній мережі (необов’язково)';

  @override
  String get loginLocalNetworkExample =>
      'Напр. http://192.168.0.10:8096. Коли він відповідає, застосунок використовує його замість основного.';

  @override
  String get loginExtrasServer => 'Сервер додаткових функцій (необов’язково)';

  @override
  String get loginExtrasServerHint =>
      'Вмикає чат, Jam, Blend, міксі та Rewind. Залиште порожнім, якщо його немає.';

  @override
  String get loginQcExpired => 'Термін дії коду минув. Спробуйте знову.';

  @override
  String get loginQcInstructions =>
      'На пристрої, де ви вже ввійшли в Jellyfin, відкрийте свій профіль, торкніться Quick Connect і введіть цей код:';

  @override
  String get loginQcWaiting => 'Очікування підтвердження…';

  @override
  String get homeDownloadedOnDevice => 'Завантажено на цей пристрій';

  @override
  String get homeTabMusic => 'Музика';

  @override
  String get homeMadeFor => 'Створено для';

  @override
  String get homeMixDiscoveries => 'Нова музика для вас щотижня';

  @override
  String get homeMixWeekly => 'Ваші улюблені та схожі треки щотижня';

  @override
  String get homeMixRadar =>
      'Нові релізи від виконавців, на яких ви підписані, щоп’ятниці';

  @override
  String get homeMixDaylist => 'Змінюється протягом дня';

  @override
  String get homeMixBlend => 'Ваші смаки разом';

  @override
  String get homeMixAuto => 'Автоматичний мікс';

  @override
  String get homeSpotifyPlaylists => 'Ваші плейлисти зі Spotify';

  @override
  String get homeFromSpotify => 'Зі Spotify';

  @override
  String get homeYourPlaylists => 'Ваші плейлисти';

  @override
  String get homeTopAlbums => 'Ваші найпрослуховуваніші альбоми';

  @override
  String get homeTopArtists => 'Ваші улюблені виконавці';

  @override
  String get homeRecentlyAdded => 'Нещодавно додані';

  @override
  String get homeYourPodcasts => 'Ваші подкасти';

  @override
  String get homeRadiosTitle => 'Рекомендовані радіостанції';

  @override
  String get homeRadiosSubtitle =>
      'Музика без перерви на основі ваших улюблених виконавців.';

  @override
  String get homeRadioBadge => 'РАДІО';

  @override
  String homeRadioWith(String name) {
    return 'З $name та схожими виконавцями';
  }

  @override
  String searchNoResults(String query) {
    return 'Нічого не знайдено за запитом «$query»';
  }

  @override
  String get searchNoResultsHint =>
      'Перевірте правопис або використайте менше чи інші слова.';

  @override
  String searchCatalogNoResponse(String error) {
    return 'Каталог не відповів: $error';
  }

  @override
  String get searchAlsoCatalog => 'Шукаємо також у каталозі…';

  @override
  String searchLibraryOnly(String error) {
    return 'Лише бібліотека: каталог не відповів ($error).';
  }

  @override
  String get searchTopResult => 'Найкращий результат';

  @override
  String get searchSpotifyPlaylists => 'Плейлисти зі Spotify';

  @override
  String get searchRecent => 'Нещодавні пошуки';

  @override
  String get searchClear => 'Очистити';

  @override
  String get searchBrowseAll => 'Переглянути все';

  @override
  String get searchHint => 'Що хочете послухати?';

  @override
  String get albumDownloadedType => 'Альбом • завантажено на цей пристрій';

  @override
  String albumSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count треку',
      many: '$count треків',
      few: '$count треки',
      one: '$count трек',
    );
    return '$_temp0, $total';
  }

  @override
  String get albumRemoveFromLibrary => 'Вилучити з вашої бібліотеки';

  @override
  String get albumSaveToLibrary => 'Зберегти у вашій бібліотеці';

  @override
  String albumMoreOptions(String name) {
    return 'Більше опцій для: $name';
  }

  @override
  String albumDisc(int number) {
    return 'Диск $number';
  }

  @override
  String albumMoreFrom(String name) {
    return 'Більше від: $name';
  }

  @override
  String artistAlbumsInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count альбому у вашій бібліотеці',
      many: '$count альбомів у вашій бібліотеці',
      few: '$count альбоми у вашій бібліотеці',
      one: '$count альбом у вашій бібліотеці',
    );
    return '$_temp0';
  }

  @override
  String artistPlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count прослуховування',
      many: '$count прослуховувань',
      few: '$count прослуховування',
      one: '$count прослуховування',
    );
    return '$_temp0';
  }

  @override
  String artistMoreOptions(String name) {
    return 'Більше опцій для: $name';
  }

  @override
  String get artistPopular => 'Популярне';

  @override
  String get artistShowLess => 'Показати менше';

  @override
  String get artistShowMore => 'Показати більше';

  @override
  String get artistYouLiked => 'Вам сподобалось';

  @override
  String artistFrom(String name) {
    return 'Від: $name';
  }

  @override
  String get artistDiscography => 'Дискографія';

  @override
  String get artistPopularReleases => 'Популярні релізи';

  @override
  String get artistSinglesEps => 'Сингли та EP';

  @override
  String get artistFansAlsoLike => 'Фанатам також подобається';

  @override
  String get artistAppearsOn => 'З’являється на';

  @override
  String get artistAbout => 'Про виконавця';

  @override
  String get playlistOriginSpotify => 'Зі Spotify';

  @override
  String get playlistOriginMadeForYou => 'Створено для вас';

  @override
  String get playlistOriginAuto => 'Автоматичний мікс';

  @override
  String get playlistDownloadedOnDevice => 'Завантажено на цей пристрій';

  @override
  String get playlistOnDevice => 'На цьому пристрої';

  @override
  String get playlistPlaysOffline => 'Грає без інтернету.';

  @override
  String playlistPlaysOfflineDownloading(int count) {
    return 'Грає без інтернету. Завантажується ще: $count…';
  }

  @override
  String playlistSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count треку',
      many: '$count треків',
      few: '$count треки',
      one: '$count трек',
    );
    return '$_temp0, $total';
  }

  @override
  String playlistMoreOptions(String name) {
    return 'Більше опцій для: $name';
  }

  @override
  String get playlistSearchHint => 'Пошук у плейлисті';

  @override
  String get playlistEmpty => 'Тут ще немає треків.';

  @override
  String get playlistErrNoPermission =>
      'У вас немає дозволу редагувати цей плейлист.';

  @override
  String playlistErrServer(String code) {
    return 'Сервер відхилив запит ($code).';
  }

  @override
  String get playlistErrNoResponse => 'немає відповіді';

  @override
  String get playlistDownloadFirst =>
      'Спочатку завантажте трек, щоб додати його до плейлиста';

  @override
  String get playlistAddTo => 'Додати до плейлиста';

  @override
  String get playlistNew => 'Новий плейлист';

  @override
  String playlistAddedTo(String name) {
    return 'Додано до: $name';
  }

  @override
  String get playlistNameHint => 'Назва плейлиста';

  @override
  String get playlistCreate => 'Створити';

  @override
  String playlistCreated(String name) {
    return 'Плейлист $name створено';
  }

  @override
  String get playlistRemoved => 'Вилучено з плейлиста';

  @override
  String get playlistInviteTitle => 'Запросити до редагування';

  @override
  String get playlistInviteSubtitle =>
      'Вони побачать плейлист у своїй бібліотеці та зможуть додавати й вилучати треки.';

  @override
  String get playlistInviteOwnerOnly => 'Запрошувати може лише автор плейлиста';

  @override
  String playlistInvited(String who, String playlist) {
    return '$who тепер може редагувати: $playlist';
  }

  @override
  String playlistCollaborative(String members) {
    return 'Спільний · $members';
  }

  @override
  String get playlistSmartShuffleTooltip =>
      'Smart Shuffle: випадковий порядок з рекомендаціями';

  @override
  String get playlistSmartShuffleOn =>
      'Smart Shuffle увімкнено: рекомендації позначено ✦';

  @override
  String get playlistAddedToThis => 'Додано до плейлиста';

  @override
  String get playlistRecommendation => 'Рекомендація Smart Shuffle';

  @override
  String get playlistPutIn => 'Додати до плейлиста';

  @override
  String get settingsSectionAccount => 'Обліковий запис';

  @override
  String get settingsProfileSubtitle => 'Ім’я, ім’я користувача та пароль';

  @override
  String settingsConnectedAt(String url) {
    return 'Підключено до $url';
  }

  @override
  String get settingsSignOut => 'Вийти';

  @override
  String get accountsTitle => 'Облікові записи';

  @override
  String get accountsAdd => 'Додати обліковий запис або сервер';

  @override
  String get accountsSwitch => 'Змінити';

  @override
  String get accountsInUse => 'Використовується';

  @override
  String accountsOn(String user, String host) {
    return '$user на $host';
  }

  @override
  String get loginBackToAccount => 'Повернутися до поточного облікового запису';

  @override
  String get settingsSectionServer => 'Сервер';

  @override
  String get settingsLocalNetwork => 'У локальній мережі';

  @override
  String get settingsServerNote =>
      'Щоб змінити адреси Jellyfin, вийдіть і відкрийте «Адреса сервера» на екрані входу.';

  @override
  String get settingsExtrasServer => 'Сервер додаткових функцій';

  @override
  String get settingsExtrasNotConfigured =>
      'Не налаштовано (чат, Jam, Blend, міксі та Recap залишаються прихованими)';

  @override
  String get settingsConfigure => 'Налаштувати';

  @override
  String get settingsChange => 'Змінити';

  @override
  String get settingsSectionPlayback => 'Відтворення';

  @override
  String get settingsQualityWifi => 'Якість через Wi-Fi';

  @override
  String get settingsQualityWifiSubtitle =>
      'Оригінальна відтворює файл таким, як він є в бібліотеці.';

  @override
  String get settingsQualityMobile => 'Якість через мобільні дані';

  @override
  String get settingsQualityMobileSubtitle =>
      'Нижча якість витрачає менше мобільних даних.';

  @override
  String get settingsQualityOriginal => 'Оригінальна';

  @override
  String get settingsAppliesNextSong => 'Діє з наступного треку';

  @override
  String get settingsSectionAbout => 'Про застосунок';

  @override
  String settingsBuild(int build) {
    return 'Збірка $build';
  }

  @override
  String get settingsExtrasEmptyHint =>
      'Залиште порожнім, щоб вимкнути додаткові функції.';

  @override
  String get settingsAutoplay => 'Автовідтворення';

  @override
  String get settingsAutoplaySubtitle =>
      'Коли черга закінчується, продовжує грати схожі треки (мікс Jellyfin).';

  @override
  String get settingsNormalize => 'Нормалізувати гучність';

  @override
  String get settingsNormalizeSubtitle =>
      'Відтворює всі треки з однаковою гучністю на основі аналізу Jellyfin.';

  @override
  String get settingsScrobble => 'Скроблінг';

  @override
  String get settingsLoading => 'Завантаження…';

  @override
  String get settingsLastfmNoKey =>
      'На сервері додаткових функцій ще не налаштовано ключ API Last.fm.';

  @override
  String settingsConnectedAs(String name) {
    return 'Підключено як $name';
  }

  @override
  String get settingsLastfmConnectedSubtitle =>
      'Усе, що ви слухаєте в Pudim, потрапляє у ваш профіль Last.fm.';

  @override
  String get settingsDisconnect => 'Відключити';

  @override
  String get settingsLastfmAuthorize => 'Авторизуйтеся на сторінці Last.fm';

  @override
  String get settingsLastfmAuthorizeSubtitle =>
      'Після натискання там «Yes, allow access» поверніться й торкніться «Готово».';

  @override
  String get settingsFinish => 'Готово';

  @override
  String get settingsLastfmConnected => 'Last.fm підключено';

  @override
  String get settingsLastfmScrobbleSubtitle =>
      'Записує в Last.fm кожен трек, який ви слухаєте.';

  @override
  String get settingsConnect => 'Підключити';

  @override
  String get sidebarOpenLibrary => 'Відкрити вашу бібліотеку';

  @override
  String get sidebarCollapseLibrary => 'Згорнути вашу бібліотеку';

  @override
  String sidebarOnDeviceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count треку',
      many: '$count треків',
      few: '$count треки',
      one: '$count трек',
    );
    return 'На пристрої • $_temp0';
  }

  @override
  String sidebarPlaylistCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count треку',
      many: '$count треків',
      few: '$count треки',
      one: '$count трек',
    );
    return 'Плейлист • $_temp0';
  }

  @override
  String sidebarAlbumBy(String artist) {
    return 'Альбом • $artist';
  }

  @override
  String get sidebarSearchLibrary => 'Пошук у вашій бібліотеці';

  @override
  String get sidebarSortBy => 'Сортувати за';

  @override
  String get sidebarSortRecents => 'Нещодавні';

  @override
  String get sidebarSortAdded => 'Нещодавно додані';

  @override
  String get sidebarSortAlpha => 'За алфавітом';

  @override
  String get sidebarSortCreator => 'Автор';

  @override
  String get topBarSearchHint => 'Що хочете відтворити?';

  @override
  String get topBarClearSearch => 'Очистити поле пошуку';

  @override
  String get topBarBrowse => 'Огляд';

  @override
  String get topBarMenu => 'Меню';

  @override
  String get topBarLogoutAccount => 'Вийти';

  @override
  String get topBarQuit => 'Закрити Pudim';

  @override
  String get topBarLogout => 'Вийти';

  @override
  String get playerBarSmartShuffleOff => 'Вимкнути Smart Shuffle';

  @override
  String get playerBarSmartShuffleOn => 'Увімкнути Smart Shuffle';

  @override
  String get playerBarShuffleOff => 'Вимкнути випадковий порядок';

  @override
  String get playerBarShuffleOn => 'Увімкнути випадковий порядок';

  @override
  String get playerBarPlay => 'Відтворити';

  @override
  String get playerBarForward => 'Далі';

  @override
  String get playerBarRepeatOn => 'Увімкнути повтор';

  @override
  String get playerBarRepeatOne => 'Увімкнути повтор одного треку';

  @override
  String get playerBarRepeatOff => 'Вимкнути повтор';

  @override
  String get playerBarNowPlayingView => 'Екран відтворення';

  @override
  String get playerBarLyrics => 'Текст';

  @override
  String get playerBarUnmute => 'Увімкнути звук';

  @override
  String get playerBarMute => 'Вимкнути звук';

  @override
  String get rightPanelNothingPlaying =>
      'Увімкніть щось, щоб побачити тут, що грає.';

  @override
  String get rightPanelLyricsPreview => 'Попередній перегляд тексту';

  @override
  String get rightPanelAboutArtist => 'Про виконавця';

  @override
  String get rightPanelNextUp => 'Далі в черзі';

  @override
  String get rightPanelOpenQueue => 'Відкрити чергу';

  @override
  String get rightPanelQueueEmptyTitle => 'Додати до черги';

  @override
  String get rightPanelQueueEmptyHint =>
      'Натисніть «Додати до черги» в меню треку, щоб розмістити його тут';

  @override
  String get rightPanelNowPlaying => 'Зараз грає';

  @override
  String get rightPanelNextInQueue => 'Наступний у черзі';

  @override
  String rightPanelNextFrom(String name) {
    return 'Далі з: $name';
  }

  @override
  String get nowPlayingPlayingFrom => 'ВІДТВОРЮЄТЬСЯ З';

  @override
  String get nowPlayingMoreOptions => 'Більше опцій';

  @override
  String get chatChats => 'Чати';

  @override
  String chatYouSaid(String text) {
    return 'Ви: $text';
  }

  @override
  String get chatContacts => 'Контакти';

  @override
  String get chatServerUnreachable =>
      'Не вдалося зв’язатися із сервером додаткових функцій.';

  @override
  String get chatMessageHint => 'Повідомлення';

  @override
  String chatJoinedJam(String title) {
    return 'Ви приєдналися до: $title';
  }

  @override
  String chatCouldNotPlay(String error) {
    return 'Не вдалося відтворити: $error';
  }

  @override
  String get chatJamCardSubtitle => 'Слухайте разом, з однією чергою';

  @override
  String get chatInJam => 'У Jam';

  @override
  String get chatJoin => 'Приєднатися';

  @override
  String get chatNoOtherAccounts => 'На сервері немає інших облікових записів.';

  @override
  String chatSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count треку',
      many: '$count треків',
      few: '$count треки',
      one: '$count трек',
    );
    return '$_temp0';
  }

  @override
  String chatSentTo(String name) {
    return 'Надіслано: $name';
  }

  @override
  String chatShareTitle(String title) {
    return 'Поділитися: $title';
  }

  @override
  String get chatNoteHint => 'Нотатка (необов’язково)';

  @override
  String get blendWorking => 'Створення Blend…';

  @override
  String blendAffinityButton(int affinity) {
    return 'Blend $affinity%';
  }

  @override
  String get blendCreate => 'Створити Blend';

  @override
  String blendWith(String name) {
    return 'Blend з: $name';
  }

  @override
  String get blendExplain =>
      'Один плейлист для вас обох: те, що ви слухаєте разом, спільні виконавці та трохи того, що кожен з вас любить найбільше. Він показує, наскільки збігаються ваші смаки, і оновлюється щодня.';

  @override
  String get blendNotNow => 'Не зараз';

  @override
  String blendAffinityTitle(int affinity) {
    return 'Збіг смаків: $affinity%';
  }

  @override
  String blendInCommon(String artists) {
    return 'Спільне: $artists';
  }

  @override
  String blendOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Відкрити Blend ($count треку)',
      many: 'Відкрити Blend ($count треків)',
      few: 'Відкрити Blend ($count треки)',
      one: 'Відкрити Blend ($count трек)',
    );
    return '$_temp0';
  }

  @override
  String get blendRefreshNow => 'Оновити зараз';

  @override
  String get blendUndo => 'Видалити Blend';

  @override
  String get blendRefreshing => 'Оновлення Blend…';

  @override
  String get blendUndoTitle => 'Видалити Blend?';

  @override
  String blendUndoBody(String name) {
    return 'Плейлист зникне для вас і для: $name.';
  }

  @override
  String get blendUndoConfirm => 'Видалити';

  @override
  String get blendUndone => 'Blend видалено';

  @override
  String get jamStart => 'Почати Jam';

  @override
  String jamTooltip(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jam ($count особи)',
      many: 'Jam ($count осіб)',
      few: 'Jam ($count особи)',
      one: 'Jam ($count особа)',
    );
    return '$_temp0';
  }

  @override
  String get jamSubIdle =>
      'Слухайте разом з іншими обліковими записами в одній черзі.';

  @override
  String get jamSubHost => 'Ви керуєте. Усі можуть пропонувати треки.';

  @override
  String get jamSubGuest => 'Ваші дії та треки потрапляють у чергу всіх.';

  @override
  String get jamPlayFirst => 'Увімкніть щось, перш ніж почати Jam.';

  @override
  String jamMembers(int count) {
    return 'У Jam ($count)';
  }

  @override
  String jamYouSuffix(String name) {
    return '$name (ви)';
  }

  @override
  String get jamHost => 'Ведучий';

  @override
  String get jamInvite => 'Запросити';

  @override
  String get jamInviteTitle => 'Запросити до Jam';

  @override
  String get jamInviteSubtitle => 'Запрошення надійде в їхній чат.';

  @override
  String jamInviteSent(String name) {
    return 'Запрошення надіслано: $name';
  }

  @override
  String get jamEnd => 'Завершити Jam';

  @override
  String get jamLeave => 'Вийти з Jam';

  @override
  String recapTitle(int year) {
    return 'Ваш Wrapped $year';
  }

  @override
  String get recapShort => 'Wrapped';

  @override
  String recapBannerBody(String minutes) {
    return '$minutes хвилин музики цього року. Подивіться, що ви слухали найбільше.';
  }

  @override
  String get recapEmpty => 'Ще немає прослуховувань, щоб створити ваш Wrapped.';

  @override
  String get recapShareCards => 'Поділитися картками';

  @override
  String get recapBigMinutes => 'хвилин прослуховування';

  @override
  String get recapBigSongs => 'різних треків';

  @override
  String get recapBigArtists => 'виконавців';

  @override
  String get recapBigDays => 'днів з музикою';

  @override
  String get recapBigStreak => 'днів поспіль, ваш рекорд';

  @override
  String get recapTopArtists => 'Ваші найпопулярніші виконавці року';

  @override
  String recapMinutesValue(String minutes) {
    return '$minutes хвилин';
  }

  @override
  String get recapTopSongs => 'Ваші найпопулярніші треки року';

  @override
  String recapPlaysLine(String artist, String plays) {
    return '$artist • прослуховувань: $plays';
  }

  @override
  String get recapSongGone => 'Цього треку вже немає в бібліотеці';

  @override
  String get recapTopAlbums => 'Ваші найпопулярніші альбоми року';

  @override
  String get recapTopGenres => 'Ваші найпрослуховуваніші жанри';

  @override
  String recapGenreLine(String genre, String minutes) {
    return '$genre • $minutes хв';
  }

  @override
  String get recapMonthly => 'Місяць за місяцем';

  @override
  String recapMonthTooltip(String month, String minutes) {
    return '$month: $minutes хв';
  }

  @override
  String get recapListeningStyle => 'Як ви слухаєте';

  @override
  String recapFavHour(String hour) {
    return 'Улюблена година: $hour:00';
  }

  @override
  String recapFavWeekday(String day) {
    return 'Улюблений день тижня: $day';
  }

  @override
  String recapBiggestDay(String date, String minutes) {
    return 'Ваш найактивніший день: $date, $minutes хвилин';
  }

  @override
  String recapNewArtists(int count, String n) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$n нового виконавця для вас',
      many: '$n нових виконавців для вас',
      few: '$n нові виконавці для вас',
      one: '$n новий виконавець для вас',
    );
    return '$_temp0';
  }

  @override
  String recapSpotifyAdded(String added) {
    return 'Додано прослуховувань зі Spotify: $added.';
  }

  @override
  String recapSpotifyAddedDup(String added, String dup) {
    return 'Додано прослуховувань зі Spotify: $added (ще $dup уже були з Pudim).';
  }

  @override
  String get recapSpotifyRemoveTitle => 'Видалити історію зі Spotify?';

  @override
  String get recapSpotifyRemoveBody =>
      'Ваш Wrapped знову враховуватиме лише те, що ви слухали в Pudim/Jellyfin. Ви зможете імпортувати її пізніше.';

  @override
  String get recapSpotifyRemoveConfirm => 'Видалити';

  @override
  String recapSpotifyRemoved(String count) {
    return 'Видалено прослуховувань зі Spotify: $count';
  }

  @override
  String get recapSpotifyTitle => 'Історія зі Spotify';

  @override
  String recapSpotifyHasData(String count, String from, String to) {
    return 'Прослуховувань зі Spotify у вашому Wrapped: $count ($from – $to). Ви можете завантажити новіший файл: те, що вже є, не буде пораховано двічі.';
  }

  @override
  String get recapSpotifyIntro =>
      'Додайте роки до Pudim. У Spotify відкрийте Обліковий запис > Конфіденційність > Завантажити ваші дані та виберіть «Extended streaming history». Коли прийде лист, виберіть тут my_spotify_data.zip.';

  @override
  String get recapSpotifyImportAnother => 'Імпортувати інший файл';

  @override
  String get recapSpotifyImport => 'Імпортувати історію';

  @override
  String get recapSpotifyRemoveBtn => 'Видалити з Wrapped';

  @override
  String get recapShareSaveDialog => 'Зберегти картку';

  @override
  String get recapShareSaved => 'Картку збережено';

  @override
  String recapShareSaveFailed(String error) {
    return 'Не вдалося зберегти: $error';
  }

  @override
  String recapShareShareFailed(String error) {
    return 'Не вдалося поділитися: $error';
  }

  @override
  String recapShareText(int year) {
    return 'Мій Wrapped $year у Pudim';
  }

  @override
  String get recapShareMyArtists => 'Мої найпопулярніші виконавці року';

  @override
  String get recapShareMySongs => 'Мої найпопулярніші треки року';

  @override
  String recapMinShort(String minutes) {
    return '$minutes хв';
  }

  @override
  String get recapShareSaveImage => 'Зберегти зображення';

  @override
  String get recapShareButton => 'Поділитися';

  @override
  String recapBrand(int year) {
    return 'Wrapped $year';
  }

  @override
  String get recapShareMyYear => 'Мій рік у музиці';

  @override
  String recapShareYearOf(String name) {
    return 'Рік у музиці: $name';
  }

  @override
  String get recapShareTopArtist => 'мій виконавець року';

  @override
  String recapShareGenres(String genres) {
    return 'Жанри: $genres';
  }

  @override
  String get widgetActionsAddedToLiked => 'Додано до вподобаних треків';

  @override
  String get widgetActionsRemovedFromLiked => 'Вилучено з вподобаних треків';

  @override
  String get widgetActionsUnfollowed => 'Підписку скасовано';

  @override
  String get widgetActionsSavedToLibrary => 'Збережено у вашій бібліотеці';

  @override
  String get widgetActionsRemovedFromLibrary => 'Вилучено з вашої бібліотеки';

  @override
  String get widgetActionsAddToQueue => 'Додати до черги';

  @override
  String get widgetActionsAddedToQueue => 'Додано до черги';

  @override
  String get widgetActionsPlayNext => 'Відтворити наступним';

  @override
  String get widgetActionsGoToPodcast => 'Перейти до подкасту';

  @override
  String get widgetActionsRemoveFromQueue => 'Вилучити з черги';

  @override
  String get widgetActionsAddToPlaylist => 'Додати до плейлиста';

  @override
  String get widgetActionsRemoveFromThisPlaylist =>
      'Вилучити з цього плейлиста';

  @override
  String get widgetActionsInviteToEdit => 'Запросити до редагування';

  @override
  String get widgetActionsKeepInPlaylist => 'Залишити в плейлисті';

  @override
  String get widgetActionsDownloadTrack => 'Завантажити трек';

  @override
  String get widgetActionsDownloadAlbum => 'Завантажити альбом';

  @override
  String get widgetActionsDownloadDiscography => 'Завантажити дискографію';

  @override
  String get widgetActionsSearchAlbums => 'Знайти альбоми';

  @override
  String widgetActionsImproveQuality(int count) {
    return 'Покращити якість ($count)';
  }

  @override
  String widgetActionsImprovingAlbums(int count) {
    return 'Пошук кращих версій альбомів: $count';
  }

  @override
  String get widgetActionsShare => 'Поділитися';

  @override
  String get widgetActionsSearchFlac => 'Знайти у FLAC';

  @override
  String widgetActionsSearchingFlac(String name) {
    return 'Пошук «$name» у FLAC; якщо знайдеться, замінить MP3';
  }

  @override
  String get widgetActionsTrackRemovedFromDevice => 'Вилучено з пристрою';

  @override
  String get widgetActionsRemovedFromDevice => 'Вилучено з пристрою';

  @override
  String get widgetActionsDownloadingToDevice =>
      'Завантаження на пристрій для прослуховування офлайн';

  @override
  String get widgetActionsUnfollow => 'Скасувати підписку';

  @override
  String get widgetActionsRemoveFromLibrary => 'Вилучити з вашої бібліотеки';

  @override
  String get widgetActionsAddToLibrary => 'Додати до вашої бібліотеки';

  @override
  String get widgetActionsGoToSongRadio => 'Перейти до радіо треку';

  @override
  String get widgetActionsStartMix => 'Запустити мікс';

  @override
  String widgetActionsMixOf(String name) {
    return 'Мікс: $name';
  }

  @override
  String get widgetActionsGoToArtist => 'Перейти до виконавця';

  @override
  String get widgetActionsGoToAlbum => 'Перейти до альбому';

  @override
  String get widgetActionsCopyName => 'Копіювати назву';

  @override
  String get widgetActionsCopied => 'Скопійовано';

  @override
  String widgetDownloadsBellDownloading(int count) {
    return 'Завантажується: $count';
  }

  @override
  String get widgetDownloadsBellEmpty =>
      'Тут поки нічого немає. Увімкніть трек зі значком хмарки або скористайтеся «Завантажити» в меню ⋯, щоб перенести його з каталогу до бібліотеки.';

  @override
  String get widgetDownloadsBellKindDiscography => 'Дискографія';

  @override
  String get widgetDownloadsBellKindFlac => 'У FLAC';

  @override
  String get widgetDownloadsBellKindQuality => 'Якість';

  @override
  String get widgetDownloadsBellOptions => 'Опції';

  @override
  String get widgetDownloadsBellCancelled => 'Завантаження скасовано';

  @override
  String get widgetDownloadsBellRetrying => 'Повторна спроба';

  @override
  String get widgetDownloadsBellRemovedFromList => 'Вилучено зі списку';

  @override
  String get widgetDownloadsBellDetails => 'Переглянути деталі';

  @override
  String get widgetDownloadsBellRemoveFromList => 'Вилучити зі списку';

  @override
  String get widgetMixSearchingReleases => 'Пошук нових релізів…';

  @override
  String get widgetMixBuildingDaylist => 'Створення вашого daylist…';

  @override
  String get widgetMixNewDiscoveriesTitle => 'Нові Щотижневі відкриття?';

  @override
  String get widgetMixNewMixTitle => 'Новий Щотижневий мікс?';

  @override
  String get widgetMixNewDiscoveriesBody =>
      'Треки, які ви ще не слухали, залишать плейлист, а на їхнє місце прийде близько 30 нових. Це вже відбувається автоматично щопонеділка.';

  @override
  String get widgetMixNewMixBody =>
      'Створює його наново з ваших улюблених, найпрослуховуваніших і схожих треків. Це вже відбувається автоматично щопонеділка.';

  @override
  String get widgetMixNotNow => 'Не зараз';

  @override
  String get widgetMixBuildingDiscoveries => 'Створення ваших Відкриттів…';

  @override
  String get widgetMixBuildingMix => 'Створення вашого Міксу…';

  @override
  String widgetMixBuiltOn(String date) {
    return 'Створено $date';
  }

  @override
  String get widgetMixRedo => 'Створити наново';

  @override
  String get widgetMixRefresh => 'Оновити';

  @override
  String get widgetMixCreateDiscoveries => 'Створити ваші Щотижневі відкриття';

  @override
  String get widgetMixCreateMix => 'Створити ваш Щотижневий мікс';

  @override
  String get widgetMixCreateRadar => 'Створити ваш Радар новинок';

  @override
  String get widgetMixCreateDaylist => 'Створити ваш daylist';

  @override
  String get widgetOfflineBanner =>
      'Немає інтернету · показано те, що збережено на пристрої';

  @override
  String widgetOfflineDownloadingProgress(int done, int total) {
    return 'Завантаження $done із $total';
  }

  @override
  String get widgetUpdateReady => 'Нова версія Pudim готова';

  @override
  String widgetUpdateReadyNotes(String notes) {
    return 'Нова версія Pudim · $notes';
  }

  @override
  String get widgetUpdateAction => 'Оновити';

  @override
  String widgetSleepShortMinutes(int count) {
    return '$count хв';
  }

  @override
  String widgetSleepShortSeconds(int count) {
    return '$count с';
  }

  @override
  String get widgetSleepStopsAtEnd => 'Зупиниться наприкінці треку';

  @override
  String widgetSleepStopsIn(String time) {
    return 'Зупиниться через $time';
  }

  @override
  String get widgetSleepTimer => 'Таймер сну';

  @override
  String get widgetSleepTurnOff => 'Вимкнути таймер';

  @override
  String get widgetSleepOneHour => '1 година';

  @override
  String get widgetSleepOneAndHalfHours => '1 година 30 хвилин';

  @override
  String get widgetSleepEndOfSong => 'Кінець треку';

  @override
  String get widgetSleepTurnedOff => 'Таймер вимкнено';

  @override
  String get widgetSleepStopsWhenSongEnds =>
      'Музика зупиниться, коли закінчиться цей трек';

  @override
  String widgetSleepSongStopsIn(String time) {
    return 'Музика зупиниться через $time';
  }

  @override
  String get widgetSpeedPodcast => 'Швидкість подкасту';

  @override
  String get widgetCommonCatalogBadge => 'З каталогу: ще не у вашій бібліотеці';

  @override
  String get widgetCommonShowAll => 'Показати все';

  @override
  String get widgetCommonSomethingWentWrong => 'Щось пішло не так';

  @override
  String get widgetCommonListenDownloaded => 'Слухати завантажені треки';

  @override
  String get widgetTracksTitle => 'Назва';

  @override
  String get widgetTracksDateAdded => 'Дата додавання';

  @override
  String widgetTracksAddedBy(String name) {
    return 'додав(ла): $name';
  }

  @override
  String get widgetTracksMoreOptions => 'Більше опцій';

  @override
  String widgetTracksAddedDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get castTooltip => 'Трансляція';

  @override
  String get castTitle => 'Відтворити на';

  @override
  String get castThisDevice => 'Цей пристрій';

  @override
  String get castSearching => 'Пошук пристроїв у мережі…';

  @override
  String get castNone =>
      'Chromecast не знайдено. Він має бути в тій самій мережі Wi-Fi.';

  @override
  String get castSearchAgain => 'Шукати знову';

  @override
  String get castStop => 'Зупинити трансляцію';

  @override
  String castPlayingOn(String name) {
    return 'Грає на $name';
  }

  @override
  String castFailed(String name) {
    return 'Не вдалося підключитися до $name';
  }

  @override
  String get settingsSectionAppearance => 'Вигляд';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get settingsThemeSubtitle => 'Змінює кольори одразу.';

  @override
  String get themeNightDesc =>
      'Темна, заокруглені картки й плавучий міні-плеєр.';

  @override
  String get themeRedDesc =>
      'Чистий чорний із червоним, великі квадратні обкладинки, міні-плеєр біля панелі.';

  @override
  String get themeWaveDesc =>
      'Фіолетові градієнти, жирний шрифт і міні-плеєр-пігулка.';

  @override
  String get themeRetroDesc =>
      'Сіре обʼємне вікно, зелений дисплей із біжучим рядком і текстові списки.';

  @override
  String get themeClassicDesc =>
      'Глянцеве синьо-чорне скло, кнопка-куля, візуалізатор і списки-таблиці.';

  @override
  String get settingsCheckUpdates => 'Перевірити оновлення';

  @override
  String get updateChecking => 'Перевірка…';

  @override
  String updateUpToDate(int build) {
    return 'У вас найновіша версія (збірка $build).';
  }

  @override
  String updateDownloading(int build, int percent) {
    return 'Завантаження збірки $build… $percent%';
  }

  @override
  String updateFailed(String error) {
    return 'Не вдалося перевірити: $error';
  }

  @override
  String get updateUnavailable => 'Сервер доповнень не налаштовано.';
}
