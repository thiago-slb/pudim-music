// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class L10nJa extends L10n {
  L10nJa([String locale = 'ja']) : super(locale);

  @override
  String get languageTitle => '言語';

  @override
  String get languageSubtitle => '表示言語';

  @override
  String get languageSystem => 'システムの設定に従う';

  @override
  String get commonCancel => 'キャンセル';

  @override
  String get commonClose => '閉じる';

  @override
  String get commonBack => '戻る';

  @override
  String get commonSave => '保存';

  @override
  String get commonEdit => '編集';

  @override
  String get commonDelete => '削除';

  @override
  String get commonRemove => '削除';

  @override
  String get commonOk => 'OK';

  @override
  String get commonRetry => '再試行';

  @override
  String get commonQueue => 'キュー';

  @override
  String get commonAlbum => 'アルバム';

  @override
  String get commonAlbums => 'アルバム';

  @override
  String get commonArtist => 'アーティスト';

  @override
  String get commonArtists => 'アーティスト';

  @override
  String get commonSong => '曲';

  @override
  String get commonSongs => '曲';

  @override
  String get commonPlaylist => 'プレイリスト';

  @override
  String get commonPlaylists => 'プレイリスト';

  @override
  String get commonSingle => 'シングル';

  @override
  String get commonLikedSongs => 'お気に入りの曲';

  @override
  String get commonAddToLiked => 'お気に入りの曲に追加';

  @override
  String get commonRemoveFromLiked => 'お気に入りの曲から削除';

  @override
  String get commonShufflePlay => 'シャッフル再生';

  @override
  String get commonPlay => '再生';

  @override
  String get commonPause => '一時停止';

  @override
  String get commonFollow => 'フォロー';

  @override
  String get commonFollowing => 'フォロー中';

  @override
  String get commonDownloadToDevice => 'デバイスにダウンロード';

  @override
  String get commonRemoveFromDevice => 'デバイスから削除';

  @override
  String get commonDownloaded => 'ダウンロード済み';

  @override
  String get commonDownloads => 'ダウンロード';

  @override
  String get commonAll => 'すべて';

  @override
  String get commonRecentlyPlayed => '最近再生した曲';

  @override
  String get commonYourLibrary => 'ライブラリ';

  @override
  String get commonHome => 'ホーム';

  @override
  String get commonSearch => '検索';

  @override
  String get commonProfile => 'プロフィール';

  @override
  String get commonSettings => '設定';

  @override
  String get commonBuilding => '作成中…';

  @override
  String get commonBuildNow => '今すぐ作成';

  @override
  String get commonShows => 'コンサート';

  @override
  String get commonPodcasts => 'ポッドキャスト';

  @override
  String commonSongCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count曲',
      one: '1曲',
      zero: '曲なし',
    );
    return '$_temp0';
  }

  @override
  String commonMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count分',
      one: '1分',
    );
    return '$_temp0';
  }

  @override
  String commonError(String error) {
    return 'エラー: $error';
  }

  @override
  String get apiStatusQueued => '待機中';

  @override
  String get apiStatusDownloading => 'ダウンロード中';

  @override
  String get apiStatusDone => 'ライブラリに追加しました';

  @override
  String get apiStatusUpToDate => 'すでにライブラリにあります';

  @override
  String get apiStatusPartial => '一部を追加しました';

  @override
  String get apiStatusNotFound => '見つかりません';

  @override
  String get apiStatusCancelled => 'キャンセルしました';

  @override
  String get apiStatusInterrupted => '中断しました';

  @override
  String get apiStatusFailed => '失敗しました';

  @override
  String get apiExtrasNoResponse => 'エクストラサーバーが応答しません。';

  @override
  String get apiAlbumListFailed => 'アルバムを一覧表示できませんでした。';

  @override
  String apiPlaylistSaved(int found, int total) {
    return 'ライブラリにプレイリストを追加しました（$total曲中$found曲）';
  }

  @override
  String apiPlaylistDownloading(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count曲',
      one: '1曲',
    );
    return 'ライブラリにプレイリストを追加しました。残り$_temp0をダウンロード中';
  }

  @override
  String get apiBadCredentials => 'ユーザー名またはパスワードが違います。';

  @override
  String get apiServerUnreachable => 'サーバーに接続できませんでした。';

  @override
  String get apiQuickConnectOff => 'このサーバーではQuick Connectがオフになっています。';

  @override
  String get apiWrongCurrentPassword => '現在のパスワードが正しくありません。';

  @override
  String stateChatShared(String title) {
    return '$titleを共有しました';
  }

  @override
  String stateDownloadingName(String name) {
    return '$nameをダウンロード中';
  }

  @override
  String stateDownloadingRequests(int count) {
    return '$count件のリクエストをダウンロード中';
  }

  @override
  String stateDownloadArrived(String name) {
    return '$nameをライブラリに追加しました';
  }

  @override
  String stateDownloadPartial(String name) {
    return '$nameを一部追加しました';
  }

  @override
  String stateDownloadEnded(String name, String status) {
    return '$name: $status';
  }

  @override
  String get stateNotFromCatalog => 'この項目はカタログのものではありません。';

  @override
  String stateAlreadyDownloading(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'このアルバムはすでにダウンロード中です。',
      'artist': 'ディスコグラフィーはすでにダウンロード中です。',
      'other': 'この曲はすでにダウンロード中です。',
    });
    return '$_temp0';
  }

  @override
  String stateDownloadRequested(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'アルバムをダウンロード中です。完了するとベルに表示されます。',
      'artist': 'ディスコグラフィーをダウンロード中です。完了するとベルに表示されます。',
      'other': '曲をダウンロード中です。完了するとベルに表示されます。',
    });
    return '$_temp0';
  }

  @override
  String get stateNotifyDownloadsChannel => 'ダウンロード';

  @override
  String get stateNotifyDownloadsChannelDesc => 'ダウンロード中の曲の進行状況';

  @override
  String get stateNotifyNewsChannel => '新着情報';

  @override
  String get stateNotifyNewsChannelDesc => '新着、リリース、DescobertasとMistura';

  @override
  String get stateOfflineLoose => '1曲ずつダウンロード済み';

  @override
  String get stateOfflineDoneTitle => 'このデバイスにダウンロードしました';

  @override
  String stateOfflineDoneBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count曲をオフラインで聴けます',
      one: '1曲をオフラインで聴けます',
    );
    return '$_temp0';
  }

  @override
  String get stateOfflineProgressTitle => 'このデバイスにダウンロード中';

  @override
  String stateOfflineProgressBody(int done, int total, String name) {
    return '$total件中$done件 • $name';
  }

  @override
  String get stateServerNoReply => 'サーバーが応答しません。アドレスを確認してください。';

  @override
  String get stateServerNoReplyBoth => 'どちらのアドレスでもサーバーが応答しません。';

  @override
  String get stateTokenStoreUnsupported =>
      '現在、Pudimでログイン情報を保存できるのはWindowsとAndroidのみです。';

  @override
  String get stateQualityPoor => '低品質';

  @override
  String get stateQualityPartial => '不完全';

  @override
  String get audioPlaybackChannel => '再生';

  @override
  String get audioRecentAlbums => '最近のアルバム';

  @override
  String audioSearchContext(String query) {
    return '検索: $query';
  }

  @override
  String audioRadioContext(String name) {
    return '$nameラジオ';
  }

  @override
  String podcastsMonthShort(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': '1月',
      'm2': '2月',
      'm3': '3月',
      'm4': '4月',
      'm5': '5月',
      'm6': '6月',
      'm7': '7月',
      'm8': '8月',
      'm9': '9月',
      'm10': '10月',
      'm11': '11月',
      'other': '12月',
    });
    return '$_temp0';
  }

  @override
  String podcastsDateThisYear(int day, String month) {
    return '$month$day日';
  }

  @override
  String podcastsDateOtherYear(int day, String month, int year) {
    return '$year年$month$day日';
  }

  @override
  String podcastsHoursMin(int h, int min) {
    return '$h時間$min分';
  }

  @override
  String podcastsMin(int min) {
    return '$min分';
  }

  @override
  String get podcastsPlayed => '再生済み';

  @override
  String podcastsTimeLeft(String time) {
    return '残り$time';
  }

  @override
  String get podcastsSearchHint => 'ポッドキャストを検索';

  @override
  String get podcastsNothingFound => '見つかりませんでした。';

  @override
  String get podcastsYours => 'あなたのポッドキャスト';

  @override
  String get podcastsNewEpisodes => '新しいエピソード';

  @override
  String get podcastsTrendingBrazil => 'ブラジルで話題';

  @override
  String get podcastsLoadFailed => '読み込めませんでした。もう一度お試しください';

  @override
  String get podcastsNoEpisodes => 'フィードにエピソードがありません。';

  @override
  String podcastsNoEpisodeMatch(String q) {
    return '「$q」に一致するエピソードはありません。';
  }

  @override
  String get podcastsKind => 'ポッドキャスト';

  @override
  String get podcastsEpisodes => 'エピソード';

  @override
  String podcastsEpisodesCount(int total) {
    return 'エピソード（$total）';
  }

  @override
  String get podcastsFindEpisode => 'エピソードを検索';

  @override
  String showsMonthName(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': '1月',
      'm2': '2月',
      'm3': '3月',
      'm4': '4月',
      'm5': '5月',
      'm6': '6月',
      'm7': '7月',
      'm8': '8月',
      'm9': '9月',
      'm10': '10月',
      'm11': '11月',
      'other': '12月',
    });
    return '$_temp0';
  }

  @override
  String showsMonthYear(String month, int year) {
    return '$year年$month';
  }

  @override
  String showsWeekdayShort(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'w1': '月',
      'w2': '火',
      'w3': '水',
      'w4': '木',
      'w5': '金',
      'w6': '土',
      'other': '日',
    });
    return '$_temp0';
  }

  @override
  String get showsFollowingNone => 'フォロー中のアーティストの公演';

  @override
  String showsFollowingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'フォロー中の$count組のアーティストの公演',
      one: 'フォロー中の1組のアーティストの公演',
    );
    return '$_temp0';
  }

  @override
  String showsSearchingFor(int count) {
    return '$count組の公演を検索中…';
  }

  @override
  String get showsUpcoming => '今後の公演';

  @override
  String get showsPast => '過去の公演';

  @override
  String get showsInBrazil => 'ブラジル国内';

  @override
  String get showsEmptyFollow =>
      'アーティストをフォローすると（アーティストページのフォローボタン）、その公演がここに表示されます。';

  @override
  String get showsNonePast => '記録された公演はまだありません。';

  @override
  String get showsNoneUpcoming => '現在予定されている公演はありません。';

  @override
  String get showsStillSearching => '検索中…';

  @override
  String get showsSource =>
      '日程はMusicBrainz（ファンによる情報）より。新しい公演が表示されるまで時間がかかる場合があります。';

  @override
  String get showsCancelled => '中止';

  @override
  String get showsFestival => 'フェス';

  @override
  String get catalogKindAlbum => 'アルバム';

  @override
  String get catalogKindSingle => 'シングル';

  @override
  String get catalogKindBroadcast => '放送';

  @override
  String get catalogKindOther => 'その他';

  @override
  String get catalogSecLive => 'ライブ';

  @override
  String get catalogSecCompilation => 'コンピレーション';

  @override
  String get catalogSecSoundtrack => 'サウンドトラック';

  @override
  String get catalogSecMixtape => 'ミックステープ';

  @override
  String get catalogSecInterview => 'インタビュー';

  @override
  String get catalogSecSpokenword => 'スポークンワード';

  @override
  String catalogDownloadingOne(String title) {
    return '$titleをダウンロード中';
  }

  @override
  String catalogDownloadingMany(int count, String artist) {
    return '$artistのアルバム$count枚をダウンロード中';
  }

  @override
  String catalogCheckingDiscography(int seconds) {
    return 'ディスコグラフィーを確認中… $seconds秒';
  }

  @override
  String catalogToDownload(int count) {
    return '$count件をダウンロード';
  }

  @override
  String catalogInLibraryCount(int count) {
    return '$count件はすでにライブラリにあります';
  }

  @override
  String catalogSkippedOneSong(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '1曲のみのリリース$count件を除外',
      one: '1曲のみのリリース1件を除外',
    );
    return '$_temp0';
  }

  @override
  String get catalogPickAll => 'すべて';

  @override
  String get catalogPickStudio => 'スタジオ';

  @override
  String get catalogPickNone => 'なし';

  @override
  String get catalogDownloadSelected => '選択項目をダウンロード';

  @override
  String catalogDownloadNSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '選択した$count件をダウンロード',
      one: '選択した1件をダウンロード',
    );
    return '$_temp0';
  }

  @override
  String get catalogNothingMissing => '不足はありません。';

  @override
  String get catalogPartial => '一部';

  @override
  String get catalogDownload => 'ダウンロード';

  @override
  String get catalogAddToLibrary => 'ライブラリに追加';

  @override
  String get catalogInYourLibrary => 'ライブラリに追加済み';

  @override
  String get catalogAllInLibrary => 'すべてライブラリにあります';

  @override
  String catalogNInLibrary(int count) {
    return '$count件がライブラリにあります';
  }

  @override
  String get catalogDownloadAlbum => 'アルバムをダウンロード';

  @override
  String get catalogArtistNotFound => 'アーティストが見つかりません。';

  @override
  String get catalogFromCatalog => 'カタログから: まだライブラリにありません';

  @override
  String get catalogDownloadAll => 'すべてダウンロード';

  @override
  String get catalogDownloadDiscography => 'ディスコグラフィーをダウンロード';

  @override
  String get catalogPopular => '人気';

  @override
  String get catalogShowLess => '一部を表示';

  @override
  String get catalogShowMore => 'もっと見る';

  @override
  String get catalogSinglesEps => 'シングルとEP';

  @override
  String get catalogFansAlsoLike => 'ファンはこちらも好き';

  @override
  String get lyricsPlaySomething => '曲を再生すると歌詞が表示されます。';

  @override
  String get lyricsNone => 'この曲の歌詞はありません';

  @override
  String get lyricsNoneHint => 'ファイルと同じ場所に.lrcまたは.txtがあると、ここに表示されます。';

  @override
  String get lyricsFind => '歌詞を探す';

  @override
  String get lyricsFinding => '歌詞を検索中…';

  @override
  String get lyricsNotFound => 'この曲の歌詞が見つかりませんでした';

  @override
  String get lyricsSynced => '.lrcファイルの同期歌詞';

  @override
  String get lyricsUnsynced => '非同期の歌詞';

  @override
  String get profileChangePhoto => '写真を変更';

  @override
  String get profileNoPhoto => '写真が選択されていません';

  @override
  String get profilePhotoTooBig => '写真が大きすぎます（8MBまで）';

  @override
  String get profilePhotoChanged => 'プロフィール写真を変更しました';

  @override
  String get profilePhotoRemoved => '写真を削除しました';

  @override
  String get profileNameSaved => 'プロフィール名を保存しました';

  @override
  String get profileRenameTitle => 'ユーザー名を変更しますか？';

  @override
  String profileRenameBody(String name) {
    return 'Pudim、Jellyfin、その他のアプリ（Finamp、Feishinなど）で「$name」としてサインインします。ディスカバリー、ミックス、Rewindは引き継がれます。';
  }

  @override
  String get profileRenameConfirm => '変更';

  @override
  String profileNowSignedAs(String name) {
    return '今後は$nameとしてサインインします';
  }

  @override
  String get profileEnterNewPassword => '新しいパスワードを入力してください';

  @override
  String get profilePasswordsDiffer => '新しいパスワードが一致しません';

  @override
  String get profilePasswordChanged => 'パスワードを変更しました';

  @override
  String get profileExtrasUnreachable =>
      'エクストラサーバーに接続できませんでした。プロフィール名とユーザー名の変更は後で行ってください。';

  @override
  String get profileNameSection => 'プロフィール名';

  @override
  String get profileNameHelp => 'チャットで連絡先に表示される名前です。';

  @override
  String get profileYourName => 'あなたの名前';

  @override
  String get profileUsernameSection => 'ユーザー名';

  @override
  String get profileUsernameHelp => 'Jellyfinへのサインインに使う名前です（このアプリでも他のアプリでも）。';

  @override
  String get profileUsernameHint => 'ユーザー名';

  @override
  String get profileChangeUsername => 'ユーザー名を変更';

  @override
  String get profilePasswordSection => 'パスワード';

  @override
  String get profileCurrentPassword => '現在のパスワード';

  @override
  String get profileNewPassword => '新しいパスワード';

  @override
  String get profileRepeatPassword => '新しいパスワードを再入力';

  @override
  String get profileChangePassword => 'パスワードを変更';

  @override
  String get loginServerRequired => 'Jellyfinサーバーのアドレスを入力してください。';

  @override
  String get loginUserRequired => 'ユーザー名を入力してください。';

  @override
  String get loginTitle => 'Pudimにサインイン';

  @override
  String get loginSubtitle => 'Jellyfinアカウントを使用してください。';

  @override
  String get loginUsername => 'ユーザー名';

  @override
  String get loginPassword => 'パスワード';

  @override
  String get loginShowPassword => 'パスワードを表示';

  @override
  String get loginHidePassword => 'パスワードを非表示';

  @override
  String get loginSubmit => 'サインイン';

  @override
  String get loginQuickConnect => 'Quick Connectでサインイン';

  @override
  String get loginHideAddresses => 'アドレスを隠す';

  @override
  String get loginServerAddress => 'サーバーアドレス';

  @override
  String get loginJellyfinServer => 'Jellyfinサーバー';

  @override
  String get loginJellyfinServerExample => '例: https://jellyfin.exemplo.com';

  @override
  String get loginLocalNetwork => 'ローカルネットワーク（任意）';

  @override
  String get loginLocalNetworkExample =>
      '例: http://192.168.0.10:8096。応答がある場合は、メインのアドレスの代わりにこちらを使用します。';

  @override
  String get loginExtrasServer => 'エクストラサーバー（任意）';

  @override
  String get loginExtrasServerHint =>
      'チャット、Jam、Blend、ミックス、Rewindが使えるようになります。お持ちでなければ空欄のままにしてください。';

  @override
  String get loginQcExpired => 'コードの有効期限が切れました。もう一度お試しください。';

  @override
  String get loginQcInstructions =>
      'すでにJellyfinにサインインしているデバイスでプロフィールを開き、Quick Connectをタップして、このコードを入力してください:';

  @override
  String get loginQcWaiting => '承認を待っています…';

  @override
  String get homeDownloadedOnDevice => 'このデバイスにダウンロード済み';

  @override
  String get homeTabMusic => '音楽';

  @override
  String get homeMadeFor => 'あなたのために作成';

  @override
  String get homeMixDiscoveries => '毎週届く、あなたのための新しい音楽';

  @override
  String get homeMixWeekly => 'お気に入りと似た曲を毎週お届け';

  @override
  String get homeMixRadar => '毎週金曜日に、フォロー中のアーティストの新作をお届け';

  @override
  String get homeMixDaylist => '1日を通して変化します';

  @override
  String get homeMixBlend => '2人の好みをひとつに';

  @override
  String get homeMixAuto => '自動ミックス';

  @override
  String get homeSpotifyPlaylists => 'Spotifyのプレイリスト';

  @override
  String get homeFromSpotify => 'Spotifyから';

  @override
  String get homeYourPlaylists => 'あなたのプレイリスト';

  @override
  String get homeTopAlbums => 'よく聴くアルバム';

  @override
  String get homeTopArtists => 'お気に入りのアーティスト';

  @override
  String get homeRecentlyAdded => '最近追加';

  @override
  String get homeYourPodcasts => 'あなたのポッドキャスト';

  @override
  String get homeRadiosTitle => 'おすすめのラジオ';

  @override
  String get homeRadiosSubtitle => 'お気に入りのアーティストをもとにした、途切れない音楽。';

  @override
  String get homeRadioBadge => 'ラジオ';

  @override
  String homeRadioWith(String name) {
    return '$nameと似たアーティスト';
  }

  @override
  String searchNoResults(String query) {
    return '「$query」の検索結果は見つかりませんでした';
  }

  @override
  String get searchNoResultsHint => 'スペルを確認するか、キーワードを減らす、または変えてみてください。';

  @override
  String searchCatalogNoResponse(String error) {
    return 'カタログが応答しませんでした: $error';
  }

  @override
  String get searchAlsoCatalog => 'カタログも検索中…';

  @override
  String searchLibraryOnly(String error) {
    return 'ライブラリのみ: カタログが応答しませんでした（$error）。';
  }

  @override
  String get searchTopResult => 'トップ結果';

  @override
  String get searchSpotifyPlaylists => 'Spotifyのプレイリスト';

  @override
  String get searchRecent => '最近の検索';

  @override
  String get searchClear => 'クリア';

  @override
  String get searchBrowseAll => 'すべて表示';

  @override
  String get searchHint => '何を聴きたいですか？';

  @override
  String get albumDownloadedType => 'アルバム • このデバイスにダウンロード済み';

  @override
  String albumSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count曲',
      one: '1曲',
    );
    return '$_temp0、$total';
  }

  @override
  String get albumRemoveFromLibrary => 'ライブラリから削除';

  @override
  String get albumSaveToLibrary => 'ライブラリに保存';

  @override
  String albumMoreOptions(String name) {
    return '$nameのその他のオプション';
  }

  @override
  String albumDisc(int number) {
    return 'ディスク$number';
  }

  @override
  String albumMoreFrom(String name) {
    return '$nameのその他の作品';
  }

  @override
  String artistAlbumsInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ライブラリに$count枚のアルバム',
      one: 'ライブラリに1枚のアルバム',
    );
    return '$_temp0';
  }

  @override
  String artistPlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count回再生',
      one: '1回再生',
    );
    return '$_temp0';
  }

  @override
  String artistMoreOptions(String name) {
    return '$nameのその他のオプション';
  }

  @override
  String get artistPopular => '人気';

  @override
  String get artistShowLess => '一部を表示';

  @override
  String get artistShowMore => 'もっと見る';

  @override
  String get artistYouLiked => 'お気に入りの曲';

  @override
  String artistFrom(String name) {
    return '$nameの作品';
  }

  @override
  String get artistDiscography => 'ディスコグラフィー';

  @override
  String get artistPopularReleases => '人気のリリース';

  @override
  String get artistSinglesEps => 'シングルとEP';

  @override
  String get artistFansAlsoLike => 'ファンはこちらも好き';

  @override
  String get artistAppearsOn => '参加作品';

  @override
  String get artistAbout => '概要';

  @override
  String get playlistOriginSpotify => 'Spotifyから';

  @override
  String get playlistOriginMadeForYou => 'あなたのために作成';

  @override
  String get playlistOriginAuto => '自動ミックス';

  @override
  String get playlistDownloadedOnDevice => 'このデバイスにダウンロード済み';

  @override
  String get playlistOnDevice => 'このデバイス内';

  @override
  String get playlistPlaysOffline => 'オフラインで再生できます。';

  @override
  String playlistPlaysOfflineDownloading(int count) {
    return 'オフラインで再生できます。残り$count曲をダウンロード中…';
  }

  @override
  String playlistSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count曲',
      one: '1曲',
    );
    return '$_temp0、$total';
  }

  @override
  String playlistMoreOptions(String name) {
    return '$nameのその他のオプション';
  }

  @override
  String get playlistSearchHint => 'プレイリスト内を検索';

  @override
  String get playlistEmpty => 'まだ曲がありません。';

  @override
  String get playlistErrNoPermission => 'このプレイリストを編集する権限がありません。';

  @override
  String playlistErrServer(String code) {
    return 'サーバーがリクエストを拒否しました（$code）。';
  }

  @override
  String get playlistErrNoResponse => '応答なし';

  @override
  String get playlistDownloadFirst => 'プレイリストに追加するには、先に曲をダウンロードしてください';

  @override
  String get playlistAddTo => 'プレイリストに追加';

  @override
  String get playlistNew => '新しいプレイリスト';

  @override
  String playlistAddedTo(String name) {
    return '$nameに追加しました';
  }

  @override
  String get playlistNameHint => 'プレイリスト名';

  @override
  String get playlistCreate => '作成';

  @override
  String playlistCreated(String name) {
    return 'プレイリスト「$name」を作成しました';
  }

  @override
  String get playlistRemoved => 'プレイリストから削除しました';

  @override
  String get playlistInviteTitle => '編集に招待';

  @override
  String get playlistInviteSubtitle =>
      '招待された人はライブラリにこのプレイリストが表示され、曲を追加・削除できます。';

  @override
  String get playlistInviteOwnerOnly => '招待できるのはプレイリストの作成者のみです';

  @override
  String playlistInvited(String who, String playlist) {
    return '$whoが$playlistを編集できるようになりました';
  }

  @override
  String playlistCollaborative(String members) {
    return '共同編集 · $members';
  }

  @override
  String get playlistSmartShuffleTooltip => 'Smart Shuffle: おすすめを加えてシャッフル';

  @override
  String get playlistSmartShuffleOn => 'Smart Shuffleオン: おすすめ曲には✦が付きます';

  @override
  String get playlistAddedToThis => 'プレイリストに追加済み';

  @override
  String get playlistRecommendation => 'Smart Shuffleのおすすめ';

  @override
  String get playlistPutIn => 'プレイリストに追加';

  @override
  String get settingsSectionAccount => 'アカウント';

  @override
  String get settingsProfileSubtitle => '名前、ユーザー名、パスワード';

  @override
  String settingsConnectedAt(String url) {
    return '$urlに接続中';
  }

  @override
  String get settingsSignOut => 'サインアウト';

  @override
  String get accountsTitle => 'アカウント';

  @override
  String get accountsAdd => 'アカウントまたはサーバーを追加';

  @override
  String get accountsSwitch => '切り替え';

  @override
  String get accountsInUse => '使用中';

  @override
  String accountsOn(String user, String host) {
    return '$host の $user';
  }

  @override
  String get loginBackToAccount => '現在のアカウントに戻る';

  @override
  String get settingsSectionServer => 'サーバー';

  @override
  String get settingsLocalNetwork => 'ローカルネットワーク';

  @override
  String get settingsServerNote =>
      'Jellyfinのアドレスを変更するには、サインアウトしてサインイン画面の「サーバーアドレス」を開いてください。';

  @override
  String get settingsExtrasServer => 'エクストラサーバー';

  @override
  String get settingsExtrasNotConfigured =>
      '未設定（チャット、Jam、Blend、ミックス、Recapは非表示になります）';

  @override
  String get settingsConfigure => '設定';

  @override
  String get settingsChange => '変更';

  @override
  String get settingsSectionPlayback => '再生';

  @override
  String get settingsQualityWifi => 'Wi-Fi時の音質';

  @override
  String get settingsQualityWifiSubtitle => '「オリジナル」はライブラリのファイルをそのまま再生します。';

  @override
  String get settingsQualityMobile => 'モバイルデータ通信時の音質';

  @override
  String get settingsQualityMobileSubtitle => '音質を下げるとデータ通信量を節約できます。';

  @override
  String get settingsQualityOriginal => 'オリジナル';

  @override
  String get settingsAppliesNextSong => '次の曲から適用されます';

  @override
  String get settingsSectionAbout => '情報';

  @override
  String settingsBuild(int build) {
    return 'ビルド $build';
  }

  @override
  String get settingsExtrasEmptyHint => '空欄にするとエクストラがオフになります。';

  @override
  String get settingsAutoplay => '自動再生';

  @override
  String get settingsAutoplaySubtitle =>
      'キューが終わったら、似た曲を続けて再生します（Jellyfinミックス）。';

  @override
  String get settingsNormalize => '音量を正規化';

  @override
  String get settingsNormalizeSubtitle => 'Jellyfinの解析結果をもとに、すべての曲を同じ音量で再生します。';

  @override
  String get settingsScrobble => 'スクロブル';

  @override
  String get settingsLoading => '読み込み中…';

  @override
  String get settingsLastfmNoKey => 'エクストラサーバーにLast.fmのAPIキーがまだ設定されていません。';

  @override
  String settingsConnectedAs(String name) {
    return '$nameとして接続中';
  }

  @override
  String get settingsLastfmConnectedSubtitle =>
      'Pudimで聴いたものはすべてLast.fmのプロフィールに記録されます。';

  @override
  String get settingsDisconnect => '接続を解除';

  @override
  String get settingsLastfmAuthorize => 'Last.fmのページで承認';

  @override
  String get settingsLastfmAuthorizeSubtitle =>
      'そのページで「Yes, allow access」をクリックしたら、戻って「完了」をタップしてください。';

  @override
  String get settingsFinish => '完了';

  @override
  String get settingsLastfmConnected => 'Last.fmに接続しました';

  @override
  String get settingsLastfmScrobbleSubtitle => '聴いた曲をすべてLast.fmに記録します。';

  @override
  String get settingsConnect => '接続';

  @override
  String get sidebarOpenLibrary => 'ライブラリを開く';

  @override
  String get sidebarCollapseLibrary => 'ライブラリを閉じる';

  @override
  String sidebarOnDeviceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count曲',
      one: '1曲',
    );
    return 'デバイス内 • $_temp0';
  }

  @override
  String sidebarPlaylistCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count曲',
      one: '1曲',
    );
    return 'プレイリスト • $_temp0';
  }

  @override
  String sidebarAlbumBy(String artist) {
    return 'アルバム • $artist';
  }

  @override
  String get sidebarSearchLibrary => 'ライブラリ内を検索';

  @override
  String get sidebarSortBy => '並べ替え';

  @override
  String get sidebarSortRecents => '最近の項目';

  @override
  String get sidebarSortAdded => '最近追加';

  @override
  String get sidebarSortAlpha => '五十音順';

  @override
  String get sidebarSortCreator => '作成者';

  @override
  String get topBarSearchHint => '何を再生しますか？';

  @override
  String get topBarClearSearch => '検索欄をクリア';

  @override
  String get topBarBrowse => '探す';

  @override
  String get topBarMenu => 'メニュー';

  @override
  String get topBarLogoutAccount => 'ログアウト';

  @override
  String get topBarQuit => 'Pudimを終了';

  @override
  String get topBarLogout => 'ログアウト';

  @override
  String get playerBarSmartShuffleOff => 'Smart Shuffleをオフ';

  @override
  String get playerBarSmartShuffleOn => 'Smart Shuffleをオン';

  @override
  String get playerBarShuffleOff => 'シャッフルをオフ';

  @override
  String get playerBarShuffleOn => 'シャッフルをオン';

  @override
  String get playerBarPlay => '再生';

  @override
  String get playerBarForward => '次へ';

  @override
  String get playerBarRepeatOn => 'リピートをオン';

  @override
  String get playerBarRepeatOne => '1曲リピートをオン';

  @override
  String get playerBarRepeatOff => 'リピートをオフ';

  @override
  String get playerBarNowPlayingView => '再生中画面';

  @override
  String get playerBarLyrics => '歌詞';

  @override
  String get playerBarUnmute => 'ミュート解除';

  @override
  String get playerBarMute => 'ミュート';

  @override
  String get rightPanelNothingPlaying => '曲を再生すると、ここに再生中の内容が表示されます。';

  @override
  String get rightPanelLyricsPreview => '歌詞のプレビュー';

  @override
  String get rightPanelAboutArtist => 'アーティストについて';

  @override
  String get rightPanelNextUp => '次に再生';

  @override
  String get rightPanelOpenQueue => 'キューを開く';

  @override
  String get rightPanelQueueEmptyTitle => 'キューに追加';

  @override
  String get rightPanelQueueEmptyHint => '曲のメニューで「キューに追加」をクリックすると、ここに表示されます';

  @override
  String get rightPanelNowPlaying => '再生中';

  @override
  String get rightPanelNextInQueue => 'キューの次の曲';

  @override
  String rightPanelNextFrom(String name) {
    return '次の再生元: $name';
  }

  @override
  String get nowPlayingPlayingFrom => '再生元';

  @override
  String get nowPlayingMoreOptions => 'その他のオプション';

  @override
  String get chatChats => 'チャット';

  @override
  String chatYouSaid(String text) {
    return 'あなた: $text';
  }

  @override
  String get chatContacts => '連絡先';

  @override
  String get chatServerUnreachable => 'エクストラサーバーに接続できませんでした。';

  @override
  String get chatMessageHint => 'メッセージ';

  @override
  String chatJoinedJam(String title) {
    return '$titleに参加しました';
  }

  @override
  String chatCouldNotPlay(String error) {
    return '再生できませんでした: $error';
  }

  @override
  String get chatJamCardSubtitle => '同じキューをみんなで聴く';

  @override
  String get chatInJam => 'Jam参加中';

  @override
  String get chatJoin => '参加';

  @override
  String get chatNoOtherAccounts => 'サーバーに他のアカウントはありません。';

  @override
  String chatSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count曲',
      one: '1曲',
    );
    return '$_temp0';
  }

  @override
  String chatSentTo(String name) {
    return '$nameに送信しました';
  }

  @override
  String chatShareTitle(String title) {
    return '$titleを共有';
  }

  @override
  String get chatNoteHint => 'メモ（任意）';

  @override
  String get blendWorking => 'ブレンド中…';

  @override
  String blendAffinityButton(int affinity) {
    return 'Blend $affinity%';
  }

  @override
  String get blendCreate => 'Blendを作成';

  @override
  String blendWith(String name) {
    return '$nameとBlend';
  }

  @override
  String get blendExplain =>
      '2人で共有する1つのプレイリスト。2人がよく聴く曲、共通のアーティスト、それぞれの一番のお気に入りが少しずつ入ります。好みの一致度も表示され、毎日更新されます。';

  @override
  String get blendNotNow => '今はしない';

  @override
  String blendAffinityTitle(int affinity) {
    return '相性は$affinity%です';
  }

  @override
  String blendInCommon(String artists) {
    return '共通: $artists';
  }

  @override
  String blendOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Blendを開く（$count曲）',
      one: 'Blendを開く（1曲）',
    );
    return '$_temp0';
  }

  @override
  String get blendRefreshNow => '今すぐ更新';

  @override
  String get blendUndo => 'Blendを削除';

  @override
  String get blendRefreshing => 'Blendを更新中…';

  @override
  String get blendUndoTitle => 'Blendを削除しますか？';

  @override
  String blendUndoBody(String name) {
    return 'プレイリストはあなたと$nameの両方から消えます。';
  }

  @override
  String get blendUndoConfirm => '削除';

  @override
  String get blendUndone => 'Blendを削除しました';

  @override
  String get jamStart => 'Jamを開始';

  @override
  String jamTooltip(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jam（$count人）',
      one: 'Jam（1人）',
    );
    return '$_temp0';
  }

  @override
  String get jamSubIdle => '他のアカウントと同じキューで一緒に聴きます。';

  @override
  String get jamSubHost => 'あなたがホストです。全員が曲をリクエストできます。';

  @override
  String get jamSubGuest => 'あなたの操作と曲は全員のキューに反映されます。';

  @override
  String get jamPlayFirst => 'Jamを始める前に曲を再生してください。';

  @override
  String jamMembers(int count) {
    return 'Jam参加者（$count）';
  }

  @override
  String jamYouSuffix(String name) {
    return '$name（あなた）';
  }

  @override
  String get jamHost => 'ホスト';

  @override
  String get jamInvite => '招待';

  @override
  String get jamInviteTitle => 'Jamに招待';

  @override
  String get jamInviteSubtitle => '招待は相手のチャットに届きます。';

  @override
  String jamInviteSent(String name) {
    return '$nameに招待を送りました';
  }

  @override
  String get jamEnd => 'Jamを終了';

  @override
  String get jamLeave => 'Jamから退出';

  @override
  String recapTitle(int year) {
    return '$year年のWrapped';
  }

  @override
  String get recapShort => 'Wrapped';

  @override
  String recapBannerBody(String minutes) {
    return '今年は$minutes分の音楽を聴きました。よく聴いた曲をチェックしましょう。';
  }

  @override
  String get recapEmpty => 'Wrappedを作成するための再生履歴がまだありません。';

  @override
  String get recapShareCards => 'カードを共有';

  @override
  String get recapBigMinutes => '分聴きました';

  @override
  String get recapBigSongs => '種類の曲';

  @override
  String get recapBigArtists => '組のアーティスト';

  @override
  String get recapBigDays => '日音楽を聴いた';

  @override
  String get recapBigStreak => '日連続、自己ベスト';

  @override
  String get recapTopArtists => '今年のトップアーティスト';

  @override
  String recapMinutesValue(String minutes) {
    return '$minutes分';
  }

  @override
  String get recapTopSongs => '今年のトップソング';

  @override
  String recapPlaysLine(String artist, String plays) {
    return '$artist • $plays回再生';
  }

  @override
  String get recapSongGone => 'この曲はライブラリにありません';

  @override
  String get recapTopAlbums => '今年のトップアルバム';

  @override
  String get recapTopGenres => 'よく聴いたジャンル';

  @override
  String recapGenreLine(String genre, String minutes) {
    return '$genre • $minutes分';
  }

  @override
  String get recapMonthly => '月別';

  @override
  String recapMonthTooltip(String month, String minutes) {
    return '$month: $minutes分';
  }

  @override
  String get recapListeningStyle => 'あなたの聴き方';

  @override
  String recapFavHour(String hour) {
    return 'よく聴く時間帯: $hour:00';
  }

  @override
  String recapFavWeekday(String day) {
    return 'よく聴く曜日: $day';
  }

  @override
  String recapBiggestDay(String date, String minutes) {
    return '一番聴いた日: $date、$minutes分';
  }

  @override
  String recapNewArtists(int count, String n) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '新しく出会ったアーティスト$n組',
      one: '新しく出会ったアーティスト$n組',
    );
    return '$_temp0';
  }

  @override
  String recapSpotifyAdded(String added) {
    return 'Spotifyの再生履歴$added件を追加しました。';
  }

  @override
  String recapSpotifyAddedDup(String added, String dup) {
    return 'Spotifyの再生履歴$added件を追加しました（$dup件はPudimの履歴としてすでにありました）。';
  }

  @override
  String get recapSpotifyRemoveTitle => 'Spotifyの履歴を削除しますか？';

  @override
  String get recapSpotifyRemoveBody =>
      'Wrappedは、Pudim/Jellyfinで再生した分のみのカウントに戻ります。後でもう一度インポートできます。';

  @override
  String get recapSpotifyRemoveConfirm => '削除';

  @override
  String recapSpotifyRemoved(String count) {
    return 'Spotifyの再生履歴$count件を削除しました';
  }

  @override
  String get recapSpotifyTitle => 'Spotifyの履歴';

  @override
  String recapSpotifyHasData(String count, String from, String to) {
    return 'Wrappedに含まれるSpotifyの再生履歴は$count件（$from〜$to）です。新しいファイルをアップロードできます。すでに含まれている分は二重にカウントされません。';
  }

  @override
  String get recapSpotifyIntro =>
      'Pudimを使う前の年月も取り込みましょう。Spotifyで「アカウント > プライバシー > データをダウンロード」を開き、「Extended streaming history」を選択します。メールが届いたら、ここでmy_spotify_data.zipを選んでください。';

  @override
  String get recapSpotifyImportAnother => '別のファイルをインポート';

  @override
  String get recapSpotifyImport => '履歴をインポート';

  @override
  String get recapSpotifyRemoveBtn => 'Wrappedから削除';

  @override
  String get recapShareSaveDialog => 'カードを保存';

  @override
  String get recapShareSaved => 'カードを保存しました';

  @override
  String recapShareSaveFailed(String error) {
    return '保存できませんでした: $error';
  }

  @override
  String recapShareShareFailed(String error) {
    return '共有できませんでした: $error';
  }

  @override
  String recapShareText(int year) {
    return 'Pudimでの$year年のWrapped';
  }

  @override
  String get recapShareMyArtists => '今年のトップアーティスト';

  @override
  String get recapShareMySongs => '今年のトップソング';

  @override
  String recapMinShort(String minutes) {
    return '$minutes分';
  }

  @override
  String get recapShareSaveImage => '画像を保存';

  @override
  String get recapShareButton => '共有';

  @override
  String recapBrand(int year) {
    return 'Wrapped $year';
  }

  @override
  String get recapShareMyYear => '私の音楽の1年';

  @override
  String recapShareYearOf(String name) {
    return '$nameの音楽の1年';
  }

  @override
  String get recapShareTopArtist => '今年のトップアーティスト';

  @override
  String recapShareGenres(String genres) {
    return 'ジャンル: $genres';
  }

  @override
  String get widgetActionsAddedToLiked => 'お気に入りの曲に追加しました';

  @override
  String get widgetActionsRemovedFromLiked => 'お気に入りの曲から削除しました';

  @override
  String get widgetActionsUnfollowed => 'フォローを解除しました';

  @override
  String get widgetActionsSavedToLibrary => 'ライブラリに保存しました';

  @override
  String get widgetActionsRemovedFromLibrary => 'ライブラリから削除しました';

  @override
  String get widgetActionsAddToQueue => 'キューに追加';

  @override
  String get widgetActionsAddedToQueue => 'キューに追加しました';

  @override
  String get widgetActionsPlayNext => '次に再生';

  @override
  String get widgetActionsGoToPodcast => 'ポッドキャストへ移動';

  @override
  String get widgetActionsRemoveFromQueue => 'キューから削除';

  @override
  String get widgetActionsAddToPlaylist => 'プレイリストに追加';

  @override
  String get widgetActionsRemoveFromThisPlaylist => 'このプレイリストから削除';

  @override
  String get widgetActionsInviteToEdit => '編集に招待';

  @override
  String get widgetActionsKeepInPlaylist => 'プレイリストに残す';

  @override
  String get widgetActionsDownloadTrack => '曲をダウンロード';

  @override
  String get widgetActionsDownloadAlbum => 'アルバムをダウンロード';

  @override
  String get widgetActionsDownloadDiscography => 'ディスコグラフィーをダウンロード';

  @override
  String get widgetActionsSearchAlbums => 'アルバムを探す';

  @override
  String widgetActionsImproveQuality(int count) {
    return '音質を改善（$count）';
  }

  @override
  String widgetActionsImprovingAlbums(int count) {
    return '$count枚のアルバムのより良いバージョンを探しています';
  }

  @override
  String get widgetActionsShare => '共有';

  @override
  String get widgetActionsSearchFlac => 'FLACで探す';

  @override
  String widgetActionsSearchingFlac(String name) {
    return '$nameをFLACで探しています。見つかった場合はMP3と置き換えます';
  }

  @override
  String get widgetActionsTrackRemovedFromDevice => 'デバイスから削除しました';

  @override
  String get widgetActionsRemovedFromDevice => 'デバイスから削除しました';

  @override
  String get widgetActionsDownloadingToDevice => 'オフラインで聴けるよう、デバイスにダウンロード中です';

  @override
  String get widgetActionsUnfollow => 'フォロー解除';

  @override
  String get widgetActionsRemoveFromLibrary => 'ライブラリから削除';

  @override
  String get widgetActionsAddToLibrary => 'ライブラリに追加';

  @override
  String get widgetActionsGoToSongRadio => '曲のラジオへ移動';

  @override
  String get widgetActionsStartMix => 'ミックスを開始';

  @override
  String widgetActionsMixOf(String name) {
    return '$nameミックス';
  }

  @override
  String get widgetActionsGoToArtist => 'アーティストへ移動';

  @override
  String get widgetActionsGoToAlbum => 'アルバムへ移動';

  @override
  String get widgetActionsCopyName => '名前をコピー';

  @override
  String get widgetActionsCopied => 'コピーしました';

  @override
  String widgetDownloadsBellDownloading(int count) {
    return '$count件ダウンロード中';
  }

  @override
  String get widgetDownloadsBellEmpty =>
      'まだ何もありません。クラウドアイコンの付いた曲を再生するか、⋯メニューの「ダウンロード」を使って、カタログからライブラリに追加しましょう。';

  @override
  String get widgetDownloadsBellKindDiscography => 'ディスコグラフィー';

  @override
  String get widgetDownloadsBellKindFlac => 'FLAC';

  @override
  String get widgetDownloadsBellKindQuality => '音質';

  @override
  String get widgetDownloadsBellOptions => 'オプション';

  @override
  String get widgetDownloadsBellCancelled => 'ダウンロードをキャンセルしました';

  @override
  String get widgetDownloadsBellRetrying => '再試行中';

  @override
  String get widgetDownloadsBellRemovedFromList => 'リストから削除しました';

  @override
  String get widgetDownloadsBellDetails => '詳細を表示';

  @override
  String get widgetDownloadsBellRemoveFromList => 'リストから削除';

  @override
  String get widgetMixSearchingReleases => '新作を探しています…';

  @override
  String get widgetMixBuildingDaylist => 'daylistを作成中…';

  @override
  String get widgetMixNewDiscoveriesTitle => '新しいWeekly Discoveriesにしますか？';

  @override
  String get widgetMixNewMixTitle => '新しいWeekly Mixにしますか？';

  @override
  String get widgetMixNewDiscoveriesBody =>
      'まだ聴いていない曲がプレイリストから外れ、新しい曲が約30曲入ります。毎週月曜日に自動でも行われます。';

  @override
  String get widgetMixNewMixBody => 'お気に入り、よく聴く曲、似た曲で作り直します。毎週月曜日に自動でも行われます。';

  @override
  String get widgetMixNotNow => '今はしない';

  @override
  String get widgetMixBuildingDiscoveries => 'Discoveriesを作成中…';

  @override
  String get widgetMixBuildingMix => 'Mixを作成中…';

  @override
  String widgetMixBuiltOn(String date) {
    return '$dateに作成';
  }

  @override
  String get widgetMixRedo => '作り直す';

  @override
  String get widgetMixRefresh => '更新';

  @override
  String get widgetMixCreateDiscoveries => 'Weekly Discoveriesを作成';

  @override
  String get widgetMixCreateMix => 'Weekly Mixを作成';

  @override
  String get widgetMixCreateRadar => 'New Releases Radarを作成';

  @override
  String get widgetMixCreateDaylist => 'daylistを作成';

  @override
  String get widgetOfflineBanner => 'オフライン · デバイスに保存した内容を表示中';

  @override
  String widgetOfflineDownloadingProgress(int done, int total) {
    return '$total件中$done件をダウンロード中';
  }

  @override
  String get widgetUpdateReady => 'Pudimの新バージョンが利用できます';

  @override
  String widgetUpdateReadyNotes(String notes) {
    return 'Pudimの新バージョン · $notes';
  }

  @override
  String get widgetUpdateAction => 'アップデート';

  @override
  String widgetSleepShortMinutes(int count) {
    return '$count分';
  }

  @override
  String widgetSleepShortSeconds(int count) {
    return '$count秒';
  }

  @override
  String get widgetSleepStopsAtEnd => '曲の終わりに停止';

  @override
  String widgetSleepStopsIn(String time) {
    return '$time後に停止';
  }

  @override
  String get widgetSleepTimer => 'スリープタイマー';

  @override
  String get widgetSleepTurnOff => 'タイマーをオフ';

  @override
  String get widgetSleepOneHour => '1時間';

  @override
  String get widgetSleepOneAndHalfHours => '1時間30分';

  @override
  String get widgetSleepEndOfSong => '曲の終わり';

  @override
  String get widgetSleepTurnedOff => 'タイマーをオフにしました';

  @override
  String get widgetSleepStopsWhenSongEnds => 'この曲が終わると音楽が停止します';

  @override
  String widgetSleepSongStopsIn(String time) {
    return '$time後に音楽が停止します';
  }

  @override
  String get widgetSpeedPodcast => 'ポッドキャストの再生速度';

  @override
  String get widgetCommonCatalogBadge => 'カタログから: まだライブラリにありません';

  @override
  String get widgetCommonShowAll => 'すべて表示';

  @override
  String get widgetCommonSomethingWentWrong => '問題が発生しました';

  @override
  String get widgetCommonListenDownloaded => 'ダウンロード済みの曲を聴く';

  @override
  String get widgetTracksTitle => 'タイトル';

  @override
  String get widgetTracksDateAdded => '追加日';

  @override
  String widgetTracksAddedBy(String name) {
    return '$nameが追加';
  }

  @override
  String get widgetTracksMoreOptions => 'その他のオプション';

  @override
  String widgetTracksAddedDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get castTooltip => 'キャスト';

  @override
  String get castTitle => '再生するデバイス';

  @override
  String get castThisDevice => 'このデバイス';

  @override
  String get castSearching => 'ネットワーク上のデバイスを検索中…';

  @override
  String get castNone => 'Chromecast が見つかりません。同じ Wi-Fi に接続してください。';

  @override
  String get castSearchAgain => '再検索';

  @override
  String get castStop => 'キャストを停止';

  @override
  String castPlayingOn(String name) {
    return '$name で再生中';
  }

  @override
  String castFailed(String name) {
    return '$name に接続できませんでした';
  }

  @override
  String get settingsSectionAppearance => '外観';

  @override
  String get settingsTheme => 'テーマ';

  @override
  String get settingsThemeSubtitle => 'すぐに色が変わります。';

  @override
  String get themeNightDesc => 'ダーク、角丸カード、浮かぶミニプレーヤー。';

  @override
  String get themeRedDesc => '純黒と赤、大きな正方形のジャケット、バーに付いたミニプレーヤー。';

  @override
  String get themeWaveDesc => '紫のグラデーション、太い文字、ピル型ミニプレーヤー。';

  @override
  String get themeRetroDesc => '立体的なグレーのウィンドウ、流れるタイトルの緑の表示、テキストリスト。';

  @override
  String get themeClassicDesc => '光沢のある青と黒のガラス、球形ボタン、ビジュアライザー、表形式のリスト。';

  @override
  String get settingsCheckUpdates => 'アップデートを確認';

  @override
  String get updateChecking => '確認中…';

  @override
  String updateUpToDate(int build) {
    return '最新バージョンです（ビルド $build）。';
  }

  @override
  String updateDownloading(int build, int percent) {
    return 'ビルド $build をダウンロード中… $percent%';
  }

  @override
  String updateFailed(String error) {
    return '確認できませんでした: $error';
  }

  @override
  String get updateUnavailable => '追加サーバーが設定されていません。';

  @override
  String get settingsHistory => '履歴';

  @override
  String get settingsHistorySubtitle => '過去の年のまとめと再生したすべての曲';

  @override
  String get historyRecaps => 'まとめ';

  @override
  String get historyPlays => '再生';

  @override
  String get historyWholeYear => '年間';

  @override
  String get historyLoadMore => 'さらに読み込む';

  @override
  String get historyEmpty => 'まだ再生履歴がありません';

  @override
  String get historyImported => 'インポート';

  @override
  String widgetMixRadarDone(int count) {
    return '新作レーダー: $count 曲';
  }

  @override
  String widgetMixRadarQueued(int count, String list) {
    return '$count 件の新作をダウンロード中: $list';
  }

  @override
  String widgetMixRadarFailed(String error) {
    return 'レーダーを更新できませんでした: $error';
  }
}
