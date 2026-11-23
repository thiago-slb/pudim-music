// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class L10nTr extends L10n {
  L10nTr([String locale = 'tr']) : super(locale);

  @override
  String get languageTitle => 'Dil';

  @override
  String get languageSubtitle => 'Arayüz dili';

  @override
  String get languageSystem => 'Sistem varsayılanı';

  @override
  String get commonCancel => 'İptal';

  @override
  String get commonClose => 'Kapat';

  @override
  String get commonBack => 'Geri';

  @override
  String get commonSave => 'Kaydet';

  @override
  String get commonEdit => 'Düzenle';

  @override
  String get commonDelete => 'Sil';

  @override
  String get commonRemove => 'Kaldır';

  @override
  String get commonOk => 'Tamam';

  @override
  String get commonRetry => 'Tekrar dene';

  @override
  String get commonQueue => 'Sıra';

  @override
  String get commonAlbum => 'Albüm';

  @override
  String get commonAlbums => 'Albümler';

  @override
  String get commonArtist => 'Sanatçı';

  @override
  String get commonArtists => 'Sanatçılar';

  @override
  String get commonSong => 'Şarkı';

  @override
  String get commonSongs => 'Şarkılar';

  @override
  String get commonPlaylist => 'Çalma listesi';

  @override
  String get commonPlaylists => 'Çalma listeleri';

  @override
  String get commonSingle => 'Single';

  @override
  String get commonLikedSongs => 'Beğenilen Şarkılar';

  @override
  String get commonAddToLiked => 'Beğenilen Şarkılar’a ekle';

  @override
  String get commonRemoveFromLiked => 'Beğenilen Şarkılar’dan kaldır';

  @override
  String get commonShufflePlay => 'Karışık çal';

  @override
  String get commonPlay => 'Çal';

  @override
  String get commonPause => 'Duraklat';

  @override
  String get commonFollow => 'Takip et';

  @override
  String get commonFollowing => 'Takip ediliyor';

  @override
  String get commonDownloadToDevice => 'Cihaza indir';

  @override
  String get commonRemoveFromDevice => 'Cihazdan kaldır';

  @override
  String get commonDownloaded => 'İndirildi';

  @override
  String get commonDownloads => 'İndirilenler';

  @override
  String get commonAll => 'Tümü';

  @override
  String get commonRecentlyPlayed => 'Son çalınanlar';

  @override
  String get commonYourLibrary => 'Kitaplığın';

  @override
  String get commonHome => 'Ana sayfa';

  @override
  String get commonSearch => 'Ara';

  @override
  String get commonProfile => 'Profil';

  @override
  String get commonSettings => 'Ayarlar';

  @override
  String get commonBuilding => 'Oluşturuluyor…';

  @override
  String get commonBuildNow => 'Şimdi oluştur';

  @override
  String get commonShows => 'Konserler';

  @override
  String get commonPodcasts => 'Podcast’ler';

  @override
  String commonSongCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count şarkı',
      one: '1 şarkı',
      zero: 'Şarkı yok',
    );
    return '$_temp0';
  }

  @override
  String commonMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dakika',
      one: '1 dakika',
    );
    return '$_temp0';
  }

  @override
  String commonError(String error) {
    return 'Hata: $error';
  }

  @override
  String get apiStatusQueued => 'Sırada';

  @override
  String get apiStatusDownloading => 'İndiriliyor';

  @override
  String get apiStatusDone => 'Kitaplığa eklendi';

  @override
  String get apiStatusUpToDate => 'Zaten kitaplıkta';

  @override
  String get apiStatusPartial => 'Kısmen eklendi';

  @override
  String get apiStatusNotFound => 'Bulunamadı';

  @override
  String get apiStatusCancelled => 'İptal edildi';

  @override
  String get apiStatusInterrupted => 'Kesintiye uğradı';

  @override
  String get apiStatusFailed => 'Başarısız';

  @override
  String get apiExtrasNoResponse => 'Ekstra sunucu yanıt vermedi.';

  @override
  String get apiAlbumListFailed => 'Albümler listelenemedi.';

  @override
  String apiPlaylistSaved(int found, int total) {
    return 'Kitaplığındaki çalma listesi ($found/$total şarkı)';
  }

  @override
  String apiPlaylistDownloading(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count şarkı daha indiriliyor',
      one: '1 şarkı daha indiriliyor',
    );
    return 'Kitaplığındaki çalma listesi; $_temp0';
  }

  @override
  String get apiBadCredentials => 'Kullanıcı adı veya parola yanlış.';

  @override
  String get apiServerUnreachable => 'Sunucuya ulaşılamadı.';

  @override
  String get apiQuickConnectOff => 'Quick Connect bu sunucuda kapalı.';

  @override
  String get apiWrongCurrentPassword => 'Mevcut parola yanlış.';

  @override
  String stateChatShared(String title) {
    return '$title paylaşıldı';
  }

  @override
  String stateDownloadingName(String name) {
    return '$name indiriliyor';
  }

  @override
  String stateDownloadingRequests(int count) {
    return '$count istek indiriliyor';
  }

  @override
  String stateDownloadArrived(String name) {
    return '$name kitaplığa eklendi';
  }

  @override
  String stateDownloadPartial(String name) {
    return '$name kısmen eklendi';
  }

  @override
  String stateDownloadEnded(String name, String status) {
    return '$name: $status';
  }

  @override
  String get stateNotFromCatalog => 'Bu öğe katalogdan değil.';

  @override
  String stateAlreadyDownloading(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Albüm zaten indiriliyor.',
      'artist': 'Diskografi zaten indiriliyor.',
      'other': 'Şarkı zaten indiriliyor.',
    });
    return '$_temp0';
  }

  @override
  String stateDownloadRequested(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Albüm indiriliyor. Geldiğinde zil simgesinde görünecek.',
      'artist': 'Diskografi indiriliyor. Geldiğinde zil simgesinde görünecek.',
      'other': 'Şarkı indiriliyor. Geldiğinde zil simgesinde görünecek.',
    });
    return '$_temp0';
  }

  @override
  String get stateNotifyDownloadsChannel => 'İndirilenler';

  @override
  String get stateNotifyDownloadsChannelDesc =>
      'İndirilen şarkıların ilerlemesi';

  @override
  String get stateNotifyNewsChannel => 'Yenilikler';

  @override
  String get stateNotifyNewsChannelDesc =>
      'Yeni gelenler, çıkışlar, Descobertas ve Mistura';

  @override
  String get stateOfflineLoose => 'Tek tek indirildi';

  @override
  String get stateOfflineDoneTitle => 'Bu cihaza indirildi';

  @override
  String stateOfflineDoneBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count şarkı çevrimdışı dinlemeye hazır',
      one: '1 şarkı çevrimdışı dinlemeye hazır',
    );
    return '$_temp0';
  }

  @override
  String get stateOfflineProgressTitle => 'Bu cihaza indiriliyor';

  @override
  String stateOfflineProgressBody(int done, int total, String name) {
    return '$done/$total • $name';
  }

  @override
  String get stateServerNoReply => 'Sunucu yanıt vermedi. Adresi kontrol et.';

  @override
  String get stateServerNoReplyBoth => 'Sunucu iki adreste de yanıt vermedi.';

  @override
  String get stateTokenStoreUnsupported =>
      'Şimdilik Pudim girişini yalnızca Windows ve Android’de kaydedebiliyor.';

  @override
  String get stateQualityPoor => 'düşük kalite';

  @override
  String get stateQualityPartial => 'eksik';

  @override
  String get audioPlaybackChannel => 'Oynatma';

  @override
  String get audioRecentAlbums => 'Son albümler';

  @override
  String audioSearchContext(String query) {
    return 'Arama: $query';
  }

  @override
  String audioRadioContext(String name) {
    return '$name Radyosu';
  }

  @override
  String podcastsMonthShort(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': 'Oca',
      'm2': 'Şub',
      'm3': 'Mar',
      'm4': 'Nis',
      'm5': 'May',
      'm6': 'Haz',
      'm7': 'Tem',
      'm8': 'Ağu',
      'm9': 'Eyl',
      'm10': 'Eki',
      'm11': 'Kas',
      'other': 'Ara',
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
    return '$h sa $min dk';
  }

  @override
  String podcastsMin(int min) {
    return '$min dk';
  }

  @override
  String get podcastsPlayed => 'dinlendi';

  @override
  String podcastsTimeLeft(String time) {
    return '$time kaldı';
  }

  @override
  String get podcastsSearchHint => 'Podcast ara';

  @override
  String get podcastsNothingFound => 'Hiçbir şey bulunamadı.';

  @override
  String get podcastsYours => 'Podcast’lerin';

  @override
  String get podcastsNewEpisodes => 'Yeni bölümler';

  @override
  String get podcastsTrendingBrazil => 'Brezilya’da öne çıkanlar';

  @override
  String get podcastsLoadFailed => 'Yüklenemedi. Tekrar dene';

  @override
  String get podcastsNoEpisodes => 'Akışta bölüm yok.';

  @override
  String podcastsNoEpisodeMatch(String q) {
    return '\"$q\" ile eşleşen bölüm yok.';
  }

  @override
  String get podcastsKind => 'Podcast';

  @override
  String get podcastsEpisodes => 'Bölümler';

  @override
  String podcastsEpisodesCount(int total) {
    return 'Bölümler ($total)';
  }

  @override
  String get podcastsFindEpisode => 'Bölüm ara';

  @override
  String showsMonthName(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': 'Ocak',
      'm2': 'Şubat',
      'm3': 'Mart',
      'm4': 'Nisan',
      'm5': 'Mayıs',
      'm6': 'Haziran',
      'm7': 'Temmuz',
      'm8': 'Ağustos',
      'm9': 'Eylül',
      'm10': 'Ekim',
      'm11': 'Kasım',
      'other': 'Aralık',
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
      'w1': 'Pzt',
      'w2': 'Sal',
      'w3': 'Çar',
      'w4': 'Per',
      'w5': 'Cum',
      'w6': 'Cmt',
      'other': 'Paz',
    });
    return '$_temp0';
  }

  @override
  String get showsFollowingNone => 'Takip ettiğin sanatçılardan';

  @override
  String showsFollowingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Takip ettiğin $count sanatçıdan',
      one: 'Takip ettiğin 1 sanatçıdan',
    );
    return '$_temp0';
  }

  @override
  String showsSearchingFor(int count) {
    return '$count sanatçının konserleri aranıyor…';
  }

  @override
  String get showsUpcoming => 'Yaklaşanlar';

  @override
  String get showsPast => 'Geçmiş';

  @override
  String get showsInBrazil => 'Brezilya’da';

  @override
  String get showsEmptyFollow =>
      'Konserlerini burada görmek için sanatçıları takip et (sanatçı sayfasındaki Takip et düğmesi).';

  @override
  String get showsNonePast => 'Henüz kayıtlı konser yok.';

  @override
  String get showsNoneUpcoming => 'Şimdilik planlanmış konser yok.';

  @override
  String get showsStillSearching => 'Aramaya devam ediliyor…';

  @override
  String get showsSource =>
      'Tarihler MusicBrainz’den (hayranlar tarafından hazırlanıyor); yeni konserlerin görünmesi biraz zaman alabilir.';

  @override
  String get showsCancelled => 'iptal edildi';

  @override
  String get showsFestival => 'festival';

  @override
  String get catalogKindAlbum => 'Albüm';

  @override
  String get catalogKindSingle => 'Single';

  @override
  String get catalogKindBroadcast => 'Yayın';

  @override
  String get catalogKindOther => 'Diğer';

  @override
  String get catalogSecLive => 'canlı';

  @override
  String get catalogSecCompilation => 'derleme';

  @override
  String get catalogSecSoundtrack => 'film müziği';

  @override
  String get catalogSecMixtape => 'mixtape';

  @override
  String get catalogSecInterview => 'röportaj';

  @override
  String get catalogSecSpokenword => 'konuşma';

  @override
  String catalogDownloadingOne(String title) {
    return '$title indiriliyor';
  }

  @override
  String catalogDownloadingMany(int count, String artist) {
    return '$artist sanatçısının $count albümü indiriliyor';
  }

  @override
  String catalogCheckingDiscography(int seconds) {
    return 'Diskografi kontrol ediliyor… $seconds sn';
  }

  @override
  String catalogToDownload(int count) {
    return '$count indirilecek';
  }

  @override
  String catalogInLibraryCount(int count) {
    return '$count zaten kitaplıkta';
  }

  @override
  String catalogSkippedOneSong(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tek şarkılık yayın dışarıda bırakıldı',
      one: '1 tek şarkılık yayın dışarıda bırakıldı',
    );
    return '$_temp0';
  }

  @override
  String get catalogPickAll => 'Tümü';

  @override
  String get catalogPickStudio => 'Stüdyo';

  @override
  String get catalogPickNone => 'Hiçbiri';

  @override
  String get catalogDownloadSelected => 'Seçilenleri indir';

  @override
  String catalogDownloadNSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Seçilen $count öğeyi indir',
      one: 'Seçilen 1 öğeyi indir',
    );
    return '$_temp0';
  }

  @override
  String get catalogNothingMissing => 'Eksik bir şey yok.';

  @override
  String get catalogPartial => 'kısmi';

  @override
  String get catalogDownload => 'İndir';

  @override
  String get catalogAddToLibrary => 'Kitaplığına ekle';

  @override
  String get catalogInYourLibrary => 'Kitaplığında';

  @override
  String get catalogAllInLibrary => 'hepsi kitaplıkta';

  @override
  String catalogNInLibrary(int count) {
    return '$count kitaplıkta';
  }

  @override
  String get catalogDownloadAlbum => 'Albümü indir';

  @override
  String get catalogArtistNotFound => 'Sanatçı bulunamadı.';

  @override
  String get catalogFromCatalog => 'Katalogdan: henüz kitaplıkta değil';

  @override
  String get catalogDownloadAll => 'Tümünü indir';

  @override
  String get catalogDownloadDiscography => 'Diskografiyi indir';

  @override
  String get catalogPopular => 'Popüler';

  @override
  String get catalogShowLess => 'Daha az göster';

  @override
  String get catalogShowMore => 'Daha fazla göster';

  @override
  String get catalogSinglesEps => 'Single ve EP’ler';

  @override
  String get catalogFansAlsoLike => 'Hayranlar bunları da beğeniyor';

  @override
  String get lyricsPlaySomething => 'Sözleri görmek için bir şey çal.';

  @override
  String get lyricsNone => 'Bu şarkının sözü yok';

  @override
  String get lyricsNoneHint =>
      'Dosyanın yanında bir .lrc veya .txt olduğunda burada görünür.';

  @override
  String get lyricsSynced => '.lrc dosyasından senkronize sözler';

  @override
  String get lyricsUnsynced => 'Senkronize olmayan sözler';

  @override
  String get profileChangePhoto => 'Fotoğrafı değiştir';

  @override
  String get profileNoPhoto => 'Fotoğraf seçilmedi';

  @override
  String get profilePhotoTooBig => 'Fotoğraf çok büyük (en fazla 8 MB)';

  @override
  String get profilePhotoChanged => 'Profil fotoğrafı değiştirildi';

  @override
  String get profilePhotoRemoved => 'Fotoğraf kaldırıldı';

  @override
  String get profileNameSaved => 'Profil adı kaydedildi';

  @override
  String get profileRenameTitle => 'Kullanıcı adını değiştir?';

  @override
  String profileRenameBody(String name) {
    return 'Pudim’de, Jellyfin’de ve diğer uygulamalarda (Finamp, Feishin…) \"$name\" olarak giriş yapacaksın. Keşifların, Karışımın ve Geri Sarmaların seninle gelir.';
  }

  @override
  String get profileRenameConfirm => 'Değiştir';

  @override
  String profileNowSignedAs(String name) {
    return 'Artık $name olarak giriş yapıyorsun';
  }

  @override
  String get profileEnterNewPassword => 'Yeni parolayı gir';

  @override
  String get profilePasswordsDiffer => 'Yeni parolalar eşleşmiyor';

  @override
  String get profilePasswordChanged => 'Parola değiştirildi';

  @override
  String get profileExtrasUnreachable =>
      'Ekstra sunucuya ulaşılamadı; profil adı ve kullanıcı adı beklemek zorunda.';

  @override
  String get profileNameSection => 'Profil adı';

  @override
  String get profileNameHelp => 'Kişilerin seni sohbetlerde böyle görür.';

  @override
  String get profileYourName => 'Adın';

  @override
  String get profileUsernameSection => 'Kullanıcı adı';

  @override
  String get profileUsernameHelp =>
      'Jellyfin’e giriş yaparken kullandığın ad (burada ve diğer uygulamalarda).';

  @override
  String get profileUsernameHint => 'Kullanıcı adı';

  @override
  String get profileChangeUsername => 'Kullanıcı adını değiştir';

  @override
  String get profilePasswordSection => 'Parola';

  @override
  String get profileCurrentPassword => 'Mevcut parola';

  @override
  String get profileNewPassword => 'Yeni parola';

  @override
  String get profileRepeatPassword => 'Yeni parolayı tekrar gir';

  @override
  String get profileChangePassword => 'Parolayı değiştir';

  @override
  String get loginServerRequired => 'Jellyfin sunucu adresini gir.';

  @override
  String get loginUserRequired => 'Kullanıcı adını gir.';

  @override
  String get loginTitle => 'Pudim’e giriş yap';

  @override
  String get loginSubtitle => 'Jellyfin hesabını kullan.';

  @override
  String get loginUsername => 'Kullanıcı adı';

  @override
  String get loginPassword => 'Parola';

  @override
  String get loginShowPassword => 'Parolayı göster';

  @override
  String get loginHidePassword => 'Parolayı gizle';

  @override
  String get loginSubmit => 'Giriş yap';

  @override
  String get loginQuickConnect => 'Quick Connect ile giriş yap';

  @override
  String get loginHideAddresses => 'Adresleri gizle';

  @override
  String get loginServerAddress => 'Sunucu adresi';

  @override
  String get loginJellyfinServer => 'Jellyfin sunucusu';

  @override
  String get loginJellyfinServerExample => 'Örn. https://jellyfin.exemplo.com';

  @override
  String get loginLocalNetwork => 'Yerel ağda (isteğe bağlı)';

  @override
  String get loginLocalNetworkExample =>
      'Örn. http://192.168.0.10:8096. Yanıt verdiğinde uygulama ana adres yerine bunu kullanır.';

  @override
  String get loginExtrasServer => 'Ekstra sunucu (isteğe bağlı)';

  @override
  String get loginExtrasServerHint =>
      'Sohbet, Jam, Blend, karışımlar ve Geri Sarma özelliklerini açar. Yoksa boş bırak.';

  @override
  String get loginQcExpired => 'Kodun süresi doldu. Tekrar dene.';

  @override
  String get loginQcInstructions =>
      'Jellyfin’de zaten giriş yaptığın bir cihazda profilini aç, Quick Connect’e dokun ve bu kodu gir:';

  @override
  String get loginQcWaiting => 'Onay bekleniyor…';

  @override
  String get homeDownloadedOnDevice => 'Bu cihaza indirilenler';

  @override
  String get homeTabMusic => 'Müzik';

  @override
  String get homeMadeFor => 'Senin için hazırlandı';

  @override
  String get homeMixDiscoveries => 'Senin için yeni müzikler, her hafta';

  @override
  String get homeMixWeekly => 'Favorilerin ve benzer şarkılar, her hafta';

  @override
  String get homeMixRadar =>
      'Takip ettiğin sanatçılardan yeni çıkanlar, her Cuma';

  @override
  String get homeMixDaylist => 'Gün boyunca değişir';

  @override
  String get homeMixBlend => 'İkinizin zevki bir arada';

  @override
  String get homeMixAuto => 'Otomatik karışım';

  @override
  String get homeSpotifyPlaylists => 'Spotify çalma listelerin';

  @override
  String get homeFromSpotify => 'Spotify’dan';

  @override
  String get homeYourPlaylists => 'Çalma listelerin';

  @override
  String get homeTopAlbums => 'En çok dinlediğin albümler';

  @override
  String get homeTopArtists => 'Favori sanatçıların';

  @override
  String get homeRecentlyAdded => 'Son eklenenler';

  @override
  String get homeYourPodcasts => 'Podcast’lerin';

  @override
  String get homeRadiosTitle => 'Önerilen radyolar';

  @override
  String get homeRadiosSubtitle =>
      'Favori sanatçılarına göre kesintisiz müzik.';

  @override
  String get homeRadioBadge => 'RADYO';

  @override
  String homeRadioWith(String name) {
    return '$name ve benzer sanatçılarla';
  }

  @override
  String searchNoResults(String query) {
    return '\"$query\" için sonuç bulunamadı';
  }

  @override
  String get searchNoResultsHint =>
      'Yazımı kontrol et veya daha az ya da farklı kelimeler kullan.';

  @override
  String searchCatalogNoResponse(String error) {
    return 'Katalog yanıt vermedi: $error';
  }

  @override
  String get searchAlsoCatalog => 'Katalogda da aranıyor…';

  @override
  String searchLibraryOnly(String error) {
    return 'Yalnızca kitaplık: katalog yanıt vermedi ($error).';
  }

  @override
  String get searchTopResult => 'En iyi sonuç';

  @override
  String get searchSpotifyPlaylists => 'Spotify çalma listeleri';

  @override
  String get searchRecent => 'Son aramalar';

  @override
  String get searchClear => 'Temizle';

  @override
  String get searchBrowseAll => 'Tümüne göz at';

  @override
  String get searchHint => 'Ne dinlemek istersin?';

  @override
  String get albumDownloadedType => 'Albüm • bu cihaza indirildi';

  @override
  String albumSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count şarkı',
      one: '1 şarkı',
    );
    return '$_temp0, $total';
  }

  @override
  String get albumRemoveFromLibrary => 'Kitaplığından kaldır';

  @override
  String get albumSaveToLibrary => 'Kitaplığına kaydet';

  @override
  String albumMoreOptions(String name) {
    return '$name için daha fazla seçenek';
  }

  @override
  String albumDisc(int number) {
    return 'Disk $number';
  }

  @override
  String albumMoreFrom(String name) {
    return '$name sanatçısından daha fazlası';
  }

  @override
  String artistAlbumsInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Kitaplığında $count albüm',
      one: 'Kitaplığında 1 albüm',
    );
    return '$_temp0';
  }

  @override
  String artistPlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dinleme',
      one: '1 dinleme',
    );
    return '$_temp0';
  }

  @override
  String artistMoreOptions(String name) {
    return '$name için daha fazla seçenek';
  }

  @override
  String get artistPopular => 'Popüler';

  @override
  String get artistShowLess => 'Daha az göster';

  @override
  String get artistShowMore => 'Daha fazla gör';

  @override
  String get artistYouLiked => 'Beğendiklerin';

  @override
  String artistFrom(String name) {
    return '$name sanatçısından';
  }

  @override
  String get artistDiscography => 'Diskografi';

  @override
  String get artistPopularReleases => 'Popüler çıkışlar';

  @override
  String get artistSinglesEps => 'Single ve EP’ler';

  @override
  String get artistFansAlsoLike => 'Hayranlar bunları da beğeniyor';

  @override
  String get artistAppearsOn => 'Yer aldığı albümler';

  @override
  String get artistAbout => 'Hakkında';

  @override
  String get playlistOriginSpotify => 'Spotify’dan';

  @override
  String get playlistOriginMadeForYou => 'Senin için hazırlandı';

  @override
  String get playlistOriginAuto => 'Otomatik karışım';

  @override
  String get playlistDownloadedOnDevice => 'Bu cihaza indirildi';

  @override
  String get playlistOnDevice => 'Bu cihazda';

  @override
  String get playlistPlaysOffline => 'İnternet olmadan çalar.';

  @override
  String playlistPlaysOfflineDownloading(int count) {
    return 'İnternet olmadan çalar. $count tane daha indiriliyor…';
  }

  @override
  String playlistSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count şarkı',
      one: '1 şarkı',
    );
    return '$_temp0, $total';
  }

  @override
  String playlistMoreOptions(String name) {
    return '$name için daha fazla seçenek';
  }

  @override
  String get playlistSearchHint => 'Çalma listesinde ara';

  @override
  String get playlistEmpty => 'Henüz şarkı yok.';

  @override
  String get playlistErrNoPermission =>
      'Bu çalma listesini düzenleme iznin yok.';

  @override
  String playlistErrServer(String code) {
    return 'Sunucu isteği reddetti ($code).';
  }

  @override
  String get playlistErrNoResponse => 'yanıt yok';

  @override
  String get playlistDownloadFirst =>
      'Çalma listesine eklemek için önce şarkıyı indir';

  @override
  String get playlistAddTo => 'Çalma listesine ekle';

  @override
  String get playlistNew => 'Yeni çalma listesi';

  @override
  String playlistAddedTo(String name) {
    return '$name listesine eklendi';
  }

  @override
  String get playlistNameHint => 'Çalma listesi adı';

  @override
  String get playlistCreate => 'Oluştur';

  @override
  String playlistCreated(String name) {
    return '$name çalma listesi oluşturuldu';
  }

  @override
  String get playlistRemoved => 'Çalma listesinden kaldırıldı';

  @override
  String get playlistInviteTitle => 'Düzenlemeye davet et';

  @override
  String get playlistInviteSubtitle =>
      'Çalma listesini kitaplıklarında görür, şarkı ekleyip kaldırabilirler.';

  @override
  String get playlistInviteOwnerOnly =>
      'Yalnızca çalma listesini oluşturan davet edebilir';

  @override
  String playlistInvited(String who, String playlist) {
    return '$who artık $playlist listesini düzenleyebilir';
  }

  @override
  String playlistCollaborative(String members) {
    return 'Ortak · $members';
  }

  @override
  String get playlistSmartShuffleTooltip =>
      'Smart Shuffle: önerilerle karışık çalma';

  @override
  String get playlistSmartShuffleOn =>
      'Smart Shuffle açık: öneriler ✦ ile işaretlenir';

  @override
  String get playlistAddedToThis => 'Çalma listesine eklendi';

  @override
  String get playlistRecommendation => 'Smart Shuffle önerisi';

  @override
  String get playlistPutIn => 'Çalma listesine ekle';

  @override
  String get settingsSectionAccount => 'Hesap';

  @override
  String get settingsProfileSubtitle => 'Ad, kullanıcı adı ve parola';

  @override
  String settingsConnectedAt(String url) {
    return '$url adresine bağlı';
  }

  @override
  String get settingsSignOut => 'Çıkış yap';

  @override
  String get settingsSectionServer => 'Sunucu';

  @override
  String get settingsLocalNetwork => 'Yerel ağda';

  @override
  String get settingsServerNote =>
      'Jellyfin adreslerini değiştirmek için çıkış yap ve giriş ekranında \"Sunucu adresi\"ni aç.';

  @override
  String get settingsExtrasServer => 'Ekstra sunucu';

  @override
  String get settingsExtrasNotConfigured =>
      'Ayarlanmadı (sohbet, Jam, Blend, karışımlar ve Özet gizli kalır)';

  @override
  String get settingsConfigure => 'Ayarla';

  @override
  String get settingsChange => 'Değiştir';

  @override
  String get settingsSectionPlayback => 'Oynatma';

  @override
  String get settingsQualityWifi => 'Wi-Fi kalitesi';

  @override
  String get settingsQualityWifiSubtitle =>
      'Orijinal, dosyayı kitaplıktaki haliyle çalar.';

  @override
  String get settingsQualityMobile => 'Mobil veri kalitesi';

  @override
  String get settingsQualityMobileSubtitle =>
      'Daha düşük kalite daha az mobil veri harcar.';

  @override
  String get settingsQualityOriginal => 'Orijinal';

  @override
  String get settingsAppliesNextSong =>
      'Sonraki şarkıdan itibaren geçerli olur';

  @override
  String get settingsSectionAbout => 'Hakkında';

  @override
  String settingsBuild(int build) {
    return 'Sürüm $build';
  }

  @override
  String get settingsExtrasEmptyHint => 'Ekstraları kapatmak için boş bırak.';

  @override
  String get settingsAutoplay => 'Otomatik oynat';

  @override
  String get settingsAutoplaySubtitle =>
      'Sıra bittiğinde benzer şarkıları çalmaya devam eder (Jellyfin karışımı).';

  @override
  String get settingsNormalize => 'Ses seviyesini normalleştir';

  @override
  String get settingsNormalizeSubtitle =>
      'Jellyfin’in analizini kullanarak tüm şarkıları aynı ses seviyesinde çalar.';

  @override
  String get settingsScrobble => 'Scrobble';

  @override
  String get settingsLoading => 'Yükleniyor…';

  @override
  String get settingsLastfmNoKey =>
      'Ekstra sunucuda henüz bir Last.fm API anahtarı ayarlanmamış.';

  @override
  String settingsConnectedAs(String name) {
    return '$name olarak bağlı';
  }

  @override
  String get settingsLastfmConnectedSubtitle =>
      'Pudim’de dinlediğin her şey Last.fm profiline gider.';

  @override
  String get settingsDisconnect => 'Bağlantıyı kes';

  @override
  String get settingsLastfmAuthorize => 'Last.fm sayfasında yetkilendir';

  @override
  String get settingsLastfmAuthorizeSubtitle =>
      'Orada \"Yes, allow access\"e tıkladıktan sonra geri dön ve Bitti’ye dokun.';

  @override
  String get settingsFinish => 'Bitti';

  @override
  String get settingsLastfmConnected => 'Last.fm bağlandı';

  @override
  String get settingsLastfmScrobbleSubtitle =>
      'Dinlediğin her şarkıyı Last.fm hesabına kaydeder.';

  @override
  String get settingsConnect => 'Bağlan';

  @override
  String get sidebarOpenLibrary => 'Kitaplığını aç';

  @override
  String get sidebarCollapseLibrary => 'Kitaplığını daralt';

  @override
  String sidebarOnDeviceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count şarkı',
      one: '1 şarkı',
    );
    return 'Cihazda • $_temp0';
  }

  @override
  String sidebarPlaylistCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count şarkı',
      one: '1 şarkı',
    );
    return 'Çalma listesi • $_temp0';
  }

  @override
  String sidebarAlbumBy(String artist) {
    return 'Albüm • $artist';
  }

  @override
  String get sidebarSearchLibrary => 'Kitaplığında ara';

  @override
  String get sidebarSortBy => 'Sırala';

  @override
  String get sidebarSortRecents => 'Son kullanılanlar';

  @override
  String get sidebarSortAdded => 'Son eklenenler';

  @override
  String get sidebarSortAlpha => 'Alfabetik';

  @override
  String get sidebarSortCreator => 'Oluşturan';

  @override
  String get topBarSearchHint => 'Ne çalmak istersin?';

  @override
  String get topBarClearSearch => 'Arama alanını temizle';

  @override
  String get topBarBrowse => 'Göz at';

  @override
  String get topBarMenu => 'Menü';

  @override
  String get topBarLogoutAccount => 'Çıkış yap';

  @override
  String get topBarQuit => 'Pudim’den çık';

  @override
  String get topBarLogout => 'Çıkış yap';

  @override
  String get playerBarSmartShuffleOff => 'Smart Shuffle’ı kapat';

  @override
  String get playerBarSmartShuffleOn => 'Smart Shuffle’ı aç';

  @override
  String get playerBarShuffleOff => 'Karışık çalmayı kapat';

  @override
  String get playerBarShuffleOn => 'Karışık çalmayı aç';

  @override
  String get playerBarPlay => 'Çal';

  @override
  String get playerBarForward => 'Sonraki';

  @override
  String get playerBarRepeatOn => 'Tekrarı aç';

  @override
  String get playerBarRepeatOne => 'Tek şarkıyı tekrarla';

  @override
  String get playerBarRepeatOff => 'Tekrarı kapat';

  @override
  String get playerBarNowPlayingView => 'Çalan şarkı görünümü';

  @override
  String get playerBarLyrics => 'Sözler';

  @override
  String get playerBarUnmute => 'Sesi aç';

  @override
  String get playerBarMute => 'Sessize al';

  @override
  String get rightPanelNothingPlaying =>
      'Burada çalanı görmek için bir şey çal.';

  @override
  String get rightPanelLyricsPreview => 'Söz önizlemesi';

  @override
  String get rightPanelAboutArtist => 'Sanatçı hakkında';

  @override
  String get rightPanelNextUp => 'Sıradaki';

  @override
  String get rightPanelOpenQueue => 'Sırayı aç';

  @override
  String get rightPanelQueueEmptyTitle => 'Sıraya ekle';

  @override
  String get rightPanelQueueEmptyHint =>
      'Buraya eklemek için bir parçanın menüsünde \"Sıraya ekle\"ye tıkla';

  @override
  String get rightPanelNowPlaying => 'Şimdi çalıyor';

  @override
  String get rightPanelNextInQueue => 'Sıradaki';

  @override
  String rightPanelNextFrom(String name) {
    return 'Sıradaki kaynak: $name';
  }

  @override
  String get nowPlayingPlayingFrom => 'ÇALINAN KAYNAK';

  @override
  String get nowPlayingMoreOptions => 'Daha fazla seçenek';

  @override
  String get chatChats => 'Sohbetler';

  @override
  String chatYouSaid(String text) {
    return 'Sen: $text';
  }

  @override
  String get chatContacts => 'Kişiler';

  @override
  String get chatServerUnreachable => 'Ekstra sunucuya ulaşılamadı.';

  @override
  String get chatMessageHint => 'Mesaj';

  @override
  String chatJoinedJam(String title) {
    return '$title oturumuna katıldın';
  }

  @override
  String chatCouldNotPlay(String error) {
    return 'Çalınamadı: $error';
  }

  @override
  String get chatJamCardSubtitle => 'Birlikte dinle, aynı sıra';

  @override
  String get chatInJam => 'Jam’de';

  @override
  String get chatJoin => 'Katıl';

  @override
  String get chatNoOtherAccounts => 'Sunucuda başka hesap yok.';

  @override
  String chatSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count şarkı',
      one: '1 şarkı',
    );
    return '$_temp0';
  }

  @override
  String chatSentTo(String name) {
    return '$name kişisine gönderildi';
  }

  @override
  String chatShareTitle(String title) {
    return '$title paylaş';
  }

  @override
  String get chatNoteHint => 'Not (isteğe bağlı)';

  @override
  String get blendWorking => 'Karıştırılıyor…';

  @override
  String blendAffinityButton(int affinity) {
    return 'Blend %$affinity';
  }

  @override
  String get blendCreate => 'Blend oluştur';

  @override
  String blendWith(String name) {
    return '$name ile Blend';
  }

  @override
  String get blendExplain =>
      'İkiniz için tek bir çalma listesi: ikinizin de dinledikleri, ortak sanatçılarınız ve her birinizin en çok sevdiklerinden biraz. Zevklerinizin ne kadar uyuştuğunu gösterir ve her gün güncellenir.';

  @override
  String get blendNotNow => 'Şimdi değil';

  @override
  String blendAffinityTitle(int affinity) {
    return '%$affinity uyumunuz var';
  }

  @override
  String blendInCommon(String artists) {
    return 'Ortak: $artists';
  }

  @override
  String blendOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Blend’i aç ($count şarkı)',
      one: 'Blend’i aç (1 şarkı)',
    );
    return '$_temp0';
  }

  @override
  String get blendRefreshNow => 'Şimdi yenile';

  @override
  String get blendUndo => 'Blend’i kaldır';

  @override
  String get blendRefreshing => 'Blend yenileniyor…';

  @override
  String get blendUndoTitle => 'Blend kaldırılsın mı?';

  @override
  String blendUndoBody(String name) {
    return 'Çalma listesi senin ve $name için kaybolacak.';
  }

  @override
  String get blendUndoConfirm => 'Kaldır';

  @override
  String get blendUndone => 'Blend kaldırıldı';

  @override
  String get jamStart => 'Jam başlat';

  @override
  String jamTooltip(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jam ($count kişi)',
      one: 'Jam (1 kişi)',
    );
    return '$_temp0';
  }

  @override
  String get jamSubIdle => 'Diğer hesaplarla aynı sırada birlikte dinle.';

  @override
  String get jamSubHost => 'Kontrol sende. Herkes şarkı isteyebilir.';

  @override
  String get jamSubGuest =>
      'Kontrollerin ve şarkıların herkesin sırasına gider.';

  @override
  String get jamPlayFirst => 'Jam’i başlatmadan önce bir şey çal.';

  @override
  String jamMembers(int count) {
    return 'Jam’de ($count)';
  }

  @override
  String jamYouSuffix(String name) {
    return '$name (sen)';
  }

  @override
  String get jamHost => 'Sahibi';

  @override
  String get jamInvite => 'Davet et';

  @override
  String get jamInviteTitle => 'Jam’e davet et';

  @override
  String get jamInviteSubtitle => 'Davet sohbetlerine gelir.';

  @override
  String jamInviteSent(String name) {
    return '$name kişisine davet gönderildi';
  }

  @override
  String get jamEnd => 'Jam’i bitir';

  @override
  String get jamLeave => 'Jam’den ayrıl';

  @override
  String recapTitle(int year) {
    return '$year Özetin';
  }

  @override
  String get recapShort => 'Özet';

  @override
  String recapBannerBody(String minutes) {
    return 'Bu yıl $minutes dakika müzik. En çok neleri çaldığına bak.';
  }

  @override
  String get recapEmpty => 'Özetini oluşturmak için henüz dinleme yok.';

  @override
  String get recapShareCards => 'Kartları paylaş';

  @override
  String get recapBigMinutes => 'dakika dinlendi';

  @override
  String get recapBigSongs => 'farklı şarkı';

  @override
  String get recapBigArtists => 'sanatçı';

  @override
  String get recapBigDays => 'müzikli gün';

  @override
  String get recapBigStreak => 'gün üst üste, rekorun';

  @override
  String get recapTopArtists => 'Yılın en çok dinlediğin sanatçıları';

  @override
  String recapMinutesValue(String minutes) {
    return '$minutes dakika';
  }

  @override
  String get recapTopSongs => 'Yılın en çok dinlediğin şarkıları';

  @override
  String recapPlaysLine(String artist, String plays) {
    return '$artist • $plays dinleme';
  }

  @override
  String get recapSongGone => 'Bu şarkı artık kitaplıkta yok';

  @override
  String get recapTopAlbums => 'Yılın en çok dinlediğin albümleri';

  @override
  String get recapTopGenres => 'En çok dinlediğin türler';

  @override
  String recapGenreLine(String genre, String minutes) {
    return '$genre • $minutes dk';
  }

  @override
  String get recapMonthly => 'Ay ay';

  @override
  String recapMonthTooltip(String month, String minutes) {
    return '$month: $minutes dk';
  }

  @override
  String get recapListeningStyle => 'Nasıl dinliyorsun';

  @override
  String recapFavHour(String hour) {
    return 'Favori saat: $hour:00';
  }

  @override
  String recapFavWeekday(String day) {
    return 'Haftanın favori günü: $day';
  }

  @override
  String recapBiggestDay(String date, String minutes) {
    return 'En yoğun günün: $date, $minutes dakika';
  }

  @override
  String recapNewArtists(int count, String n) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Senin için $n yeni sanatçı',
      one: 'Senin için $n yeni sanatçı',
    );
    return '$_temp0';
  }

  @override
  String recapSpotifyAdded(String added) {
    return '$added Spotify dinlemesi eklendi.';
  }

  @override
  String recapSpotifyAddedDup(String added, String dup) {
    return '$added Spotify dinlemesi eklendi ($dup tanesi Pudim’den zaten vardı).';
  }

  @override
  String get recapSpotifyRemoveTitle => 'Spotify geçmişin kaldırılsın mı?';

  @override
  String get recapSpotifyRemoveBody =>
      'Özetin yalnızca Pudim/Jellyfin’de çaldıklarını saymaya geri dönecek. Daha sonra tekrar içe aktarabilirsin.';

  @override
  String get recapSpotifyRemoveConfirm => 'Kaldır';

  @override
  String recapSpotifyRemoved(String count) {
    return '$count Spotify dinlemesi kaldırıldı';
  }

  @override
  String get recapSpotifyTitle => 'Spotify geçmişi';

  @override
  String recapSpotifyHasData(String count, String from, String to) {
    return 'Özetinde $count Spotify dinlemesi var ($from – $to). Daha yeni bir dosya yükleyebilirsin: zaten eklenenler iki kez sayılmaz.';
  }

  @override
  String get recapSpotifyIntro =>
      'Pudim öncesi yılları da getir. Spotify’da Hesap > Gizlilik > Verilerini indir bölümüne git ve \"Extended streaming history\"yi seç. E-posta geldiğinde my_spotify_data.zip dosyasını burada seç.';

  @override
  String get recapSpotifyImportAnother => 'Başka bir dosya içe aktar';

  @override
  String get recapSpotifyImport => 'Geçmişi içe aktar';

  @override
  String get recapSpotifyRemoveBtn => 'Özetten kaldır';

  @override
  String get recapShareSaveDialog => 'Kartı kaydet';

  @override
  String get recapShareSaved => 'Kart kaydedildi';

  @override
  String recapShareSaveFailed(String error) {
    return 'Kaydedilemedi: $error';
  }

  @override
  String recapShareShareFailed(String error) {
    return 'Paylaşılamadı: $error';
  }

  @override
  String recapShareText(int year) {
    return 'Pudim’de $year Özetim';
  }

  @override
  String get recapShareMyArtists => 'Yılın en çok dinlediğim sanatçılar';

  @override
  String get recapShareMySongs => 'Yılın en çok dinlediğim şarkılar';

  @override
  String recapMinShort(String minutes) {
    return '$minutes dk';
  }

  @override
  String get recapShareSaveImage => 'Görseli kaydet';

  @override
  String get recapShareButton => 'Paylaş';

  @override
  String recapBrand(int year) {
    return 'Özet $year';
  }

  @override
  String get recapShareMyYear => 'Müzikle geçen yılım';

  @override
  String recapShareYearOf(String name) {
    return '$name kişisinin müzikle geçen yılı';
  }

  @override
  String get recapShareTopArtist => 'yılın en çok dinlediğim sanatçısı';

  @override
  String recapShareGenres(String genres) {
    return 'Türler: $genres';
  }

  @override
  String get widgetActionsAddedToLiked => 'Beğenilen Şarkılar’a eklendi';

  @override
  String get widgetActionsRemovedFromLiked =>
      'Beğenilen Şarkılar’dan kaldırıldı';

  @override
  String get widgetActionsUnfollowed => 'Takipten çıkıldı';

  @override
  String get widgetActionsSavedToLibrary => 'Kitaplığına kaydedildi';

  @override
  String get widgetActionsRemovedFromLibrary => 'Kitaplığından kaldırıldı';

  @override
  String get widgetActionsAddToQueue => 'Sıraya ekle';

  @override
  String get widgetActionsAddedToQueue => 'Sıraya eklendi';

  @override
  String get widgetActionsPlayNext => 'Sonra çal';

  @override
  String get widgetActionsGoToPodcast => 'Podcast’e git';

  @override
  String get widgetActionsRemoveFromQueue => 'Sıradan kaldır';

  @override
  String get widgetActionsAddToPlaylist => 'Çalma listesine ekle';

  @override
  String get widgetActionsRemoveFromThisPlaylist =>
      'Bu çalma listesinden kaldır';

  @override
  String get widgetActionsInviteToEdit => 'Düzenlemeye davet et';

  @override
  String get widgetActionsKeepInPlaylist => 'Çalma listesinde tut';

  @override
  String get widgetActionsDownloadTrack => 'Şarkıyı indir';

  @override
  String get widgetActionsDownloadAlbum => 'Albümü indir';

  @override
  String get widgetActionsDownloadDiscography => 'Diskografiyi indir';

  @override
  String get widgetActionsSearchAlbums => 'Albüm bul';

  @override
  String widgetActionsImproveQuality(int count) {
    return 'Kaliteyi artır ($count)';
  }

  @override
  String widgetActionsImprovingAlbums(int count) {
    return '$count albümün daha iyi sürümleri aranıyor';
  }

  @override
  String get widgetActionsShare => 'Paylaş';

  @override
  String get widgetActionsSearchFlac => 'FLAC olarak bul';

  @override
  String widgetActionsSearchingFlac(String name) {
    return '$name FLAC olarak aranıyor; bulunursa MP3’ün yerini alır';
  }

  @override
  String get widgetActionsTrackRemovedFromDevice => 'Cihazdan kaldırıldı';

  @override
  String get widgetActionsRemovedFromDevice => 'Cihazdan kaldırıldı';

  @override
  String get widgetActionsDownloadingToDevice =>
      'Çevrimdışı dinlemek için cihazına indiriliyor';

  @override
  String get widgetActionsUnfollow => 'Takibi bırak';

  @override
  String get widgetActionsRemoveFromLibrary => 'Kitaplığından kaldır';

  @override
  String get widgetActionsAddToLibrary => 'Kitaplığına ekle';

  @override
  String get widgetActionsGoToSongRadio => 'Şarkı radyosuna git';

  @override
  String get widgetActionsStartMix => 'Karışımı başlat';

  @override
  String widgetActionsMixOf(String name) {
    return '$name Karışımı';
  }

  @override
  String get widgetActionsGoToArtist => 'Sanatçıya git';

  @override
  String get widgetActionsGoToAlbum => 'Albüme git';

  @override
  String get widgetActionsCopyName => 'Adı kopyala';

  @override
  String get widgetActionsCopied => 'Kopyalandı';

  @override
  String widgetDownloadsBellDownloading(int count) {
    return '$count indiriliyor';
  }

  @override
  String get widgetDownloadsBellEmpty =>
      'Burada henüz bir şey yok. Bulut simgeli bir şarkıyı çal veya ⋯ menüsündeki \"İndir\"i kullanarak katalogdan kitaplığına getir.';

  @override
  String get widgetDownloadsBellKindDiscography => 'Diskografi';

  @override
  String get widgetDownloadsBellKindFlac => 'FLAC olarak';

  @override
  String get widgetDownloadsBellKindQuality => 'Kalite';

  @override
  String get widgetDownloadsBellOptions => 'Seçenekler';

  @override
  String get widgetDownloadsBellCancelled => 'İndirme iptal edildi';

  @override
  String get widgetDownloadsBellRetrying => 'Tekrar deneniyor';

  @override
  String get widgetDownloadsBellRemovedFromList => 'Listeden kaldırıldı';

  @override
  String get widgetDownloadsBellDetails => 'Ayrıntıları gör';

  @override
  String get widgetDownloadsBellRemoveFromList => 'Listeden kaldır';

  @override
  String get widgetMixSearchingReleases => 'Yeni çıkışlar aranıyor…';

  @override
  String get widgetMixBuildingDaylist => 'Günlük listen oluşturuluyor…';

  @override
  String get widgetMixNewDiscoveriesTitle => 'Yeni Haftalık Keşifler?';

  @override
  String get widgetMixNewMixTitle => 'Yeni Haftalık Karışım?';

  @override
  String get widgetMixNewDiscoveriesBody =>
      'Henüz dinlemediğin şarkılar listeden çıkar ve yaklaşık 30 yenisi gelmeye başlar. Bu zaten her Pazartesi kendiliğinden olur.';

  @override
  String get widgetMixNewMixBody =>
      'Favorilerinle, en çok dinlediklerinle ve benzer şarkılarla yeniden oluşturur. Bu zaten her Pazartesi kendiliğinden olur.';

  @override
  String get widgetMixNotNow => 'Şimdi değil';

  @override
  String get widgetMixBuildingDiscoveries => 'Keşifların oluşturuluyor…';

  @override
  String get widgetMixBuildingMix => 'Karışımın oluşturuluyor…';

  @override
  String widgetMixBuiltOn(String date) {
    return '$date tarihinde oluşturuldu';
  }

  @override
  String get widgetMixRedo => 'Yeniden oluştur';

  @override
  String get widgetMixRefresh => 'Yenile';

  @override
  String get widgetMixCreateDiscoveries => 'Haftalık Keşiflerini oluştur';

  @override
  String get widgetMixCreateMix => 'Haftalık Karışımını oluştur';

  @override
  String get widgetMixCreateRadar => 'Yeni Çıkışlar Radarını oluştur';

  @override
  String get widgetMixCreateDaylist => 'Günlük listeni oluştur';

  @override
  String get widgetOfflineBanner =>
      'İnternet yok · cihazına kaydedilenler gösteriliyor';

  @override
  String widgetOfflineDownloadingProgress(int done, int total) {
    return '$done/$total indiriliyor';
  }

  @override
  String get widgetUpdateReady => 'Pudim’in yeni sürümü hazır';

  @override
  String widgetUpdateReadyNotes(String notes) {
    return 'Pudim’in yeni sürümü · $notes';
  }

  @override
  String get widgetUpdateAction => 'Güncelle';

  @override
  String widgetSleepShortMinutes(int count) {
    return '$count dk';
  }

  @override
  String widgetSleepShortSeconds(int count) {
    return '$count sn';
  }

  @override
  String get widgetSleepStopsAtEnd => 'Şarkı bitince durur';

  @override
  String widgetSleepStopsIn(String time) {
    return '$time sonra durur';
  }

  @override
  String get widgetSleepTimer => 'Uyku zamanlayıcısı';

  @override
  String get widgetSleepTurnOff => 'Zamanlayıcıyı kapat';

  @override
  String get widgetSleepOneHour => '1 saat';

  @override
  String get widgetSleepOneAndHalfHours => '1 saat 30 dakika';

  @override
  String get widgetSleepEndOfSong => 'Şarkı sonu';

  @override
  String get widgetSleepTurnedOff => 'Zamanlayıcı kapatıldı';

  @override
  String get widgetSleepStopsWhenSongEnds => 'Bu şarkı bitince müzik durur';

  @override
  String widgetSleepSongStopsIn(String time) {
    return 'Müzik $time sonra durur';
  }

  @override
  String get widgetSpeedPodcast => 'Podcast hızı';

  @override
  String get widgetCommonCatalogBadge => 'Katalogdan: henüz kitaplığında değil';

  @override
  String get widgetCommonShowAll => 'Tümünü göster';

  @override
  String get widgetCommonSomethingWentWrong => 'Bir şeyler ters gitti';

  @override
  String get widgetCommonListenDownloaded => 'İndirilen şarkıları dinle';

  @override
  String get widgetTracksTitle => 'Başlık';

  @override
  String get widgetTracksDateAdded => 'Eklenme tarihi';

  @override
  String widgetTracksAddedBy(String name) {
    return '$name tarafından';
  }

  @override
  String get widgetTracksMoreOptions => 'Daha fazla seçenek';

  @override
  String widgetTracksAddedDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }
}
