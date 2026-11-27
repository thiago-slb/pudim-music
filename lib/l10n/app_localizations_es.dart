// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class L10nEs extends L10n {
  L10nEs([String locale = 'es']) : super(locale);

  @override
  String get languageTitle => 'Idioma';

  @override
  String get languageSubtitle => 'Idioma de la interfaz';

  @override
  String get languageSystem => 'Predeterminado del sistema';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonClose => 'Cerrar';

  @override
  String get commonBack => 'Volver';

  @override
  String get commonSave => 'Guardar';

  @override
  String get commonEdit => 'Editar';

  @override
  String get commonDelete => 'Eliminar';

  @override
  String get commonRemove => 'Quitar';

  @override
  String get commonOk => 'Aceptar';

  @override
  String get commonRetry => 'Reintentar';

  @override
  String get commonQueue => 'Cola';

  @override
  String get commonAlbum => 'Álbum';

  @override
  String get commonAlbums => 'Álbumes';

  @override
  String get commonArtist => 'Artista';

  @override
  String get commonArtists => 'Artistas';

  @override
  String get commonSong => 'Canción';

  @override
  String get commonSongs => 'Canciones';

  @override
  String get commonPlaylist => 'Playlist';

  @override
  String get commonPlaylists => 'Playlists';

  @override
  String get commonSingle => 'Sencillo';

  @override
  String get commonLikedSongs => 'Canciones que te gustan';

  @override
  String get commonAddToLiked => 'Añadir a Canciones que te gustan';

  @override
  String get commonRemoveFromLiked => 'Quitar de Canciones que te gustan';

  @override
  String get commonShufflePlay => 'Reproducir en aleatorio';

  @override
  String get commonPlay => 'Reproducir';

  @override
  String get commonPause => 'Pausar';

  @override
  String get commonFollow => 'Seguir';

  @override
  String get commonFollowing => 'Siguiendo';

  @override
  String get commonDownloadToDevice => 'Descargar en el dispositivo';

  @override
  String get commonRemoveFromDevice => 'Quitar del dispositivo';

  @override
  String get commonDownloaded => 'Descargadas';

  @override
  String get commonDownloads => 'Descargas';

  @override
  String get commonAll => 'Todo';

  @override
  String get commonRecentlyPlayed => 'Escuchado recientemente';

  @override
  String get commonYourLibrary => 'Tu biblioteca';

  @override
  String get commonHome => 'Inicio';

  @override
  String get commonSearch => 'Buscar';

  @override
  String get commonProfile => 'Perfil';

  @override
  String get commonSettings => 'Ajustes';

  @override
  String get commonBuilding => 'Creando…';

  @override
  String get commonBuildNow => 'Crear ahora';

  @override
  String get commonShows => 'Conciertos';

  @override
  String get commonPodcasts => 'Pódcasts';

  @override
  String commonSongCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count canciones',
      one: '1 canción',
      zero: 'Ninguna canción',
    );
    return '$_temp0';
  }

  @override
  String commonMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutos',
      one: '1 minuto',
    );
    return '$_temp0';
  }

  @override
  String commonError(String error) {
    return 'Error: $error';
  }

  @override
  String get apiStatusQueued => 'En cola';

  @override
  String get apiStatusDownloading => 'Descargando';

  @override
  String get apiStatusDone => 'Llegó a la biblioteca';

  @override
  String get apiStatusUpToDate => 'Ya estaba en la biblioteca';

  @override
  String get apiStatusPartial => 'Llegó en parte';

  @override
  String get apiStatusNotFound => 'No encontrado';

  @override
  String get apiStatusCancelled => 'Cancelado';

  @override
  String get apiStatusInterrupted => 'Interrumpido';

  @override
  String get apiStatusFailed => 'Falló';

  @override
  String get apiExtrasNoResponse => 'El servidor de extras no respondió.';

  @override
  String get apiAlbumListFailed => 'No pude listar los álbumes.';

  @override
  String apiPlaylistSaved(int found, int total) {
    return 'Playlist en Tu biblioteca ($found de $total canciones)';
  }

  @override
  String apiPlaylistDownloading(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count canciones más',
      one: '1 canción más',
    );
    return 'Playlist en Tu biblioteca; descargando $_temp0';
  }

  @override
  String get apiBadCredentials => 'Usuario o contraseña incorrectos.';

  @override
  String get apiServerUnreachable => 'No pude comunicarme con el servidor.';

  @override
  String get apiQuickConnectOff =>
      'Quick Connect está desactivado en este servidor.';

  @override
  String get apiWrongCurrentPassword => 'La contraseña actual no coincide.';

  @override
  String stateChatShared(String title) {
    return 'Compartió $title';
  }

  @override
  String stateDownloadingName(String name) {
    return 'Descargando $name';
  }

  @override
  String stateDownloadingRequests(int count) {
    return 'Descargando $count pedidos';
  }

  @override
  String stateDownloadArrived(String name) {
    return '$name llegó a la biblioteca';
  }

  @override
  String stateDownloadPartial(String name) {
    return '$name llegó en parte';
  }

  @override
  String stateDownloadEnded(String name, String status) {
    return '$name: $status';
  }

  @override
  String get stateNotFromCatalog => 'Este elemento no viene del catálogo.';

  @override
  String stateAlreadyDownloading(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'El álbum ya se está descargando.',
      'artist': 'La discografía ya se está descargando.',
      'other': 'La canción ya se está descargando.',
    });
    return '$_temp0';
  }

  @override
  String stateDownloadRequested(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Descargando el álbum. Aparecerá en la campana cuando llegue.',
      'artist':
          'Descargando la discografía. Aparecerá en la campana cuando llegue.',
      'other': 'Descargando la canción. Aparecerá en la campana cuando llegue.',
    });
    return '$_temp0';
  }

  @override
  String get stateNotifyDownloadsChannel => 'Descargas';

  @override
  String get stateNotifyDownloadsChannelDesc =>
      'Progreso de las canciones que se descargan';

  @override
  String get stateNotifyNewsChannel => 'Novedades';

  @override
  String get stateNotifyNewsChannelDesc =>
      'Canciones que llegaron, lanzamientos, Descobertas y Mistura';

  @override
  String get stateOfflineLoose => 'Descargadas una a una';

  @override
  String get stateOfflineDoneTitle => 'Descargadas en el dispositivo';

  @override
  String stateOfflineDoneBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count canciones listas para escuchar sin internet',
      one: '1 canción lista para escuchar sin internet',
    );
    return '$_temp0';
  }

  @override
  String get stateOfflineProgressTitle => 'Descargando en el dispositivo';

  @override
  String stateOfflineProgressBody(int done, int total, String name) {
    return '$done de $total • $name';
  }

  @override
  String get stateServerNoReply =>
      'El servidor no respondió. Revisa la dirección.';

  @override
  String get stateServerNoReplyBoth =>
      'El servidor no respondió en ninguna de las dos direcciones.';

  @override
  String get stateTokenStoreUnsupported =>
      'Por ahora Pudim solo guarda el inicio de sesión en Windows y Android.';

  @override
  String get stateQualityPoor => 'sonido débil';

  @override
  String get stateQualityPartial => 'incompleto';

  @override
  String get audioPlaybackChannel => 'Reproducción';

  @override
  String get audioRecentAlbums => 'Álbumes recientes';

  @override
  String audioSearchContext(String query) {
    return 'Búsqueda: $query';
  }

  @override
  String audioRadioContext(String name) {
    return 'Radio de $name';
  }

  @override
  String podcastsMonthShort(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': 'ene',
      'm2': 'feb',
      'm3': 'mar',
      'm4': 'abr',
      'm5': 'may',
      'm6': 'jun',
      'm7': 'jul',
      'm8': 'ago',
      'm9': 'sep',
      'm10': 'oct',
      'm11': 'nov',
      'other': 'dic',
    });
    return '$_temp0';
  }

  @override
  String podcastsDateThisYear(int day, String month) {
    return '$day de $month';
  }

  @override
  String podcastsDateOtherYear(int day, String month, int year) {
    return '$day de $month de $year';
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
  String get podcastsPlayed => 'escuchado';

  @override
  String podcastsTimeLeft(String time) {
    return 'faltan $time';
  }

  @override
  String get podcastsSearchHint => 'Buscar podcasts';

  @override
  String get podcastsNothingFound => 'No se encontró nada.';

  @override
  String get podcastsYours => 'Tus podcasts';

  @override
  String get podcastsNewEpisodes => 'Episodios nuevos';

  @override
  String get podcastsTrendingBrazil => 'Tendencias en Brasil';

  @override
  String get podcastsLoadFailed => 'No se cargó. Intentar de nuevo';

  @override
  String get podcastsNoEpisodes => 'No hay episodios en el feed.';

  @override
  String podcastsNoEpisodeMatch(String q) {
    return 'Ningún episodio con \"$q\".';
  }

  @override
  String get podcastsKind => 'Podcast';

  @override
  String get podcastsEpisodes => 'Episodios';

  @override
  String podcastsEpisodesCount(int total) {
    return 'Episodios ($total)';
  }

  @override
  String get podcastsFindEpisode => 'Buscar episodio';

  @override
  String showsMonthName(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': 'enero',
      'm2': 'febrero',
      'm3': 'marzo',
      'm4': 'abril',
      'm5': 'mayo',
      'm6': 'junio',
      'm7': 'julio',
      'm8': 'agosto',
      'm9': 'septiembre',
      'm10': 'octubre',
      'm11': 'noviembre',
      'other': 'diciembre',
    });
    return '$_temp0';
  }

  @override
  String showsMonthYear(String month, int year) {
    return '$month de $year';
  }

  @override
  String showsWeekdayShort(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'w1': 'lun',
      'w2': 'mar',
      'w3': 'mié',
      'w4': 'jue',
      'w5': 'vie',
      'w6': 'sáb',
      'other': 'dom',
    });
    return '$_temp0';
  }

  @override
  String get showsFollowingNone => 'De los artistas que sigues';

  @override
  String showsFollowingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'De los $count artistas que sigues',
      one: 'Del 1 artista que sigues',
    );
    return '$_temp0';
  }

  @override
  String showsSearchingFor(int count) {
    return 'buscando conciertos de $count…';
  }

  @override
  String get showsUpcoming => 'Próximos';

  @override
  String get showsPast => 'Ya ocurridos';

  @override
  String get showsInBrazil => 'En Brasil';

  @override
  String get showsEmptyFollow =>
      'Sigue artistas (botón Seguir en la página del artista) para ver sus conciertos aquí.';

  @override
  String get showsNonePast => 'Aún no hay conciertos registrados.';

  @override
  String get showsNoneUpcoming => 'No hay conciertos programados por ahora.';

  @override
  String get showsStillSearching => 'Aún buscando…';

  @override
  String get showsSource =>
      'Fechas de MusicBrainz (hecho por fans); los conciertos nuevos pueden tardar en aparecer.';

  @override
  String get showsCancelled => 'cancelado';

  @override
  String get showsFestival => 'festival';

  @override
  String get catalogKindAlbum => 'Álbum';

  @override
  String get catalogKindSingle => 'Sencillo';

  @override
  String get catalogKindBroadcast => 'Transmisión';

  @override
  String get catalogKindOther => 'Otro';

  @override
  String get catalogSecLive => 'en vivo';

  @override
  String get catalogSecCompilation => 'recopilatorio';

  @override
  String get catalogSecSoundtrack => 'banda sonora';

  @override
  String get catalogSecMixtape => 'mixtape';

  @override
  String get catalogSecInterview => 'entrevista';

  @override
  String get catalogSecSpokenword => 'palabra hablada';

  @override
  String catalogDownloadingOne(String title) {
    return 'Descargando $title';
  }

  @override
  String catalogDownloadingMany(int count, String artist) {
    return 'Descargando $count álbumes de $artist';
  }

  @override
  String catalogCheckingDiscography(int seconds) {
    return 'Revisando la discografía… ${seconds}s';
  }

  @override
  String catalogToDownload(int count) {
    return '$count para descargar';
  }

  @override
  String catalogInLibraryCount(int count) {
    return '$count ya en la biblioteca';
  }

  @override
  String catalogSkippedOneSong(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de 1 canción quedan fuera',
      one: '1 de 1 canción queda fuera',
    );
    return '$_temp0';
  }

  @override
  String get catalogPickAll => 'Todos';

  @override
  String get catalogPickStudio => 'Estudio';

  @override
  String get catalogPickNone => 'Ninguno';

  @override
  String get catalogDownloadSelected => 'Descargar seleccionados';

  @override
  String catalogDownloadNSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Descargar $count seleccionados',
      one: 'Descargar 1 seleccionado',
    );
    return '$_temp0';
  }

  @override
  String get catalogNothingMissing => 'No falta nada.';

  @override
  String get catalogPartial => 'parcial';

  @override
  String get catalogDownload => 'Descargar';

  @override
  String get catalogAddToLibrary => 'Añadir a Tu biblioteca';

  @override
  String get catalogInYourLibrary => 'En Tu biblioteca';

  @override
  String get catalogAllInLibrary => 'todo en la biblioteca';

  @override
  String catalogNInLibrary(int count) {
    return '$count en la biblioteca';
  }

  @override
  String get catalogDownloadAlbum => 'Descargar álbum';

  @override
  String get catalogArtistNotFound => 'Artista no encontrado.';

  @override
  String get catalogFromCatalog => 'Del catálogo: aún no está en la biblioteca';

  @override
  String get catalogDownloadAll => 'Descargar todo';

  @override
  String get catalogDownloadDiscography => 'Descargar discografía';

  @override
  String get catalogPopular => 'Populares';

  @override
  String get catalogShowLess => 'Mostrar menos';

  @override
  String get catalogShowMore => 'Ver más';

  @override
  String get catalogSinglesEps => 'Sencillos y EPs';

  @override
  String get catalogFansAlsoLike => 'A los fans también les gusta';

  @override
  String get lyricsPlaySomething => 'Reproduce algo para ver la letra.';

  @override
  String get lyricsNone => 'No hay letra para esta canción';

  @override
  String get lyricsNoneHint =>
      'Cuando haya un .lrc o .txt junto al archivo, aparecerá aquí.';

  @override
  String get lyricsFind => 'Buscar letra';

  @override
  String get lyricsFinding => 'Buscando la letra…';

  @override
  String get lyricsNotFound => 'No se encontró la letra de esta canción';

  @override
  String get lyricsSynced => 'Letra sincronizada del archivo .lrc';

  @override
  String get lyricsUnsynced => 'Letra sin sincronizar';

  @override
  String get profileChangePhoto => 'Cambiar foto';

  @override
  String get profileNoPhoto => 'No se eligió ninguna foto';

  @override
  String get profilePhotoTooBig => 'Foto demasiado grande (hasta 8 MB)';

  @override
  String get profilePhotoChanged => 'Foto de perfil cambiada';

  @override
  String get profilePhotoRemoved => 'Foto eliminada';

  @override
  String get profileNameSaved => 'Nombre del perfil guardado';

  @override
  String get profileRenameTitle => '¿Cambiar el nombre de usuario?';

  @override
  String profileRenameBody(String name) {
    return 'Entrarás como \"$name\" en Pudim, en Jellyfin y en las otras apps (Finamp, Feishin…). Tus Descubrimientos, Mezcla y Resumen del año se vienen contigo.';
  }

  @override
  String get profileRenameConfirm => 'Cambiar';

  @override
  String profileNowSignedAs(String name) {
    return 'Ahora entras como $name';
  }

  @override
  String get profileEnterNewPassword => 'Escribe la contraseña nueva';

  @override
  String get profilePasswordsDiffer => 'Las contraseñas nuevas no coinciden';

  @override
  String get profilePasswordChanged => 'Contraseña cambiada';

  @override
  String get profileExtrasUnreachable =>
      'No pude comunicarme con el servidor de extras; el nombre del perfil y el de usuario quedan para después.';

  @override
  String get profileNameSection => 'Nombre del perfil';

  @override
  String get profileNameHelp =>
      'Así te ven tus contactos en las conversaciones.';

  @override
  String get profileYourName => 'Tu nombre';

  @override
  String get profileUsernameSection => 'Nombre de usuario';

  @override
  String get profileUsernameHelp =>
      'El nombre para entrar en Jellyfin (aquí y en las otras apps).';

  @override
  String get profileUsernameHint => 'Usuario';

  @override
  String get profileChangeUsername => 'Cambiar usuario';

  @override
  String get profilePasswordSection => 'Contraseña';

  @override
  String get profileCurrentPassword => 'Contraseña actual';

  @override
  String get profileNewPassword => 'Contraseña nueva';

  @override
  String get profileRepeatPassword => 'Repite la contraseña nueva';

  @override
  String get profileChangePassword => 'Cambiar contraseña';

  @override
  String get loginServerRequired =>
      'Escribe la dirección de tu servidor Jellyfin.';

  @override
  String get loginUserRequired => 'Escribe tu nombre de usuario.';

  @override
  String get loginTitle => 'Iniciar sesión en Pudim';

  @override
  String get loginSubtitle => 'Usa tu cuenta de Jellyfin.';

  @override
  String get loginUsername => 'Nombre de usuario';

  @override
  String get loginPassword => 'Contraseña';

  @override
  String get loginShowPassword => 'Mostrar contraseña';

  @override
  String get loginHidePassword => 'Ocultar contraseña';

  @override
  String get loginSubmit => 'Entrar';

  @override
  String get loginQuickConnect => 'Entrar con Quick Connect';

  @override
  String get loginHideAddresses => 'Ocultar direcciones';

  @override
  String get loginServerAddress => 'Dirección del servidor';

  @override
  String get loginJellyfinServer => 'Servidor Jellyfin';

  @override
  String get loginJellyfinServerExample => 'Ej.: https://jellyfin.exemplo.com';

  @override
  String get loginLocalNetwork => 'En la red local (opcional)';

  @override
  String get loginLocalNetworkExample =>
      'Ej.: http://192.168.0.10:8096. Cuando responde, la app usa este en lugar del principal.';

  @override
  String get loginExtrasServer => 'Servidor de extras (opcional)';

  @override
  String get loginExtrasServerHint =>
      'Activa chat, Jam, Blend, mixes y Resumen del año. Déjalo vacío si no tienes.';

  @override
  String get loginQcExpired => 'El código expiró. Inténtalo de nuevo.';

  @override
  String get loginQcInstructions =>
      'En un dispositivo donde ya iniciaste sesión en Jellyfin, abre tu perfil, toca Quick Connect y escribe este código:';

  @override
  String get loginQcWaiting => 'Esperando la aprobación…';

  @override
  String get homeDownloadedOnDevice => 'Descargadas en el dispositivo';

  @override
  String get homeTabMusic => 'Música';

  @override
  String get homeMadeFor => 'Hecho para';

  @override
  String get homeMixDiscoveries => 'Música nueva para ti, cada semana';

  @override
  String get homeMixWeekly => 'Tus favoritas y otras parecidas, cada semana';

  @override
  String get homeMixRadar => 'Novedades de quienes sigues, cada viernes';

  @override
  String get homeMixDaylist => 'Cambia a lo largo del día';

  @override
  String get homeMixBlend => 'El gusto de los dos juntos';

  @override
  String get homeMixAuto => 'Mix automático';

  @override
  String get homeSpotifyPlaylists => 'Tus playlists de Spotify';

  @override
  String get homeFromSpotify => 'De Spotify';

  @override
  String get homeYourPlaylists => 'Tus playlists';

  @override
  String get homeTopAlbums => 'Tus álbumes más escuchados';

  @override
  String get homeTopArtists => 'Tus artistas favoritos';

  @override
  String get homeRecentlyAdded => 'Añadidos recientemente';

  @override
  String get homeYourPodcasts => 'Tus podcasts';

  @override
  String get homeRadiosTitle => 'Radios recomendadas';

  @override
  String get homeRadiosSubtitle =>
      'Música sin parar basada en tus artistas favoritos.';

  @override
  String get homeRadioBadge => 'RADIO';

  @override
  String homeRadioWith(String name) {
    return 'Con $name y artistas parecidos';
  }

  @override
  String searchNoResults(String query) {
    return 'No se encontraron resultados para \"$query\"';
  }

  @override
  String get searchNoResultsHint =>
      'Revisa la ortografía o usa menos palabras o palabras diferentes.';

  @override
  String searchCatalogNoResponse(String error) {
    return 'El catálogo no respondió: $error';
  }

  @override
  String get searchAlsoCatalog => 'Buscando también en el catálogo…';

  @override
  String searchLibraryOnly(String error) {
    return 'Solo la biblioteca: el catálogo no respondió ($error).';
  }

  @override
  String get searchTopResult => 'Mejor resultado';

  @override
  String get searchSpotifyPlaylists => 'Playlists de Spotify';

  @override
  String get searchRecent => 'Búsquedas recientes';

  @override
  String get searchClear => 'Borrar';

  @override
  String get searchBrowseAll => 'Explorar todo';

  @override
  String get searchHint => '¿Qué quieres escuchar?';

  @override
  String get albumDownloadedType => 'Álbum • descargado en el dispositivo';

  @override
  String albumSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count canciones',
      one: '1 canción',
    );
    return '$_temp0, $total';
  }

  @override
  String get albumRemoveFromLibrary => 'Quitar de Tu biblioteca';

  @override
  String get albumSaveToLibrary => 'Guardar en Tu biblioteca';

  @override
  String albumMoreOptions(String name) {
    return 'Más opciones para $name';
  }

  @override
  String albumDisc(int number) {
    return 'Disco $number';
  }

  @override
  String albumMoreFrom(String name) {
    return 'Más de $name';
  }

  @override
  String artistAlbumsInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count álbumes en la biblioteca',
      one: '1 álbum en la biblioteca',
    );
    return '$_temp0';
  }

  @override
  String artistPlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reproducciones',
      one: '1 reproducción',
    );
    return '$_temp0';
  }

  @override
  String artistMoreOptions(String name) {
    return 'Más opciones para $name';
  }

  @override
  String get artistPopular => 'Populares';

  @override
  String get artistShowLess => 'Mostrar menos';

  @override
  String get artistShowMore => 'Ver más';

  @override
  String get artistYouLiked => 'Te gustó';

  @override
  String artistFrom(String name) {
    return 'De $name';
  }

  @override
  String get artistDiscography => 'Discografía';

  @override
  String get artistPopularReleases => 'Lanzamientos populares';

  @override
  String get artistSinglesEps => 'Sencillos y EPs';

  @override
  String get artistFansAlsoLike => 'A los fans también les gusta';

  @override
  String get artistAppearsOn => 'Aparece en';

  @override
  String get artistAbout => 'Acerca de';

  @override
  String get playlistOriginSpotify => 'De Spotify';

  @override
  String get playlistOriginMadeForYou => 'Hecha para ti';

  @override
  String get playlistOriginAuto => 'Mix automático';

  @override
  String get playlistDownloadedOnDevice => 'Descargada en el dispositivo';

  @override
  String get playlistOnDevice => 'En el dispositivo';

  @override
  String get playlistPlaysOffline => 'Se reproducen sin internet.';

  @override
  String playlistPlaysOfflineDownloading(int count) {
    return 'Se reproducen sin internet. Descargando $count más…';
  }

  @override
  String playlistSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count canciones',
      one: '1 canción',
    );
    return '$_temp0, $total';
  }

  @override
  String playlistMoreOptions(String name) {
    return 'Más opciones para $name';
  }

  @override
  String get playlistSearchHint => 'Buscar en la playlist';

  @override
  String get playlistEmpty => 'Aún no hay canciones aquí.';

  @override
  String get playlistErrNoPermission =>
      'No tienes permiso para editar esta playlist.';

  @override
  String playlistErrServer(String code) {
    return 'El servidor no lo aceptó ($code).';
  }

  @override
  String get playlistErrNoResponse => 'sin respuesta';

  @override
  String get playlistDownloadFirst =>
      'Descarga la canción primero para añadirla a una playlist';

  @override
  String get playlistAddTo => 'Añadir a la playlist';

  @override
  String get playlistNew => 'Nueva playlist';

  @override
  String playlistAddedTo(String name) {
    return 'Añadida a $name';
  }

  @override
  String get playlistNameHint => 'Nombre de la playlist';

  @override
  String get playlistCreate => 'Crear';

  @override
  String playlistCreated(String name) {
    return 'Playlist $name creada';
  }

  @override
  String get playlistRemoved => 'Quitada de la playlist';

  @override
  String get playlistInviteTitle => 'Invitar a editar';

  @override
  String get playlistInviteSubtitle =>
      'La persona verá la playlist en su biblioteca y podrá añadir y quitar canciones.';

  @override
  String get playlistInviteOwnerOnly =>
      'Solo quien creó la playlist puede invitar';

  @override
  String playlistInvited(String who, String playlist) {
    return '$who ahora puede editar $playlist';
  }

  @override
  String playlistCollaborative(String members) {
    return 'Colaborativa · $members';
  }

  @override
  String get playlistSmartShuffleTooltip =>
      'Smart Shuffle: aleatorio con recomendaciones';

  @override
  String get playlistSmartShuffleOn =>
      'Smart Shuffle activado: las recomendaciones están marcadas con ✦';

  @override
  String get playlistAddedToThis => 'Añadida a la playlist';

  @override
  String get playlistRecommendation => 'Recomendación de Smart Shuffle';

  @override
  String get playlistPutIn => 'Añadir a la playlist';

  @override
  String get settingsSectionAccount => 'Cuenta';

  @override
  String get settingsProfileSubtitle => 'Nombre, usuario y contraseña';

  @override
  String settingsConnectedAt(String url) {
    return 'Conectado a $url';
  }

  @override
  String get settingsSignOut => 'Cerrar sesión';

  @override
  String get accountsTitle => 'Cuentas';

  @override
  String get accountsAdd => 'Añadir cuenta o servidor';

  @override
  String get accountsSwitch => 'Cambiar';

  @override
  String get accountsInUse => 'En uso';

  @override
  String accountsOn(String user, String host) {
    return '$user en $host';
  }

  @override
  String get loginBackToAccount => 'Volver a la cuenta actual';

  @override
  String get settingsSectionServer => 'Servidor';

  @override
  String get settingsLocalNetwork => 'En la red local';

  @override
  String get settingsServerNote =>
      'Para cambiar las direcciones de Jellyfin, cierra sesión y abre \"Dirección del servidor\" en la pantalla de inicio de sesión.';

  @override
  String get settingsExtrasServer => 'Servidor de extras';

  @override
  String get settingsExtrasNotConfigured =>
      'Sin configurar (el chat, Jam, Blend, los mixes y el Resumen quedan ocultos)';

  @override
  String get settingsConfigure => 'Configurar';

  @override
  String get settingsChange => 'Cambiar';

  @override
  String get settingsSectionPlayback => 'Reproducción';

  @override
  String get settingsQualityWifi => 'Calidad en Wi-Fi';

  @override
  String get settingsQualityWifiSubtitle =>
      'Original reproduce el archivo tal como está en la biblioteca.';

  @override
  String get settingsQualityMobile => 'Calidad con datos móviles';

  @override
  String get settingsQualityMobileSubtitle =>
      'Una calidad menor gasta menos datos móviles.';

  @override
  String get settingsQualityOriginal => 'Original';

  @override
  String get settingsAppliesNextSong => 'Se aplica desde la próxima canción';

  @override
  String get settingsSectionAbout => 'Acerca de';

  @override
  String settingsBuild(int build) {
    return 'Build $build';
  }

  @override
  String get settingsExtrasEmptyHint =>
      'Déjalo vacío para desactivar los extras.';

  @override
  String get settingsAutoplay => 'Reproducción automática';

  @override
  String get settingsAutoplaySubtitle =>
      'Cuando la cola termine, sigue reproduciendo canciones parecidas (mix de Jellyfin).';

  @override
  String get settingsNormalize => 'Normalizar el volumen';

  @override
  String get settingsNormalizeSubtitle =>
      'Deja todas las canciones al mismo volumen, con el análisis de Jellyfin.';

  @override
  String get settingsScrobble => 'Scrobble';

  @override
  String get settingsLoading => 'Cargando…';

  @override
  String get settingsLastfmNoKey =>
      'El servidor de extras aún no tiene configurada una clave de la API de Last.fm.';

  @override
  String settingsConnectedAs(String name) {
    return 'Conectado como $name';
  }

  @override
  String get settingsLastfmConnectedSubtitle =>
      'Todo lo que escuchas en Pudim va a tu perfil de Last.fm.';

  @override
  String get settingsDisconnect => 'Desconectar';

  @override
  String get settingsLastfmAuthorize => 'Autoriza en la página de Last.fm';

  @override
  String get settingsLastfmAuthorizeSubtitle =>
      'Después de hacer clic en \"Yes, allow access\" allí, vuelve y toca Listo.';

  @override
  String get settingsFinish => 'Listo';

  @override
  String get settingsLastfmConnected => 'Last.fm conectado';

  @override
  String get settingsLastfmScrobbleSubtitle =>
      'Registra en tu Last.fm cada canción que escuchas.';

  @override
  String get settingsConnect => 'Conectar';

  @override
  String get sidebarOpenLibrary => 'Abrir Tu biblioteca';

  @override
  String get sidebarCollapseLibrary => 'Contraer Tu biblioteca';

  @override
  String sidebarOnDeviceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count canciones',
      one: '1 canción',
    );
    return 'En el dispositivo • $_temp0';
  }

  @override
  String sidebarPlaylistCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count canciones',
      one: '1 canción',
    );
    return 'Lista • $_temp0';
  }

  @override
  String sidebarAlbumBy(String artist) {
    return 'Álbum • $artist';
  }

  @override
  String get sidebarSearchLibrary => 'Buscar en Tu biblioteca';

  @override
  String get sidebarSortBy => 'Ordenar por';

  @override
  String get sidebarSortRecents => 'Recientes';

  @override
  String get sidebarSortAdded => 'Agregados recientemente';

  @override
  String get sidebarSortAlpha => 'Alfabético';

  @override
  String get sidebarSortCreator => 'Creador';

  @override
  String get topBarSearchHint => '¿Qué quieres escuchar?';

  @override
  String get topBarClearSearch => 'Borrar campo de búsqueda';

  @override
  String get topBarBrowse => 'Explorar';

  @override
  String get topBarMenu => 'Menú';

  @override
  String get topBarLogoutAccount => 'Cerrar sesión';

  @override
  String get topBarQuit => 'Cerrar Pudim';

  @override
  String get topBarLogout => 'Salir';

  @override
  String get playerBarSmartShuffleOff => 'Desactivar Smart Shuffle';

  @override
  String get playerBarSmartShuffleOn => 'Activar Smart Shuffle';

  @override
  String get playerBarShuffleOff => 'Desactivar el modo aleatorio';

  @override
  String get playerBarShuffleOn => 'Activar el modo aleatorio';

  @override
  String get playerBarPlay => 'Reproducir';

  @override
  String get playerBarForward => 'Siguiente';

  @override
  String get playerBarRepeatOn => 'Activar repetición';

  @override
  String get playerBarRepeatOne => 'Activar repetición de una canción';

  @override
  String get playerBarRepeatOff => 'Desactivar repetición';

  @override
  String get playerBarNowPlayingView => 'Vista En reproducción';

  @override
  String get playerBarLyrics => 'Letra';

  @override
  String get playerBarUnmute => 'Activar sonido';

  @override
  String get playerBarMute => 'Silenciar';

  @override
  String get rightPanelNothingPlaying =>
      'Reproduce algo para ver aquí lo que está sonando.';

  @override
  String get rightPanelLyricsPreview => 'Vista previa de la letra';

  @override
  String get rightPanelAboutArtist => 'Acerca del artista';

  @override
  String get rightPanelNextUp => 'A continuación';

  @override
  String get rightPanelOpenQueue => 'Abrir cola';

  @override
  String get rightPanelQueueEmptyTitle => 'Agrega a la cola';

  @override
  String get rightPanelQueueEmptyHint =>
      'Haz clic en \"Agregar a la cola\" en el menú de una canción para incluirla aquí';

  @override
  String get rightPanelNowPlaying => 'En reproducción';

  @override
  String get rightPanelNextInQueue => 'Siguiente en la cola';

  @override
  String rightPanelNextFrom(String name) {
    return 'A continuación de: $name';
  }

  @override
  String get nowPlayingPlayingFrom => 'REPRODUCIENDO DE';

  @override
  String get nowPlayingMoreOptions => 'Más opciones';

  @override
  String get chatChats => 'Conversaciones';

  @override
  String chatYouSaid(String text) {
    return 'Tú: $text';
  }

  @override
  String get chatContacts => 'Contactos';

  @override
  String get chatServerUnreachable =>
      'No pude comunicarme con el servidor de extras.';

  @override
  String get chatMessageHint => 'Mensaje';

  @override
  String chatJoinedJam(String title) {
    return 'Te uniste a $title';
  }

  @override
  String chatCouldNotPlay(String error) {
    return 'No pude reproducir: $error';
  }

  @override
  String get chatJamCardSubtitle => 'Escuchar juntos, con la misma cola';

  @override
  String get chatInJam => 'En la Jam';

  @override
  String get chatJoin => 'Unirse';

  @override
  String get chatNoOtherAccounts => 'No hay otras cuentas en el servidor.';

  @override
  String chatSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count canciones',
      one: '1 canción',
    );
    return '$_temp0';
  }

  @override
  String chatSentTo(String name) {
    return 'Enviado a $name';
  }

  @override
  String chatShareTitle(String title) {
    return 'Compartir $title';
  }

  @override
  String get chatNoteHint => 'Nota (opcional)';

  @override
  String get blendWorking => 'Mezclando…';

  @override
  String blendAffinityButton(int affinity) {
    return 'Blend $affinity%';
  }

  @override
  String get blendCreate => 'Crear Blend';

  @override
  String blendWith(String name) {
    return 'Blend con $name';
  }

  @override
  String get blendExplain =>
      'Una playlist igual para los dos, con lo que ambos escuchan, los artistas en común y un poco de lo que más le gusta a cada uno. Muestra la afinidad entre ustedes y se actualiza todos los días.';

  @override
  String get blendNotNow => 'Ahora no';

  @override
  String blendAffinityTitle(int affinity) {
    return 'Tienen $affinity% de afinidad';
  }

  @override
  String blendInCommon(String artists) {
    return 'En común: $artists';
  }

  @override
  String blendOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Abrir el Blend ($count canciones)',
      one: 'Abrir el Blend (1 canción)',
    );
    return '$_temp0';
  }

  @override
  String get blendRefreshNow => 'Actualizar ahora';

  @override
  String get blendUndo => 'Deshacer Blend';

  @override
  String get blendRefreshing => 'Actualizando el Blend…';

  @override
  String get blendUndoTitle => '¿Deshacer el Blend?';

  @override
  String blendUndoBody(String name) {
    return 'La playlist desaparece para ti y para $name.';
  }

  @override
  String get blendUndoConfirm => 'Deshacer';

  @override
  String get blendUndone => 'Blend deshecho';

  @override
  String get jamStart => 'Iniciar una Jam';

  @override
  String jamTooltip(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jam ($count personas)',
      one: 'Jam (1 persona)',
    );
    return '$_temp0';
  }

  @override
  String get jamSubIdle => 'Escucha junto con otras cuentas, en la misma cola.';

  @override
  String get jamSubHost =>
      'Tú tienes el control. Todos pueden pedir canciones.';

  @override
  String get jamSubGuest => 'Tus botones y canciones van a la cola de todos.';

  @override
  String get jamPlayFirst => 'Reproduce algo antes de iniciar la Jam.';

  @override
  String jamMembers(int count) {
    return 'En la Jam ($count)';
  }

  @override
  String jamYouSuffix(String name) {
    return '$name (tú)';
  }

  @override
  String get jamHost => 'Anfitrión';

  @override
  String get jamInvite => 'Invitar';

  @override
  String get jamInviteTitle => 'Invitar a la Jam';

  @override
  String get jamInviteSubtitle => 'La invitación llega al chat de la persona.';

  @override
  String jamInviteSent(String name) {
    return 'Invitación enviada a $name';
  }

  @override
  String get jamEnd => 'Terminar la Jam';

  @override
  String get jamLeave => 'Salir de la Jam';

  @override
  String recapTitle(int year) {
    return 'Tu Resumen $year';
  }

  @override
  String get recapShort => 'Resumen';

  @override
  String recapBannerBody(String minutes) {
    return '$minutes minutos de música este año. Mira lo que más escuchaste.';
  }

  @override
  String get recapEmpty => 'Aún no hay reproducciones para armar tu Resumen.';

  @override
  String get recapShareCards => 'Compartir tarjetas';

  @override
  String get recapBigMinutes => 'minutos escuchando';

  @override
  String get recapBigSongs => 'canciones distintas';

  @override
  String get recapBigArtists => 'artistas';

  @override
  String get recapBigDays => 'días con música';

  @override
  String get recapBigStreak => 'días seguidos, tu récord';

  @override
  String get recapTopArtists => 'Tus artistas del año';

  @override
  String recapMinutesValue(String minutes) {
    return '$minutes minutos';
  }

  @override
  String get recapTopSongs => 'Tus canciones del año';

  @override
  String recapPlaysLine(String artist, String plays) {
    return '$artist • $plays veces';
  }

  @override
  String get recapSongGone => 'Esta canción ya no está en la biblioteca';

  @override
  String get recapTopAlbums => 'Tus álbumes del año';

  @override
  String get recapTopGenres => 'Géneros que más sonaron';

  @override
  String recapGenreLine(String genre, String minutes) {
    return '$genre • $minutes min';
  }

  @override
  String get recapMonthly => 'Mes a mes';

  @override
  String recapMonthTooltip(String month, String minutes) {
    return '$month: $minutes min';
  }

  @override
  String get recapListeningStyle => 'Tu forma de escuchar';

  @override
  String recapFavHour(String hour) {
    return 'Hora favorita: $hour h';
  }

  @override
  String recapFavWeekday(String day) {
    return 'Día de la semana favorito: $day';
  }

  @override
  String recapBiggestDay(String date, String minutes) {
    return 'Tu mejor día: $date, $minutes minutos';
  }

  @override
  String recapNewArtists(int count, String n) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$n artistas nuevos para ti',
      one: '$n artista nuevo para ti',
    );
    return '$_temp0';
  }

  @override
  String recapSpotifyAdded(String added) {
    return 'Se agregaron $added reproducciones de Spotify.';
  }

  @override
  String recapSpotifyAddedDup(String added, String dup) {
    return 'Se agregaron $added reproducciones de Spotify ($dup ya estaban por Pudim).';
  }

  @override
  String get recapSpotifyRemoveTitle => '¿Quitar el historial de Spotify?';

  @override
  String get recapSpotifyRemoveBody =>
      'El Resumen vuelve a contar solo lo que escuchaste en Pudim/Jellyfin. Puedes importarlo de nuevo después.';

  @override
  String get recapSpotifyRemoveConfirm => 'Quitar';

  @override
  String recapSpotifyRemoved(String count) {
    return '$count reproducciones de Spotify eliminadas';
  }

  @override
  String get recapSpotifyTitle => 'Historial de Spotify';

  @override
  String recapSpotifyHasData(String count, String from, String to) {
    return '$count reproducciones de Spotify en tu Resumen ($from a $to). Puedes subir un archivo más reciente: lo que ya entró no se repite.';
  }

  @override
  String get recapSpotifyIntro =>
      'Trae los años anteriores a Pudim. En Spotify, ve a Cuenta > Privacidad > Descarga tus datos y marca \"Historial de streaming ampliado\". Cuando llegue el correo, elige aquí my_spotify_data.zip.';

  @override
  String get recapSpotifyImportAnother => 'Importar otro archivo';

  @override
  String get recapSpotifyImport => 'Importar historial';

  @override
  String get recapSpotifyRemoveBtn => 'Quitar del Resumen';

  @override
  String get recapShareSaveDialog => 'Guardar tarjeta';

  @override
  String get recapShareSaved => 'Tarjeta guardada';

  @override
  String recapShareSaveFailed(String error) {
    return 'No pude guardar: $error';
  }

  @override
  String recapShareShareFailed(String error) {
    return 'No pude compartir: $error';
  }

  @override
  String recapShareText(int year) {
    return 'Mi Resumen $year en Pudim';
  }

  @override
  String get recapShareMyArtists => 'Mis artistas del año';

  @override
  String get recapShareMySongs => 'Mis canciones del año';

  @override
  String recapMinShort(String minutes) {
    return '$minutes min';
  }

  @override
  String get recapShareSaveImage => 'Guardar imagen';

  @override
  String get recapShareButton => 'Compartir';

  @override
  String recapBrand(int year) {
    return 'Resumen $year';
  }

  @override
  String get recapShareMyYear => 'Mi año en música';

  @override
  String recapShareYearOf(String name) {
    return 'El año de $name en música';
  }

  @override
  String get recapShareTopArtist => 'mi artista del año';

  @override
  String recapShareGenres(String genres) {
    return 'Géneros: $genres';
  }

  @override
  String get widgetActionsAddedToLiked => 'Añadida a Canciones que te gustan';

  @override
  String get widgetActionsRemovedFromLiked =>
      'Eliminada de Canciones que te gustan';

  @override
  String get widgetActionsUnfollowed => 'Dejaste de seguir';

  @override
  String get widgetActionsSavedToLibrary => 'Guardado en Tu biblioteca';

  @override
  String get widgetActionsRemovedFromLibrary => 'Eliminado de Tu biblioteca';

  @override
  String get widgetActionsAddToQueue => 'Añadir a la cola';

  @override
  String get widgetActionsAddedToQueue => 'Añadido a la cola';

  @override
  String get widgetActionsPlayNext => 'Reproducir a continuación';

  @override
  String get widgetActionsGoToPodcast => 'Ir al pódcast';

  @override
  String get widgetActionsRemoveFromQueue => 'Quitar de la cola';

  @override
  String get widgetActionsAddToPlaylist => 'Añadir a la playlist';

  @override
  String get widgetActionsRemoveFromThisPlaylist => 'Quitar de esta playlist';

  @override
  String get widgetActionsInviteToEdit => 'Invitar a editar';

  @override
  String get widgetActionsKeepInPlaylist => 'Mantener en la playlist';

  @override
  String get widgetActionsDownloadTrack => 'Descargar canción';

  @override
  String get widgetActionsDownloadAlbum => 'Descargar álbum';

  @override
  String get widgetActionsDownloadDiscography => 'Descargar discografía';

  @override
  String get widgetActionsSearchAlbums => 'Buscar álbumes';

  @override
  String widgetActionsImproveQuality(int count) {
    return 'Mejorar calidad ($count)';
  }

  @override
  String widgetActionsImprovingAlbums(int count) {
    return 'Buscando mejores versiones de $count álbumes';
  }

  @override
  String get widgetActionsShare => 'Compartir';

  @override
  String get widgetActionsSearchFlac => 'Buscar en FLAC';

  @override
  String widgetActionsSearchingFlac(String name) {
    return 'Buscando $name en FLAC; si lo encuentra, reemplaza el MP3';
  }

  @override
  String get widgetActionsTrackRemovedFromDevice => 'Eliminada del dispositivo';

  @override
  String get widgetActionsRemovedFromDevice => 'Eliminado del dispositivo';

  @override
  String get widgetActionsDownloadingToDevice =>
      'Descargando en el dispositivo para escuchar sin conexión';

  @override
  String get widgetActionsUnfollow => 'Dejar de seguir';

  @override
  String get widgetActionsRemoveFromLibrary => 'Quitar de Tu biblioteca';

  @override
  String get widgetActionsAddToLibrary => 'Añadir a Tu biblioteca';

  @override
  String get widgetActionsGoToSongRadio => 'Ir a la radio de la canción';

  @override
  String get widgetActionsStartMix => 'Iniciar mix';

  @override
  String widgetActionsMixOf(String name) {
    return 'Mix de $name';
  }

  @override
  String get widgetActionsGoToArtist => 'Ir al artista';

  @override
  String get widgetActionsGoToAlbum => 'Ir al álbum';

  @override
  String get widgetActionsCopyName => 'Copiar nombre';

  @override
  String get widgetActionsCopied => 'Copiado';

  @override
  String widgetDownloadsBellDownloading(int count) {
    return '$count descargando';
  }

  @override
  String get widgetDownloadsBellEmpty =>
      'Nada por aquí. Reproduce una canción con nube o usa \"Descargar\" en el menú ⋯ para traerla del catálogo a la biblioteca.';

  @override
  String get widgetDownloadsBellKindDiscography => 'Discografía';

  @override
  String get widgetDownloadsBellKindFlac => 'En FLAC';

  @override
  String get widgetDownloadsBellKindQuality => 'Calidad';

  @override
  String get widgetDownloadsBellOptions => 'Opciones';

  @override
  String get widgetDownloadsBellCancelled => 'Descarga cancelada';

  @override
  String get widgetDownloadsBellRetrying => 'Reintentando';

  @override
  String get widgetDownloadsBellRemovedFromList => 'Eliminado de la lista';

  @override
  String get widgetDownloadsBellDetails => 'Ver detalles';

  @override
  String get widgetDownloadsBellRemoveFromList => 'Quitar de la lista';

  @override
  String get widgetMixSearchingReleases => 'Buscando lanzamientos…';

  @override
  String get widgetMixBuildingDaylist => 'Creando tu daylist…';

  @override
  String get widgetMixNewDiscoveriesTitle =>
      '¿Nuevos Descubrimientos de la semana?';

  @override
  String get widgetMixNewMixTitle => '¿Nueva Mezcla de la semana?';

  @override
  String get widgetMixNewDiscoveriesBody =>
      'Las canciones que aún no has escuchado salen de la playlist y empiezan a llegar unas 30 nuevas. Esto ya ocurre solo cada lunes.';

  @override
  String get widgetMixNewMixBody =>
      'Se vuelve a crear con tus favoritas, lo que más escuchas y canciones parecidas. Esto ya ocurre solo cada lunes.';

  @override
  String get widgetMixNotNow => 'Ahora no';

  @override
  String get widgetMixBuildingDiscoveries => 'Creando tus Descubrimientos…';

  @override
  String get widgetMixBuildingMix => 'Creando tu Mezcla…';

  @override
  String widgetMixBuiltOn(String date) {
    return 'Creada el $date';
  }

  @override
  String get widgetMixRedo => 'Rehacer';

  @override
  String get widgetMixRefresh => 'Actualizar';

  @override
  String get widgetMixCreateDiscoveries =>
      'Crear tus Descubrimientos de la semana';

  @override
  String get widgetMixCreateMix => 'Crear tu Mezcla de la semana';

  @override
  String get widgetMixCreateRadar => 'Crear tu Radar de novedades';

  @override
  String get widgetMixCreateDaylist => 'Crear tu daylist';

  @override
  String get widgetOfflineBanner =>
      'Sin internet · mostrando lo guardado en el dispositivo';

  @override
  String widgetOfflineDownloadingProgress(int done, int total) {
    return 'Descargando $done de $total';
  }

  @override
  String get widgetUpdateReady => 'Nueva versión de Pudim lista';

  @override
  String widgetUpdateReadyNotes(String notes) {
    return 'Nueva versión de Pudim · $notes';
  }

  @override
  String get widgetUpdateAction => 'Actualizar';

  @override
  String widgetSleepShortMinutes(int count) {
    return '$count min';
  }

  @override
  String widgetSleepShortSeconds(int count) {
    return '$count s';
  }

  @override
  String get widgetSleepStopsAtEnd => 'Se detiene al final de la canción';

  @override
  String widgetSleepStopsIn(String time) {
    return 'Se detiene en $time';
  }

  @override
  String get widgetSleepTimer => 'Temporizador de sueño';

  @override
  String get widgetSleepTurnOff => 'Desactivar el temporizador';

  @override
  String get widgetSleepOneHour => '1 hora';

  @override
  String get widgetSleepOneAndHalfHours => '1 hora y media';

  @override
  String get widgetSleepEndOfSong => 'Final de la canción';

  @override
  String get widgetSleepTurnedOff => 'Temporizador desactivado';

  @override
  String get widgetSleepStopsWhenSongEnds =>
      'La música se detiene cuando termine esta canción';

  @override
  String widgetSleepSongStopsIn(String time) {
    return 'La música se detiene en $time';
  }

  @override
  String get widgetSpeedPodcast => 'Velocidad del pódcast';

  @override
  String get widgetCommonCatalogBadge =>
      'Del catálogo: aún no está en la biblioteca';

  @override
  String get widgetCommonShowAll => 'Mostrar todo';

  @override
  String get widgetCommonSomethingWentWrong => 'Algo salió mal';

  @override
  String get widgetCommonListenDownloaded =>
      'Escuchar las canciones descargadas';

  @override
  String get widgetTracksTitle => 'Título';

  @override
  String get widgetTracksDateAdded => 'Fecha en que se añadió';

  @override
  String widgetTracksAddedBy(String name) {
    return 'por $name';
  }

  @override
  String get widgetTracksMoreOptions => 'Más opciones';

  @override
  String widgetTracksAddedDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get castTooltip => 'Transmitir';

  @override
  String get castTitle => 'Reproducir en';

  @override
  String get castThisDevice => 'Este dispositivo';

  @override
  String get castSearching => 'Buscando dispositivos en la red…';

  @override
  String get castNone =>
      'No se encontró ningún Chromecast. Tiene que estar en la misma red Wi-Fi.';

  @override
  String get castSearchAgain => 'Buscar de nuevo';

  @override
  String get castStop => 'Dejar de transmitir';

  @override
  String castPlayingOn(String name) {
    return 'Reproduciendo en $name';
  }

  @override
  String castFailed(String name) {
    return 'No se pudo conectar con $name';
  }

  @override
  String get settingsSectionAppearance => 'Apariencia';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSubtitle => 'Cambia los colores al instante.';

  @override
  String get themeNightDesc =>
      'Oscuro, tarjetas redondeadas y mini reproductor flotante.';

  @override
  String get themeRedDesc =>
      'Negro puro con rojo, portadas grandes y cuadradas, mini reproductor pegado a la barra.';

  @override
  String get themeWaveDesc =>
      'Morado con degradados, letras fuertes y mini reproductor en píldora.';

  @override
  String get themeRetroDesc =>
      'Ventana gris en relieve, pantalla verde con título deslizante y listas de texto.';

  @override
  String get themeClassicDesc =>
      'Azul y negro con brillo de cristal, botón esfera, visualizador y listas en tabla.';

  @override
  String get settingsCheckUpdates => 'Buscar actualizaciones';

  @override
  String get updateChecking => 'Comprobando…';

  @override
  String updateUpToDate(int build) {
    return 'Tienes la versión más reciente (build $build).';
  }

  @override
  String updateDownloading(int build, int percent) {
    return 'Descargando la build $build… $percent%';
  }

  @override
  String updateFailed(String error) {
    return 'No se pudo comprobar: $error';
  }

  @override
  String get updateUnavailable => 'No hay servidor de extras configurado.';

  @override
  String get settingsHistory => 'Historial';

  @override
  String get settingsHistorySubtitle =>
      'Resúmenes de años anteriores y todo lo que escuchaste';

  @override
  String get historyRecaps => 'Resúmenes';

  @override
  String get historyPlays => 'Reproducciones';

  @override
  String get historyWholeYear => 'Todo el año';

  @override
  String get historyLoadMore => 'Cargar más';

  @override
  String get historyEmpty => 'Nada reproducido todavía';

  @override
  String get historyImported => 'importado';

  @override
  String widgetMixRadarDone(int count) {
    return 'Radar de novedades: $count canciones';
  }

  @override
  String widgetMixRadarQueued(int count, String list) {
    return 'Descargando $count lanzamiento(s): $list';
  }

  @override
  String widgetMixRadarFailed(String error) {
    return 'El Radar no se actualizó: $error';
  }

  @override
  String get visualsFullscreen => 'Pantalla completa';

  @override
  String get visualsSwitch => 'Cambiar visualización';

  @override
  String get visualsWaves => 'Ondas';

  @override
  String get visualsSwirl => 'Remolino';

  @override
  String get visualsBars => 'Barras';

  @override
  String get visualsNebula => 'Nebulosa';
}
