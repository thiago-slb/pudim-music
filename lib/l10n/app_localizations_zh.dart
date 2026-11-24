// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class L10nZh extends L10n {
  L10nZh([String locale = 'zh']) : super(locale);

  @override
  String get languageTitle => '语言';

  @override
  String get languageSubtitle => '界面语言';

  @override
  String get languageSystem => '跟随系统';

  @override
  String get commonCancel => '取消';

  @override
  String get commonClose => '关闭';

  @override
  String get commonBack => '返回';

  @override
  String get commonSave => '保存';

  @override
  String get commonEdit => '编辑';

  @override
  String get commonDelete => '删除';

  @override
  String get commonRemove => '移除';

  @override
  String get commonOk => '确定';

  @override
  String get commonRetry => '重试';

  @override
  String get commonQueue => '播放队列';

  @override
  String get commonAlbum => '专辑';

  @override
  String get commonAlbums => '专辑';

  @override
  String get commonArtist => '艺人';

  @override
  String get commonArtists => '艺人';

  @override
  String get commonSong => '歌曲';

  @override
  String get commonSongs => '歌曲';

  @override
  String get commonPlaylist => '播放列表';

  @override
  String get commonPlaylists => '播放列表';

  @override
  String get commonSingle => '单曲';

  @override
  String get commonLikedSongs => '喜欢的歌曲';

  @override
  String get commonAddToLiked => '添加到“喜欢的歌曲”';

  @override
  String get commonRemoveFromLiked => '从“喜欢的歌曲”中移除';

  @override
  String get commonShufflePlay => '随机播放';

  @override
  String get commonPlay => '播放';

  @override
  String get commonPause => '暂停';

  @override
  String get commonFollow => '关注';

  @override
  String get commonFollowing => '已关注';

  @override
  String get commonDownloadToDevice => '下载到设备';

  @override
  String get commonRemoveFromDevice => '从设备中移除';

  @override
  String get commonDownloaded => '已下载';

  @override
  String get commonDownloads => '下载';

  @override
  String get commonAll => '全部';

  @override
  String get commonRecentlyPlayed => '最近播放';

  @override
  String get commonYourLibrary => '音乐库';

  @override
  String get commonHome => '主页';

  @override
  String get commonSearch => '搜索';

  @override
  String get commonProfile => '个人资料';

  @override
  String get commonSettings => '设置';

  @override
  String get commonBuilding => '生成中…';

  @override
  String get commonBuildNow => '立即生成';

  @override
  String get commonShows => '演出';

  @override
  String get commonPodcasts => '播客';

  @override
  String commonSongCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 首歌曲',
      zero: '没有歌曲',
    );
    return '$_temp0';
  }

  @override
  String commonMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 分钟',
    );
    return '$_temp0';
  }

  @override
  String commonError(String error) {
    return '错误：$error';
  }

  @override
  String get apiStatusQueued => '排队中';

  @override
  String get apiStatusDownloading => '下载中';

  @override
  String get apiStatusDone => '已添加到音乐库';

  @override
  String get apiStatusUpToDate => '音乐库中已有';

  @override
  String get apiStatusPartial => '部分已添加';

  @override
  String get apiStatusNotFound => '未找到';

  @override
  String get apiStatusCancelled => '已取消';

  @override
  String get apiStatusInterrupted => '已中断';

  @override
  String get apiStatusFailed => '失败';

  @override
  String get apiExtrasNoResponse => '扩展服务器没有响应。';

  @override
  String get apiAlbumListFailed => '无法列出专辑。';

  @override
  String apiPlaylistSaved(int found, int total) {
    return '播放列表已加入音乐库（$total 首中的 $found 首）';
  }

  @override
  String apiPlaylistDownloading(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 首歌曲',
    );
    return '播放列表已加入音乐库；还有 $_temp0正在下载';
  }

  @override
  String get apiBadCredentials => '用户名或密码错误。';

  @override
  String get apiServerUnreachable => '无法连接到服务器。';

  @override
  String get apiQuickConnectOff => '此服务器已关闭 Quick Connect。';

  @override
  String get apiWrongCurrentPassword => '当前密码不正确。';

  @override
  String stateChatShared(String title) {
    return '已分享 $title';
  }

  @override
  String stateDownloadingName(String name) {
    return '正在下载 $name';
  }

  @override
  String stateDownloadingRequests(int count) {
    return '正在下载 $count 个请求';
  }

  @override
  String stateDownloadArrived(String name) {
    return '$name 已添加到音乐库';
  }

  @override
  String stateDownloadPartial(String name) {
    return '$name 已部分添加';
  }

  @override
  String stateDownloadEnded(String name, String status) {
    return '$name：$status';
  }

  @override
  String get stateNotFromCatalog => '此项目不来自曲库。';

  @override
  String stateAlreadyDownloading(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': '这张专辑已在下载。',
      'artist': '这位艺人的全部专辑已在下载。',
      'other': '这首歌曲已在下载。',
    });
    return '$_temp0';
  }

  @override
  String stateDownloadRequested(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': '正在下载专辑，完成后会在通知铃铛中显示。',
      'artist': '正在下载全部专辑，完成后会在通知铃铛中显示。',
      'other': '正在下载歌曲，完成后会在通知铃铛中显示。',
    });
    return '$_temp0';
  }

  @override
  String get stateNotifyDownloadsChannel => '下载';

  @override
  String get stateNotifyDownloadsChannelDesc => '歌曲下载进度';

  @override
  String get stateNotifyNewsChannel => '最新动态';

  @override
  String get stateNotifyNewsChannelDesc => '新到歌曲、新发行、Descobertas 和 Mistura';

  @override
  String get stateOfflineLoose => '逐首下载';

  @override
  String get stateOfflineDoneTitle => '已下载到此设备';

  @override
  String stateOfflineDoneBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 首歌曲可离线收听',
    );
    return '$_temp0';
  }

  @override
  String get stateOfflineProgressTitle => '正在下载到此设备';

  @override
  String stateOfflineProgressBody(int done, int total, String name) {
    return '$done/$total • $name';
  }

  @override
  String get stateServerNoReply => '服务器没有响应，请检查地址。';

  @override
  String get stateServerNoReplyBoth => '两个地址的服务器都没有响应。';

  @override
  String get stateTokenStoreUnsupported =>
      '目前 Pudim 只能在 Windows 和 Android 上保存登录信息。';

  @override
  String get stateQualityPoor => '低音质';

  @override
  String get stateQualityPartial => '不完整';

  @override
  String get audioPlaybackChannel => '播放';

  @override
  String get audioRecentAlbums => '最近的专辑';

  @override
  String audioSearchContext(String query) {
    return '搜索：$query';
  }

  @override
  String audioRadioContext(String name) {
    return '$name 电台';
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
    return '$h 小时 $min 分钟';
  }

  @override
  String podcastsMin(int min) {
    return '$min 分钟';
  }

  @override
  String get podcastsPlayed => '已播放';

  @override
  String podcastsTimeLeft(String time) {
    return '剩余 $time';
  }

  @override
  String get podcastsSearchHint => '搜索播客';

  @override
  String get podcastsNothingFound => '未找到任何内容。';

  @override
  String get podcastsYours => '你的播客';

  @override
  String get podcastsNewEpisodes => '新一期';

  @override
  String get podcastsTrendingBrazil => '巴西热门';

  @override
  String get podcastsLoadFailed => '加载失败，请重试';

  @override
  String get podcastsNoEpisodes => '订阅源中没有节目。';

  @override
  String podcastsNoEpisodeMatch(String q) {
    return '没有与“$q”匹配的节目。';
  }

  @override
  String get podcastsKind => '播客';

  @override
  String get podcastsEpisodes => '节目';

  @override
  String podcastsEpisodesCount(int total) {
    return '节目（$total）';
  }

  @override
  String get podcastsFindEpisode => '搜索节目';

  @override
  String showsMonthName(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': '一月',
      'm2': '二月',
      'm3': '三月',
      'm4': '四月',
      'm5': '五月',
      'm6': '六月',
      'm7': '七月',
      'm8': '八月',
      'm9': '九月',
      'm10': '十月',
      'm11': '十一月',
      'other': '十二月',
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
      'w1': '周一',
      'w2': '周二',
      'w3': '周三',
      'w4': '周四',
      'w5': '周五',
      'w6': '周六',
      'other': '周日',
    });
    return '$_temp0';
  }

  @override
  String get showsFollowingNone => '来自你关注的艺人';

  @override
  String showsFollowingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '来自你关注的 $count 位艺人',
    );
    return '$_temp0';
  }

  @override
  String showsSearchingFor(int count) {
    return '正在查找 $count 位艺人的演出…';
  }

  @override
  String get showsUpcoming => '即将举行';

  @override
  String get showsPast => '已结束';

  @override
  String get showsInBrazil => '巴西';

  @override
  String get showsEmptyFollow => '关注艺人（艺人页面上的“关注”按钮）即可在此查看他们的演出。';

  @override
  String get showsNonePast => '暂无演出记录。';

  @override
  String get showsNoneUpcoming => '暂无已安排的演出。';

  @override
  String get showsStillSearching => '仍在查找…';

  @override
  String get showsSource => '日期来自 MusicBrainz（由乐迷维护）；新演出可能要过一段时间才会出现。';

  @override
  String get showsCancelled => '已取消';

  @override
  String get showsFestival => '音乐节';

  @override
  String get catalogKindAlbum => '专辑';

  @override
  String get catalogKindSingle => '单曲';

  @override
  String get catalogKindBroadcast => '广播';

  @override
  String get catalogKindOther => '其他';

  @override
  String get catalogSecLive => '现场';

  @override
  String get catalogSecCompilation => '合辑';

  @override
  String get catalogSecSoundtrack => '原声带';

  @override
  String get catalogSecMixtape => '混音带';

  @override
  String get catalogSecInterview => '访谈';

  @override
  String get catalogSecSpokenword => '口述';

  @override
  String catalogDownloadingOne(String title) {
    return '正在下载 $title';
  }

  @override
  String catalogDownloadingMany(int count, String artist) {
    return '正在下载 $artist 的 $count 张专辑';
  }

  @override
  String catalogCheckingDiscography(int seconds) {
    return '正在检查全部专辑… $seconds 秒';
  }

  @override
  String catalogToDownload(int count) {
    return '$count 张待下载';
  }

  @override
  String catalogInLibraryCount(int count) {
    return '音乐库中已有 $count 张';
  }

  @override
  String catalogSkippedOneSong(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已略过 $count 个单曲发行',
    );
    return '$_temp0';
  }

  @override
  String get catalogPickAll => '全部';

  @override
  String get catalogPickStudio => '录音室';

  @override
  String get catalogPickNone => '无';

  @override
  String get catalogDownloadSelected => '下载所选';

  @override
  String catalogDownloadNSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '下载所选的 $count 项',
    );
    return '$_temp0';
  }

  @override
  String get catalogNothingMissing => '没有缺失的内容。';

  @override
  String get catalogPartial => '部分';

  @override
  String get catalogDownload => '下载';

  @override
  String get catalogAddToLibrary => '添加到音乐库';

  @override
  String get catalogInYourLibrary => '已在音乐库中';

  @override
  String get catalogAllInLibrary => '音乐库中已全部拥有';

  @override
  String catalogNInLibrary(int count) {
    return '音乐库中有 $count 张';
  }

  @override
  String get catalogDownloadAlbum => '下载专辑';

  @override
  String get catalogArtistNotFound => '未找到艺人。';

  @override
  String get catalogFromCatalog => '来自曲库：尚未加入音乐库';

  @override
  String get catalogDownloadAll => '全部下载';

  @override
  String get catalogDownloadDiscography => '下载全部专辑';

  @override
  String get catalogPopular => '热门';

  @override
  String get catalogShowLess => '收起';

  @override
  String get catalogShowMore => '展开';

  @override
  String get catalogSinglesEps => '单曲与 EP';

  @override
  String get catalogFansAlsoLike => '粉丝也喜欢';

  @override
  String get lyricsPlaySomething => '播放歌曲即可查看歌词。';

  @override
  String get lyricsNone => '这首歌没有歌词';

  @override
  String get lyricsNoneHint => '文件旁边有 .lrc 或 .txt 文件时，歌词会显示在这里。';

  @override
  String get lyricsSynced => '来自 .lrc 文件的同步歌词';

  @override
  String get lyricsUnsynced => '非同步歌词';

  @override
  String get profileChangePhoto => '更换头像';

  @override
  String get profileNoPhoto => '未选择照片';

  @override
  String get profilePhotoTooBig => '照片过大（最大 8 MB）';

  @override
  String get profilePhotoChanged => '头像已更换';

  @override
  String get profilePhotoRemoved => '照片已移除';

  @override
  String get profileNameSaved => '昵称已保存';

  @override
  String get profileRenameTitle => '更改用户名？';

  @override
  String profileRenameBody(String name) {
    return '你将以“$name”登录 Pudim、Jellyfin 和其他应用（Finamp、Feishin…）。你的 Discoveries、Mix 和 Rewind 会一并保留。';
  }

  @override
  String get profileRenameConfirm => '更改';

  @override
  String profileNowSignedAs(String name) {
    return '你现在以 $name 登录';
  }

  @override
  String get profileEnterNewPassword => '请输入新密码';

  @override
  String get profilePasswordsDiffer => '两次输入的新密码不一致';

  @override
  String get profilePasswordChanged => '密码已更改';

  @override
  String get profileExtrasUnreachable => '无法连接扩展服务器；昵称和用户名需稍后再改。';

  @override
  String get profileNameSection => '昵称';

  @override
  String get profileNameHelp => '你的联系人在聊天中看到的名字。';

  @override
  String get profileYourName => '你的名字';

  @override
  String get profileUsernameSection => '用户名';

  @override
  String get profileUsernameHelp => '用于登录 Jellyfin 的名称（在此处和其他应用中）。';

  @override
  String get profileUsernameHint => '用户名';

  @override
  String get profileChangeUsername => '更改用户名';

  @override
  String get profilePasswordSection => '密码';

  @override
  String get profileCurrentPassword => '当前密码';

  @override
  String get profileNewPassword => '新密码';

  @override
  String get profileRepeatPassword => '再次输入新密码';

  @override
  String get profileChangePassword => '更改密码';

  @override
  String get loginServerRequired => '请输入 Jellyfin 服务器地址。';

  @override
  String get loginUserRequired => '请输入用户名。';

  @override
  String get loginTitle => '登录 Pudim';

  @override
  String get loginSubtitle => '使用你的 Jellyfin 账号。';

  @override
  String get loginUsername => '用户名';

  @override
  String get loginPassword => '密码';

  @override
  String get loginShowPassword => '显示密码';

  @override
  String get loginHidePassword => '隐藏密码';

  @override
  String get loginSubmit => '登录';

  @override
  String get loginQuickConnect => '使用 Quick Connect 登录';

  @override
  String get loginHideAddresses => '隐藏地址';

  @override
  String get loginServerAddress => '服务器地址';

  @override
  String get loginJellyfinServer => 'Jellyfin 服务器';

  @override
  String get loginJellyfinServerExample => '例如 https://jellyfin.exemplo.com';

  @override
  String get loginLocalNetwork => '局域网地址（可选）';

  @override
  String get loginLocalNetworkExample =>
      '例如 http://192.168.0.10:8096。可连接时，应用会优先使用它而不是主地址。';

  @override
  String get loginExtrasServer => '扩展服务器（可选）';

  @override
  String get loginExtrasServerHint => '启用聊天、Jam、Blend、Mix 和 Rewind。没有的话请留空。';

  @override
  String get loginQcExpired => '验证码已过期，请重试。';

  @override
  String get loginQcInstructions =>
      '在已登录 Jellyfin 的设备上，打开你的个人资料，点按 Quick Connect 并输入此验证码：';

  @override
  String get loginQcWaiting => '等待批准…';

  @override
  String get homeDownloadedOnDevice => '已下载到此设备';

  @override
  String get homeTabMusic => '音乐';

  @override
  String get homeMadeFor => '专为你打造';

  @override
  String get homeMixDiscoveries => '每周为你推荐的新音乐';

  @override
  String get homeMixWeekly => '你喜爱的歌曲和相似歌曲，每周更新';

  @override
  String get homeMixRadar => '你关注的艺人的新发行，每周五更新';

  @override
  String get homeMixDaylist => '随一天时间而变化';

  @override
  String get homeMixBlend => '融合你们两人的口味';

  @override
  String get homeMixAuto => '自动合辑';

  @override
  String get homeSpotifyPlaylists => '你的 Spotify 播放列表';

  @override
  String get homeFromSpotify => '来自 Spotify';

  @override
  String get homeYourPlaylists => '你的播放列表';

  @override
  String get homeTopAlbums => '播放最多的专辑';

  @override
  String get homeTopArtists => '你最爱的艺人';

  @override
  String get homeRecentlyAdded => '最近添加';

  @override
  String get homeYourPodcasts => '你的播客';

  @override
  String get homeRadiosTitle => '推荐电台';

  @override
  String get homeRadiosSubtitle => '基于你最爱艺人的不间断音乐。';

  @override
  String get homeRadioBadge => '电台';

  @override
  String homeRadioWith(String name) {
    return '$name 及相似艺人';
  }

  @override
  String searchNoResults(String query) {
    return '未找到与“$query”相关的结果';
  }

  @override
  String get searchNoResultsHint => '请检查拼写，或使用更少或不同的关键词。';

  @override
  String searchCatalogNoResponse(String error) {
    return '曲库没有响应：$error';
  }

  @override
  String get searchAlsoCatalog => '同时在曲库中搜索…';

  @override
  String searchLibraryOnly(String error) {
    return '仅显示音乐库：曲库没有响应（$error）。';
  }

  @override
  String get searchTopResult => '最佳结果';

  @override
  String get searchSpotifyPlaylists => 'Spotify 播放列表';

  @override
  String get searchRecent => '最近搜索';

  @override
  String get searchClear => '清除';

  @override
  String get searchBrowseAll => '浏览全部';

  @override
  String get searchHint => '想听点什么？';

  @override
  String get albumDownloadedType => '专辑 • 已下载到此设备';

  @override
  String albumSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 首歌曲',
    );
    return '$_temp0，$total';
  }

  @override
  String get albumRemoveFromLibrary => '从音乐库中移除';

  @override
  String get albumSaveToLibrary => '保存到音乐库';

  @override
  String albumMoreOptions(String name) {
    return '$name 的更多选项';
  }

  @override
  String albumDisc(int number) {
    return '唱片 $number';
  }

  @override
  String albumMoreFrom(String name) {
    return '$name 的更多作品';
  }

  @override
  String artistAlbumsInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '音乐库中有 $count 张专辑',
    );
    return '$_temp0';
  }

  @override
  String artistPlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 次播放',
    );
    return '$_temp0';
  }

  @override
  String artistMoreOptions(String name) {
    return '$name 的更多选项';
  }

  @override
  String get artistPopular => '热门';

  @override
  String get artistShowLess => '收起';

  @override
  String get artistShowMore => '查看更多';

  @override
  String get artistYouLiked => '你喜欢的';

  @override
  String artistFrom(String name) {
    return '来自 $name';
  }

  @override
  String get artistDiscography => '全部作品';

  @override
  String get artistPopularReleases => '热门发行';

  @override
  String get artistSinglesEps => '单曲与 EP';

  @override
  String get artistFansAlsoLike => '粉丝也喜欢';

  @override
  String get artistAppearsOn => '参与作品';

  @override
  String get artistAbout => '简介';

  @override
  String get playlistOriginSpotify => '来自 Spotify';

  @override
  String get playlistOriginMadeForYou => '专为你打造';

  @override
  String get playlistOriginAuto => '自动合辑';

  @override
  String get playlistDownloadedOnDevice => '已下载到此设备';

  @override
  String get playlistOnDevice => '在此设备上';

  @override
  String get playlistPlaysOffline => '无需联网即可播放。';

  @override
  String playlistPlaysOfflineDownloading(int count) {
    return '无需联网即可播放。还有 $count 首正在下载…';
  }

  @override
  String playlistSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 首歌曲',
    );
    return '$_temp0，$total';
  }

  @override
  String playlistMoreOptions(String name) {
    return '$name 的更多选项';
  }

  @override
  String get playlistSearchHint => '在播放列表中搜索';

  @override
  String get playlistEmpty => '这里还没有歌曲。';

  @override
  String get playlistErrNoPermission => '你没有编辑此播放列表的权限。';

  @override
  String playlistErrServer(String code) {
    return '服务器拒绝了请求（$code）。';
  }

  @override
  String get playlistErrNoResponse => '无响应';

  @override
  String get playlistDownloadFirst => '请先下载歌曲，再添加到播放列表';

  @override
  String get playlistAddTo => '添加到播放列表';

  @override
  String get playlistNew => '新建播放列表';

  @override
  String playlistAddedTo(String name) {
    return '已添加到 $name';
  }

  @override
  String get playlistNameHint => '播放列表名称';

  @override
  String get playlistCreate => '创建';

  @override
  String playlistCreated(String name) {
    return '已创建播放列表 $name';
  }

  @override
  String get playlistRemoved => '已从播放列表中移除';

  @override
  String get playlistInviteTitle => '邀请共同编辑';

  @override
  String get playlistInviteSubtitle => '对方会在自己的音乐库中看到此播放列表，并可添加和移除歌曲。';

  @override
  String get playlistInviteOwnerOnly => '只有播放列表创建者可以邀请';

  @override
  String playlistInvited(String who, String playlist) {
    return '$who 现在可以编辑 $playlist';
  }

  @override
  String playlistCollaborative(String members) {
    return '协作 · $members';
  }

  @override
  String get playlistSmartShuffleTooltip => 'Smart Shuffle：带推荐的随机播放';

  @override
  String get playlistSmartShuffleOn => 'Smart Shuffle 已开启：推荐歌曲以 ✦ 标记';

  @override
  String get playlistAddedToThis => '已添加到播放列表';

  @override
  String get playlistRecommendation => 'Smart Shuffle 推荐';

  @override
  String get playlistPutIn => '添加到播放列表';

  @override
  String get settingsSectionAccount => '账号';

  @override
  String get settingsProfileSubtitle => '昵称、用户名和密码';

  @override
  String settingsConnectedAt(String url) {
    return '已连接到 $url';
  }

  @override
  String get settingsSignOut => '退出登录';

  @override
  String get accountsTitle => '账户';

  @override
  String get accountsAdd => '添加账户或服务器';

  @override
  String get accountsSwitch => '切换';

  @override
  String get accountsInUse => '使用中';

  @override
  String accountsOn(String user, String host) {
    return '$host 上的 $user';
  }

  @override
  String get loginBackToAccount => '返回当前账户';

  @override
  String get settingsSectionServer => '服务器';

  @override
  String get settingsLocalNetwork => '局域网';

  @override
  String get settingsServerNote => '如需更改 Jellyfin 地址，请退出登录，然后在登录界面打开“服务器地址”。';

  @override
  String get settingsExtrasServer => '扩展服务器';

  @override
  String get settingsExtrasNotConfigured =>
      '未配置（聊天、Jam、Blend、Mix 和 Recap 将被隐藏）';

  @override
  String get settingsConfigure => '设置';

  @override
  String get settingsChange => '更改';

  @override
  String get settingsSectionPlayback => '播放';

  @override
  String get settingsQualityWifi => 'Wi-Fi 音质';

  @override
  String get settingsQualityWifiSubtitle => '“原始”将按音乐库中的文件原样播放。';

  @override
  String get settingsQualityMobile => '移动数据音质';

  @override
  String get settingsQualityMobileSubtitle => '音质越低，消耗的移动数据越少。';

  @override
  String get settingsQualityOriginal => '原始';

  @override
  String get settingsAppliesNextSong => '从下一首歌曲开始生效';

  @override
  String get settingsSectionAbout => '关于';

  @override
  String settingsBuild(int build) {
    return '版本号 $build';
  }

  @override
  String get settingsExtrasEmptyHint => '留空即可关闭扩展功能。';

  @override
  String get settingsAutoplay => '自动播放';

  @override
  String get settingsAutoplaySubtitle => '队列结束后，继续播放相似歌曲（Jellyfin 合辑）。';

  @override
  String get settingsNormalize => '音量标准化';

  @override
  String get settingsNormalizeSubtitle => '根据 Jellyfin 的分析，以相同音量播放所有歌曲。';

  @override
  String get settingsScrobble => 'Scrobble';

  @override
  String get settingsLoading => '加载中…';

  @override
  String get settingsLastfmNoKey => '扩展服务器尚未配置 Last.fm API 密钥。';

  @override
  String settingsConnectedAs(String name) {
    return '已登录为 $name';
  }

  @override
  String get settingsLastfmConnectedSubtitle =>
      '你在 Pudim 上听的所有歌曲都会记录到你的 Last.fm 资料。';

  @override
  String get settingsDisconnect => '断开连接';

  @override
  String get settingsLastfmAuthorize => '在 Last.fm 页面授权';

  @override
  String get settingsLastfmAuthorizeSubtitle =>
      '在那里点击“Yes, allow access”后，返回并点按“完成”。';

  @override
  String get settingsFinish => '完成';

  @override
  String get settingsLastfmConnected => 'Last.fm 已连接';

  @override
  String get settingsLastfmScrobbleSubtitle => '将你听的每首歌曲记录到 Last.fm。';

  @override
  String get settingsConnect => '连接';

  @override
  String get sidebarOpenLibrary => '展开音乐库';

  @override
  String get sidebarCollapseLibrary => '收起音乐库';

  @override
  String sidebarOnDeviceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 首歌曲',
    );
    return '在设备上 • $_temp0';
  }

  @override
  String sidebarPlaylistCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 首歌曲',
    );
    return '播放列表 • $_temp0';
  }

  @override
  String sidebarAlbumBy(String artist) {
    return '专辑 • $artist';
  }

  @override
  String get sidebarSearchLibrary => '在音乐库中搜索';

  @override
  String get sidebarSortBy => '排序方式';

  @override
  String get sidebarSortRecents => '最近播放';

  @override
  String get sidebarSortAdded => '最近添加';

  @override
  String get sidebarSortAlpha => '按字母顺序';

  @override
  String get sidebarSortCreator => '创建者';

  @override
  String get topBarSearchHint => '想播放什么？';

  @override
  String get topBarClearSearch => '清除搜索框';

  @override
  String get topBarBrowse => '浏览';

  @override
  String get topBarMenu => '菜单';

  @override
  String get topBarLogoutAccount => '退出登录';

  @override
  String get topBarQuit => '退出 Pudim';

  @override
  String get topBarLogout => '退出登录';

  @override
  String get playerBarSmartShuffleOff => '关闭 Smart Shuffle';

  @override
  String get playerBarSmartShuffleOn => '开启 Smart Shuffle';

  @override
  String get playerBarShuffleOff => '关闭随机播放';

  @override
  String get playerBarShuffleOn => '开启随机播放';

  @override
  String get playerBarPlay => '播放';

  @override
  String get playerBarForward => '下一首';

  @override
  String get playerBarRepeatOn => '开启循环播放';

  @override
  String get playerBarRepeatOne => '开启单曲循环';

  @override
  String get playerBarRepeatOff => '关闭循环播放';

  @override
  String get playerBarNowPlayingView => '正在播放视图';

  @override
  String get playerBarLyrics => '歌词';

  @override
  String get playerBarUnmute => '取消静音';

  @override
  String get playerBarMute => '静音';

  @override
  String get rightPanelNothingPlaying => '播放歌曲后，正在播放的内容会显示在这里。';

  @override
  String get rightPanelLyricsPreview => '歌词预览';

  @override
  String get rightPanelAboutArtist => '关于艺人';

  @override
  String get rightPanelNextUp => '接下来播放';

  @override
  String get rightPanelOpenQueue => '打开播放队列';

  @override
  String get rightPanelQueueEmptyTitle => '添加到播放队列';

  @override
  String get rightPanelQueueEmptyHint => '在歌曲菜单中点击“添加到播放队列”即可放到这里';

  @override
  String get rightPanelNowPlaying => '正在播放';

  @override
  String get rightPanelNextInQueue => '队列中的下一首';

  @override
  String rightPanelNextFrom(String name) {
    return '接下来来自：$name';
  }

  @override
  String get nowPlayingPlayingFrom => '播放来源';

  @override
  String get nowPlayingMoreOptions => '更多选项';

  @override
  String get chatChats => '聊天';

  @override
  String chatYouSaid(String text) {
    return '你：$text';
  }

  @override
  String get chatContacts => '联系人';

  @override
  String get chatServerUnreachable => '无法连接扩展服务器。';

  @override
  String get chatMessageHint => '消息';

  @override
  String chatJoinedJam(String title) {
    return '你已加入 $title';
  }

  @override
  String chatCouldNotPlay(String error) {
    return '无法播放：$error';
  }

  @override
  String get chatJamCardSubtitle => '一起听，共用同一个队列';

  @override
  String get chatInJam => '在 Jam 中';

  @override
  String get chatJoin => '加入';

  @override
  String get chatNoOtherAccounts => '服务器上没有其他账号。';

  @override
  String chatSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 首歌曲',
    );
    return '$_temp0';
  }

  @override
  String chatSentTo(String name) {
    return '已发送给 $name';
  }

  @override
  String chatShareTitle(String title) {
    return '分享 $title';
  }

  @override
  String get chatNoteHint => '留言（可选）';

  @override
  String get blendWorking => '正在融合…';

  @override
  String blendAffinityButton(int affinity) {
    return 'Blend $affinity%';
  }

  @override
  String get blendCreate => '创建 Blend';

  @override
  String blendWith(String name) {
    return '与 $name 的 Blend';
  }

  @override
  String get blendExplain =>
      '为你们两人生成一个播放列表，包含你们都在听的歌曲、共同喜爱的艺人，以及各自最爱的一部分。它会显示你们口味的契合度，并每天更新。';

  @override
  String get blendNotNow => '以后再说';

  @override
  String blendAffinityTitle(int affinity) {
    return '你们的契合度为 $affinity%';
  }

  @override
  String blendInCommon(String artists) {
    return '共同点：$artists';
  }

  @override
  String blendOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '打开 Blend（$count 首歌曲）',
    );
    return '$_temp0';
  }

  @override
  String get blendRefreshNow => '立即刷新';

  @override
  String get blendUndo => '移除 Blend';

  @override
  String get blendRefreshing => '正在刷新 Blend…';

  @override
  String get blendUndoTitle => '移除 Blend？';

  @override
  String blendUndoBody(String name) {
    return '此播放列表将对你和 $name 都消失。';
  }

  @override
  String get blendUndoConfirm => '移除';

  @override
  String get blendUndone => 'Blend 已移除';

  @override
  String get jamStart => '开始 Jam';

  @override
  String jamTooltip(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jam（$count 人）',
    );
    return '$_temp0';
  }

  @override
  String get jamSubIdle => '与其他账号一起听，共用同一个队列。';

  @override
  String get jamSubHost => '由你掌控。所有人都可以点歌。';

  @override
  String get jamSubGuest => '你的操作和歌曲会进入所有人的队列。';

  @override
  String get jamPlayFirst => '开始 Jam 之前请先播放一首歌曲。';

  @override
  String jamMembers(int count) {
    return 'Jam 成员（$count）';
  }

  @override
  String jamYouSuffix(String name) {
    return '$name（你）';
  }

  @override
  String get jamHost => '主持人';

  @override
  String get jamInvite => '邀请';

  @override
  String get jamInviteTitle => '邀请加入 Jam';

  @override
  String get jamInviteSubtitle => '邀请会发送到对方的聊天中。';

  @override
  String jamInviteSent(String name) {
    return '已向 $name 发送邀请';
  }

  @override
  String get jamEnd => '结束 Jam';

  @override
  String get jamLeave => '退出 Jam';

  @override
  String recapTitle(int year) {
    return '你的 $year 年度回顾';
  }

  @override
  String get recapShort => '年度回顾';

  @override
  String recapBannerBody(String minutes) {
    return '今年共听了 $minutes 分钟音乐。看看你听得最多的是什么。';
  }

  @override
  String get recapEmpty => '还没有足够的播放记录来生成你的年度回顾。';

  @override
  String get recapShareCards => '分享卡片';

  @override
  String get recapBigMinutes => '收听分钟数';

  @override
  String get recapBigSongs => '首不同的歌曲';

  @override
  String get recapBigArtists => '位艺人';

  @override
  String get recapBigDays => '天有音乐相伴';

  @override
  String get recapBigStreak => '天连续收听，你的纪录';

  @override
  String get recapTopArtists => '你的年度最爱艺人';

  @override
  String recapMinutesValue(String minutes) {
    return '$minutes 分钟';
  }

  @override
  String get recapTopSongs => '你的年度最爱歌曲';

  @override
  String recapPlaysLine(String artist, String plays) {
    return '$artist • $plays 次播放';
  }

  @override
  String get recapSongGone => '这首歌已不在音乐库中';

  @override
  String get recapTopAlbums => '你的年度最爱专辑';

  @override
  String get recapTopGenres => '你听得最多的曲风';

  @override
  String recapGenreLine(String genre, String minutes) {
    return '$genre • $minutes 分钟';
  }

  @override
  String get recapMonthly => '逐月回顾';

  @override
  String recapMonthTooltip(String month, String minutes) {
    return '$month：$minutes 分钟';
  }

  @override
  String get recapListeningStyle => '你的收听习惯';

  @override
  String recapFavHour(String hour) {
    return '最爱时段：$hour:00';
  }

  @override
  String recapFavWeekday(String day) {
    return '最爱的星期：$day';
  }

  @override
  String recapBiggestDay(String date, String minutes) {
    return '你听得最多的一天：$date，$minutes 分钟';
  }

  @override
  String recapNewArtists(int count, String n) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$n 位新艺人',
    );
    return '$_temp0';
  }

  @override
  String recapSpotifyAdded(String added) {
    return '已添加 $added 次 Spotify 播放记录。';
  }

  @override
  String recapSpotifyAddedDup(String added, String dup) {
    return '已添加 $added 次 Spotify 播放记录（另有 $dup 次已在 Pudim 中存在）。';
  }

  @override
  String get recapSpotifyRemoveTitle => '移除 Spotify 历史记录？';

  @override
  String get recapSpotifyRemoveBody =>
      '你的年度回顾将只统计在 Pudim/Jellyfin 上的播放。之后可以重新导入。';

  @override
  String get recapSpotifyRemoveConfirm => '移除';

  @override
  String recapSpotifyRemoved(String count) {
    return '已移除 $count 次 Spotify 播放记录';
  }

  @override
  String get recapSpotifyTitle => 'Spotify 历史记录';

  @override
  String recapSpotifyHasData(String count, String from, String to) {
    return '你的年度回顾中有 $count 次 Spotify 播放记录（$from 至 $to）。你可以上传更新的文件：已有的记录不会被重复计算。';
  }

  @override
  String get recapSpotifyIntro =>
      '导入使用 Pudim 之前的年份。在 Spotify 中，前往“账户 > 隐私设置 > 下载你的数据”，并选择“扩展流媒体历史记录”。收到邮件后，在这里选择 my_spotify_data.zip。';

  @override
  String get recapSpotifyImportAnother => '导入其他文件';

  @override
  String get recapSpotifyImport => '导入历史记录';

  @override
  String get recapSpotifyRemoveBtn => '从年度回顾中移除';

  @override
  String get recapShareSaveDialog => '保存卡片';

  @override
  String get recapShareSaved => '卡片已保存';

  @override
  String recapShareSaveFailed(String error) {
    return '无法保存：$error';
  }

  @override
  String recapShareShareFailed(String error) {
    return '无法分享：$error';
  }

  @override
  String recapShareText(int year) {
    return '我在 Pudim 上的 $year 年度回顾';
  }

  @override
  String get recapShareMyArtists => '我的年度最爱艺人';

  @override
  String get recapShareMySongs => '我的年度最爱歌曲';

  @override
  String recapMinShort(String minutes) {
    return '$minutes 分钟';
  }

  @override
  String get recapShareSaveImage => '保存图片';

  @override
  String get recapShareButton => '分享';

  @override
  String recapBrand(int year) {
    return '$year 年度回顾';
  }

  @override
  String get recapShareMyYear => '我的音乐年度';

  @override
  String recapShareYearOf(String name) {
    return '$name 的音乐年度';
  }

  @override
  String get recapShareTopArtist => '我的年度最爱艺人';

  @override
  String recapShareGenres(String genres) {
    return '曲风：$genres';
  }

  @override
  String get widgetActionsAddedToLiked => '已添加到“喜欢的歌曲”';

  @override
  String get widgetActionsRemovedFromLiked => '已从“喜欢的歌曲”中移除';

  @override
  String get widgetActionsUnfollowed => '已取消关注';

  @override
  String get widgetActionsSavedToLibrary => '已保存到音乐库';

  @override
  String get widgetActionsRemovedFromLibrary => '已从音乐库中移除';

  @override
  String get widgetActionsAddToQueue => '添加到播放队列';

  @override
  String get widgetActionsAddedToQueue => '已添加到播放队列';

  @override
  String get widgetActionsPlayNext => '下一首播放';

  @override
  String get widgetActionsGoToPodcast => '前往播客';

  @override
  String get widgetActionsRemoveFromQueue => '从播放队列中移除';

  @override
  String get widgetActionsAddToPlaylist => '添加到播放列表';

  @override
  String get widgetActionsRemoveFromThisPlaylist => '从此播放列表中移除';

  @override
  String get widgetActionsInviteToEdit => '邀请共同编辑';

  @override
  String get widgetActionsKeepInPlaylist => '保留在播放列表中';

  @override
  String get widgetActionsDownloadTrack => '下载歌曲';

  @override
  String get widgetActionsDownloadAlbum => '下载专辑';

  @override
  String get widgetActionsDownloadDiscography => '下载全部专辑';

  @override
  String get widgetActionsSearchAlbums => '查找专辑';

  @override
  String widgetActionsImproveQuality(int count) {
    return '提升音质（$count）';
  }

  @override
  String widgetActionsImprovingAlbums(int count) {
    return '正在为 $count 张专辑查找更好的版本';
  }

  @override
  String get widgetActionsShare => '分享';

  @override
  String get widgetActionsSearchFlac => '查找 FLAC 版本';

  @override
  String widgetActionsSearchingFlac(String name) {
    return '正在查找 $name 的 FLAC 版本；找到后将替换 MP3';
  }

  @override
  String get widgetActionsTrackRemovedFromDevice => '已从设备中移除';

  @override
  String get widgetActionsRemovedFromDevice => '已从设备中移除';

  @override
  String get widgetActionsDownloadingToDevice => '正在下载到你的设备以便离线收听';

  @override
  String get widgetActionsUnfollow => '取消关注';

  @override
  String get widgetActionsRemoveFromLibrary => '从音乐库中移除';

  @override
  String get widgetActionsAddToLibrary => '添加到音乐库';

  @override
  String get widgetActionsGoToSongRadio => '前往歌曲电台';

  @override
  String get widgetActionsStartMix => '开始播放合辑';

  @override
  String widgetActionsMixOf(String name) {
    return '$name 合辑';
  }

  @override
  String get widgetActionsGoToArtist => '前往艺人';

  @override
  String get widgetActionsGoToAlbum => '前往专辑';

  @override
  String get widgetActionsCopyName => '复制名称';

  @override
  String get widgetActionsCopied => '已复制';

  @override
  String widgetDownloadsBellDownloading(int count) {
    return '$count 项下载中';
  }

  @override
  String get widgetDownloadsBellEmpty =>
      '这里还没有内容。播放带云图标的歌曲，或使用 ⋯ 菜单中的“下载”，即可将曲库中的内容加入你的音乐库。';

  @override
  String get widgetDownloadsBellKindDiscography => '全部专辑';

  @override
  String get widgetDownloadsBellKindFlac => 'FLAC 版本';

  @override
  String get widgetDownloadsBellKindQuality => '音质';

  @override
  String get widgetDownloadsBellOptions => '选项';

  @override
  String get widgetDownloadsBellCancelled => '下载已取消';

  @override
  String get widgetDownloadsBellRetrying => '正在重试';

  @override
  String get widgetDownloadsBellRemovedFromList => '已从列表中移除';

  @override
  String get widgetDownloadsBellDetails => '查看详情';

  @override
  String get widgetDownloadsBellRemoveFromList => '从列表中移除';

  @override
  String get widgetMixSearchingReleases => '正在查找新发行…';

  @override
  String get widgetMixBuildingDaylist => '正在生成你的 daylist…';

  @override
  String get widgetMixNewDiscoveriesTitle => '生成新的每周 Discoveries？';

  @override
  String get widgetMixNewMixTitle => '生成新的每周 Mix？';

  @override
  String get widgetMixNewDiscoveriesBody =>
      '你还没听过的歌曲会从播放列表中移出，并加入约 30 首新歌。每周一也会自动更新。';

  @override
  String get widgetMixNewMixBody => '根据你的最爱、听得最多的歌曲和相似歌曲重新生成。每周一也会自动更新。';

  @override
  String get widgetMixNotNow => '以后再说';

  @override
  String get widgetMixBuildingDiscoveries => '正在生成你的 Discoveries…';

  @override
  String get widgetMixBuildingMix => '正在生成你的 Mix…';

  @override
  String widgetMixBuiltOn(String date) {
    return '生成于 $date';
  }

  @override
  String get widgetMixRedo => '重新生成';

  @override
  String get widgetMixRefresh => '刷新';

  @override
  String get widgetMixCreateDiscoveries => '创建你的每周 Discoveries';

  @override
  String get widgetMixCreateMix => '创建你的每周 Mix';

  @override
  String get widgetMixCreateRadar => '创建你的新发行雷达';

  @override
  String get widgetMixCreateDaylist => '创建你的 daylist';

  @override
  String get widgetOfflineBanner => '无网络 · 显示已保存在设备上的内容';

  @override
  String widgetOfflineDownloadingProgress(int done, int total) {
    return '正在下载 $done/$total';
  }

  @override
  String get widgetUpdateReady => 'Pudim 新版本已就绪';

  @override
  String widgetUpdateReadyNotes(String notes) {
    return 'Pudim 新版本 · $notes';
  }

  @override
  String get widgetUpdateAction => '更新';

  @override
  String widgetSleepShortMinutes(int count) {
    return '$count 分钟';
  }

  @override
  String widgetSleepShortSeconds(int count) {
    return '$count 秒';
  }

  @override
  String get widgetSleepStopsAtEnd => '在歌曲结束时停止';

  @override
  String widgetSleepStopsIn(String time) {
    return '$time后停止';
  }

  @override
  String get widgetSleepTimer => '睡眠定时';

  @override
  String get widgetSleepTurnOff => '关闭定时';

  @override
  String get widgetSleepOneHour => '1 小时';

  @override
  String get widgetSleepOneAndHalfHours => '1 小时 30 分钟';

  @override
  String get widgetSleepEndOfSong => '歌曲结束时';

  @override
  String get widgetSleepTurnedOff => '定时已关闭';

  @override
  String get widgetSleepStopsWhenSongEnds => '这首歌结束后音乐将停止';

  @override
  String widgetSleepSongStopsIn(String time) {
    return '音乐将在 $time后停止';
  }

  @override
  String get widgetSpeedPodcast => '播客播放速度';

  @override
  String get widgetCommonCatalogBadge => '来自曲库：尚未加入你的音乐库';

  @override
  String get widgetCommonShowAll => '显示全部';

  @override
  String get widgetCommonSomethingWentWrong => '出了点问题';

  @override
  String get widgetCommonListenDownloaded => '收听已下载的歌曲';

  @override
  String get widgetTracksTitle => '标题';

  @override
  String get widgetTracksDateAdded => '添加日期';

  @override
  String widgetTracksAddedBy(String name) {
    return '添加者：$name';
  }

  @override
  String get widgetTracksMoreOptions => '更多选项';

  @override
  String widgetTracksAddedDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get castTooltip => '投放';

  @override
  String get castTitle => '播放到';

  @override
  String get castThisDevice => '此设备';

  @override
  String get castSearching => '正在搜索网络中的设备…';

  @override
  String get castNone => '未找到 Chromecast。它需要连接同一个 Wi-Fi。';

  @override
  String get castSearchAgain => '重新搜索';

  @override
  String get castStop => '停止投放';

  @override
  String castPlayingOn(String name) {
    return '正在 $name 上播放';
  }

  @override
  String castFailed(String name) {
    return '无法连接到 $name';
  }

  @override
  String get settingsSectionAppearance => '外观';

  @override
  String get settingsTheme => '主题';

  @override
  String get settingsThemeSubtitle => '立即更改颜色。';

  @override
  String get themeNightDesc => '深色、圆角卡片和悬浮迷你播放器。';

  @override
  String get themeRedDesc => '纯黑配红色，大方形封面，迷你播放器贴着导航栏。';

  @override
  String get themeWaveDesc => '紫色渐变、粗体字和胶囊形迷你播放器。';

  @override
  String get themeRetroDesc => '立体灰色窗口、滚动标题的绿色显示屏和文本列表。';

  @override
  String get themeClassicDesc => '光泽蓝黑玻璃、球形按钮、可视化效果和表格列表。';

  @override
  String get settingsCheckUpdates => '检查更新';

  @override
  String get updateChecking => '正在检查…';

  @override
  String updateUpToDate(int build) {
    return '已是最新版本（构建 $build）。';
  }

  @override
  String updateDownloading(int build, int percent) {
    return '正在下载构建 $build… $percent%';
  }

  @override
  String updateFailed(String error) {
    return '无法检查：$error';
  }

  @override
  String get updateUnavailable => '未配置附加服务器。';

  @override
  String get settingsHistory => '历史记录';

  @override
  String get settingsHistorySubtitle => '往年回顾和你听过的所有内容';

  @override
  String get historyRecaps => '回顾';

  @override
  String get historyPlays => '播放记录';

  @override
  String get historyWholeYear => '全年';

  @override
  String get historyLoadMore => '加载更多';

  @override
  String get historyEmpty => '还没有播放记录';

  @override
  String get historyImported => '已导入';
}
