// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class L10nRu extends L10n {
  L10nRu([String locale = 'ru']) : super(locale);

  @override
  String get languageTitle => 'Язык';

  @override
  String get languageSubtitle => 'Язык интерфейса';

  @override
  String get languageSystem => 'Как в системе';

  @override
  String get commonCancel => 'Отмена';

  @override
  String get commonClose => 'Закрыть';

  @override
  String get commonBack => 'Назад';

  @override
  String get commonSave => 'Сохранить';

  @override
  String get commonEdit => 'Изменить';

  @override
  String get commonDelete => 'Удалить';

  @override
  String get commonRemove => 'Убрать';

  @override
  String get commonOk => 'ОК';

  @override
  String get commonRetry => 'Повторить';

  @override
  String get commonQueue => 'Очередь';

  @override
  String get commonAlbum => 'Альбом';

  @override
  String get commonAlbums => 'Альбомы';

  @override
  String get commonArtist => 'Исполнитель';

  @override
  String get commonArtists => 'Исполнители';

  @override
  String get commonSong => 'Трек';

  @override
  String get commonSongs => 'Треки';

  @override
  String get commonPlaylist => 'Плейлист';

  @override
  String get commonPlaylists => 'Плейлисты';

  @override
  String get commonSingle => 'Сингл';

  @override
  String get commonLikedSongs => 'Любимые треки';

  @override
  String get commonAddToLiked => 'Добавить в «Любимые треки»';

  @override
  String get commonRemoveFromLiked => 'Удалить из «Любимых треков»';

  @override
  String get commonShufflePlay => 'Перемешать';

  @override
  String get commonPlay => 'Слушать';

  @override
  String get commonPause => 'Пауза';

  @override
  String get commonFollow => 'Подписаться';

  @override
  String get commonFollowing => 'Вы подписаны';

  @override
  String get commonDownloadToDevice => 'Скачать на устройство';

  @override
  String get commonRemoveFromDevice => 'Удалить с устройства';

  @override
  String get commonDownloaded => 'Скачано';

  @override
  String get commonDownloads => 'Загрузки';

  @override
  String get commonAll => 'Все';

  @override
  String get commonRecentlyPlayed => 'Недавно прослушано';

  @override
  String get commonYourLibrary => 'Моя медиатека';

  @override
  String get commonHome => 'Главная';

  @override
  String get commonSearch => 'Поиск';

  @override
  String get commonProfile => 'Профиль';

  @override
  String get commonSettings => 'Настройки';

  @override
  String get commonBuilding => 'Создаём…';

  @override
  String get commonBuildNow => 'Создать';

  @override
  String get commonShows => 'Концерты';

  @override
  String get commonPodcasts => 'Подкасты';

  @override
  String commonSongCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count трека',
      many: '$count треков',
      few: '$count трека',
      one: '$count трек',
      zero: 'Нет треков',
    );
    return '$_temp0';
  }

  @override
  String commonMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count минуты',
      many: '$count минут',
      few: '$count минуты',
      one: '$count минута',
    );
    return '$_temp0';
  }

  @override
  String commonError(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get apiStatusQueued => 'В очереди';

  @override
  String get apiStatusDownloading => 'Скачивается';

  @override
  String get apiStatusDone => 'Добавлено в медиатеку';

  @override
  String get apiStatusUpToDate => 'Уже в медиатеке';

  @override
  String get apiStatusPartial => 'Добавлено частично';

  @override
  String get apiStatusNotFound => 'Не найдено';

  @override
  String get apiStatusCancelled => 'Отменено';

  @override
  String get apiStatusInterrupted => 'Прервано';

  @override
  String get apiStatusFailed => 'Не удалось';

  @override
  String get apiExtrasNoResponse => 'Сервер расширений не отвечает.';

  @override
  String get apiAlbumListFailed => 'Не удалось получить список альбомов.';

  @override
  String apiPlaylistSaved(int found, int total) {
    return 'Плейлист в медиатеке ($found из $total треков)';
  }

  @override
  String apiPlaylistDownloading(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count трека',
      many: '$count треков',
      few: '$count трека',
      one: '$count трек',
    );
    return 'Плейлист в медиатеке; скачивается ещё $_temp0';
  }

  @override
  String get apiBadCredentials => 'Неверное имя пользователя или пароль.';

  @override
  String get apiServerUnreachable => 'Не удалось подключиться к серверу.';

  @override
  String get apiQuickConnectOff => 'Quick Connect отключён на этом сервере.';

  @override
  String get apiWrongCurrentPassword => 'Текущий пароль неверен.';

  @override
  String stateChatShared(String title) {
    return 'Вы поделились: $title';
  }

  @override
  String stateDownloadingName(String name) {
    return 'Скачивается $name';
  }

  @override
  String stateDownloadingRequests(int count) {
    return 'Скачивается запросов: $count';
  }

  @override
  String stateDownloadArrived(String name) {
    return '$name добавлено в медиатеку';
  }

  @override
  String stateDownloadPartial(String name) {
    return '$name добавлено частично';
  }

  @override
  String stateDownloadEnded(String name, String status) {
    return '$name: $status';
  }

  @override
  String get stateNotFromCatalog => 'Этого элемента нет в каталоге.';

  @override
  String stateAlreadyDownloading(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Альбом уже скачивается.',
      'artist': 'Дискография уже скачивается.',
      'other': 'Трек уже скачивается.',
    });
    return '$_temp0';
  }

  @override
  String stateDownloadRequested(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Альбом скачивается. Уведомление появится в колокольчике, когда он будет готов.',
      'artist': 'Дискография скачивается. Уведомление появится в колокольчике, когда она будет готова.',
      'other': 'Трек скачивается. Уведомление появится в колокольчике, когда он будет готов.',
    });
    return '$_temp0';
  }

  @override
  String get stateNotifyDownloadsChannel => 'Загрузки';

  @override
  String get stateNotifyDownloadsChannelDesc => 'Ход загрузки треков';

  @override
  String get stateNotifyNewsChannel => 'Новое';

  @override
  String get stateNotifyNewsChannelDesc =>
      'Новые поступления, релизы, Descobertas и Mistura';

  @override
  String get stateOfflineLoose => 'Скачано по одному';

  @override
  String get stateOfflineDoneTitle => 'Скачано на это устройство';

  @override
  String stateOfflineDoneBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count трека доступны офлайн',
      many: '$count треков доступны офлайн',
      few: '$count трека доступны офлайн',
      one: '$count трек доступен офлайн',
    );
    return '$_temp0';
  }

  @override
  String get stateOfflineProgressTitle => 'Скачивание на это устройство';

  @override
  String stateOfflineProgressBody(int done, int total, String name) {
    return '$done из $total • $name';
  }

  @override
  String get stateServerNoReply => 'Сервер не отвечает. Проверьте адрес.';

  @override
  String get stateServerNoReplyBoth =>
      'Сервер не отвечает ни по одному из адресов.';

  @override
  String get stateTokenStoreUnsupported =>
      'Пока Pudim может сохранять вход только в Windows и Android.';

  @override
  String get stateQualityPoor => 'низкое качество';

  @override
  String get stateQualityPartial => 'неполный';

  @override
  String get audioPlaybackChannel => 'Воспроизведение';

  @override
  String get audioRecentAlbums => 'Недавние альбомы';

  @override
  String audioSearchContext(String query) {
    return 'Поиск: $query';
  }

  @override
  String audioRadioContext(String name) {
    return 'Радио $name';
  }

  @override
  String podcastsMonthShort(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': 'янв.',
      'm2': 'февр.',
      'm3': 'мар.',
      'm4': 'апр.',
      'm5': 'мая',
      'm6': 'июн.',
      'm7': 'июл.',
      'm8': 'авг.',
      'm9': 'сент.',
      'm10': 'окт.',
      'm11': 'нояб.',
      'other': 'дек.',
    });
    return '$_temp0';
  }

  @override
  String podcastsDateThisYear(int day, String month) {
    return '$day $month';
  }

  @override
  String podcastsDateOtherYear(int day, String month, int year) {
    return '$day $month $year г.';
  }

  @override
  String podcastsHoursMin(int h, int min) {
    return '$h ч $min мин';
  }

  @override
  String podcastsMin(int min) {
    return '$min мин';
  }

  @override
  String get podcastsPlayed => 'прослушано';

  @override
  String podcastsTimeLeft(String time) {
    return 'осталось $time';
  }

  @override
  String get podcastsSearchHint => 'Поиск подкастов';

  @override
  String get podcastsNothingFound => 'Ничего не найдено.';

  @override
  String get podcastsYours => 'Ваши подкасты';

  @override
  String get podcastsNewEpisodes => 'Новые выпуски';

  @override
  String get podcastsTrendingBrazil => 'Популярное в Бразилии';

  @override
  String get podcastsLoadFailed => 'Не удалось загрузить. Повторите';

  @override
  String get podcastsNoEpisodes => 'В ленте нет выпусков.';

  @override
  String podcastsNoEpisodeMatch(String q) {
    return 'Нет выпусков по запросу «$q».';
  }

  @override
  String get podcastsKind => 'Подкаст';

  @override
  String get podcastsEpisodes => 'Выпуски';

  @override
  String podcastsEpisodesCount(int total) {
    return 'Выпуски ($total)';
  }

  @override
  String get podcastsFindEpisode => 'Поиск выпусков';

  @override
  String showsMonthName(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': 'Январь',
      'm2': 'Февраль',
      'm3': 'Март',
      'm4': 'Апрель',
      'm5': 'Май',
      'm6': 'Июнь',
      'm7': 'Июль',
      'm8': 'Август',
      'm9': 'Сентябрь',
      'm10': 'Октябрь',
      'm11': 'Ноябрь',
      'other': 'Декабрь',
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
      'w1': 'Пн',
      'w2': 'Вт',
      'w3': 'Ср',
      'w4': 'Чт',
      'w5': 'Пт',
      'w6': 'Сб',
      'other': 'Вс',
    });
    return '$_temp0';
  }

  @override
  String get showsFollowingNone => 'От исполнителей, на которых вы подписаны';

  @override
  String showsFollowingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'От $count исполнителей, на которых вы подписаны',
      many: 'От $count исполнителей, на которых вы подписаны',
      few: 'От $count исполнителей, на которых вы подписаны',
      one: 'От $count исполнителя, на которого вы подписаны',
    );
    return '$_temp0';
  }

  @override
  String showsSearchingFor(int count) {
    return 'ищем концерты: $count…';
  }

  @override
  String get showsUpcoming => 'Предстоящие';

  @override
  String get showsPast => 'Прошедшие';

  @override
  String get showsInBrazil => 'В Бразилии';

  @override
  String get showsEmptyFollow =>
      'Подпишитесь на исполнителей (кнопка на странице исполнителя), чтобы видеть их концерты здесь.';

  @override
  String get showsNonePast => 'Пока нет записей о концертах.';

  @override
  String get showsNoneUpcoming => 'Пока нет запланированных концертов.';

  @override
  String get showsStillSearching => 'Всё ещё ищем…';

  @override
  String get showsSource =>
      'Даты с MusicBrainz (ведётся фанатами); новые концерты могут появляться не сразу.';

  @override
  String get showsCancelled => 'отменён';

  @override
  String get showsFestival => 'фестиваль';

  @override
  String get catalogKindAlbum => 'Альбом';

  @override
  String get catalogKindSingle => 'Сингл';

  @override
  String get catalogKindBroadcast => 'Эфир';

  @override
  String get catalogKindOther => 'Другое';

  @override
  String get catalogSecLive => 'концертный';

  @override
  String get catalogSecCompilation => 'сборник';

  @override
  String get catalogSecSoundtrack => 'саундтрек';

  @override
  String get catalogSecMixtape => 'микстейп';

  @override
  String get catalogSecInterview => 'интервью';

  @override
  String get catalogSecSpokenword => 'разговорный';

  @override
  String catalogDownloadingOne(String title) {
    return 'Скачивается $title';
  }

  @override
  String catalogDownloadingMany(int count, String artist) {
    return 'Скачивается альбомов $artist: $count';
  }

  @override
  String catalogCheckingDiscography(int seconds) {
    return 'Проверяем дискографию… $seconds с';
  }

  @override
  String catalogToDownload(int count) {
    return 'Скачать: $count';
  }

  @override
  String catalogInLibraryCount(int count) {
    return 'Уже в медиатеке: $count';
  }

  @override
  String catalogSkippedOneSong(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Пропущено $count релиза из одного трека',
      many: 'Пропущено $count релизов из одного трека',
      few: 'Пропущено $count релиза из одного трека',
      one: 'Пропущен $count релиз из одного трека',
    );
    return '$_temp0';
  }

  @override
  String get catalogPickAll => 'Все';

  @override
  String get catalogPickStudio => 'Студийные';

  @override
  String get catalogPickNone => 'Ничего';

  @override
  String get catalogDownloadSelected => 'Скачать выбранное';

  @override
  String catalogDownloadNSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Скачать $count выбранных',
      many: 'Скачать $count выбранных',
      few: 'Скачать $count выбранных',
      one: 'Скачать $count выбранный',
    );
    return '$_temp0';
  }

  @override
  String get catalogNothingMissing => 'Всё уже есть.';

  @override
  String get catalogPartial => 'частично';

  @override
  String get catalogDownload => 'Скачать';

  @override
  String get catalogAddToLibrary => 'Добавить в медиатеку';

  @override
  String get catalogInYourLibrary => 'В медиатеке';

  @override
  String get catalogAllInLibrary => 'всё в медиатеке';

  @override
  String catalogNInLibrary(int count) {
    return 'в медиатеке: $count';
  }

  @override
  String get catalogDownloadAlbum => 'Скачать альбом';

  @override
  String get catalogArtistNotFound => 'Исполнитель не найден.';

  @override
  String get catalogFromCatalog => 'Из каталога: ещё не в медиатеке';

  @override
  String get catalogDownloadAll => 'Скачать всё';

  @override
  String get catalogDownloadDiscography => 'Скачать дискографию';

  @override
  String get catalogPopular => 'Популярное';

  @override
  String get catalogShowLess => 'Свернуть';

  @override
  String get catalogShowMore => 'Ещё';

  @override
  String get catalogSinglesEps => 'Синглы и EP';

  @override
  String get catalogFansAlsoLike => 'Фанатам также нравится';

  @override
  String get lyricsPlaySomething => 'Включите трек, чтобы увидеть текст.';

  @override
  String get lyricsNone => 'Для этого трека нет текста';

  @override
  String get lyricsNoneHint =>
      'Если рядом с файлом лежит .lrc или .txt, текст появится здесь.';

  @override
  String get lyricsFind => 'Найти текст';

  @override
  String get lyricsFinding => 'Ищем текст…';

  @override
  String get lyricsNotFound => 'Текст этой песни не найден';

  @override
  String get lyricsSynced => 'Синхронизированный текст из файла .lrc';

  @override
  String get lyricsUnsynced => 'Текст без синхронизации';

  @override
  String get profileChangePhoto => 'Сменить фото';

  @override
  String get profileNoPhoto => 'Фото не выбрано';

  @override
  String get profilePhotoTooBig => 'Фото слишком большое (до 8 МБ)';

  @override
  String get profilePhotoChanged => 'Фото профиля изменено';

  @override
  String get profilePhotoRemoved => 'Фото удалено';

  @override
  String get profileNameSaved => 'Имя профиля сохранено';

  @override
  String get profileRenameTitle => 'Изменить имя пользователя?';

  @override
  String profileRenameBody(String name) {
    return 'Вы будете входить как «$name» в Pudim, Jellyfin и другие приложения (Finamp, Feishin…). Ваши Discoveries, Mix и Rewind сохранятся.';
  }

  @override
  String get profileRenameConfirm => 'Изменить';

  @override
  String profileNowSignedAs(String name) {
    return 'Теперь вы входите как $name';
  }

  @override
  String get profileEnterNewPassword => 'Введите новый пароль';

  @override
  String get profilePasswordsDiffer => 'Новые пароли не совпадают';

  @override
  String get profilePasswordChanged => 'Пароль изменён';

  @override
  String get profileExtrasUnreachable =>
      'Не удалось подключиться к серверу расширений; имя профиля и имя пользователя придётся изменить позже.';

  @override
  String get profileNameSection => 'Имя профиля';

  @override
  String get profileNameHelp => 'Так вас видят контакты в чатах.';

  @override
  String get profileYourName => 'Ваше имя';

  @override
  String get profileUsernameSection => 'Имя пользователя';

  @override
  String get profileUsernameHelp =>
      'Имя для входа в Jellyfin (здесь и в других приложениях).';

  @override
  String get profileUsernameHint => 'Имя пользователя';

  @override
  String get profileChangeUsername => 'Изменить имя пользователя';

  @override
  String get profilePasswordSection => 'Пароль';

  @override
  String get profileCurrentPassword => 'Текущий пароль';

  @override
  String get profileNewPassword => 'Новый пароль';

  @override
  String get profileRepeatPassword => 'Повторите новый пароль';

  @override
  String get profileChangePassword => 'Изменить пароль';

  @override
  String get loginServerRequired => 'Введите адрес сервера Jellyfin.';

  @override
  String get loginUserRequired => 'Введите имя пользователя.';

  @override
  String get loginTitle => 'Вход в Pudim';

  @override
  String get loginSubtitle => 'Используйте свой аккаунт Jellyfin.';

  @override
  String get loginUsername => 'Имя пользователя';

  @override
  String get loginPassword => 'Пароль';

  @override
  String get loginShowPassword => 'Показать пароль';

  @override
  String get loginHidePassword => 'Скрыть пароль';

  @override
  String get loginSubmit => 'Войти';

  @override
  String get loginQuickConnect => 'Войти через Quick Connect';

  @override
  String get loginHideAddresses => 'Скрыть адреса';

  @override
  String get loginServerAddress => 'Адрес сервера';

  @override
  String get loginJellyfinServer => 'Сервер Jellyfin';

  @override
  String get loginJellyfinServerExample =>
      'Например, https://jellyfin.exemplo.com';

  @override
  String get loginLocalNetwork => 'В локальной сети (необязательно)';

  @override
  String get loginLocalNetworkExample =>
      'Например, http://192.168.0.10:8096. Если он отвечает, приложение использует его вместо основного.';

  @override
  String get loginExtrasServer => 'Сервер расширений (необязательно)';

  @override
  String get loginExtrasServerHint =>
      'Включает чат, Jam, Blend, миксы и Rewind. Оставьте пустым, если у вас его нет.';

  @override
  String get loginQcExpired => 'Срок действия кода истёк. Повторите попытку.';

  @override
  String get loginQcInstructions =>
      'На устройстве, где вы уже вошли в Jellyfin, откройте профиль, нажмите Quick Connect и введите этот код:';

  @override
  String get loginQcWaiting => 'Ждём подтверждения…';

  @override
  String get homeDownloadedOnDevice => 'Скачано на это устройство';

  @override
  String get homeTabMusic => 'Музыка';

  @override
  String get homeMadeFor => 'Специально для вас';

  @override
  String get homeMixDiscoveries => 'Новая музыка для вас каждую неделю';

  @override
  String get homeMixWeekly => 'Ваши любимые и похожие треки, каждую неделю';

  @override
  String get homeMixRadar =>
      'Новые релизы исполнителей, на которых вы подписаны, каждую пятницу';

  @override
  String get homeMixDaylist => 'Меняется в течение дня';

  @override
  String get homeMixBlend => 'Ваши вкусы вместе';

  @override
  String get homeMixAuto => 'Автоматический микс';

  @override
  String get homeSpotifyPlaylists => 'Ваши плейлисты из Spotify';

  @override
  String get homeFromSpotify => 'Из Spotify';

  @override
  String get homeYourPlaylists => 'Ваши плейлисты';

  @override
  String get homeTopAlbums => 'Самые прослушиваемые альбомы';

  @override
  String get homeTopArtists => 'Ваши любимые исполнители';

  @override
  String get homeRecentlyAdded => 'Недавно добавленное';

  @override
  String get homeYourPodcasts => 'Ваши подкасты';

  @override
  String get homeRadiosTitle => 'Рекомендуемые радио';

  @override
  String get homeRadiosSubtitle =>
      'Музыка без остановки на основе ваших любимых исполнителей.';

  @override
  String get homeRadioBadge => 'РАДИО';

  @override
  String homeRadioWith(String name) {
    return '$name и похожие исполнители';
  }

  @override
  String searchNoResults(String query) {
    return 'По запросу «$query» ничего не найдено';
  }

  @override
  String get searchNoResultsHint =>
      'Проверьте написание или используйте меньше слов или другие слова.';

  @override
  String searchCatalogNoResponse(String error) {
    return 'Каталог не отвечает: $error';
  }

  @override
  String get searchAlsoCatalog => 'Ищем также в каталоге…';

  @override
  String searchLibraryOnly(String error) {
    return 'Только медиатека: каталог не отвечает ($error).';
  }

  @override
  String get searchTopResult => 'Лучший результат';

  @override
  String get searchSpotifyPlaylists => 'Плейлисты Spotify';

  @override
  String get searchRecent => 'Недавние запросы';

  @override
  String get searchClear => 'Очистить';

  @override
  String get searchBrowseAll => 'Обзор';

  @override
  String get searchHint => 'Что хотите послушать?';

  @override
  String get albumDownloadedType => 'Альбом • скачан на это устройство';

  @override
  String albumSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count трека',
      many: '$count треков',
      few: '$count трека',
      one: '$count трек',
    );
    return '$_temp0, $total';
  }

  @override
  String get albumRemoveFromLibrary => 'Убрать из медиатеки';

  @override
  String get albumSaveToLibrary => 'Сохранить в медиатеку';

  @override
  String albumMoreOptions(String name) {
    return 'Ещё: $name';
  }

  @override
  String albumDisc(int number) {
    return 'Диск $number';
  }

  @override
  String albumMoreFrom(String name) {
    return 'Ещё от $name';
  }

  @override
  String artistAlbumsInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count альбома в вашей медиатеке',
      many: '$count альбомов в вашей медиатеке',
      few: '$count альбома в вашей медиатеке',
      one: '$count альбом в вашей медиатеке',
    );
    return '$_temp0';
  }

  @override
  String artistPlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count прослушивания',
      many: '$count прослушиваний',
      few: '$count прослушивания',
      one: '$count прослушивание',
    );
    return '$_temp0';
  }

  @override
  String artistMoreOptions(String name) {
    return 'Ещё: $name';
  }

  @override
  String get artistPopular => 'Популярное';

  @override
  String get artistShowLess => 'Свернуть';

  @override
  String get artistShowMore => 'Показать ещё';

  @override
  String get artistYouLiked => 'Вам понравилось';

  @override
  String artistFrom(String name) {
    return 'От $name';
  }

  @override
  String get artistDiscography => 'Дискография';

  @override
  String get artistPopularReleases => 'Популярные релизы';

  @override
  String get artistSinglesEps => 'Синглы и EP';

  @override
  String get artistFansAlsoLike => 'Фанатам также нравится';

  @override
  String get artistAppearsOn => 'Участие';

  @override
  String get artistAbout => 'Об исполнителе';

  @override
  String get playlistOriginSpotify => 'Из Spotify';

  @override
  String get playlistOriginMadeForYou => 'Специально для вас';

  @override
  String get playlistOriginAuto => 'Автоматический микс';

  @override
  String get playlistDownloadedOnDevice => 'Скачано на это устройство';

  @override
  String get playlistOnDevice => 'На этом устройстве';

  @override
  String get playlistPlaysOffline => 'Играет без интернета.';

  @override
  String playlistPlaysOfflineDownloading(int count) {
    return 'Играет без интернета. Скачивается ещё $count…';
  }

  @override
  String playlistSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count трека',
      many: '$count треков',
      few: '$count трека',
      one: '$count трек',
    );
    return '$_temp0, $total';
  }

  @override
  String playlistMoreOptions(String name) {
    return 'Ещё: $name';
  }

  @override
  String get playlistSearchHint => 'Поиск в плейлисте';

  @override
  String get playlistEmpty => 'Здесь пока нет треков.';

  @override
  String get playlistErrNoPermission =>
      'У вас нет прав на редактирование этого плейлиста.';

  @override
  String playlistErrServer(String code) {
    return 'Сервер отклонил запрос ($code).';
  }

  @override
  String get playlistErrNoResponse => 'нет ответа';

  @override
  String get playlistDownloadFirst =>
      'Сначала скачайте трек, чтобы добавить его в плейлист';

  @override
  String get playlistAddTo => 'Добавить в плейлист';

  @override
  String get playlistNew => 'Новый плейлист';

  @override
  String playlistAddedTo(String name) {
    return 'Добавлено в $name';
  }

  @override
  String get playlistNameHint => 'Название плейлиста';

  @override
  String get playlistCreate => 'Создать';

  @override
  String playlistCreated(String name) {
    return 'Плейлист $name создан';
  }

  @override
  String get playlistRemoved => 'Удалено из плейлиста';

  @override
  String get playlistInviteTitle => 'Пригласить к редактированию';

  @override
  String get playlistInviteSubtitle =>
      'Плейлист появится в их медиатеке, и они смогут добавлять и удалять треки.';

  @override
  String get playlistInviteOwnerOnly =>
      'Приглашать может только автор плейлиста';

  @override
  String playlistInvited(String who, String playlist) {
    return '$who теперь может редактировать $playlist';
  }

  @override
  String playlistCollaborative(String members) {
    return 'Совместный · $members';
  }

  @override
  String get playlistSmartShuffleTooltip =>
      'Smart Shuffle: перемешивание с рекомендациями';

  @override
  String get playlistSmartShuffleOn =>
      'Smart Shuffle включён: рекомендации отмечены значком ✦';

  @override
  String get playlistAddedToThis => 'Добавлено в плейлист';

  @override
  String get playlistRecommendation => 'Рекомендация Smart Shuffle';

  @override
  String get playlistPutIn => 'Добавить в плейлист';

  @override
  String get settingsSectionAccount => 'Аккаунт';

  @override
  String get settingsProfileSubtitle => 'Имя, имя пользователя и пароль';

  @override
  String settingsConnectedAt(String url) {
    return 'Подключено к $url';
  }

  @override
  String get settingsSignOut => 'Выйти';

  @override
  String get accountsTitle => 'Аккаунты';

  @override
  String get accountsAdd => 'Добавить аккаунт или сервер';

  @override
  String get accountsSwitch => 'Сменить';

  @override
  String get accountsInUse => 'Используется';

  @override
  String accountsOn(String user, String host) {
    return '$user на $host';
  }

  @override
  String get loginBackToAccount => 'Вернуться к текущему аккаунту';

  @override
  String get settingsSectionServer => 'Сервер';

  @override
  String get settingsLocalNetwork => 'В локальной сети';

  @override
  String get settingsServerNote =>
      'Чтобы изменить адреса Jellyfin, выйдите из аккаунта и откройте «Адрес сервера» на экране входа.';

  @override
  String get settingsExtrasServer => 'Сервер расширений';

  @override
  String get settingsExtrasNotConfigured =>
      'Не настроен (чат, Jam, Blend, миксы и итоги скрыты)';

  @override
  String get settingsConfigure => 'Настроить';

  @override
  String get settingsChange => 'Изменить';

  @override
  String get settingsSectionPlayback => 'Воспроизведение';

  @override
  String get settingsQualityWifi => 'Качество по Wi-Fi';

  @override
  String get settingsQualityWifiSubtitle =>
      '«Оригинал» воспроизводит файл как есть в медиатеке.';

  @override
  String get settingsQualityMobile => 'Качество в мобильной сети';

  @override
  String get settingsQualityMobileSubtitle =>
      'Чем ниже качество, тем меньше расходуется мобильный трафик.';

  @override
  String get settingsQualityOriginal => 'Оригинал';

  @override
  String get settingsAppliesNextSong => 'Применится со следующего трека';

  @override
  String get settingsSectionAbout => 'О приложении';

  @override
  String settingsBuild(int build) {
    return 'Сборка $build';
  }

  @override
  String get settingsExtrasEmptyHint =>
      'Оставьте пустым, чтобы отключить расширения.';

  @override
  String get settingsAutoplay => 'Автовоспроизведение';

  @override
  String get settingsAutoplaySubtitle =>
      'Когда очередь закончится, продолжит играть похожие треки (микс Jellyfin).';

  @override
  String get settingsNormalize => 'Выравнивание громкости';

  @override
  String get settingsNormalizeSubtitle =>
      'Все треки играют с одинаковой громкостью по анализу Jellyfin.';

  @override
  String get settingsScrobble => 'Скробблинг';

  @override
  String get settingsLoading => 'Загрузка…';

  @override
  String get settingsLastfmNoKey =>
      'На сервере расширений ещё не настроен ключ API Last.fm.';

  @override
  String settingsConnectedAs(String name) {
    return 'Вы вошли как $name';
  }

  @override
  String get settingsLastfmConnectedSubtitle =>
      'Всё, что вы слушаете в Pudim, попадает в ваш профиль Last.fm.';

  @override
  String get settingsDisconnect => 'Отключить';

  @override
  String get settingsLastfmAuthorize => 'Авторизуйтесь на странице Last.fm';

  @override
  String get settingsLastfmAuthorizeSubtitle =>
      'Нажмите там «Yes, allow access», затем вернитесь и нажмите «Готово».';

  @override
  String get settingsFinish => 'Готово';

  @override
  String get settingsLastfmConnected => 'Last.fm подключён';

  @override
  String get settingsLastfmScrobbleSubtitle =>
      'Записывает каждый прослушанный трек в ваш Last.fm.';

  @override
  String get settingsConnect => 'Подключить';

  @override
  String get sidebarOpenLibrary => 'Развернуть медиатеку';

  @override
  String get sidebarCollapseLibrary => 'Свернуть медиатеку';

  @override
  String sidebarOnDeviceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count трека',
      many: '$count треков',
      few: '$count трека',
      one: '$count трек',
    );
    return 'На устройстве • $_temp0';
  }

  @override
  String sidebarPlaylistCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count трека',
      many: '$count треков',
      few: '$count трека',
      one: '$count трек',
    );
    return 'Плейлист • $_temp0';
  }

  @override
  String sidebarAlbumBy(String artist) {
    return 'Альбом • $artist';
  }

  @override
  String get sidebarSearchLibrary => 'Поиск в медиатеке';

  @override
  String get sidebarSortBy => 'Сортировка';

  @override
  String get sidebarSortRecents => 'Недавние';

  @override
  String get sidebarSortAdded => 'Недавно добавленные';

  @override
  String get sidebarSortAlpha => 'По алфавиту';

  @override
  String get sidebarSortCreator => 'По автору';

  @override
  String get topBarSearchHint => 'Что хотите включить?';

  @override
  String get topBarClearSearch => 'Очистить поле поиска';

  @override
  String get topBarBrowse => 'Обзор';

  @override
  String get topBarMenu => 'Меню';

  @override
  String get topBarLogoutAccount => 'Выйти';

  @override
  String get topBarQuit => 'Выйти из Pudim';

  @override
  String get topBarLogout => 'Выйти';

  @override
  String get playerBarSmartShuffleOff => 'Выключить Smart Shuffle';

  @override
  String get playerBarSmartShuffleOn => 'Включить Smart Shuffle';

  @override
  String get playerBarShuffleOff => 'Выключить перемешивание';

  @override
  String get playerBarShuffleOn => 'Включить перемешивание';

  @override
  String get playerBarPlay => 'Слушать';

  @override
  String get playerBarForward => 'Далее';

  @override
  String get playerBarRepeatOn => 'Включить повтор';

  @override
  String get playerBarRepeatOne => 'Включить повтор трека';

  @override
  String get playerBarRepeatOff => 'Выключить повтор';

  @override
  String get playerBarNowPlayingView => 'Экран воспроизведения';

  @override
  String get playerBarLyrics => 'Текст';

  @override
  String get playerBarUnmute => 'Включить звук';

  @override
  String get playerBarMute => 'Выключить звук';

  @override
  String get rightPanelNothingPlaying =>
      'Включите трек, чтобы увидеть здесь, что играет.';

  @override
  String get rightPanelLyricsPreview => 'Фрагмент текста';

  @override
  String get rightPanelAboutArtist => 'Об исполнителе';

  @override
  String get rightPanelNextUp => 'Далее в очереди';

  @override
  String get rightPanelOpenQueue => 'Открыть очередь';

  @override
  String get rightPanelQueueEmptyTitle => 'Добавьте в очередь';

  @override
  String get rightPanelQueueEmptyHint =>
      'Выберите «Добавить в очередь» в меню трека, и он появится здесь';

  @override
  String get rightPanelNowPlaying => 'Сейчас играет';

  @override
  String get rightPanelNextInQueue => 'Следующий в очереди';

  @override
  String rightPanelNextFrom(String name) {
    return 'Далее из: $name';
  }

  @override
  String get nowPlayingPlayingFrom => 'ИГРАЕТ ИЗ';

  @override
  String get nowPlayingMoreOptions => 'Ещё';

  @override
  String get chatChats => 'Чаты';

  @override
  String chatYouSaid(String text) {
    return 'Вы: $text';
  }

  @override
  String get chatContacts => 'Контакты';

  @override
  String get chatServerUnreachable =>
      'Не удалось подключиться к серверу расширений.';

  @override
  String get chatMessageHint => 'Сообщение';

  @override
  String chatJoinedJam(String title) {
    return 'Вы присоединились: $title';
  }

  @override
  String chatCouldNotPlay(String error) {
    return 'Не удалось воспроизвести: $error';
  }

  @override
  String get chatJamCardSubtitle => 'Слушайте вместе, одна очередь на всех';

  @override
  String get chatInJam => 'В Jam';

  @override
  String get chatJoin => 'Присоединиться';

  @override
  String get chatNoOtherAccounts => 'На сервере нет других аккаунтов.';

  @override
  String chatSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count трека',
      many: '$count треков',
      few: '$count трека',
      one: '$count трек',
    );
    return '$_temp0';
  }

  @override
  String chatSentTo(String name) {
    return 'Отправлено: $name';
  }

  @override
  String chatShareTitle(String title) {
    return 'Поделиться: $title';
  }

  @override
  String get chatNoteHint => 'Заметка (необязательно)';

  @override
  String get blendWorking => 'Смешиваем…';

  @override
  String blendAffinityButton(int affinity) {
    return 'Blend $affinity%';
  }

  @override
  String get blendCreate => 'Создать Blend';

  @override
  String blendWith(String name) {
    return 'Blend с $name';
  }

  @override
  String get blendExplain =>
      'Один плейлист на двоих: то, что вы оба слушаете, общие исполнители и немного того, что каждый из вас любит больше всего. Он показывает, насколько совпадают ваши вкусы, и обновляется каждый день.';

  @override
  String get blendNotNow => 'Не сейчас';

  @override
  String blendAffinityTitle(int affinity) {
    return 'Ваше совпадение: $affinity%';
  }

  @override
  String blendInCommon(String artists) {
    return 'Общее: $artists';
  }

  @override
  String blendOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Открыть Blend ($count трека)',
      many: 'Открыть Blend ($count треков)',
      few: 'Открыть Blend ($count трека)',
      one: 'Открыть Blend ($count трек)',
    );
    return '$_temp0';
  }

  @override
  String get blendRefreshNow => 'Обновить сейчас';

  @override
  String get blendUndo => 'Удалить Blend';

  @override
  String get blendRefreshing => 'Обновляем Blend…';

  @override
  String get blendUndoTitle => 'Удалить Blend?';

  @override
  String blendUndoBody(String name) {
    return 'Плейлист исчезнет у вас и у $name.';
  }

  @override
  String get blendUndoConfirm => 'Удалить';

  @override
  String get blendUndone => 'Blend удалён';

  @override
  String get jamStart => 'Начать Jam';

  @override
  String jamTooltip(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jam ($count человека)',
      many: 'Jam ($count человек)',
      few: 'Jam ($count человека)',
      one: 'Jam ($count человек)',
    );
    return '$_temp0';
  }

  @override
  String get jamSubIdle =>
      'Слушайте вместе с другими аккаунтами, в одной очереди.';

  @override
  String get jamSubHost => 'Вы за главного. Все могут предлагать треки.';

  @override
  String get jamSubGuest =>
      'Ваши действия и треки попадают в очередь всех участников.';

  @override
  String get jamPlayFirst => 'Включите трек, прежде чем начинать Jam.';

  @override
  String jamMembers(int count) {
    return 'В Jam ($count)';
  }

  @override
  String jamYouSuffix(String name) {
    return '$name (вы)';
  }

  @override
  String get jamHost => 'Ведущий';

  @override
  String get jamInvite => 'Пригласить';

  @override
  String get jamInviteTitle => 'Пригласить в Jam';

  @override
  String get jamInviteSubtitle => 'Приглашение придёт в их чат.';

  @override
  String jamInviteSent(String name) {
    return 'Приглашение отправлено: $name';
  }

  @override
  String get jamEnd => 'Завершить Jam';

  @override
  String get jamLeave => 'Выйти из Jam';

  @override
  String recapTitle(int year) {
    return 'Ваш Wrapped $year';
  }

  @override
  String get recapShort => 'Wrapped';

  @override
  String recapBannerBody(String minutes) {
    return '$minutes минут музыки за этот год. Узнайте, что вы слушали чаще всего.';
  }

  @override
  String get recapEmpty =>
      'Пока недостаточно прослушиваний для вашего Wrapped.';

  @override
  String get recapShareCards => 'Карточки для публикации';

  @override
  String get recapBigMinutes => 'минут прослушано';

  @override
  String get recapBigSongs => 'разных треков';

  @override
  String get recapBigArtists => 'исполнителей';

  @override
  String get recapBigDays => 'дней с музыкой';

  @override
  String get recapBigStreak => 'дней подряд, ваш рекорд';

  @override
  String get recapTopArtists => 'Ваши главные исполнители года';

  @override
  String recapMinutesValue(String minutes) {
    return '$minutes минут';
  }

  @override
  String get recapTopSongs => 'Ваши главные треки года';

  @override
  String recapPlaysLine(String artist, String plays) {
    return '$artist • прослушиваний: $plays';
  }

  @override
  String get recapSongGone => 'Этого трека больше нет в медиатеке';

  @override
  String get recapTopAlbums => 'Ваши главные альбомы года';

  @override
  String get recapTopGenres => 'Ваши любимые жанры';

  @override
  String recapGenreLine(String genre, String minutes) {
    return '$genre • $minutes мин';
  }

  @override
  String get recapMonthly => 'По месяцам';

  @override
  String recapMonthTooltip(String month, String minutes) {
    return '$month: $minutes мин';
  }

  @override
  String get recapListeningStyle => 'Как вы слушаете';

  @override
  String recapFavHour(String hour) {
    return 'Любимый час: $hour:00';
  }

  @override
  String recapFavWeekday(String day) {
    return 'Любимый день недели: $day';
  }

  @override
  String recapBiggestDay(String date, String minutes) {
    return 'Ваш самый насыщенный день: $date, $minutes минут';
  }

  @override
  String recapNewArtists(int count, String n) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$n новых исполнителя для вас',
      many: '$n новых исполнителей для вас',
      few: '$n новых исполнителя для вас',
      one: '$n новый исполнитель для вас',
    );
    return '$_temp0';
  }

  @override
  String recapSpotifyAdded(String added) {
    return 'Добавлено прослушиваний из Spotify: $added.';
  }

  @override
  String recapSpotifyAddedDup(String added, String dup) {
    return 'Добавлено прослушиваний из Spotify: $added (ещё $dup уже были из Pudim).';
  }

  @override
  String get recapSpotifyRemoveTitle => 'Удалить историю Spotify?';

  @override
  String get recapSpotifyRemoveBody =>
      'В вашем Wrapped снова будет учитываться только то, что вы слушали в Pudim/Jellyfin. Позже историю можно импортировать снова.';

  @override
  String get recapSpotifyRemoveConfirm => 'Удалить';

  @override
  String recapSpotifyRemoved(String count) {
    return 'Удалено прослушиваний из Spotify: $count';
  }

  @override
  String get recapSpotifyTitle => 'История Spotify';

  @override
  String recapSpotifyHasData(String count, String from, String to) {
    return 'Прослушиваний из Spotify в вашем Wrapped: $count ($from — $to). Можно загрузить более новый файл: то, что уже есть, не будет учтено дважды.';
  }

  @override
  String get recapSpotifyIntro =>
      'Добавьте годы до Pudim. В Spotify откройте «Аккаунт > Конфиденциальность > Скачать свои данные» и выберите «Расширенная история прослушиваний». Когда придёт письмо, выберите здесь my_spotify_data.zip.';

  @override
  String get recapSpotifyImportAnother => 'Импортировать другой файл';

  @override
  String get recapSpotifyImport => 'Импортировать историю';

  @override
  String get recapSpotifyRemoveBtn => 'Убрать из Wrapped';

  @override
  String get recapShareSaveDialog => 'Сохранить карточку';

  @override
  String get recapShareSaved => 'Карточка сохранена';

  @override
  String recapShareSaveFailed(String error) {
    return 'Не удалось сохранить: $error';
  }

  @override
  String recapShareShareFailed(String error) {
    return 'Не удалось поделиться: $error';
  }

  @override
  String recapShareText(int year) {
    return 'Мой Wrapped $year в Pudim';
  }

  @override
  String get recapShareMyArtists => 'Мои главные исполнители года';

  @override
  String get recapShareMySongs => 'Мои главные треки года';

  @override
  String recapMinShort(String minutes) {
    return '$minutes мин';
  }

  @override
  String get recapShareSaveImage => 'Сохранить изображение';

  @override
  String get recapShareButton => 'Поделиться';

  @override
  String recapBrand(int year) {
    return 'Wrapped $year';
  }

  @override
  String get recapShareMyYear => 'Мой год в музыке';

  @override
  String recapShareYearOf(String name) {
    return 'Год в музыке: $name';
  }

  @override
  String get recapShareTopArtist => 'мой главный исполнитель года';

  @override
  String recapShareGenres(String genres) {
    return 'Жанры: $genres';
  }

  @override
  String get widgetActionsAddedToLiked => 'Добавлено в «Любимые треки»';

  @override
  String get widgetActionsRemovedFromLiked => 'Удалено из «Любимых треков»';

  @override
  String get widgetActionsUnfollowed => 'Вы отписались';

  @override
  String get widgetActionsSavedToLibrary => 'Сохранено в медиатеку';

  @override
  String get widgetActionsRemovedFromLibrary => 'Убрано из медиатеки';

  @override
  String get widgetActionsAddToQueue => 'Добавить в очередь';

  @override
  String get widgetActionsAddedToQueue => 'Добавлено в очередь';

  @override
  String get widgetActionsPlayNext => 'Играть следующим';

  @override
  String get widgetActionsGoToPodcast => 'Перейти к подкасту';

  @override
  String get widgetActionsRemoveFromQueue => 'Убрать из очереди';

  @override
  String get widgetActionsAddToPlaylist => 'Добавить в плейлист';

  @override
  String get widgetActionsRemoveFromThisPlaylist =>
      'Удалить из этого плейлиста';

  @override
  String get widgetActionsInviteToEdit => 'Пригласить к редактированию';

  @override
  String get widgetActionsKeepInPlaylist => 'Оставить в плейлисте';

  @override
  String get widgetActionsDownloadTrack => 'Скачать трек';

  @override
  String get widgetActionsDownloadAlbum => 'Скачать альбом';

  @override
  String get widgetActionsDownloadDiscography => 'Скачать дискографию';

  @override
  String get widgetActionsSearchAlbums => 'Найти альбомы';

  @override
  String widgetActionsImproveQuality(int count) {
    return 'Улучшить качество ($count)';
  }

  @override
  String widgetActionsImprovingAlbums(int count) {
    return 'Ищем лучшие версии альбомов: $count';
  }

  @override
  String get widgetActionsShare => 'Поделиться';

  @override
  String get widgetActionsSearchFlac => 'Найти в FLAC';

  @override
  String widgetActionsSearchingFlac(String name) {
    return 'Ищем $name в FLAC; если найдём, он заменит MP3';
  }

  @override
  String get widgetActionsTrackRemovedFromDevice => 'Удалено с устройства';

  @override
  String get widgetActionsRemovedFromDevice => 'Удалено с устройства';

  @override
  String get widgetActionsDownloadingToDevice =>
      'Скачивается на устройство для прослушивания офлайн';

  @override
  String get widgetActionsUnfollow => 'Отписаться';

  @override
  String get widgetActionsRemoveFromLibrary => 'Убрать из медиатеки';

  @override
  String get widgetActionsAddToLibrary => 'Добавить в медиатеку';

  @override
  String get widgetActionsGoToSongRadio => 'Перейти к радио трека';

  @override
  String get widgetActionsStartMix => 'Запустить микс';

  @override
  String widgetActionsMixOf(String name) {
    return 'Микс $name';
  }

  @override
  String get widgetActionsGoToArtist => 'Перейти к исполнителю';

  @override
  String get widgetActionsGoToAlbum => 'Перейти к альбому';

  @override
  String get widgetActionsCopyName => 'Копировать название';

  @override
  String get widgetActionsCopied => 'Скопировано';

  @override
  String widgetDownloadsBellDownloading(int count) {
    return 'Скачивается: $count';
  }

  @override
  String get widgetDownloadsBellEmpty =>
      'Пока пусто. Включите трек со значком облака или выберите «Скачать» в меню ⋯, чтобы добавить его из каталога в медиатеку.';

  @override
  String get widgetDownloadsBellKindDiscography => 'Дискография';

  @override
  String get widgetDownloadsBellKindFlac => 'В FLAC';

  @override
  String get widgetDownloadsBellKindQuality => 'Качество';

  @override
  String get widgetDownloadsBellOptions => 'Параметры';

  @override
  String get widgetDownloadsBellCancelled => 'Загрузка отменена';

  @override
  String get widgetDownloadsBellRetrying => 'Повторяем попытку';

  @override
  String get widgetDownloadsBellRemovedFromList => 'Убрано из списка';

  @override
  String get widgetDownloadsBellDetails => 'Подробнее';

  @override
  String get widgetDownloadsBellRemoveFromList => 'Убрать из списка';

  @override
  String get widgetMixSearchingReleases => 'Ищем новые релизы…';

  @override
  String get widgetMixBuildingDaylist => 'Создаём ваш daylist…';

  @override
  String get widgetMixNewDiscoveriesTitle => 'Обновить «Открытия недели»?';

  @override
  String get widgetMixNewMixTitle => 'Обновить «Микс недели»?';

  @override
  String get widgetMixNewDiscoveriesBody =>
      'Треки, которые вы ещё не слушали, уйдут из плейлиста, и появится около 30 новых. Это и так происходит само каждый понедельник.';

  @override
  String get widgetMixNewMixBody =>
      'Пересоберёт его из ваших любимых, самых прослушиваемых и похожих треков. Это и так происходит само каждый понедельник.';

  @override
  String get widgetMixNotNow => 'Не сейчас';

  @override
  String get widgetMixBuildingDiscoveries => 'Создаём ваши Discoveries…';

  @override
  String get widgetMixBuildingMix => 'Создаём ваш Mix…';

  @override
  String widgetMixBuiltOn(String date) {
    return 'Создан $date';
  }

  @override
  String get widgetMixRedo => 'Пересоздать';

  @override
  String get widgetMixRefresh => 'Обновить';

  @override
  String get widgetMixCreateDiscoveries => 'Создать «Открытия недели»';

  @override
  String get widgetMixCreateMix => 'Создать «Микс недели»';

  @override
  String get widgetMixCreateRadar => 'Создать «Радар новинок»';

  @override
  String get widgetMixCreateDaylist => 'Создать daylist';

  @override
  String get widgetOfflineBanner =>
      'Нет интернета · показано то, что сохранено на устройстве';

  @override
  String widgetOfflineDownloadingProgress(int done, int total) {
    return 'Скачивается $done из $total';
  }

  @override
  String get widgetUpdateReady => 'Готова новая версия Pudim';

  @override
  String widgetUpdateReadyNotes(String notes) {
    return 'Новая версия Pudim · $notes';
  }

  @override
  String get widgetUpdateAction => 'Обновить';

  @override
  String widgetSleepShortMinutes(int count) {
    return '$count мин';
  }

  @override
  String widgetSleepShortSeconds(int count) {
    return '$count с';
  }

  @override
  String get widgetSleepStopsAtEnd => 'Остановится в конце трека';

  @override
  String widgetSleepStopsIn(String time) {
    return 'Остановится через $time';
  }

  @override
  String get widgetSleepTimer => 'Таймер сна';

  @override
  String get widgetSleepTurnOff => 'Выключить таймер';

  @override
  String get widgetSleepOneHour => '1 час';

  @override
  String get widgetSleepOneAndHalfHours => '1 час 30 минут';

  @override
  String get widgetSleepEndOfSong => 'Конец трека';

  @override
  String get widgetSleepTurnedOff => 'Таймер выключен';

  @override
  String get widgetSleepStopsWhenSongEnds =>
      'Музыка остановится, когда закончится этот трек';

  @override
  String widgetSleepSongStopsIn(String time) {
    return 'Музыка остановится через $time';
  }

  @override
  String get widgetSpeedPodcast => 'Скорость подкаста';

  @override
  String get widgetCommonCatalogBadge =>
      'Из каталога: ещё не в вашей медиатеке';

  @override
  String get widgetCommonShowAll => 'Показать все';

  @override
  String get widgetCommonSomethingWentWrong => 'Что-то пошло не так';

  @override
  String get widgetCommonListenDownloaded => 'Слушать скачанные треки';

  @override
  String get widgetTracksTitle => 'Название';

  @override
  String get widgetTracksDateAdded => 'Дата добавления';

  @override
  String widgetTracksAddedBy(String name) {
    return 'добавил(а): $name';
  }

  @override
  String get widgetTracksMoreOptions => 'Ещё';

  @override
  String widgetTracksAddedDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get castTooltip => 'Трансляция';

  @override
  String get castTitle => 'Воспроизвести на';

  @override
  String get castThisDevice => 'Это устройство';

  @override
  String get castSearching => 'Поиск устройств в сети…';

  @override
  String get castNone =>
      'Chromecast не найден. Он должен быть в той же сети Wi-Fi.';

  @override
  String get castSearchAgain => 'Искать снова';

  @override
  String get castStop => 'Остановить трансляцию';

  @override
  String castPlayingOn(String name) {
    return 'Играет на $name';
  }

  @override
  String castFailed(String name) {
    return 'Не удалось подключиться к $name';
  }

  @override
  String get settingsSectionAppearance => 'Оформление';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get settingsThemeSubtitle => 'Меняет цвета сразу.';

  @override
  String get themeNightDesc =>
      'Тёмная, скруглённые карточки и плавающий мини-плеер.';

  @override
  String get themeRedDesc =>
      'Чистый чёрный с красным, большие квадратные обложки, мини-плеер у панели.';

  @override
  String get themeWaveDesc =>
      'Фиолетовые градиенты, жирный шрифт и мини-плеер-таблетка.';

  @override
  String get themeRetroDesc =>
      'Серое объёмное окно, зелёный дисплей с бегущей строкой и текстовые списки.';

  @override
  String get themeClassicDesc =>
      'Глянцевое сине-чёрное стекло, кнопка-шар, визуализатор и списки-таблицы.';

  @override
  String get settingsCheckUpdates => 'Проверить обновления';

  @override
  String get updateChecking => 'Проверка…';

  @override
  String updateUpToDate(int build) {
    return 'У вас последняя версия (сборка $build).';
  }

  @override
  String updateDownloading(int build, int percent) {
    return 'Загрузка сборки $build… $percent%';
  }

  @override
  String updateFailed(String error) {
    return 'Не удалось проверить: $error';
  }

  @override
  String get updateUnavailable => 'Сервер дополнений не настроен.';

  @override
  String get settingsHistory => 'История';

  @override
  String get settingsHistorySubtitle =>
      'Итоги прошлых лет и всё, что вы слушали';

  @override
  String get historyRecaps => 'Итоги';

  @override
  String get historyPlays => 'Прослушивания';

  @override
  String get historyWholeYear => 'Весь год';

  @override
  String get historyLoadMore => 'Загрузить ещё';

  @override
  String get historyEmpty => 'Пока ничего не прослушано';

  @override
  String get historyImported => 'импорт';

  @override
  String widgetMixRadarDone(int count) {
    return 'Радар новинок: $count треков';
  }

  @override
  String widgetMixRadarQueued(int count, String list) {
    return 'Загрузка релизов ($count): $list';
  }

  @override
  String widgetMixRadarFailed(String error) {
    return 'Радар не обновился: $error';
  }
}
