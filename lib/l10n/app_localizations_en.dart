// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get languageTitle => 'Language';

  @override
  String get languageSubtitle => 'Interface language';

  @override
  String get languageSystem => 'System default';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonClose => 'Close';

  @override
  String get commonBack => 'Back';

  @override
  String get commonSave => 'Save';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonRemove => 'Remove';

  @override
  String get commonOk => 'OK';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonQueue => 'Queue';

  @override
  String get commonAlbum => 'Album';

  @override
  String get commonAlbums => 'Albums';

  @override
  String get commonArtist => 'Artist';

  @override
  String get commonArtists => 'Artists';

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
  String get commonLikedSongs => 'Liked Songs';

  @override
  String get commonAddToLiked => 'Add to Liked Songs';

  @override
  String get commonRemoveFromLiked => 'Remove from Liked Songs';

  @override
  String get commonShufflePlay => 'Shuffle play';

  @override
  String get commonPlay => 'Play';

  @override
  String get commonPause => 'Pause';

  @override
  String get commonFollow => 'Follow';

  @override
  String get commonFollowing => 'Following';

  @override
  String get commonDownloadToDevice => 'Download to device';

  @override
  String get commonRemoveFromDevice => 'Remove from device';

  @override
  String get commonDownloaded => 'Downloaded';

  @override
  String get commonDownloads => 'Downloads';

  @override
  String get commonAll => 'All';

  @override
  String get commonRecentlyPlayed => 'Recently played';

  @override
  String get commonYourLibrary => 'Your Library';

  @override
  String get commonHome => 'Home';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonProfile => 'Profile';

  @override
  String get commonSettings => 'Settings';

  @override
  String get commonBuilding => 'Building…';

  @override
  String get commonBuildNow => 'Build now';

  @override
  String get commonShows => 'Concerts';

  @override
  String get commonPodcasts => 'Podcasts';

  @override
  String commonSongCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count songs',
      one: '1 song',
      zero: 'No songs',
    );
    return '$_temp0';
  }

  @override
  String commonMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String commonError(String error) {
    return 'Error: $error';
  }

  @override
  String get apiStatusQueued => 'Queued';

  @override
  String get apiStatusDownloading => 'Downloading';

  @override
  String get apiStatusDone => 'Added to the library';

  @override
  String get apiStatusUpToDate => 'Already in the library';

  @override
  String get apiStatusPartial => 'Partially added';

  @override
  String get apiStatusNotFound => 'Not found';

  @override
  String get apiStatusCancelled => 'Canceled';

  @override
  String get apiStatusInterrupted => 'Interrupted';

  @override
  String get apiStatusFailed => 'Failed';

  @override
  String get apiExtrasNoResponse => 'The extras server didn\'t respond.';

  @override
  String get apiAlbumListFailed => 'Couldn\'t list the albums.';

  @override
  String apiPlaylistSaved(int found, int total) {
    return 'Playlist in Your Library ($found of $total songs)';
  }

  @override
  String apiPlaylistDownloading(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more songs',
      one: '1 more song',
    );
    return 'Playlist in Your Library; downloading $_temp0';
  }

  @override
  String get apiBadCredentials => 'Wrong username or password.';

  @override
  String get apiServerUnreachable => 'Couldn\'t reach the server.';

  @override
  String get apiQuickConnectOff =>
      'Quick Connect is turned off on this server.';

  @override
  String get apiWrongCurrentPassword => 'The current password is incorrect.';

  @override
  String stateChatShared(String title) {
    return 'Shared $title';
  }

  @override
  String stateDownloadingName(String name) {
    return 'Downloading $name';
  }

  @override
  String stateDownloadingRequests(int count) {
    return 'Downloading $count requests';
  }

  @override
  String stateDownloadArrived(String name) {
    return '$name was added to the library';
  }

  @override
  String stateDownloadPartial(String name) {
    return '$name was partially added';
  }

  @override
  String stateDownloadEnded(String name, String status) {
    return '$name: $status';
  }

  @override
  String get stateNotFromCatalog => 'This item isn\'t from the catalog.';

  @override
  String stateAlreadyDownloading(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'The album is already downloading.',
      'artist': 'The discography is already downloading.',
      'other': 'The song is already downloading.',
    });
    return '$_temp0';
  }

  @override
  String stateDownloadRequested(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album':
          'Downloading the album. It\'ll show up in the bell when it arrives.',
      'artist': 'Downloading the discography. It\'ll show up in the bell when it arrives.',
      'other':
          'Downloading the song. It\'ll show up in the bell when it arrives.',
    });
    return '$_temp0';
  }

  @override
  String get stateNotifyDownloadsChannel => 'Downloads';

  @override
  String get stateNotifyDownloadsChannelDesc =>
      'Progress of songs being downloaded';

  @override
  String get stateNotifyNewsChannel => 'What\'s new';

  @override
  String get stateNotifyNewsChannelDesc =>
      'New arrivals, releases, Descobertas and Mistura';

  @override
  String get stateOfflineLoose => 'Downloaded one by one';

  @override
  String get stateOfflineDoneTitle => 'Downloaded to this device';

  @override
  String stateOfflineDoneBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count songs ready to listen to offline',
      one: '1 song ready to listen to offline',
    );
    return '$_temp0';
  }

  @override
  String get stateOfflineProgressTitle => 'Downloading to this device';

  @override
  String stateOfflineProgressBody(int done, int total, String name) {
    return '$done of $total • $name';
  }

  @override
  String get stateServerNoReply =>
      'The server didn\'t respond. Check the address.';

  @override
  String get stateServerNoReplyBoth =>
      'The server didn\'t respond at either address.';

  @override
  String get stateTokenStoreUnsupported =>
      'For now Pudim can only save your login on Windows and Android.';

  @override
  String get stateQualityPoor => 'low quality';

  @override
  String get stateQualityPartial => 'incomplete';

  @override
  String get audioPlaybackChannel => 'Playback';

  @override
  String get audioRecentAlbums => 'Recent albums';

  @override
  String audioSearchContext(String query) {
    return 'Search: $query';
  }

  @override
  String audioRadioContext(String name) {
    return '$name Radio';
  }

  @override
  String podcastsMonthShort(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': 'Jan',
      'm2': 'Feb',
      'm3': 'Mar',
      'm4': 'Apr',
      'm5': 'May',
      'm6': 'Jun',
      'm7': 'Jul',
      'm8': 'Aug',
      'm9': 'Sep',
      'm10': 'Oct',
      'm11': 'Nov',
      'other': 'Dec',
    });
    return '$_temp0';
  }

  @override
  String podcastsDateThisYear(int day, String month) {
    return '$month $day';
  }

  @override
  String podcastsDateOtherYear(int day, String month, int year) {
    return '$month $day, $year';
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
  String get podcastsPlayed => 'played';

  @override
  String podcastsTimeLeft(String time) {
    return '$time left';
  }

  @override
  String get podcastsSearchHint => 'Search podcasts';

  @override
  String get podcastsNothingFound => 'Nothing found.';

  @override
  String get podcastsYours => 'Your podcasts';

  @override
  String get podcastsNewEpisodes => 'New episodes';

  @override
  String get podcastsTrendingBrazil => 'Trending in Brazil';

  @override
  String get podcastsLoadFailed => 'Couldn’t load. Try again';

  @override
  String get podcastsNoEpisodes => 'No episodes in the feed.';

  @override
  String podcastsNoEpisodeMatch(String q) {
    return 'No episodes matching \"$q\".';
  }

  @override
  String get podcastsKind => 'Podcast';

  @override
  String get podcastsEpisodes => 'Episodes';

  @override
  String podcastsEpisodesCount(int total) {
    return 'Episodes ($total)';
  }

  @override
  String get podcastsFindEpisode => 'Search episodes';

  @override
  String showsMonthName(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': 'January',
      'm2': 'February',
      'm3': 'March',
      'm4': 'April',
      'm5': 'May',
      'm6': 'June',
      'm7': 'July',
      'm8': 'August',
      'm9': 'September',
      'm10': 'October',
      'm11': 'November',
      'other': 'December',
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
      'w1': 'Mon',
      'w2': 'Tue',
      'w3': 'Wed',
      'w4': 'Thu',
      'w5': 'Fri',
      'w6': 'Sat',
      'other': 'Sun',
    });
    return '$_temp0';
  }

  @override
  String get showsFollowingNone => 'From the artists you follow';

  @override
  String showsFollowingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'From the $count artists you follow',
      one: 'From the 1 artist you follow',
    );
    return '$_temp0';
  }

  @override
  String showsSearchingFor(int count) {
    return 'looking for shows from $count…';
  }

  @override
  String get showsUpcoming => 'Upcoming';

  @override
  String get showsPast => 'Past';

  @override
  String get showsInBrazil => 'In Brazil';

  @override
  String get showsEmptyFollow =>
      'Follow artists (Follow button on the artist page) to see their shows here.';

  @override
  String get showsNonePast => 'No shows recorded yet.';

  @override
  String get showsNoneUpcoming => 'No shows scheduled for now.';

  @override
  String get showsStillSearching => 'Still looking…';

  @override
  String get showsSource =>
      'Dates from MusicBrainz (fan-made); new shows may take a while to appear.';

  @override
  String get showsCancelled => 'cancelled';

  @override
  String get showsFestival => 'festival';

  @override
  String get catalogKindAlbum => 'Album';

  @override
  String get catalogKindSingle => 'Single';

  @override
  String get catalogKindBroadcast => 'Broadcast';

  @override
  String get catalogKindOther => 'Other';

  @override
  String get catalogSecLive => 'live';

  @override
  String get catalogSecCompilation => 'compilation';

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
    return 'Downloading $title';
  }

  @override
  String catalogDownloadingMany(int count, String artist) {
    return 'Downloading $count albums by $artist';
  }

  @override
  String catalogCheckingDiscography(int seconds) {
    return 'Checking the discography… ${seconds}s';
  }

  @override
  String catalogToDownload(int count) {
    return '$count to download';
  }

  @override
  String catalogInLibraryCount(int count) {
    return '$count already in the library';
  }

  @override
  String catalogSkippedOneSong(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count one-song releases left out',
      one: '1 one-song release left out',
    );
    return '$_temp0';
  }

  @override
  String get catalogPickAll => 'All';

  @override
  String get catalogPickStudio => 'Studio';

  @override
  String get catalogPickNone => 'None';

  @override
  String get catalogDownloadSelected => 'Download selected';

  @override
  String catalogDownloadNSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Download $count selected',
      one: 'Download 1 selected',
    );
    return '$_temp0';
  }

  @override
  String get catalogNothingMissing => 'Nothing missing.';

  @override
  String get catalogPartial => 'partial';

  @override
  String get catalogDownload => 'Download';

  @override
  String get catalogAddToLibrary => 'Add to Your Library';

  @override
  String get catalogInYourLibrary => 'In Your Library';

  @override
  String get catalogAllInLibrary => 'all in the library';

  @override
  String catalogNInLibrary(int count) {
    return '$count in the library';
  }

  @override
  String get catalogDownloadAlbum => 'Download album';

  @override
  String get catalogArtistNotFound => 'Artist not found.';

  @override
  String get catalogFromCatalog => 'From the catalog: not in the library yet';

  @override
  String get catalogDownloadAll => 'Download all';

  @override
  String get catalogDownloadDiscography => 'Download discography';

  @override
  String get catalogPopular => 'Popular';

  @override
  String get catalogShowLess => 'Show less';

  @override
  String get catalogShowMore => 'Show more';

  @override
  String get catalogSinglesEps => 'Singles and EPs';

  @override
  String get catalogFansAlsoLike => 'Fans also like';

  @override
  String get lyricsPlaySomething => 'Play something to see the lyrics.';

  @override
  String get lyricsNone => 'No lyrics for this song';

  @override
  String get lyricsNoneHint =>
      'When there’s a .lrc or .txt next to the file, it shows up here.';

  @override
  String get lyricsFind => 'Find lyrics';

  @override
  String get lyricsFinding => 'Looking for lyrics…';

  @override
  String get lyricsNotFound => 'Couldn\'t find lyrics for this song';

  @override
  String get lyricsSynced => 'Synced lyrics from the .lrc file';

  @override
  String get lyricsUnsynced => 'Unsynced lyrics';

  @override
  String get profileChangePhoto => 'Change photo';

  @override
  String get profileNoPhoto => 'No photo chosen';

  @override
  String get profilePhotoTooBig => 'Photo too large (up to 8 MB)';

  @override
  String get profilePhotoChanged => 'Profile photo changed';

  @override
  String get profilePhotoRemoved => 'Photo removed';

  @override
  String get profileNameSaved => 'Profile name saved';

  @override
  String get profileRenameTitle => 'Change your username?';

  @override
  String profileRenameBody(String name) {
    return 'You’ll sign in as \"$name\" in Pudim, Jellyfin and the other apps (Finamp, Feishin…). Your Discoveries, Mix and Rewind come along.';
  }

  @override
  String get profileRenameConfirm => 'Change';

  @override
  String profileNowSignedAs(String name) {
    return 'You now sign in as $name';
  }

  @override
  String get profileEnterNewPassword => 'Enter the new password';

  @override
  String get profilePasswordsDiffer => 'The new passwords don’t match';

  @override
  String get profilePasswordChanged => 'Password changed';

  @override
  String get profileExtrasUnreachable =>
      'Couldn’t reach the extras server; the profile name and username will have to wait.';

  @override
  String get profileNameSection => 'Profile name';

  @override
  String get profileNameHelp => 'This is how your contacts see you in chats.';

  @override
  String get profileYourName => 'Your name';

  @override
  String get profileUsernameSection => 'Username';

  @override
  String get profileUsernameHelp =>
      'The name you use to sign in to Jellyfin (here and in other apps).';

  @override
  String get profileUsernameHint => 'Username';

  @override
  String get profileChangeUsername => 'Change username';

  @override
  String get profilePasswordSection => 'Password';

  @override
  String get profileCurrentPassword => 'Current password';

  @override
  String get profileNewPassword => 'New password';

  @override
  String get profileRepeatPassword => 'Repeat the new password';

  @override
  String get profileChangePassword => 'Change password';

  @override
  String get loginServerRequired => 'Enter your Jellyfin server address.';

  @override
  String get loginUserRequired => 'Enter your username.';

  @override
  String get loginTitle => 'Sign in to Pudim';

  @override
  String get loginSubtitle => 'Use your Jellyfin account.';

  @override
  String get loginUsername => 'Username';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginShowPassword => 'Show password';

  @override
  String get loginHidePassword => 'Hide password';

  @override
  String get loginSubmit => 'Sign in';

  @override
  String get loginQuickConnect => 'Sign in with Quick Connect';

  @override
  String get loginHideAddresses => 'Hide addresses';

  @override
  String get loginServerAddress => 'Server address';

  @override
  String get loginJellyfinServer => 'Jellyfin server';

  @override
  String get loginJellyfinServerExample => 'E.g. https://jellyfin.exemplo.com';

  @override
  String get loginLocalNetwork => 'On the local network (optional)';

  @override
  String get loginLocalNetworkExample =>
      'E.g. http://192.168.0.10:8096. When it responds, the app uses it instead of the main one.';

  @override
  String get loginExtrasServer => 'Extras server (optional)';

  @override
  String get loginExtrasServerHint =>
      'Turns on chat, Jam, Blend, mixes and Rewind. Leave empty if you don’t have one.';

  @override
  String get loginQcExpired => 'The code expired. Try again.';

  @override
  String get loginQcInstructions =>
      'On a device where you’re already signed in to Jellyfin, open your profile, tap Quick Connect and enter this code:';

  @override
  String get loginQcWaiting => 'Waiting for approval…';

  @override
  String get homeDownloadedOnDevice => 'Downloaded on this device';

  @override
  String get homeTabMusic => 'Music';

  @override
  String get homeMadeFor => 'Made for';

  @override
  String get homeMixDiscoveries => 'New music for you, every week';

  @override
  String get homeMixWeekly => 'Your favorites and similar songs, every week';

  @override
  String get homeMixRadar =>
      'New releases from artists you follow, every Friday';

  @override
  String get homeMixDaylist => 'Changes throughout the day';

  @override
  String get homeMixBlend => 'Both of your tastes together';

  @override
  String get homeMixAuto => 'Automatic mix';

  @override
  String get homeSpotifyPlaylists => 'Your Spotify playlists';

  @override
  String get homeFromSpotify => 'From Spotify';

  @override
  String get homeYourPlaylists => 'Your playlists';

  @override
  String get homeTopAlbums => 'Your most played albums';

  @override
  String get homeTopArtists => 'Your favorite artists';

  @override
  String get homeRecentlyAdded => 'Recently added';

  @override
  String get homeYourPodcasts => 'Your podcasts';

  @override
  String get homeRadiosTitle => 'Recommended radios';

  @override
  String get homeRadiosSubtitle =>
      'Non-stop music based on your favorite artists.';

  @override
  String get homeRadioBadge => 'RADIO';

  @override
  String homeRadioWith(String name) {
    return 'With $name and similar artists';
  }

  @override
  String searchNoResults(String query) {
    return 'No results found for \"$query\"';
  }

  @override
  String get searchNoResultsHint =>
      'Check the spelling or use fewer or different words.';

  @override
  String searchCatalogNoResponse(String error) {
    return 'The catalog did not respond: $error';
  }

  @override
  String get searchAlsoCatalog => 'Also searching the catalog…';

  @override
  String searchLibraryOnly(String error) {
    return 'Library only: the catalog did not respond ($error).';
  }

  @override
  String get searchTopResult => 'Top result';

  @override
  String get searchSpotifyPlaylists => 'Spotify playlists';

  @override
  String get searchRecent => 'Recent searches';

  @override
  String get searchClear => 'Clear';

  @override
  String get searchBrowseAll => 'Browse all';

  @override
  String get searchHint => 'What do you want to listen to?';

  @override
  String get albumDownloadedType => 'Album • downloaded on this device';

  @override
  String albumSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count songs',
      one: '1 song',
    );
    return '$_temp0, $total';
  }

  @override
  String get albumRemoveFromLibrary => 'Remove from Your Library';

  @override
  String get albumSaveToLibrary => 'Save to Your Library';

  @override
  String albumMoreOptions(String name) {
    return 'More options for $name';
  }

  @override
  String albumDisc(int number) {
    return 'Disc $number';
  }

  @override
  String albumMoreFrom(String name) {
    return 'More from $name';
  }

  @override
  String artistAlbumsInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count albums in your library',
      one: '1 album in your library',
    );
    return '$_temp0';
  }

  @override
  String artistPlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plays',
      one: '1 play',
    );
    return '$_temp0';
  }

  @override
  String artistMoreOptions(String name) {
    return 'More options for $name';
  }

  @override
  String get artistPopular => 'Popular';

  @override
  String get artistShowLess => 'Show less';

  @override
  String get artistShowMore => 'See more';

  @override
  String get artistYouLiked => 'You liked';

  @override
  String artistFrom(String name) {
    return 'From $name';
  }

  @override
  String get artistDiscography => 'Discography';

  @override
  String get artistPopularReleases => 'Popular releases';

  @override
  String get artistSinglesEps => 'Singles and EPs';

  @override
  String get artistFansAlsoLike => 'Fans also like';

  @override
  String get artistAppearsOn => 'Appears on';

  @override
  String get artistAbout => 'About';

  @override
  String get playlistOriginSpotify => 'From Spotify';

  @override
  String get playlistOriginMadeForYou => 'Made for you';

  @override
  String get playlistOriginAuto => 'Automatic mix';

  @override
  String get playlistDownloadedOnDevice => 'Downloaded on this device';

  @override
  String get playlistOnDevice => 'On this device';

  @override
  String get playlistPlaysOffline => 'Plays without internet.';

  @override
  String playlistPlaysOfflineDownloading(int count) {
    return 'Plays without internet. Downloading $count more…';
  }

  @override
  String playlistSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count songs',
      one: '1 song',
    );
    return '$_temp0, $total';
  }

  @override
  String playlistMoreOptions(String name) {
    return 'More options for $name';
  }

  @override
  String get playlistSearchHint => 'Search in playlist';

  @override
  String get playlistEmpty => 'No songs here yet.';

  @override
  String get playlistErrNoPermission =>
      'You don\'t have permission to edit this playlist.';

  @override
  String playlistErrServer(String code) {
    return 'The server rejected the request ($code).';
  }

  @override
  String get playlistErrNoResponse => 'no response';

  @override
  String get playlistDownloadFirst =>
      'Download the song first to add it to a playlist';

  @override
  String get playlistAddTo => 'Add to playlist';

  @override
  String get playlistNew => 'New playlist';

  @override
  String playlistAddedTo(String name) {
    return 'Added to $name';
  }

  @override
  String get playlistNameHint => 'Playlist name';

  @override
  String get playlistCreate => 'Create';

  @override
  String playlistCreated(String name) {
    return 'Playlist $name created';
  }

  @override
  String get playlistRemoved => 'Removed from playlist';

  @override
  String get playlistInviteTitle => 'Invite to edit';

  @override
  String get playlistInviteSubtitle =>
      'They\'ll see the playlist in their library and can add and remove songs.';

  @override
  String get playlistInviteOwnerOnly => 'Only the playlist creator can invite';

  @override
  String playlistInvited(String who, String playlist) {
    return '$who can now edit $playlist';
  }

  @override
  String playlistCollaborative(String members) {
    return 'Collaborative · $members';
  }

  @override
  String get playlistSmartShuffleTooltip =>
      'Smart Shuffle: shuffle with recommendations';

  @override
  String get playlistSmartShuffleOn =>
      'Smart Shuffle on: recommendations are marked with ✦';

  @override
  String get playlistAddedToThis => 'Added to playlist';

  @override
  String get playlistRecommendation => 'Smart Shuffle recommendation';

  @override
  String get playlistPutIn => 'Add to playlist';

  @override
  String get settingsSectionAccount => 'Account';

  @override
  String get settingsProfileSubtitle => 'Name, username and password';

  @override
  String settingsConnectedAt(String url) {
    return 'Connected to $url';
  }

  @override
  String get settingsSignOut => 'Sign out';

  @override
  String get accountsTitle => 'Accounts';

  @override
  String get accountsAdd => 'Add account or server';

  @override
  String get accountsSwitch => 'Switch';

  @override
  String get accountsInUse => 'In use';

  @override
  String accountsOn(String user, String host) {
    return '$user on $host';
  }

  @override
  String get loginBackToAccount => 'Back to current account';

  @override
  String get settingsSectionServer => 'Server';

  @override
  String get settingsLocalNetwork => 'On the local network';

  @override
  String get settingsServerNote =>
      'To change the Jellyfin addresses, sign out and open \"Server address\" on the sign-in screen.';

  @override
  String get settingsExtrasServer => 'Extras server';

  @override
  String get settingsExtrasNotConfigured =>
      'Not configured (chat, Jam, Blend, mixes and Recap stay hidden)';

  @override
  String get settingsConfigure => 'Set up';

  @override
  String get settingsChange => 'Change';

  @override
  String get settingsSectionPlayback => 'Playback';

  @override
  String get settingsQualityWifi => 'Wi-Fi quality';

  @override
  String get settingsQualityWifiSubtitle =>
      'Original plays the file as it is in the library.';

  @override
  String get settingsQualityMobile => 'Mobile data quality';

  @override
  String get settingsQualityMobileSubtitle =>
      'A lower quality uses less mobile data.';

  @override
  String get settingsQualityOriginal => 'Original';

  @override
  String get settingsAppliesNextSong => 'Applies from the next song';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String settingsBuild(int build) {
    return 'Build $build';
  }

  @override
  String get settingsExtrasEmptyHint => 'Leave empty to turn extras off.';

  @override
  String get settingsAutoplay => 'Autoplay';

  @override
  String get settingsAutoplaySubtitle =>
      'When the queue ends, keeps playing similar songs (Jellyfin mix).';

  @override
  String get settingsNormalize => 'Normalize volume';

  @override
  String get settingsNormalizeSubtitle =>
      'Plays all songs at the same volume, using Jellyfin\'s analysis.';

  @override
  String get settingsScrobble => 'Scrobble';

  @override
  String get settingsLoading => 'Loading…';

  @override
  String get settingsLastfmNoKey =>
      'The extras server doesn\'t have a Last.fm API key configured yet.';

  @override
  String settingsConnectedAs(String name) {
    return 'Connected as $name';
  }

  @override
  String get settingsLastfmConnectedSubtitle =>
      'Everything you listen to on Pudim goes to your Last.fm profile.';

  @override
  String get settingsDisconnect => 'Disconnect';

  @override
  String get settingsLastfmAuthorize => 'Authorize on the Last.fm page';

  @override
  String get settingsLastfmAuthorizeSubtitle =>
      'After clicking \"Yes, allow access\" there, come back and tap Done.';

  @override
  String get settingsFinish => 'Done';

  @override
  String get settingsLastfmConnected => 'Last.fm connected';

  @override
  String get settingsLastfmScrobbleSubtitle =>
      'Logs every song you listen to on your Last.fm.';

  @override
  String get settingsConnect => 'Connect';

  @override
  String get sidebarOpenLibrary => 'Open Your Library';

  @override
  String get sidebarCollapseLibrary => 'Collapse Your Library';

  @override
  String sidebarOnDeviceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count songs',
      one: '1 song',
    );
    return 'On device • $_temp0';
  }

  @override
  String sidebarPlaylistCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count songs',
      one: '1 song',
    );
    return 'Playlist • $_temp0';
  }

  @override
  String sidebarAlbumBy(String artist) {
    return 'Album • $artist';
  }

  @override
  String get sidebarSearchLibrary => 'Search in Your Library';

  @override
  String get sidebarSortBy => 'Sort by';

  @override
  String get sidebarSortRecents => 'Recents';

  @override
  String get sidebarSortAdded => 'Recently added';

  @override
  String get sidebarSortAlpha => 'Alphabetical';

  @override
  String get sidebarSortCreator => 'Creator';

  @override
  String get topBarSearchHint => 'What do you want to play?';

  @override
  String get topBarClearSearch => 'Clear search field';

  @override
  String get topBarBrowse => 'Browse';

  @override
  String get topBarMenu => 'Menu';

  @override
  String get topBarLogoutAccount => 'Log out';

  @override
  String get topBarQuit => 'Quit Pudim';

  @override
  String get topBarLogout => 'Log out';

  @override
  String get playerBarSmartShuffleOff => 'Disable Smart Shuffle';

  @override
  String get playerBarSmartShuffleOn => 'Enable Smart Shuffle';

  @override
  String get playerBarShuffleOff => 'Disable shuffle';

  @override
  String get playerBarShuffleOn => 'Enable shuffle';

  @override
  String get playerBarPlay => 'Play';

  @override
  String get playerBarForward => 'Next';

  @override
  String get playerBarRepeatOn => 'Enable repeat';

  @override
  String get playerBarRepeatOne => 'Enable repeat one';

  @override
  String get playerBarRepeatOff => 'Disable repeat';

  @override
  String get playerBarNowPlayingView => 'Now playing view';

  @override
  String get playerBarLyrics => 'Lyrics';

  @override
  String get playerBarUnmute => 'Unmute';

  @override
  String get playerBarMute => 'Mute';

  @override
  String get rightPanelNothingPlaying =>
      'Play something to see what\'s playing here.';

  @override
  String get rightPanelLyricsPreview => 'Lyrics preview';

  @override
  String get rightPanelAboutArtist => 'About the artist';

  @override
  String get rightPanelNextUp => 'Next up';

  @override
  String get rightPanelOpenQueue => 'Open queue';

  @override
  String get rightPanelQueueEmptyTitle => 'Add to queue';

  @override
  String get rightPanelQueueEmptyHint =>
      'Click \"Add to queue\" in a track\'s menu to put it here';

  @override
  String get rightPanelNowPlaying => 'Now playing';

  @override
  String get rightPanelNextInQueue => 'Next in queue';

  @override
  String rightPanelNextFrom(String name) {
    return 'Next from: $name';
  }

  @override
  String get nowPlayingPlayingFrom => 'PLAYING FROM';

  @override
  String get nowPlayingMoreOptions => 'More options';

  @override
  String get chatChats => 'Chats';

  @override
  String chatYouSaid(String text) {
    return 'You: $text';
  }

  @override
  String get chatContacts => 'Contacts';

  @override
  String get chatServerUnreachable => 'Couldn\'t reach the extras server.';

  @override
  String get chatMessageHint => 'Message';

  @override
  String chatJoinedJam(String title) {
    return 'You joined $title';
  }

  @override
  String chatCouldNotPlay(String error) {
    return 'Couldn\'t play: $error';
  }

  @override
  String get chatJamCardSubtitle => 'Listen together, same queue';

  @override
  String get chatInJam => 'In the Jam';

  @override
  String get chatJoin => 'Join';

  @override
  String get chatNoOtherAccounts => 'No other accounts on the server.';

  @override
  String chatSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count songs',
      one: '1 song',
    );
    return '$_temp0';
  }

  @override
  String chatSentTo(String name) {
    return 'Sent to $name';
  }

  @override
  String chatShareTitle(String title) {
    return 'Share $title';
  }

  @override
  String get chatNoteHint => 'Note (optional)';

  @override
  String get blendWorking => 'Blending…';

  @override
  String blendAffinityButton(int affinity) {
    return 'Blend $affinity%';
  }

  @override
  String get blendCreate => 'Create Blend';

  @override
  String blendWith(String name) {
    return 'Blend with $name';
  }

  @override
  String get blendExplain =>
      'One playlist for both of you, with what you both listen to, the artists you have in common and a bit of what each of you loves most. It shows how well your tastes match and updates every day.';

  @override
  String get blendNotNow => 'Not now';

  @override
  String blendAffinityTitle(int affinity) {
    return 'You have $affinity% affinity';
  }

  @override
  String blendInCommon(String artists) {
    return 'In common: $artists';
  }

  @override
  String blendOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Open Blend ($count songs)',
      one: 'Open Blend (1 song)',
    );
    return '$_temp0';
  }

  @override
  String get blendRefreshNow => 'Refresh now';

  @override
  String get blendUndo => 'Remove Blend';

  @override
  String get blendRefreshing => 'Refreshing the Blend…';

  @override
  String get blendUndoTitle => 'Remove the Blend?';

  @override
  String blendUndoBody(String name) {
    return 'The playlist will disappear for you and $name.';
  }

  @override
  String get blendUndoConfirm => 'Remove';

  @override
  String get blendUndone => 'Blend removed';

  @override
  String get jamStart => 'Start a Jam';

  @override
  String jamTooltip(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jam ($count people)',
      one: 'Jam (1 person)',
    );
    return '$_temp0';
  }

  @override
  String get jamSubIdle =>
      'Listen together with other accounts, on the same queue.';

  @override
  String get jamSubHost => 'You\'re in charge. Everyone can request songs.';

  @override
  String get jamSubGuest => 'Your controls and songs go to everyone’s queue.';

  @override
  String get jamPlayFirst => 'Play something before starting the Jam.';

  @override
  String jamMembers(int count) {
    return 'In the Jam ($count)';
  }

  @override
  String jamYouSuffix(String name) {
    return '$name (you)';
  }

  @override
  String get jamHost => 'Host';

  @override
  String get jamInvite => 'Invite';

  @override
  String get jamInviteTitle => 'Invite to the Jam';

  @override
  String get jamInviteSubtitle => 'The invite arrives in their chat.';

  @override
  String jamInviteSent(String name) {
    return 'Invite sent to $name';
  }

  @override
  String get jamEnd => 'End the Jam';

  @override
  String get jamLeave => 'Leave the Jam';

  @override
  String recapTitle(int year) {
    return 'Your $year Wrapped';
  }

  @override
  String get recapShort => 'Wrapped';

  @override
  String recapBannerBody(String minutes) {
    return '$minutes minutes of music this year. See what you played the most.';
  }

  @override
  String get recapEmpty => 'There are no plays yet to build your Wrapped.';

  @override
  String get recapShareCards => 'Share cards';

  @override
  String get recapBigMinutes => 'minutes listened';

  @override
  String get recapBigSongs => 'different songs';

  @override
  String get recapBigArtists => 'artists';

  @override
  String get recapBigDays => 'days with music';

  @override
  String get recapBigStreak => 'days in a row, your record';

  @override
  String get recapTopArtists => 'Your top artists of the year';

  @override
  String recapMinutesValue(String minutes) {
    return '$minutes minutes';
  }

  @override
  String get recapTopSongs => 'Your top songs of the year';

  @override
  String recapPlaysLine(String artist, String plays) {
    return '$artist • $plays plays';
  }

  @override
  String get recapSongGone => 'This song is no longer in the library';

  @override
  String get recapTopAlbums => 'Your top albums of the year';

  @override
  String get recapTopGenres => 'Your most played genres';

  @override
  String recapGenreLine(String genre, String minutes) {
    return '$genre • $minutes min';
  }

  @override
  String get recapMonthly => 'Month by month';

  @override
  String recapMonthTooltip(String month, String minutes) {
    return '$month: $minutes min';
  }

  @override
  String get recapListeningStyle => 'How you listen';

  @override
  String recapFavHour(String hour) {
    return 'Favorite hour: $hour:00';
  }

  @override
  String recapFavWeekday(String day) {
    return 'Favorite day of the week: $day';
  }

  @override
  String recapBiggestDay(String date, String minutes) {
    return 'Your biggest day: $date, $minutes minutes';
  }

  @override
  String recapNewArtists(int count, String n) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$n new artists for you',
      one: '$n new artist for you',
    );
    return '$_temp0';
  }

  @override
  String recapSpotifyAdded(String added) {
    return '$added Spotify plays were added.';
  }

  @override
  String recapSpotifyAddedDup(String added, String dup) {
    return '$added Spotify plays were added ($dup were already there from Pudim).';
  }

  @override
  String get recapSpotifyRemoveTitle => 'Remove your Spotify history?';

  @override
  String get recapSpotifyRemoveBody =>
      'Your Wrapped will go back to counting only what you played on Pudim/Jellyfin. You can import it again later.';

  @override
  String get recapSpotifyRemoveConfirm => 'Remove';

  @override
  String recapSpotifyRemoved(String count) {
    return '$count Spotify plays removed';
  }

  @override
  String get recapSpotifyTitle => 'Spotify history';

  @override
  String recapSpotifyHasData(String count, String from, String to) {
    return '$count Spotify plays in your Wrapped ($from to $to). You can upload a newer file: what is already in won’t be counted twice.';
  }

  @override
  String get recapSpotifyIntro =>
      'Bring in the years before Pudim. In Spotify, go to Account > Privacy > Download your data and select \"Extended streaming history\". When the email arrives, pick my_spotify_data.zip here.';

  @override
  String get recapSpotifyImportAnother => 'Import another file';

  @override
  String get recapSpotifyImport => 'Import history';

  @override
  String get recapSpotifyRemoveBtn => 'Remove from Wrapped';

  @override
  String get recapShareSaveDialog => 'Save card';

  @override
  String get recapShareSaved => 'Card saved';

  @override
  String recapShareSaveFailed(String error) {
    return 'Couldn\'t save: $error';
  }

  @override
  String recapShareShareFailed(String error) {
    return 'Couldn\'t share: $error';
  }

  @override
  String recapShareText(int year) {
    return 'My $year Wrapped on Pudim';
  }

  @override
  String get recapShareMyArtists => 'My top artists of the year';

  @override
  String get recapShareMySongs => 'My top songs of the year';

  @override
  String recapMinShort(String minutes) {
    return '$minutes min';
  }

  @override
  String get recapShareSaveImage => 'Save image';

  @override
  String get recapShareButton => 'Share';

  @override
  String recapBrand(int year) {
    return 'Wrapped $year';
  }

  @override
  String get recapShareMyYear => 'My year in music';

  @override
  String recapShareYearOf(String name) {
    return '$name\'s year in music';
  }

  @override
  String get recapShareTopArtist => 'my top artist of the year';

  @override
  String recapShareGenres(String genres) {
    return 'Genres: $genres';
  }

  @override
  String get widgetActionsAddedToLiked => 'Added to Liked Songs';

  @override
  String get widgetActionsRemovedFromLiked => 'Removed from Liked Songs';

  @override
  String get widgetActionsUnfollowed => 'Unfollowed';

  @override
  String get widgetActionsSavedToLibrary => 'Saved to Your Library';

  @override
  String get widgetActionsRemovedFromLibrary => 'Removed from Your Library';

  @override
  String get widgetActionsAddToQueue => 'Add to queue';

  @override
  String get widgetActionsAddedToQueue => 'Added to queue';

  @override
  String get widgetActionsPlayNext => 'Play next';

  @override
  String get widgetActionsGoToPodcast => 'Go to podcast';

  @override
  String get widgetActionsRemoveFromQueue => 'Remove from queue';

  @override
  String get widgetActionsAddToPlaylist => 'Add to playlist';

  @override
  String get widgetActionsRemoveFromThisPlaylist => 'Remove from this playlist';

  @override
  String get widgetActionsInviteToEdit => 'Invite to edit';

  @override
  String get widgetActionsKeepInPlaylist => 'Keep in playlist';

  @override
  String get widgetActionsDownloadTrack => 'Download song';

  @override
  String get widgetActionsDownloadAlbum => 'Download album';

  @override
  String get widgetActionsDownloadDiscography => 'Download discography';

  @override
  String get widgetActionsSearchAlbums => 'Find albums';

  @override
  String widgetActionsImproveQuality(int count) {
    return 'Improve quality ($count)';
  }

  @override
  String widgetActionsImprovingAlbums(int count) {
    return 'Looking for better versions of $count albums';
  }

  @override
  String get widgetActionsShare => 'Share';

  @override
  String get widgetActionsSearchFlac => 'Find in FLAC';

  @override
  String widgetActionsSearchingFlac(String name) {
    return 'Looking for $name in FLAC; if found, it replaces the MP3';
  }

  @override
  String get widgetActionsTrackRemovedFromDevice => 'Removed from device';

  @override
  String get widgetActionsRemovedFromDevice => 'Removed from device';

  @override
  String get widgetActionsDownloadingToDevice =>
      'Downloading to your device for offline listening';

  @override
  String get widgetActionsUnfollow => 'Unfollow';

  @override
  String get widgetActionsRemoveFromLibrary => 'Remove from Your Library';

  @override
  String get widgetActionsAddToLibrary => 'Add to Your Library';

  @override
  String get widgetActionsGoToSongRadio => 'Go to song radio';

  @override
  String get widgetActionsStartMix => 'Start mix';

  @override
  String widgetActionsMixOf(String name) {
    return '$name Mix';
  }

  @override
  String get widgetActionsGoToArtist => 'Go to artist';

  @override
  String get widgetActionsGoToAlbum => 'Go to album';

  @override
  String get widgetActionsCopyName => 'Copy name';

  @override
  String get widgetActionsCopied => 'Copied';

  @override
  String widgetDownloadsBellDownloading(int count) {
    return '$count downloading';
  }

  @override
  String get widgetDownloadsBellEmpty =>
      'Nothing here yet. Play a song with a cloud icon or use \"Download\" in the ⋯ menu to bring it from the catalog into your library.';

  @override
  String get widgetDownloadsBellKindDiscography => 'Discography';

  @override
  String get widgetDownloadsBellKindFlac => 'In FLAC';

  @override
  String get widgetDownloadsBellKindQuality => 'Quality';

  @override
  String get widgetDownloadsBellOptions => 'Options';

  @override
  String get widgetDownloadsBellCancelled => 'Download cancelled';

  @override
  String get widgetDownloadsBellRetrying => 'Trying again';

  @override
  String get widgetDownloadsBellRemovedFromList => 'Removed from list';

  @override
  String get widgetDownloadsBellDetails => 'View details';

  @override
  String get widgetDownloadsBellRemoveFromList => 'Remove from list';

  @override
  String get widgetMixSearchingReleases => 'Looking for new releases…';

  @override
  String get widgetMixBuildingDaylist => 'Building your daylist…';

  @override
  String get widgetMixNewDiscoveriesTitle => 'New Weekly Discoveries?';

  @override
  String get widgetMixNewMixTitle => 'New Weekly Mix?';

  @override
  String get widgetMixNewDiscoveriesBody =>
      'Songs you haven\'t listened to yet leave the playlist and about 30 new ones start coming in. This already happens on its own every Monday.';

  @override
  String get widgetMixNewMixBody =>
      'Rebuilds it with your favorites, what you listen to most and similar songs. This already happens on its own every Monday.';

  @override
  String get widgetMixNotNow => 'Not now';

  @override
  String get widgetMixBuildingDiscoveries => 'Building your Discoveries…';

  @override
  String get widgetMixBuildingMix => 'Building your Mix…';

  @override
  String widgetMixBuiltOn(String date) {
    return 'Built on $date';
  }

  @override
  String get widgetMixRedo => 'Rebuild';

  @override
  String get widgetMixRefresh => 'Refresh';

  @override
  String get widgetMixCreateDiscoveries => 'Create your Weekly Discoveries';

  @override
  String get widgetMixCreateMix => 'Create your Weekly Mix';

  @override
  String get widgetMixCreateRadar => 'Create your New Releases Radar';

  @override
  String get widgetMixCreateDaylist => 'Create your daylist';

  @override
  String get widgetOfflineBanner =>
      'No internet · showing what is saved on your device';

  @override
  String widgetOfflineDownloadingProgress(int done, int total) {
    return 'Downloading $done of $total';
  }

  @override
  String get widgetUpdateReady => 'New version of Pudim ready';

  @override
  String widgetUpdateReadyNotes(String notes) {
    return 'New version of Pudim · $notes';
  }

  @override
  String get widgetUpdateAction => 'Update';

  @override
  String widgetSleepShortMinutes(int count) {
    return '$count min';
  }

  @override
  String widgetSleepShortSeconds(int count) {
    return '$count s';
  }

  @override
  String get widgetSleepStopsAtEnd => 'Stops at end of song';

  @override
  String widgetSleepStopsIn(String time) {
    return 'Stops in $time';
  }

  @override
  String get widgetSleepTimer => 'Sleep timer';

  @override
  String get widgetSleepTurnOff => 'Turn off timer';

  @override
  String get widgetSleepOneHour => '1 hour';

  @override
  String get widgetSleepOneAndHalfHours => '1 hour 30 minutes';

  @override
  String get widgetSleepEndOfSong => 'End of song';

  @override
  String get widgetSleepTurnedOff => 'Timer turned off';

  @override
  String get widgetSleepStopsWhenSongEnds => 'Music stops when this song ends';

  @override
  String widgetSleepSongStopsIn(String time) {
    return 'Music stops in $time';
  }

  @override
  String get widgetSpeedPodcast => 'Podcast speed';

  @override
  String get widgetCommonCatalogBadge =>
      'From the catalog: not in your library yet';

  @override
  String get widgetCommonShowAll => 'Show all';

  @override
  String get widgetCommonSomethingWentWrong => 'Something went wrong';

  @override
  String get widgetCommonListenDownloaded => 'Listen to downloaded songs';

  @override
  String get widgetTracksTitle => 'Title';

  @override
  String get widgetTracksDateAdded => 'Date added';

  @override
  String widgetTracksAddedBy(String name) {
    return 'by $name';
  }

  @override
  String get widgetTracksMoreOptions => 'More options';

  @override
  String widgetTracksAddedDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get castTooltip => 'Cast';

  @override
  String get castTitle => 'Play on';

  @override
  String get castThisDevice => 'This device';

  @override
  String get castSearching => 'Looking for devices on the network…';

  @override
  String get castNone =>
      'No Chromecast found. It needs to be on the same Wi-Fi.';

  @override
  String get castSearchAgain => 'Search again';

  @override
  String get castStop => 'Stop casting';

  @override
  String castPlayingOn(String name) {
    return 'Playing on $name';
  }

  @override
  String castFailed(String name) {
    return 'Couldn\'t connect to $name';
  }

  @override
  String get settingsSectionAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSubtitle => 'Changes the colors right away.';

  @override
  String get themeNightDesc =>
      'Dark, rounded cards and a floating mini player.';

  @override
  String get themeRedDesc =>
      'Pure black with red, big square covers, mini player docked to the bar.';

  @override
  String get themeWaveDesc =>
      'Purple gradients, bold type and a pill-shaped mini player.';

  @override
  String get themeRetroDesc =>
      'Bevelled gray window, green display with scrolling title and text lists.';

  @override
  String get themeClassicDesc =>
      'Glossy blue and black glass, orb button, visualizer and table lists.';

  @override
  String get settingsCheckUpdates => 'Check for updates';

  @override
  String get updateChecking => 'Checking…';

  @override
  String updateUpToDate(int build) {
    return 'You have the latest version (build $build).';
  }

  @override
  String updateDownloading(int build, int percent) {
    return 'Downloading build $build… $percent%';
  }

  @override
  String updateFailed(String error) {
    return 'Could not check: $error';
  }

  @override
  String get updateUnavailable => 'No extras server configured.';

  @override
  String get settingsHistory => 'History';

  @override
  String get settingsHistorySubtitle =>
      'Recaps from earlier years and everything you played';

  @override
  String get historyRecaps => 'Recaps';

  @override
  String get historyPlays => 'Plays';

  @override
  String get historyWholeYear => 'Whole year';

  @override
  String get historyLoadMore => 'Load more';

  @override
  String get historyEmpty => 'Nothing played yet';

  @override
  String get historyImported => 'imported';

  @override
  String widgetMixRadarDone(int count) {
    return 'New Releases Radar: $count songs';
  }

  @override
  String widgetMixRadarQueued(int count, String list) {
    return 'Downloading $count release(s): $list';
  }

  @override
  String widgetMixRadarFailed(String error) {
    return 'The Radar did not update: $error';
  }
}
