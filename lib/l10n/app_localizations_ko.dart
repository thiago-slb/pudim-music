// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class L10nKo extends L10n {
  L10nKo([String locale = 'ko']) : super(locale);

  @override
  String get languageTitle => '언어';

  @override
  String get languageSubtitle => '인터페이스 언어';

  @override
  String get languageSystem => '시스템 기본값';

  @override
  String get commonCancel => '취소';

  @override
  String get commonClose => '닫기';

  @override
  String get commonBack => '뒤로';

  @override
  String get commonSave => '저장';

  @override
  String get commonEdit => '편집';

  @override
  String get commonDelete => '삭제';

  @override
  String get commonRemove => '제거';

  @override
  String get commonOk => '확인';

  @override
  String get commonRetry => '다시 시도';

  @override
  String get commonQueue => '대기열';

  @override
  String get commonAlbum => '앨범';

  @override
  String get commonAlbums => '앨범';

  @override
  String get commonArtist => '아티스트';

  @override
  String get commonArtists => '아티스트';

  @override
  String get commonSong => '노래';

  @override
  String get commonSongs => '노래';

  @override
  String get commonPlaylist => '플레이리스트';

  @override
  String get commonPlaylists => '플레이리스트';

  @override
  String get commonSingle => '싱글';

  @override
  String get commonLikedSongs => '좋아요 표시한 곡';

  @override
  String get commonAddToLiked => '좋아요 표시한 곡에 추가';

  @override
  String get commonRemoveFromLiked => '좋아요 표시한 곡에서 삭제';

  @override
  String get commonShufflePlay => '셔플 재생';

  @override
  String get commonPlay => '재생';

  @override
  String get commonPause => '일시중지';

  @override
  String get commonFollow => '팔로우';

  @override
  String get commonFollowing => '팔로잉';

  @override
  String get commonDownloadToDevice => '기기에 다운로드';

  @override
  String get commonRemoveFromDevice => '기기에서 삭제';

  @override
  String get commonDownloaded => '다운로드됨';

  @override
  String get commonDownloads => '다운로드';

  @override
  String get commonAll => '전체';

  @override
  String get commonRecentlyPlayed => '최근 재생한 항목';

  @override
  String get commonYourLibrary => '내 라이브러리';

  @override
  String get commonHome => '홈';

  @override
  String get commonSearch => '검색';

  @override
  String get commonProfile => '프로필';

  @override
  String get commonSettings => '설정';

  @override
  String get commonBuilding => '만드는 중…';

  @override
  String get commonBuildNow => '지금 만들기';

  @override
  String get commonShows => '콘서트';

  @override
  String get commonPodcasts => '팟캐스트';

  @override
  String commonSongCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '노래 $count곡',
      one: '노래 1곡',
      zero: '노래 없음',
    );
    return '$_temp0';
  }

  @override
  String commonMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count분',
      one: '1분',
    );
    return '$_temp0';
  }

  @override
  String commonError(String error) {
    return '오류: $error';
  }

  @override
  String get apiStatusQueued => '대기 중';

  @override
  String get apiStatusDownloading => '다운로드 중';

  @override
  String get apiStatusDone => '라이브러리에 추가됨';

  @override
  String get apiStatusUpToDate => '이미 라이브러리에 있음';

  @override
  String get apiStatusPartial => '일부만 추가됨';

  @override
  String get apiStatusNotFound => '찾을 수 없음';

  @override
  String get apiStatusCancelled => '취소됨';

  @override
  String get apiStatusInterrupted => '중단됨';

  @override
  String get apiStatusFailed => '실패';

  @override
  String get apiExtrasNoResponse => '엑스트라 서버가 응답하지 않습니다.';

  @override
  String get apiAlbumListFailed => '앨범 목록을 불러오지 못했습니다.';

  @override
  String apiPlaylistSaved(int found, int total) {
    return '내 라이브러리에 플레이리스트가 추가되었습니다($total곡 중 $found곡)';
  }

  @override
  String apiPlaylistDownloading(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count곡',
      one: '1곡',
    );
    return '내 라이브러리에 플레이리스트가 추가되었습니다. $_temp0을 더 다운로드하는 중';
  }

  @override
  String get apiBadCredentials => '사용자 이름 또는 비밀번호가 올바르지 않습니다.';

  @override
  String get apiServerUnreachable => '서버에 연결할 수 없습니다.';

  @override
  String get apiQuickConnectOff => '이 서버에서는 Quick Connect가 꺼져 있습니다.';

  @override
  String get apiWrongCurrentPassword => '현재 비밀번호가 올바르지 않습니다.';

  @override
  String stateChatShared(String title) {
    return '$title을(를) 공유했습니다';
  }

  @override
  String stateDownloadingName(String name) {
    return '$name 다운로드 중';
  }

  @override
  String stateDownloadingRequests(int count) {
    return '요청 $count건 다운로드 중';
  }

  @override
  String stateDownloadArrived(String name) {
    return '$name이(가) 라이브러리에 추가되었습니다';
  }

  @override
  String stateDownloadPartial(String name) {
    return '$name이(가) 일부만 추가되었습니다';
  }

  @override
  String stateDownloadEnded(String name, String status) {
    return '$name: $status';
  }

  @override
  String get stateNotFromCatalog => '이 항목은 카탈로그에 있는 항목이 아닙니다.';

  @override
  String stateAlreadyDownloading(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': '이 앨범은 이미 다운로드 중입니다.',
      'artist': '디스코그래피는 이미 다운로드 중입니다.',
      'other': '이 노래는 이미 다운로드 중입니다.',
    });
    return '$_temp0';
  }

  @override
  String stateDownloadRequested(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': '앨범을 다운로드하는 중입니다. 완료되면 알림 벨에 표시됩니다.',
      'artist': '디스코그래피를 다운로드하는 중입니다. 완료되면 알림 벨에 표시됩니다.',
      'other': '노래를 다운로드하는 중입니다. 완료되면 알림 벨에 표시됩니다.',
    });
    return '$_temp0';
  }

  @override
  String get stateNotifyDownloadsChannel => '다운로드';

  @override
  String get stateNotifyDownloadsChannelDesc => '다운로드 중인 노래의 진행 상황';

  @override
  String get stateNotifyNewsChannel => '새로운 소식';

  @override
  String get stateNotifyNewsChannelDesc => '새로 들어온 곡, 신곡, Descobertas, Mistura';

  @override
  String get stateOfflineLoose => '곡별로 다운로드됨';

  @override
  String get stateOfflineDoneTitle => '이 기기에 다운로드됨';

  @override
  String stateOfflineDoneBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '오프라인으로 들을 수 있는 노래 $count곡',
      one: '오프라인으로 들을 수 있는 노래 1곡',
    );
    return '$_temp0';
  }

  @override
  String get stateOfflineProgressTitle => '이 기기에 다운로드 중';

  @override
  String stateOfflineProgressBody(int done, int total, String name) {
    return '$total개 중 $done개 • $name';
  }

  @override
  String get stateServerNoReply => '서버가 응답하지 않습니다. 주소를 확인하세요.';

  @override
  String get stateServerNoReplyBoth => '두 주소 모두에서 서버가 응답하지 않습니다.';

  @override
  String get stateTokenStoreUnsupported =>
      '현재 Pudim은 Windows와 Android에서만 로그인 정보를 저장할 수 있습니다.';

  @override
  String get stateQualityPoor => '낮은 음질';

  @override
  String get stateQualityPartial => '불완전';

  @override
  String get audioPlaybackChannel => '재생';

  @override
  String get audioRecentAlbums => '최근 앨범';

  @override
  String audioSearchContext(String query) {
    return '검색: $query';
  }

  @override
  String audioRadioContext(String name) {
    return '$name 라디오';
  }

  @override
  String podcastsMonthShort(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': '1월',
      'm2': '2월',
      'm3': '3월',
      'm4': '4월',
      'm5': '5월',
      'm6': '6월',
      'm7': '7월',
      'm8': '8월',
      'm9': '9월',
      'm10': '10월',
      'm11': '11월',
      'other': '12월',
    });
    return '$_temp0';
  }

  @override
  String podcastsDateThisYear(int day, String month) {
    return '$month $day일';
  }

  @override
  String podcastsDateOtherYear(int day, String month, int year) {
    return '$year년 $month $day일';
  }

  @override
  String podcastsHoursMin(int h, int min) {
    return '$h시간 $min분';
  }

  @override
  String podcastsMin(int min) {
    return '$min분';
  }

  @override
  String get podcastsPlayed => '재생함';

  @override
  String podcastsTimeLeft(String time) {
    return '$time 남음';
  }

  @override
  String get podcastsSearchHint => '팟캐스트 검색';

  @override
  String get podcastsNothingFound => '결과가 없습니다.';

  @override
  String get podcastsYours => '내 팟캐스트';

  @override
  String get podcastsNewEpisodes => '새 에피소드';

  @override
  String get podcastsTrendingBrazil => '브라질 인기 팟캐스트';

  @override
  String get podcastsLoadFailed => '불러오지 못했습니다. 다시 시도하세요';

  @override
  String get podcastsNoEpisodes => '피드에 에피소드가 없습니다.';

  @override
  String podcastsNoEpisodeMatch(String q) {
    return '\"$q\"와(과) 일치하는 에피소드가 없습니다.';
  }

  @override
  String get podcastsKind => '팟캐스트';

  @override
  String get podcastsEpisodes => '에피소드';

  @override
  String podcastsEpisodesCount(int total) {
    return '에피소드 ($total)';
  }

  @override
  String get podcastsFindEpisode => '에피소드 검색';

  @override
  String showsMonthName(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': '1월',
      'm2': '2월',
      'm3': '3월',
      'm4': '4월',
      'm5': '5월',
      'm6': '6월',
      'm7': '7월',
      'm8': '8월',
      'm9': '9월',
      'm10': '10월',
      'm11': '11월',
      'other': '12월',
    });
    return '$_temp0';
  }

  @override
  String showsMonthYear(String month, int year) {
    return '$year년 $month';
  }

  @override
  String showsWeekdayShort(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'w1': '월',
      'w2': '화',
      'w3': '수',
      'w4': '목',
      'w5': '금',
      'w6': '토',
      'other': '일',
    });
    return '$_temp0';
  }

  @override
  String get showsFollowingNone => '팔로우하는 아티스트의 공연';

  @override
  String showsFollowingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '팔로우하는 아티스트 $count명의 공연',
      one: '팔로우하는 아티스트 1명의 공연',
    );
    return '$_temp0';
  }

  @override
  String showsSearchingFor(int count) {
    return '공연 $count건 검색 중…';
  }

  @override
  String get showsUpcoming => '예정된 공연';

  @override
  String get showsPast => '지난 공연';

  @override
  String get showsInBrazil => '브라질';

  @override
  String get showsEmptyFollow =>
      '아티스트를 팔로우하면(아티스트 페이지의 팔로우 버튼) 해당 공연이 여기에 표시됩니다.';

  @override
  String get showsNonePast => '기록된 공연이 아직 없습니다.';

  @override
  String get showsNoneUpcoming => '현재 예정된 공연이 없습니다.';

  @override
  String get showsStillSearching => '계속 검색 중…';

  @override
  String get showsSource =>
      '일정은 MusicBrainz(팬 참여형) 기준이며, 새 공연이 표시되기까지 시간이 걸릴 수 있습니다.';

  @override
  String get showsCancelled => '취소됨';

  @override
  String get showsFestival => '페스티벌';

  @override
  String get catalogKindAlbum => '앨범';

  @override
  String get catalogKindSingle => '싱글';

  @override
  String get catalogKindBroadcast => '방송';

  @override
  String get catalogKindOther => '기타';

  @override
  String get catalogSecLive => '라이브';

  @override
  String get catalogSecCompilation => '컴필레이션';

  @override
  String get catalogSecSoundtrack => '사운드트랙';

  @override
  String get catalogSecMixtape => '믹스테이프';

  @override
  String get catalogSecInterview => '인터뷰';

  @override
  String get catalogSecSpokenword => '스포큰 워드';

  @override
  String catalogDownloadingOne(String title) {
    return '$title 다운로드 중';
  }

  @override
  String catalogDownloadingMany(int count, String artist) {
    return '$artist의 앨범 $count장 다운로드 중';
  }

  @override
  String catalogCheckingDiscography(int seconds) {
    return '디스코그래피 확인 중… $seconds초';
  }

  @override
  String catalogToDownload(int count) {
    return '$count개 다운로드 예정';
  }

  @override
  String catalogInLibraryCount(int count) {
    return '$count개는 이미 라이브러리에 있음';
  }

  @override
  String catalogSkippedOneSong(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '1곡짜리 발매작 $count개 제외됨',
      one: '1곡짜리 발매작 1개 제외됨',
    );
    return '$_temp0';
  }

  @override
  String get catalogPickAll => '전체';

  @override
  String get catalogPickStudio => '스튜디오';

  @override
  String get catalogPickNone => '선택 안 함';

  @override
  String get catalogDownloadSelected => '선택 항목 다운로드';

  @override
  String catalogDownloadNSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '선택한 $count개 다운로드',
      one: '선택한 1개 다운로드',
    );
    return '$_temp0';
  }

  @override
  String get catalogNothingMissing => '빠진 항목이 없습니다.';

  @override
  String get catalogPartial => '일부';

  @override
  String get catalogDownload => '다운로드';

  @override
  String get catalogAddToLibrary => '내 라이브러리에 추가';

  @override
  String get catalogInYourLibrary => '내 라이브러리에 있음';

  @override
  String get catalogAllInLibrary => '모두 라이브러리에 있음';

  @override
  String catalogNInLibrary(int count) {
    return '$count개가 라이브러리에 있음';
  }

  @override
  String get catalogDownloadAlbum => '앨범 다운로드';

  @override
  String get catalogArtistNotFound => '아티스트를 찾을 수 없습니다.';

  @override
  String get catalogFromCatalog => '카탈로그: 아직 라이브러리에 없음';

  @override
  String get catalogDownloadAll => '모두 다운로드';

  @override
  String get catalogDownloadDiscography => '디스코그래피 다운로드';

  @override
  String get catalogPopular => '인기';

  @override
  String get catalogShowLess => '간단히 보기';

  @override
  String get catalogShowMore => '더 보기';

  @override
  String get catalogSinglesEps => '싱글 및 EP';

  @override
  String get catalogFansAlsoLike => '팬들이 좋아하는 다른 아티스트';

  @override
  String get lyricsPlaySomething => '노래를 재생하면 가사를 볼 수 있습니다.';

  @override
  String get lyricsNone => '이 노래의 가사가 없습니다';

  @override
  String get lyricsNoneHint => '파일 옆에 .lrc 또는 .txt 파일이 있으면 여기에 표시됩니다.';

  @override
  String get lyricsSynced => '.lrc 파일의 싱크 가사';

  @override
  String get lyricsUnsynced => '싱크 없는 가사';

  @override
  String get profileChangePhoto => '사진 변경';

  @override
  String get profileNoPhoto => '선택한 사진 없음';

  @override
  String get profilePhotoTooBig => '사진이 너무 큽니다(최대 8MB)';

  @override
  String get profilePhotoChanged => '프로필 사진이 변경되었습니다';

  @override
  String get profilePhotoRemoved => '사진이 삭제되었습니다';

  @override
  String get profileNameSaved => '프로필 이름이 저장되었습니다';

  @override
  String get profileRenameTitle => '사용자 이름을 변경할까요?';

  @override
  String profileRenameBody(String name) {
    return 'Pudim, Jellyfin 및 다른 앱(Finamp, Feishin 등)에서 \"$name\"(으)로 로그인하게 됩니다. 디스커버리, 믹스, Rewind는 그대로 유지됩니다.';
  }

  @override
  String get profileRenameConfirm => '변경';

  @override
  String profileNowSignedAs(String name) {
    return '이제 $name(으)로 로그인합니다';
  }

  @override
  String get profileEnterNewPassword => '새 비밀번호를 입력하세요';

  @override
  String get profilePasswordsDiffer => '새 비밀번호가 일치하지 않습니다';

  @override
  String get profilePasswordChanged => '비밀번호가 변경되었습니다';

  @override
  String get profileExtrasUnreachable =>
      '엑스트라 서버에 연결할 수 없습니다. 프로필 이름과 사용자 이름은 나중에 변경해 주세요.';

  @override
  String get profileNameSection => '프로필 이름';

  @override
  String get profileNameHelp => '채팅에서 연락처에게 표시되는 이름입니다.';

  @override
  String get profileYourName => '내 이름';

  @override
  String get profileUsernameSection => '사용자 이름';

  @override
  String get profileUsernameHelp =>
      'Jellyfin에 로그인할 때 사용하는 이름입니다(이 앱과 다른 앱 모두).';

  @override
  String get profileUsernameHint => '사용자 이름';

  @override
  String get profileChangeUsername => '사용자 이름 변경';

  @override
  String get profilePasswordSection => '비밀번호';

  @override
  String get profileCurrentPassword => '현재 비밀번호';

  @override
  String get profileNewPassword => '새 비밀번호';

  @override
  String get profileRepeatPassword => '새 비밀번호 확인';

  @override
  String get profileChangePassword => '비밀번호 변경';

  @override
  String get loginServerRequired => 'Jellyfin 서버 주소를 입력하세요.';

  @override
  String get loginUserRequired => '사용자 이름을 입력하세요.';

  @override
  String get loginTitle => 'Pudim에 로그인';

  @override
  String get loginSubtitle => 'Jellyfin 계정을 사용하세요.';

  @override
  String get loginUsername => '사용자 이름';

  @override
  String get loginPassword => '비밀번호';

  @override
  String get loginShowPassword => '비밀번호 표시';

  @override
  String get loginHidePassword => '비밀번호 숨기기';

  @override
  String get loginSubmit => '로그인';

  @override
  String get loginQuickConnect => 'Quick Connect로 로그인';

  @override
  String get loginHideAddresses => '주소 숨기기';

  @override
  String get loginServerAddress => '서버 주소';

  @override
  String get loginJellyfinServer => 'Jellyfin 서버';

  @override
  String get loginJellyfinServerExample => '예: https://jellyfin.exemplo.com';

  @override
  String get loginLocalNetwork => '로컬 네트워크(선택 사항)';

  @override
  String get loginLocalNetworkExample =>
      '예: http://192.168.0.10:8096. 응답이 있으면 기본 주소 대신 이 주소를 사용합니다.';

  @override
  String get loginExtrasServer => '엑스트라 서버(선택 사항)';

  @override
  String get loginExtrasServerHint =>
      '채팅, Jam, Blend, 믹스, Rewind를 사용할 수 있습니다. 없으면 비워 두세요.';

  @override
  String get loginQcExpired => '코드가 만료되었습니다. 다시 시도하세요.';

  @override
  String get loginQcInstructions =>
      '이미 Jellyfin에 로그인한 기기에서 프로필을 열고 Quick Connect를 탭한 다음 이 코드를 입력하세요:';

  @override
  String get loginQcWaiting => '승인을 기다리는 중…';

  @override
  String get homeDownloadedOnDevice => '이 기기에 다운로드됨';

  @override
  String get homeTabMusic => '음악';

  @override
  String get homeMadeFor => '맞춤 추천';

  @override
  String get homeMixDiscoveries => '매주 만나는 나만을 위한 새로운 음악';

  @override
  String get homeMixWeekly => '좋아하는 곡과 비슷한 곡을 매주 추천';

  @override
  String get homeMixRadar => '매주 금요일, 팔로우하는 아티스트의 신곡';

  @override
  String get homeMixDaylist => '하루 동안 계속 바뀝니다';

  @override
  String get homeMixBlend => '두 사람의 취향을 하나로';

  @override
  String get homeMixAuto => '자동 믹스';

  @override
  String get homeSpotifyPlaylists => '내 Spotify 플레이리스트';

  @override
  String get homeFromSpotify => 'Spotify에서 가져옴';

  @override
  String get homeYourPlaylists => '내 플레이리스트';

  @override
  String get homeTopAlbums => '가장 많이 들은 앨범';

  @override
  String get homeTopArtists => '내가 좋아하는 아티스트';

  @override
  String get homeRecentlyAdded => '최근 추가됨';

  @override
  String get homeYourPodcasts => '내 팟캐스트';

  @override
  String get homeRadiosTitle => '추천 라디오';

  @override
  String get homeRadiosSubtitle => '좋아하는 아티스트를 기반으로 끊김 없이 이어지는 음악.';

  @override
  String get homeRadioBadge => '라디오';

  @override
  String homeRadioWith(String name) {
    return '$name 및 비슷한 아티스트';
  }

  @override
  String searchNoResults(String query) {
    return '\"$query\"에 대한 검색 결과가 없습니다';
  }

  @override
  String get searchNoResultsHint => '맞춤법을 확인하거나 더 적은 단어 또는 다른 단어로 검색해 보세요.';

  @override
  String searchCatalogNoResponse(String error) {
    return '카탈로그가 응답하지 않았습니다: $error';
  }

  @override
  String get searchAlsoCatalog => '카탈로그도 검색하는 중…';

  @override
  String searchLibraryOnly(String error) {
    return '라이브러리만 검색됨: 카탈로그가 응답하지 않았습니다($error).';
  }

  @override
  String get searchTopResult => '인기 검색결과';

  @override
  String get searchSpotifyPlaylists => 'Spotify 플레이리스트';

  @override
  String get searchRecent => '최근 검색';

  @override
  String get searchClear => '지우기';

  @override
  String get searchBrowseAll => '모두 둘러보기';

  @override
  String get searchHint => '어떤 음악을 듣고 싶으세요?';

  @override
  String get albumDownloadedType => '앨범 • 이 기기에 다운로드됨';

  @override
  String albumSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count곡',
      one: '1곡',
    );
    return '$_temp0, $total';
  }

  @override
  String get albumRemoveFromLibrary => '내 라이브러리에서 삭제';

  @override
  String get albumSaveToLibrary => '내 라이브러리에 저장';

  @override
  String albumMoreOptions(String name) {
    return '$name 옵션 더보기';
  }

  @override
  String albumDisc(int number) {
    return '디스크 $number';
  }

  @override
  String albumMoreFrom(String name) {
    return '$name의 다른 앨범';
  }

  @override
  String artistAlbumsInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '내 라이브러리에 앨범 $count장',
      one: '내 라이브러리에 앨범 1장',
    );
    return '$_temp0';
  }

  @override
  String artistPlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '재생 $count회',
      one: '재생 1회',
    );
    return '$_temp0';
  }

  @override
  String artistMoreOptions(String name) {
    return '$name 옵션 더보기';
  }

  @override
  String get artistPopular => '인기';

  @override
  String get artistShowLess => '간단히 보기';

  @override
  String get artistShowMore => '더 보기';

  @override
  String get artistYouLiked => '좋아요 표시한 곡';

  @override
  String artistFrom(String name) {
    return '$name의 앨범';
  }

  @override
  String get artistDiscography => '디스코그래피';

  @override
  String get artistPopularReleases => '인기 발매작';

  @override
  String get artistSinglesEps => '싱글 및 EP';

  @override
  String get artistFansAlsoLike => '팬들이 좋아하는 다른 아티스트';

  @override
  String get artistAppearsOn => '참여 앨범';

  @override
  String get artistAbout => '소개';

  @override
  String get playlistOriginSpotify => 'Spotify에서 가져옴';

  @override
  String get playlistOriginMadeForYou => '맞춤 추천';

  @override
  String get playlistOriginAuto => '자동 믹스';

  @override
  String get playlistDownloadedOnDevice => '이 기기에 다운로드됨';

  @override
  String get playlistOnDevice => '이 기기에 있음';

  @override
  String get playlistPlaysOffline => '인터넷 없이 재생됩니다.';

  @override
  String playlistPlaysOfflineDownloading(int count) {
    return '인터넷 없이 재생됩니다. $count곡 더 다운로드하는 중…';
  }

  @override
  String playlistSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count곡',
      one: '1곡',
    );
    return '$_temp0, $total';
  }

  @override
  String playlistMoreOptions(String name) {
    return '$name 옵션 더보기';
  }

  @override
  String get playlistSearchHint => '플레이리스트에서 검색';

  @override
  String get playlistEmpty => '아직 노래가 없습니다.';

  @override
  String get playlistErrNoPermission => '이 플레이리스트를 편집할 권한이 없습니다.';

  @override
  String playlistErrServer(String code) {
    return '서버가 요청을 거부했습니다($code).';
  }

  @override
  String get playlistErrNoResponse => '응답 없음';

  @override
  String get playlistDownloadFirst => '플레이리스트에 추가하려면 먼저 노래를 다운로드하세요';

  @override
  String get playlistAddTo => '플레이리스트에 추가';

  @override
  String get playlistNew => '새 플레이리스트';

  @override
  String playlistAddedTo(String name) {
    return '$name에 추가했습니다';
  }

  @override
  String get playlistNameHint => '플레이리스트 이름';

  @override
  String get playlistCreate => '만들기';

  @override
  String playlistCreated(String name) {
    return '플레이리스트 $name을(를) 만들었습니다';
  }

  @override
  String get playlistRemoved => '플레이리스트에서 삭제했습니다';

  @override
  String get playlistInviteTitle => '편집 초대';

  @override
  String get playlistInviteSubtitle =>
      '초대받은 사람의 라이브러리에 이 플레이리스트가 표시되며, 노래를 추가하고 삭제할 수 있습니다.';

  @override
  String get playlistInviteOwnerOnly => '플레이리스트를 만든 사람만 초대할 수 있습니다';

  @override
  String playlistInvited(String who, String playlist) {
    return '이제 $who님이 $playlist을(를) 편집할 수 있습니다';
  }

  @override
  String playlistCollaborative(String members) {
    return '공동 작업 · $members';
  }

  @override
  String get playlistSmartShuffleTooltip => 'Smart Shuffle: 추천곡을 섞어 셔플';

  @override
  String get playlistSmartShuffleOn => 'Smart Shuffle 켜짐: 추천곡에는 ✦ 표시가 붙습니다';

  @override
  String get playlistAddedToThis => '플레이리스트에 추가됨';

  @override
  String get playlistRecommendation => 'Smart Shuffle 추천곡';

  @override
  String get playlistPutIn => '플레이리스트에 추가';

  @override
  String get settingsSectionAccount => '계정';

  @override
  String get settingsProfileSubtitle => '이름, 사용자 이름, 비밀번호';

  @override
  String settingsConnectedAt(String url) {
    return '$url에 연결됨';
  }

  @override
  String get settingsSignOut => '로그아웃';

  @override
  String get accountsTitle => '계정';

  @override
  String get accountsAdd => '계정 또는 서버 추가';

  @override
  String get accountsSwitch => '전환';

  @override
  String get accountsInUse => '사용 중';

  @override
  String accountsOn(String user, String host) {
    return '$host의 $user';
  }

  @override
  String get loginBackToAccount => '현재 계정으로 돌아가기';

  @override
  String get settingsSectionServer => '서버';

  @override
  String get settingsLocalNetwork => '로컬 네트워크';

  @override
  String get settingsServerNote =>
      'Jellyfin 주소를 변경하려면 로그아웃한 후 로그인 화면에서 \"서버 주소\"를 여세요.';

  @override
  String get settingsExtrasServer => '엑스트라 서버';

  @override
  String get settingsExtrasNotConfigured =>
      '설정 안 됨(채팅, Jam, Blend, 믹스, Recap이 숨겨집니다)';

  @override
  String get settingsConfigure => '설정';

  @override
  String get settingsChange => '변경';

  @override
  String get settingsSectionPlayback => '재생';

  @override
  String get settingsQualityWifi => 'Wi-Fi 음질';

  @override
  String get settingsQualityWifiSubtitle => '원본은 라이브러리에 있는 파일을 그대로 재생합니다.';

  @override
  String get settingsQualityMobile => '모바일 데이터 음질';

  @override
  String get settingsQualityMobileSubtitle => '음질을 낮추면 모바일 데이터를 덜 사용합니다.';

  @override
  String get settingsQualityOriginal => '원본';

  @override
  String get settingsAppliesNextSong => '다음 곡부터 적용됩니다';

  @override
  String get settingsSectionAbout => '정보';

  @override
  String settingsBuild(int build) {
    return '빌드 $build';
  }

  @override
  String get settingsExtrasEmptyHint => '비워 두면 엑스트라가 꺼집니다.';

  @override
  String get settingsAutoplay => '자동 재생';

  @override
  String get settingsAutoplaySubtitle =>
      '대기열이 끝나면 비슷한 노래를 계속 재생합니다(Jellyfin 믹스).';

  @override
  String get settingsNormalize => '볼륨 평준화';

  @override
  String get settingsNormalizeSubtitle =>
      'Jellyfin의 분석 결과를 사용해 모든 노래를 같은 볼륨으로 재생합니다.';

  @override
  String get settingsScrobble => '스크로블';

  @override
  String get settingsLoading => '불러오는 중…';

  @override
  String get settingsLastfmNoKey => '엑스트라 서버에 Last.fm API 키가 아직 설정되지 않았습니다.';

  @override
  String settingsConnectedAs(String name) {
    return '$name(으)로 연결됨';
  }

  @override
  String get settingsLastfmConnectedSubtitle =>
      'Pudim에서 들은 모든 곡이 Last.fm 프로필에 기록됩니다.';

  @override
  String get settingsDisconnect => '연결 해제';

  @override
  String get settingsLastfmAuthorize => 'Last.fm 페이지에서 승인';

  @override
  String get settingsLastfmAuthorizeSubtitle =>
      '해당 페이지에서 \"Yes, allow access\"를 클릭한 후 돌아와서 완료를 탭하세요.';

  @override
  String get settingsFinish => '완료';

  @override
  String get settingsLastfmConnected => 'Last.fm 연결됨';

  @override
  String get settingsLastfmScrobbleSubtitle => '들은 모든 노래를 Last.fm에 기록합니다.';

  @override
  String get settingsConnect => '연결';

  @override
  String get sidebarOpenLibrary => '내 라이브러리 열기';

  @override
  String get sidebarCollapseLibrary => '내 라이브러리 접기';

  @override
  String sidebarOnDeviceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count곡',
      one: '1곡',
    );
    return '기기에 있음 • $_temp0';
  }

  @override
  String sidebarPlaylistCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count곡',
      one: '1곡',
    );
    return '플레이리스트 • $_temp0';
  }

  @override
  String sidebarAlbumBy(String artist) {
    return '앨범 • $artist';
  }

  @override
  String get sidebarSearchLibrary => '내 라이브러리에서 검색';

  @override
  String get sidebarSortBy => '정렬 기준';

  @override
  String get sidebarSortRecents => '최근 항목';

  @override
  String get sidebarSortAdded => '최근 추가순';

  @override
  String get sidebarSortAlpha => '가나다순';

  @override
  String get sidebarSortCreator => '만든 사람';

  @override
  String get topBarSearchHint => '어떤 음악을 재생할까요?';

  @override
  String get topBarClearSearch => '검색창 지우기';

  @override
  String get topBarBrowse => '둘러보기';

  @override
  String get topBarMenu => '메뉴';

  @override
  String get topBarLogoutAccount => '로그아웃';

  @override
  String get topBarQuit => 'Pudim 종료';

  @override
  String get topBarLogout => '로그아웃';

  @override
  String get playerBarSmartShuffleOff => 'Smart Shuffle 끄기';

  @override
  String get playerBarSmartShuffleOn => 'Smart Shuffle 켜기';

  @override
  String get playerBarShuffleOff => '셔플 끄기';

  @override
  String get playerBarShuffleOn => '셔플 켜기';

  @override
  String get playerBarPlay => '재생';

  @override
  String get playerBarForward => '다음';

  @override
  String get playerBarRepeatOn => '반복 켜기';

  @override
  String get playerBarRepeatOne => '한 곡 반복 켜기';

  @override
  String get playerBarRepeatOff => '반복 끄기';

  @override
  String get playerBarNowPlayingView => '현재 재생 중 화면';

  @override
  String get playerBarLyrics => '가사';

  @override
  String get playerBarUnmute => '음소거 해제';

  @override
  String get playerBarMute => '음소거';

  @override
  String get rightPanelNothingPlaying => '노래를 재생하면 여기에 재생 중인 곡이 표시됩니다.';

  @override
  String get rightPanelLyricsPreview => '가사 미리보기';

  @override
  String get rightPanelAboutArtist => '아티스트 소개';

  @override
  String get rightPanelNextUp => '다음 곡';

  @override
  String get rightPanelOpenQueue => '대기열 열기';

  @override
  String get rightPanelQueueEmptyTitle => '대기열에 추가';

  @override
  String get rightPanelQueueEmptyHint => '트랙 메뉴에서 \"대기열에 추가\"를 클릭하면 여기에 표시됩니다';

  @override
  String get rightPanelNowPlaying => '현재 재생 중';

  @override
  String get rightPanelNextInQueue => '대기열의 다음 곡';

  @override
  String rightPanelNextFrom(String name) {
    return '다음 재생 출처: $name';
  }

  @override
  String get nowPlayingPlayingFrom => '재생 출처';

  @override
  String get nowPlayingMoreOptions => '옵션 더보기';

  @override
  String get chatChats => '채팅';

  @override
  String chatYouSaid(String text) {
    return '나: $text';
  }

  @override
  String get chatContacts => '연락처';

  @override
  String get chatServerUnreachable => '엑스트라 서버에 연결할 수 없습니다.';

  @override
  String get chatMessageHint => '메시지';

  @override
  String chatJoinedJam(String title) {
    return '$title에 참여했습니다';
  }

  @override
  String chatCouldNotPlay(String error) {
    return '재생할 수 없습니다: $error';
  }

  @override
  String get chatJamCardSubtitle => '같은 대기열로 함께 듣기';

  @override
  String get chatInJam => 'Jam 참여 중';

  @override
  String get chatJoin => '참여';

  @override
  String get chatNoOtherAccounts => '서버에 다른 계정이 없습니다.';

  @override
  String chatSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count곡',
      one: '1곡',
    );
    return '$_temp0';
  }

  @override
  String chatSentTo(String name) {
    return '$name님에게 보냈습니다';
  }

  @override
  String chatShareTitle(String title) {
    return '$title 공유';
  }

  @override
  String get chatNoteHint => '메모(선택 사항)';

  @override
  String get blendWorking => 'Blend 만드는 중…';

  @override
  String blendAffinityButton(int affinity) {
    return 'Blend $affinity%';
  }

  @override
  String get blendCreate => 'Blend 만들기';

  @override
  String blendWith(String name) {
    return '$name님과 Blend';
  }

  @override
  String get blendExplain =>
      '두 사람이 함께 듣는 곡, 공통 아티스트, 그리고 각자가 가장 좋아하는 곡을 조금씩 담은 하나의 플레이리스트입니다. 취향이 얼마나 잘 맞는지 보여 주며 매일 업데이트됩니다.';

  @override
  String get blendNotNow => '나중에';

  @override
  String blendAffinityTitle(int affinity) {
    return '취향 일치도 $affinity%';
  }

  @override
  String blendInCommon(String artists) {
    return '공통: $artists';
  }

  @override
  String blendOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Blend 열기($count곡)',
      one: 'Blend 열기(1곡)',
    );
    return '$_temp0';
  }

  @override
  String get blendRefreshNow => '지금 새로고침';

  @override
  String get blendUndo => 'Blend 삭제';

  @override
  String get blendRefreshing => 'Blend 새로고침 중…';

  @override
  String get blendUndoTitle => 'Blend를 삭제할까요?';

  @override
  String blendUndoBody(String name) {
    return '나와 $name님 모두에게서 플레이리스트가 사라집니다.';
  }

  @override
  String get blendUndoConfirm => '삭제';

  @override
  String get blendUndone => 'Blend를 삭제했습니다';

  @override
  String get jamStart => 'Jam 시작';

  @override
  String jamTooltip(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jam($count명)',
      one: 'Jam(1명)',
    );
    return '$_temp0';
  }

  @override
  String get jamSubIdle => '다른 계정과 같은 대기열로 함께 듣습니다.';

  @override
  String get jamSubHost => '내가 호스트입니다. 모두 노래를 신청할 수 있습니다.';

  @override
  String get jamSubGuest => '내 조작과 노래가 모두의 대기열에 반영됩니다.';

  @override
  String get jamPlayFirst => 'Jam을 시작하기 전에 노래를 재생하세요.';

  @override
  String jamMembers(int count) {
    return 'Jam 참여자 ($count)';
  }

  @override
  String jamYouSuffix(String name) {
    return '$name(나)';
  }

  @override
  String get jamHost => '호스트';

  @override
  String get jamInvite => '초대';

  @override
  String get jamInviteTitle => 'Jam에 초대';

  @override
  String get jamInviteSubtitle => '초대장은 상대방의 채팅으로 전달됩니다.';

  @override
  String jamInviteSent(String name) {
    return '$name님에게 초대장을 보냈습니다';
  }

  @override
  String get jamEnd => 'Jam 종료';

  @override
  String get jamLeave => 'Jam 나가기';

  @override
  String recapTitle(int year) {
    return '나의 $year Wrapped';
  }

  @override
  String get recapShort => 'Wrapped';

  @override
  String recapBannerBody(String minutes) {
    return '올해 $minutes분 동안 음악을 들었습니다. 가장 많이 들은 곡을 확인해 보세요.';
  }

  @override
  String get recapEmpty => 'Wrapped를 만들 재생 기록이 아직 없습니다.';

  @override
  String get recapShareCards => '카드 공유';

  @override
  String get recapBigMinutes => '분 청취';

  @override
  String get recapBigSongs => '곡 청취';

  @override
  String get recapBigArtists => '명의 아티스트';

  @override
  String get recapBigDays => '일 동안 음악 감상';

  @override
  String get recapBigStreak => '일 연속, 나의 최고 기록';

  @override
  String get recapTopArtists => '올해의 톱 아티스트';

  @override
  String recapMinutesValue(String minutes) {
    return '$minutes분';
  }

  @override
  String get recapTopSongs => '올해의 톱 노래';

  @override
  String recapPlaysLine(String artist, String plays) {
    return '$artist • $plays회 재생';
  }

  @override
  String get recapSongGone => '이 노래는 더 이상 라이브러리에 없습니다';

  @override
  String get recapTopAlbums => '올해의 톱 앨범';

  @override
  String get recapTopGenres => '가장 많이 들은 장르';

  @override
  String recapGenreLine(String genre, String minutes) {
    return '$genre • $minutes분';
  }

  @override
  String get recapMonthly => '월별 기록';

  @override
  String recapMonthTooltip(String month, String minutes) {
    return '$month: $minutes분';
  }

  @override
  String get recapListeningStyle => '나의 감상 스타일';

  @override
  String recapFavHour(String hour) {
    return '가장 좋아하는 시간대: $hour:00';
  }

  @override
  String recapFavWeekday(String day) {
    return '가장 좋아하는 요일: $day';
  }

  @override
  String recapBiggestDay(String date, String minutes) {
    return '가장 많이 들은 날: $date, $minutes분';
  }

  @override
  String recapNewArtists(int count, String n) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '새로 알게 된 아티스트 $n명',
      one: '새로 알게 된 아티스트 $n명',
    );
    return '$_temp0';
  }

  @override
  String recapSpotifyAdded(String added) {
    return 'Spotify 재생 기록 $added건이 추가되었습니다.';
  }

  @override
  String recapSpotifyAddedDup(String added, String dup) {
    return 'Spotify 재생 기록 $added건이 추가되었습니다($dup건은 이미 Pudim 기록에 있었습니다).';
  }

  @override
  String get recapSpotifyRemoveTitle => 'Spotify 기록을 삭제할까요?';

  @override
  String get recapSpotifyRemoveBody =>
      'Wrapped가 Pudim/Jellyfin에서 재생한 기록만 집계하도록 돌아갑니다. 나중에 다시 가져올 수 있습니다.';

  @override
  String get recapSpotifyRemoveConfirm => '삭제';

  @override
  String recapSpotifyRemoved(String count) {
    return 'Spotify 재생 기록 $count건을 삭제했습니다';
  }

  @override
  String get recapSpotifyTitle => 'Spotify 기록';

  @override
  String recapSpotifyHasData(String count, String from, String to) {
    return 'Wrapped에 Spotify 재생 기록 $count건이 포함되어 있습니다($from ~ $to). 더 최신 파일을 업로드할 수 있으며, 이미 포함된 기록은 중복 집계되지 않습니다.';
  }

  @override
  String get recapSpotifyIntro =>
      'Pudim을 쓰기 전의 기록도 가져오세요. Spotify에서 계정 > 개인정보 보호 > 데이터 다운로드로 이동해 \"Extended streaming history\"를 선택합니다. 이메일이 도착하면 여기서 my_spotify_data.zip을 선택하세요.';

  @override
  String get recapSpotifyImportAnother => '다른 파일 가져오기';

  @override
  String get recapSpotifyImport => '기록 가져오기';

  @override
  String get recapSpotifyRemoveBtn => 'Wrapped에서 삭제';

  @override
  String get recapShareSaveDialog => '카드 저장';

  @override
  String get recapShareSaved => '카드를 저장했습니다';

  @override
  String recapShareSaveFailed(String error) {
    return '저장하지 못했습니다: $error';
  }

  @override
  String recapShareShareFailed(String error) {
    return '공유하지 못했습니다: $error';
  }

  @override
  String recapShareText(int year) {
    return 'Pudim에서 만든 나의 $year Wrapped';
  }

  @override
  String get recapShareMyArtists => '올해의 내 톱 아티스트';

  @override
  String get recapShareMySongs => '올해의 내 톱 노래';

  @override
  String recapMinShort(String minutes) {
    return '$minutes분';
  }

  @override
  String get recapShareSaveImage => '이미지 저장';

  @override
  String get recapShareButton => '공유';

  @override
  String recapBrand(int year) {
    return 'Wrapped $year';
  }

  @override
  String get recapShareMyYear => '나의 올해 음악';

  @override
  String recapShareYearOf(String name) {
    return '$name님의 올해 음악';
  }

  @override
  String get recapShareTopArtist => '올해의 내 톱 아티스트';

  @override
  String recapShareGenres(String genres) {
    return '장르: $genres';
  }

  @override
  String get widgetActionsAddedToLiked => '좋아요 표시한 곡에 추가했습니다';

  @override
  String get widgetActionsRemovedFromLiked => '좋아요 표시한 곡에서 삭제했습니다';

  @override
  String get widgetActionsUnfollowed => '팔로우를 취소했습니다';

  @override
  String get widgetActionsSavedToLibrary => '내 라이브러리에 저장했습니다';

  @override
  String get widgetActionsRemovedFromLibrary => '내 라이브러리에서 삭제했습니다';

  @override
  String get widgetActionsAddToQueue => '대기열에 추가';

  @override
  String get widgetActionsAddedToQueue => '대기열에 추가했습니다';

  @override
  String get widgetActionsPlayNext => '다음에 재생';

  @override
  String get widgetActionsGoToPodcast => '팟캐스트로 이동';

  @override
  String get widgetActionsRemoveFromQueue => '대기열에서 삭제';

  @override
  String get widgetActionsAddToPlaylist => '플레이리스트에 추가';

  @override
  String get widgetActionsRemoveFromThisPlaylist => '이 플레이리스트에서 삭제';

  @override
  String get widgetActionsInviteToEdit => '편집 초대';

  @override
  String get widgetActionsKeepInPlaylist => '플레이리스트에 유지';

  @override
  String get widgetActionsDownloadTrack => '노래 다운로드';

  @override
  String get widgetActionsDownloadAlbum => '앨범 다운로드';

  @override
  String get widgetActionsDownloadDiscography => '디스코그래피 다운로드';

  @override
  String get widgetActionsSearchAlbums => '앨범 찾기';

  @override
  String widgetActionsImproveQuality(int count) {
    return '음질 개선($count)';
  }

  @override
  String widgetActionsImprovingAlbums(int count) {
    return '앨범 $count장의 더 나은 버전을 찾는 중';
  }

  @override
  String get widgetActionsShare => '공유';

  @override
  String get widgetActionsSearchFlac => 'FLAC으로 찾기';

  @override
  String widgetActionsSearchingFlac(String name) {
    return '$name을(를) FLAC으로 찾는 중입니다. 찾으면 MP3를 대체합니다';
  }

  @override
  String get widgetActionsTrackRemovedFromDevice => '기기에서 삭제했습니다';

  @override
  String get widgetActionsRemovedFromDevice => '기기에서 삭제했습니다';

  @override
  String get widgetActionsDownloadingToDevice => '오프라인 감상을 위해 기기에 다운로드하는 중입니다';

  @override
  String get widgetActionsUnfollow => '팔로우 취소';

  @override
  String get widgetActionsRemoveFromLibrary => '내 라이브러리에서 삭제';

  @override
  String get widgetActionsAddToLibrary => '내 라이브러리에 추가';

  @override
  String get widgetActionsGoToSongRadio => '노래 라디오로 이동';

  @override
  String get widgetActionsStartMix => '믹스 시작';

  @override
  String widgetActionsMixOf(String name) {
    return '$name 믹스';
  }

  @override
  String get widgetActionsGoToArtist => '아티스트로 이동';

  @override
  String get widgetActionsGoToAlbum => '앨범으로 이동';

  @override
  String get widgetActionsCopyName => '이름 복사';

  @override
  String get widgetActionsCopied => '복사했습니다';

  @override
  String widgetDownloadsBellDownloading(int count) {
    return '$count개 다운로드 중';
  }

  @override
  String get widgetDownloadsBellEmpty =>
      '아직 아무것도 없습니다. 구름 아이콘이 있는 노래를 재생하거나 ⋯ 메뉴의 \"다운로드\"를 사용해 카탈로그에서 라이브러리로 가져오세요.';

  @override
  String get widgetDownloadsBellKindDiscography => '디스코그래피';

  @override
  String get widgetDownloadsBellKindFlac => 'FLAC';

  @override
  String get widgetDownloadsBellKindQuality => '음질';

  @override
  String get widgetDownloadsBellOptions => '옵션';

  @override
  String get widgetDownloadsBellCancelled => '다운로드를 취소했습니다';

  @override
  String get widgetDownloadsBellRetrying => '다시 시도하는 중';

  @override
  String get widgetDownloadsBellRemovedFromList => '목록에서 삭제했습니다';

  @override
  String get widgetDownloadsBellDetails => '자세히 보기';

  @override
  String get widgetDownloadsBellRemoveFromList => '목록에서 삭제';

  @override
  String get widgetMixSearchingReleases => '신곡을 찾는 중…';

  @override
  String get widgetMixBuildingDaylist => 'daylist 만드는 중…';

  @override
  String get widgetMixNewDiscoveriesTitle => '새 Weekly Discoveries를 만들까요?';

  @override
  String get widgetMixNewMixTitle => '새 Weekly Mix를 만들까요?';

  @override
  String get widgetMixNewDiscoveriesBody =>
      '아직 듣지 않은 노래는 플레이리스트에서 빠지고 새 노래 약 30곡이 들어옵니다. 매주 월요일에 자동으로도 진행됩니다.';

  @override
  String get widgetMixNewMixBody =>
      '좋아하는 곡, 가장 많이 듣는 곡, 비슷한 곡으로 다시 만듭니다. 매주 월요일에 자동으로도 진행됩니다.';

  @override
  String get widgetMixNotNow => '나중에';

  @override
  String get widgetMixBuildingDiscoveries => 'Discoveries 만드는 중…';

  @override
  String get widgetMixBuildingMix => 'Mix 만드는 중…';

  @override
  String widgetMixBuiltOn(String date) {
    return '$date에 생성됨';
  }

  @override
  String get widgetMixRedo => '다시 만들기';

  @override
  String get widgetMixRefresh => '새로고침';

  @override
  String get widgetMixCreateDiscoveries => 'Weekly Discoveries 만들기';

  @override
  String get widgetMixCreateMix => 'Weekly Mix 만들기';

  @override
  String get widgetMixCreateRadar => 'New Releases Radar 만들기';

  @override
  String get widgetMixCreateDaylist => 'daylist 만들기';

  @override
  String get widgetOfflineBanner => '인터넷 연결 없음 · 기기에 저장된 항목을 표시 중';

  @override
  String widgetOfflineDownloadingProgress(int done, int total) {
    return '$total개 중 $done개 다운로드 중';
  }

  @override
  String get widgetUpdateReady => 'Pudim 새 버전이 준비되었습니다';

  @override
  String widgetUpdateReadyNotes(String notes) {
    return 'Pudim 새 버전 · $notes';
  }

  @override
  String get widgetUpdateAction => '업데이트';

  @override
  String widgetSleepShortMinutes(int count) {
    return '$count분';
  }

  @override
  String widgetSleepShortSeconds(int count) {
    return '$count초';
  }

  @override
  String get widgetSleepStopsAtEnd => '노래가 끝나면 정지';

  @override
  String widgetSleepStopsIn(String time) {
    return '$time 후 정지';
  }

  @override
  String get widgetSleepTimer => '수면 타이머';

  @override
  String get widgetSleepTurnOff => '타이머 끄기';

  @override
  String get widgetSleepOneHour => '1시간';

  @override
  String get widgetSleepOneAndHalfHours => '1시간 30분';

  @override
  String get widgetSleepEndOfSong => '노래 끝';

  @override
  String get widgetSleepTurnedOff => '타이머를 껐습니다';

  @override
  String get widgetSleepStopsWhenSongEnds => '이 노래가 끝나면 음악이 멈춥니다';

  @override
  String widgetSleepSongStopsIn(String time) {
    return '$time 후 음악이 멈춥니다';
  }

  @override
  String get widgetSpeedPodcast => '팟캐스트 재생 속도';

  @override
  String get widgetCommonCatalogBadge => '카탈로그: 아직 내 라이브러리에 없음';

  @override
  String get widgetCommonShowAll => '모두 보기';

  @override
  String get widgetCommonSomethingWentWrong => '문제가 발생했습니다';

  @override
  String get widgetCommonListenDownloaded => '다운로드한 노래 듣기';

  @override
  String get widgetTracksTitle => '제목';

  @override
  String get widgetTracksDateAdded => '추가한 날짜';

  @override
  String widgetTracksAddedBy(String name) {
    return '$name님이 추가';
  }

  @override
  String get widgetTracksMoreOptions => '옵션 더보기';

  @override
  String widgetTracksAddedDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get castTooltip => '전송';

  @override
  String get castTitle => '재생할 기기';

  @override
  String get castThisDevice => '이 기기';

  @override
  String get castSearching => '네트워크에서 기기 찾는 중…';

  @override
  String get castNone => 'Chromecast를 찾을 수 없습니다. 같은 Wi-Fi에 있어야 합니다.';

  @override
  String get castSearchAgain => '다시 찾기';

  @override
  String get castStop => '전송 중지';

  @override
  String castPlayingOn(String name) {
    return '$name에서 재생 중';
  }

  @override
  String castFailed(String name) {
    return '$name에 연결할 수 없습니다';
  }
}
