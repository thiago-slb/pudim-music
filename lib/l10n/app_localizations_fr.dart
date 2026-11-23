// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class L10nFr extends L10n {
  L10nFr([String locale = 'fr']) : super(locale);

  @override
  String get languageTitle => 'Langue';

  @override
  String get languageSubtitle => 'Langue de l’interface';

  @override
  String get languageSystem => 'Par défaut du système';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonClose => 'Fermer';

  @override
  String get commonBack => 'Retour';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonEdit => 'Modifier';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonRemove => 'Retirer';

  @override
  String get commonOk => 'OK';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonQueue => 'File d’attente';

  @override
  String get commonAlbum => 'Album';

  @override
  String get commonAlbums => 'Albums';

  @override
  String get commonArtist => 'Artiste';

  @override
  String get commonArtists => 'Artistes';

  @override
  String get commonSong => 'Titre';

  @override
  String get commonSongs => 'Titres';

  @override
  String get commonPlaylist => 'Playlist';

  @override
  String get commonPlaylists => 'Playlists';

  @override
  String get commonSingle => 'Single';

  @override
  String get commonLikedSongs => 'Titres likés';

  @override
  String get commonAddToLiked => 'Ajouter aux titres likés';

  @override
  String get commonRemoveFromLiked => 'Retirer des titres likés';

  @override
  String get commonShufflePlay => 'Lecture aléatoire';

  @override
  String get commonPlay => 'Lecture';

  @override
  String get commonPause => 'Pause';

  @override
  String get commonFollow => 'Suivre';

  @override
  String get commonFollowing => 'Abonné';

  @override
  String get commonDownloadToDevice => 'Télécharger sur l’appareil';

  @override
  String get commonRemoveFromDevice => 'Supprimer de l’appareil';

  @override
  String get commonDownloaded => 'Téléchargé';

  @override
  String get commonDownloads => 'Téléchargements';

  @override
  String get commonAll => 'Tout';

  @override
  String get commonRecentlyPlayed => 'Écoutés récemment';

  @override
  String get commonYourLibrary => 'Ta bibliothèque';

  @override
  String get commonHome => 'Accueil';

  @override
  String get commonSearch => 'Rechercher';

  @override
  String get commonProfile => 'Profil';

  @override
  String get commonSettings => 'Paramètres';

  @override
  String get commonBuilding => 'Création…';

  @override
  String get commonBuildNow => 'Créer maintenant';

  @override
  String get commonShows => 'Concerts';

  @override
  String get commonPodcasts => 'Podcasts';

  @override
  String commonSongCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titres',
      one: '1 titre',
      zero: 'Aucun titre',
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
    return 'Erreur : $error';
  }

  @override
  String get apiStatusQueued => 'En attente';

  @override
  String get apiStatusDownloading => 'Téléchargement';

  @override
  String get apiStatusDone => 'Ajouté à la bibliothèque';

  @override
  String get apiStatusUpToDate => 'Déjà dans la bibliothèque';

  @override
  String get apiStatusPartial => 'Ajouté en partie';

  @override
  String get apiStatusNotFound => 'Introuvable';

  @override
  String get apiStatusCancelled => 'Annulé';

  @override
  String get apiStatusInterrupted => 'Interrompu';

  @override
  String get apiStatusFailed => 'Échec';

  @override
  String get apiExtrasNoResponse => 'Le serveur d’extras ne répond pas.';

  @override
  String get apiAlbumListFailed => 'Impossible de lister les albums.';

  @override
  String apiPlaylistSaved(int found, int total) {
    return 'Playlist dans Ta bibliothèque ($found titres sur $total)';
  }

  @override
  String apiPlaylistDownloading(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titres de plus',
      one: '1 titre de plus',
    );
    return 'Playlist dans Ta bibliothèque ; téléchargement de $_temp0';
  }

  @override
  String get apiBadCredentials =>
      'Nom d’utilisateur ou mot de passe incorrect.';

  @override
  String get apiServerUnreachable => 'Impossible de joindre le serveur.';

  @override
  String get apiQuickConnectOff =>
      'Quick Connect est désactivé sur ce serveur.';

  @override
  String get apiWrongCurrentPassword => 'Le mot de passe actuel est incorrect.';

  @override
  String stateChatShared(String title) {
    return '$title partagé';
  }

  @override
  String stateDownloadingName(String name) {
    return 'Téléchargement de $name';
  }

  @override
  String stateDownloadingRequests(int count) {
    return 'Téléchargement de $count demandes';
  }

  @override
  String stateDownloadArrived(String name) {
    return '$name a été ajouté à la bibliothèque';
  }

  @override
  String stateDownloadPartial(String name) {
    return '$name a été ajouté en partie';
  }

  @override
  String stateDownloadEnded(String name, String status) {
    return '$name : $status';
  }

  @override
  String get stateNotFromCatalog => 'Cet élément ne vient pas du catalogue.';

  @override
  String stateAlreadyDownloading(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'L’album est déjà en cours de téléchargement.',
      'artist': 'La discographie est déjà en cours de téléchargement.',
      'other': 'Le titre est déjà en cours de téléchargement.',
    });
    return '$_temp0';
  }

  @override
  String stateDownloadRequested(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'album': 'Téléchargement de l’album. Il apparaîtra dans la cloche à son arrivée.',
      'artist': 'Téléchargement de la discographie. Elle apparaîtra dans la cloche à son arrivée.',
      'other': 'Téléchargement du titre. Il apparaîtra dans la cloche à son arrivée.',
    });
    return '$_temp0';
  }

  @override
  String get stateNotifyDownloadsChannel => 'Téléchargements';

  @override
  String get stateNotifyDownloadsChannelDesc =>
      'Progression des titres en cours de téléchargement';

  @override
  String get stateNotifyNewsChannel => 'Nouveautés';

  @override
  String get stateNotifyNewsChannelDesc =>
      'Nouveaux arrivages, sorties, Descobertas et Mistura';

  @override
  String get stateOfflineLoose => 'Téléchargés un par un';

  @override
  String get stateOfflineDoneTitle => 'Téléchargé sur cet appareil';

  @override
  String stateOfflineDoneBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titres prêts à être écoutés hors connexion',
      one: '1 titre prêt à être écouté hors connexion',
    );
    return '$_temp0';
  }

  @override
  String get stateOfflineProgressTitle => 'Téléchargement sur cet appareil';

  @override
  String stateOfflineProgressBody(int done, int total, String name) {
    return '$done sur $total • $name';
  }

  @override
  String get stateServerNoReply =>
      'Le serveur ne répond pas. Vérifie l’adresse.';

  @override
  String get stateServerNoReplyBoth =>
      'Le serveur ne répond à aucune des deux adresses.';

  @override
  String get stateTokenStoreUnsupported =>
      'Pour l’instant, Pudim ne peut enregistrer ta connexion que sur Windows et Android.';

  @override
  String get stateQualityPoor => 'faible qualité';

  @override
  String get stateQualityPartial => 'incomplet';

  @override
  String get audioPlaybackChannel => 'Lecture';

  @override
  String get audioRecentAlbums => 'Albums récents';

  @override
  String audioSearchContext(String query) {
    return 'Recherche : $query';
  }

  @override
  String audioRadioContext(String name) {
    return 'Radio $name';
  }

  @override
  String podcastsMonthShort(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': 'janv.',
      'm2': 'févr.',
      'm3': 'mars',
      'm4': 'avr.',
      'm5': 'mai',
      'm6': 'juin',
      'm7': 'juil.',
      'm8': 'août',
      'm9': 'sept.',
      'm10': 'oct.',
      'm11': 'nov.',
      'other': 'déc.',
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
    return '$h h $min min';
  }

  @override
  String podcastsMin(int min) {
    return '$min min';
  }

  @override
  String get podcastsPlayed => 'écouté';

  @override
  String podcastsTimeLeft(String time) {
    return '$time restantes';
  }

  @override
  String get podcastsSearchHint => 'Rechercher des podcasts';

  @override
  String get podcastsNothingFound => 'Aucun résultat.';

  @override
  String get podcastsYours => 'Tes podcasts';

  @override
  String get podcastsNewEpisodes => 'Nouveaux épisodes';

  @override
  String get podcastsTrendingBrazil => 'Tendances au Brésil';

  @override
  String get podcastsLoadFailed => 'Chargement impossible. Réessaie';

  @override
  String get podcastsNoEpisodes => 'Aucun épisode dans le flux.';

  @override
  String podcastsNoEpisodeMatch(String q) {
    return 'Aucun épisode correspondant à « $q ».';
  }

  @override
  String get podcastsKind => 'Podcast';

  @override
  String get podcastsEpisodes => 'Épisodes';

  @override
  String podcastsEpisodesCount(int total) {
    return 'Épisodes ($total)';
  }

  @override
  String get podcastsFindEpisode => 'Rechercher des épisodes';

  @override
  String showsMonthName(String m) {
    String _temp0 = intl.Intl.selectLogic(m, {
      'm1': 'janvier',
      'm2': 'février',
      'm3': 'mars',
      'm4': 'avril',
      'm5': 'mai',
      'm6': 'juin',
      'm7': 'juillet',
      'm8': 'août',
      'm9': 'septembre',
      'm10': 'octobre',
      'm11': 'novembre',
      'other': 'décembre',
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
      'w1': 'lun.',
      'w2': 'mar.',
      'w3': 'mer.',
      'w4': 'jeu.',
      'w5': 'ven.',
      'w6': 'sam.',
      'other': 'dim.',
    });
    return '$_temp0';
  }

  @override
  String get showsFollowingNone => 'Des artistes que tu suis';

  @override
  String showsFollowingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Des $count artistes que tu suis',
      one: 'De l’artiste que tu suis',
    );
    return '$_temp0';
  }

  @override
  String showsSearchingFor(int count) {
    return 'recherche de concerts pour $count…';
  }

  @override
  String get showsUpcoming => 'À venir';

  @override
  String get showsPast => 'Passés';

  @override
  String get showsInBrazil => 'Au Brésil';

  @override
  String get showsEmptyFollow =>
      'Suis des artistes (bouton Suivre sur la page de l’artiste) pour voir leurs concerts ici.';

  @override
  String get showsNonePast => 'Aucun concert enregistré pour l’instant.';

  @override
  String get showsNoneUpcoming => 'Aucun concert prévu pour l’instant.';

  @override
  String get showsStillSearching => 'Recherche en cours…';

  @override
  String get showsSource =>
      'Dates issues de MusicBrainz (communautaire) ; les nouveaux concerts peuvent mettre du temps à apparaître.';

  @override
  String get showsCancelled => 'annulé';

  @override
  String get showsFestival => 'festival';

  @override
  String get catalogKindAlbum => 'Album';

  @override
  String get catalogKindSingle => 'Single';

  @override
  String get catalogKindBroadcast => 'Émission';

  @override
  String get catalogKindOther => 'Autre';

  @override
  String get catalogSecLive => 'live';

  @override
  String get catalogSecCompilation => 'compilation';

  @override
  String get catalogSecSoundtrack => 'bande originale';

  @override
  String get catalogSecMixtape => 'mixtape';

  @override
  String get catalogSecInterview => 'interview';

  @override
  String get catalogSecSpokenword => 'spoken word';

  @override
  String catalogDownloadingOne(String title) {
    return 'Téléchargement de $title';
  }

  @override
  String catalogDownloadingMany(int count, String artist) {
    return 'Téléchargement de $count albums de $artist';
  }

  @override
  String catalogCheckingDiscography(int seconds) {
    return 'Vérification de la discographie… $seconds s';
  }

  @override
  String catalogToDownload(int count) {
    return '$count à télécharger';
  }

  @override
  String catalogInLibraryCount(int count) {
    return '$count déjà dans la bibliothèque';
  }

  @override
  String catalogSkippedOneSong(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sorties d’un seul titre ignorées',
      one: '1 sortie d’un seul titre ignorée',
    );
    return '$_temp0';
  }

  @override
  String get catalogPickAll => 'Tout';

  @override
  String get catalogPickStudio => 'Studio';

  @override
  String get catalogPickNone => 'Aucun';

  @override
  String get catalogDownloadSelected => 'Télécharger la sélection';

  @override
  String catalogDownloadNSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Télécharger $count sélectionnés',
      one: 'Télécharger 1 sélectionné',
    );
    return '$_temp0';
  }

  @override
  String get catalogNothingMissing => 'Il ne manque rien.';

  @override
  String get catalogPartial => 'partiel';

  @override
  String get catalogDownload => 'Télécharger';

  @override
  String get catalogAddToLibrary => 'Ajouter à Ta bibliothèque';

  @override
  String get catalogInYourLibrary => 'Dans Ta bibliothèque';

  @override
  String get catalogAllInLibrary => 'tout est dans la bibliothèque';

  @override
  String catalogNInLibrary(int count) {
    return '$count dans la bibliothèque';
  }

  @override
  String get catalogDownloadAlbum => 'Télécharger l’album';

  @override
  String get catalogArtistNotFound => 'Artiste introuvable.';

  @override
  String get catalogFromCatalog =>
      'Du catalogue : pas encore dans la bibliothèque';

  @override
  String get catalogDownloadAll => 'Tout télécharger';

  @override
  String get catalogDownloadDiscography => 'Télécharger la discographie';

  @override
  String get catalogPopular => 'Populaires';

  @override
  String get catalogShowLess => 'Voir moins';

  @override
  String get catalogShowMore => 'Voir plus';

  @override
  String get catalogSinglesEps => 'Singles et EP';

  @override
  String get catalogFansAlsoLike => 'Les fans aiment aussi';

  @override
  String get lyricsPlaySomething => 'Lance un titre pour voir les paroles.';

  @override
  String get lyricsNone => 'Pas de paroles pour ce titre';

  @override
  String get lyricsNoneHint =>
      'Quand un fichier .lrc ou .txt se trouve à côté du fichier audio, il apparaît ici.';

  @override
  String get lyricsSynced => 'Paroles synchronisées du fichier .lrc';

  @override
  String get lyricsUnsynced => 'Paroles non synchronisées';

  @override
  String get profileChangePhoto => 'Changer de photo';

  @override
  String get profileNoPhoto => 'Aucune photo choisie';

  @override
  String get profilePhotoTooBig => 'Photo trop lourde (8 Mo maximum)';

  @override
  String get profilePhotoChanged => 'Photo de profil modifiée';

  @override
  String get profilePhotoRemoved => 'Photo supprimée';

  @override
  String get profileNameSaved => 'Nom de profil enregistré';

  @override
  String get profileRenameTitle => 'Changer ton nom d’utilisateur ?';

  @override
  String profileRenameBody(String name) {
    return 'Tu te connecteras avec « $name » dans Pudim, Jellyfin et les autres applis (Finamp, Feishin…). Tes Descobertas, ton Mix et ton Rewind te suivent.';
  }

  @override
  String get profileRenameConfirm => 'Changer';

  @override
  String profileNowSignedAs(String name) {
    return 'Tu te connectes maintenant avec $name';
  }

  @override
  String get profileEnterNewPassword => 'Saisis le nouveau mot de passe';

  @override
  String get profilePasswordsDiffer =>
      'Les nouveaux mots de passe ne correspondent pas';

  @override
  String get profilePasswordChanged => 'Mot de passe modifié';

  @override
  String get profileExtrasUnreachable =>
      'Impossible de joindre le serveur d’extras ; le nom de profil et le nom d’utilisateur devront attendre.';

  @override
  String get profileNameSection => 'Nom de profil';

  @override
  String get profileNameHelp =>
      'C’est le nom que tes contacts voient dans les discussions.';

  @override
  String get profileYourName => 'Ton nom';

  @override
  String get profileUsernameSection => 'Nom d’utilisateur';

  @override
  String get profileUsernameHelp =>
      'Le nom que tu utilises pour te connecter à Jellyfin (ici et dans d’autres applis).';

  @override
  String get profileUsernameHint => 'Nom d’utilisateur';

  @override
  String get profileChangeUsername => 'Changer le nom d’utilisateur';

  @override
  String get profilePasswordSection => 'Mot de passe';

  @override
  String get profileCurrentPassword => 'Mot de passe actuel';

  @override
  String get profileNewPassword => 'Nouveau mot de passe';

  @override
  String get profileRepeatPassword => 'Répète le nouveau mot de passe';

  @override
  String get profileChangePassword => 'Changer le mot de passe';

  @override
  String get loginServerRequired => 'Saisis l’adresse de ton serveur Jellyfin.';

  @override
  String get loginUserRequired => 'Saisis ton nom d’utilisateur.';

  @override
  String get loginTitle => 'Connecte-toi à Pudim';

  @override
  String get loginSubtitle => 'Utilise ton compte Jellyfin.';

  @override
  String get loginUsername => 'Nom d’utilisateur';

  @override
  String get loginPassword => 'Mot de passe';

  @override
  String get loginShowPassword => 'Afficher le mot de passe';

  @override
  String get loginHidePassword => 'Masquer le mot de passe';

  @override
  String get loginSubmit => 'Se connecter';

  @override
  String get loginQuickConnect => 'Se connecter avec Quick Connect';

  @override
  String get loginHideAddresses => 'Masquer les adresses';

  @override
  String get loginServerAddress => 'Adresse du serveur';

  @override
  String get loginJellyfinServer => 'Serveur Jellyfin';

  @override
  String get loginJellyfinServerExample => 'Ex. https://jellyfin.exemplo.com';

  @override
  String get loginLocalNetwork => 'Sur le réseau local (facultatif)';

  @override
  String get loginLocalNetworkExample =>
      'Ex. http://192.168.0.10:8096. Quand il répond, l’appli l’utilise à la place de l’adresse principale.';

  @override
  String get loginExtrasServer => 'Serveur d’extras (facultatif)';

  @override
  String get loginExtrasServerHint =>
      'Active le chat, Jam, Blend, les mixes et Rewind. Laisse vide si tu n’en as pas.';

  @override
  String get loginQcExpired => 'Le code a expiré. Réessaie.';

  @override
  String get loginQcInstructions =>
      'Sur un appareil où tu es déjà connecté à Jellyfin, ouvre ton profil, touche Quick Connect et saisis ce code :';

  @override
  String get loginQcWaiting => 'En attente d’approbation…';

  @override
  String get homeDownloadedOnDevice => 'Téléchargé sur cet appareil';

  @override
  String get homeTabMusic => 'Musique';

  @override
  String get homeMadeFor => 'Conçu pour';

  @override
  String get homeMixDiscoveries =>
      'De la nouvelle musique pour toi, chaque semaine';

  @override
  String get homeMixWeekly =>
      'Tes favoris et des titres similaires, chaque semaine';

  @override
  String get homeMixRadar =>
      'Les nouveautés des artistes que tu suis, chaque vendredi';

  @override
  String get homeMixDaylist => 'Change tout au long de la journée';

  @override
  String get homeMixBlend => 'Vos deux goûts réunis';

  @override
  String get homeMixAuto => 'Mix automatique';

  @override
  String get homeSpotifyPlaylists => 'Tes playlists Spotify';

  @override
  String get homeFromSpotify => 'De Spotify';

  @override
  String get homeYourPlaylists => 'Tes playlists';

  @override
  String get homeTopAlbums => 'Tes albums les plus écoutés';

  @override
  String get homeTopArtists => 'Tes artistes préférés';

  @override
  String get homeRecentlyAdded => 'Ajoutés récemment';

  @override
  String get homeYourPodcasts => 'Tes podcasts';

  @override
  String get homeRadiosTitle => 'Radios recommandées';

  @override
  String get homeRadiosSubtitle =>
      'De la musique en continu basée sur tes artistes préférés.';

  @override
  String get homeRadioBadge => 'RADIO';

  @override
  String homeRadioWith(String name) {
    return 'Avec $name et des artistes similaires';
  }

  @override
  String searchNoResults(String query) {
    return 'Aucun résultat pour « $query »';
  }

  @override
  String get searchNoResultsHint =>
      'Vérifie l’orthographe ou utilise moins de mots, ou d’autres mots.';

  @override
  String searchCatalogNoResponse(String error) {
    return 'Le catalogue n’a pas répondu : $error';
  }

  @override
  String get searchAlsoCatalog => 'Recherche aussi dans le catalogue…';

  @override
  String searchLibraryOnly(String error) {
    return 'Bibliothèque uniquement : le catalogue n’a pas répondu ($error).';
  }

  @override
  String get searchTopResult => 'Meilleur résultat';

  @override
  String get searchSpotifyPlaylists => 'Playlists Spotify';

  @override
  String get searchRecent => 'Recherches récentes';

  @override
  String get searchClear => 'Effacer';

  @override
  String get searchBrowseAll => 'Tout parcourir';

  @override
  String get searchHint => 'Qu’as-tu envie d’écouter ?';

  @override
  String get albumDownloadedType => 'Album • téléchargé sur cet appareil';

  @override
  String albumSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titres',
      one: '1 titre',
    );
    return '$_temp0, $total';
  }

  @override
  String get albumRemoveFromLibrary => 'Retirer de Ta bibliothèque';

  @override
  String get albumSaveToLibrary => 'Enregistrer dans Ta bibliothèque';

  @override
  String albumMoreOptions(String name) {
    return 'Plus d’options pour $name';
  }

  @override
  String albumDisc(int number) {
    return 'Disque $number';
  }

  @override
  String albumMoreFrom(String name) {
    return 'Plus de $name';
  }

  @override
  String artistAlbumsInLibrary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count albums dans ta bibliothèque',
      one: '1 album dans ta bibliothèque',
    );
    return '$_temp0';
  }

  @override
  String artistPlays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count écoutes',
      one: '1 écoute',
    );
    return '$_temp0';
  }

  @override
  String artistMoreOptions(String name) {
    return 'Plus d’options pour $name';
  }

  @override
  String get artistPopular => 'Populaires';

  @override
  String get artistShowLess => 'Voir moins';

  @override
  String get artistShowMore => 'Voir plus';

  @override
  String get artistYouLiked => 'Tes titres likés';

  @override
  String artistFrom(String name) {
    return 'De $name';
  }

  @override
  String get artistDiscography => 'Discographie';

  @override
  String get artistPopularReleases => 'Sorties populaires';

  @override
  String get artistSinglesEps => 'Singles et EP';

  @override
  String get artistFansAlsoLike => 'Les fans aiment aussi';

  @override
  String get artistAppearsOn => 'Apparaît sur';

  @override
  String get artistAbout => 'À propos';

  @override
  String get playlistOriginSpotify => 'De Spotify';

  @override
  String get playlistOriginMadeForYou => 'Conçu pour toi';

  @override
  String get playlistOriginAuto => 'Mix automatique';

  @override
  String get playlistDownloadedOnDevice => 'Téléchargé sur cet appareil';

  @override
  String get playlistOnDevice => 'Sur cet appareil';

  @override
  String get playlistPlaysOffline => 'Se lit sans connexion.';

  @override
  String playlistPlaysOfflineDownloading(int count) {
    return 'Se lit sans connexion. $count de plus en cours de téléchargement…';
  }

  @override
  String playlistSongsAndTime(int count, String total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titres',
      one: '1 titre',
    );
    return '$_temp0, $total';
  }

  @override
  String playlistMoreOptions(String name) {
    return 'Plus d’options pour $name';
  }

  @override
  String get playlistSearchHint => 'Rechercher dans la playlist';

  @override
  String get playlistEmpty => 'Aucun titre pour l’instant.';

  @override
  String get playlistErrNoPermission =>
      'Tu n’as pas l’autorisation de modifier cette playlist.';

  @override
  String playlistErrServer(String code) {
    return 'Le serveur a refusé la requête ($code).';
  }

  @override
  String get playlistErrNoResponse => 'pas de réponse';

  @override
  String get playlistDownloadFirst =>
      'Télécharge d’abord le titre pour l’ajouter à une playlist';

  @override
  String get playlistAddTo => 'Ajouter à une playlist';

  @override
  String get playlistNew => 'Nouvelle playlist';

  @override
  String playlistAddedTo(String name) {
    return 'Ajouté à $name';
  }

  @override
  String get playlistNameHint => 'Nom de la playlist';

  @override
  String get playlistCreate => 'Créer';

  @override
  String playlistCreated(String name) {
    return 'Playlist $name créée';
  }

  @override
  String get playlistRemoved => 'Retiré de la playlist';

  @override
  String get playlistInviteTitle => 'Inviter à modifier';

  @override
  String get playlistInviteSubtitle =>
      'La personne verra la playlist dans sa bibliothèque et pourra ajouter et retirer des titres.';

  @override
  String get playlistInviteOwnerOnly =>
      'Seul le créateur de la playlist peut inviter';

  @override
  String playlistInvited(String who, String playlist) {
    return '$who peut maintenant modifier $playlist';
  }

  @override
  String playlistCollaborative(String members) {
    return 'Collaborative · $members';
  }

  @override
  String get playlistSmartShuffleTooltip =>
      'Smart Shuffle : lecture aléatoire avec recommandations';

  @override
  String get playlistSmartShuffleOn =>
      'Smart Shuffle activé : les recommandations sont marquées d’un ✦';

  @override
  String get playlistAddedToThis => 'Ajouté à la playlist';

  @override
  String get playlistRecommendation => 'Recommandation Smart Shuffle';

  @override
  String get playlistPutIn => 'Ajouter à une playlist';

  @override
  String get settingsSectionAccount => 'Compte';

  @override
  String get settingsProfileSubtitle =>
      'Nom, nom d’utilisateur et mot de passe';

  @override
  String settingsConnectedAt(String url) {
    return 'Connecté à $url';
  }

  @override
  String get settingsSignOut => 'Se déconnecter';

  @override
  String get accountsTitle => 'Comptes';

  @override
  String get accountsAdd => 'Ajouter un compte ou un serveur';

  @override
  String get accountsSwitch => 'Changer';

  @override
  String get accountsInUse => 'Actif';

  @override
  String accountsOn(String user, String host) {
    return '$user sur $host';
  }

  @override
  String get loginBackToAccount => 'Revenir au compte actuel';

  @override
  String get settingsSectionServer => 'Serveur';

  @override
  String get settingsLocalNetwork => 'Sur le réseau local';

  @override
  String get settingsServerNote =>
      'Pour changer les adresses Jellyfin, déconnecte-toi et ouvre « Adresse du serveur » sur l’écran de connexion.';

  @override
  String get settingsExtrasServer => 'Serveur d’extras';

  @override
  String get settingsExtrasNotConfigured =>
      'Non configuré (chat, Jam, Blend, mixes et Récap restent masqués)';

  @override
  String get settingsConfigure => 'Configurer';

  @override
  String get settingsChange => 'Modifier';

  @override
  String get settingsSectionPlayback => 'Lecture';

  @override
  String get settingsQualityWifi => 'Qualité en Wi-Fi';

  @override
  String get settingsQualityWifiSubtitle =>
      'Original lit le fichier tel qu’il est dans la bibliothèque.';

  @override
  String get settingsQualityMobile => 'Qualité en données mobiles';

  @override
  String get settingsQualityMobileSubtitle =>
      'Une qualité plus basse consomme moins de données mobiles.';

  @override
  String get settingsQualityOriginal => 'Original';

  @override
  String get settingsAppliesNextSong => 'S’applique à partir du prochain titre';

  @override
  String get settingsSectionAbout => 'À propos';

  @override
  String settingsBuild(int build) {
    return 'Build $build';
  }

  @override
  String get settingsExtrasEmptyHint =>
      'Laisse vide pour désactiver les extras.';

  @override
  String get settingsAutoplay => 'Lecture automatique';

  @override
  String get settingsAutoplaySubtitle =>
      'Quand la file d’attente se termine, continue avec des titres similaires (mix Jellyfin).';

  @override
  String get settingsNormalize => 'Normaliser le volume';

  @override
  String get settingsNormalizeSubtitle =>
      'Lit tous les titres au même volume, grâce à l’analyse de Jellyfin.';

  @override
  String get settingsScrobble => 'Scrobbling';

  @override
  String get settingsLoading => 'Chargement…';

  @override
  String get settingsLastfmNoKey =>
      'Le serveur d’extras n’a pas encore de clé API Last.fm configurée.';

  @override
  String settingsConnectedAs(String name) {
    return 'Connecté en tant que $name';
  }

  @override
  String get settingsLastfmConnectedSubtitle =>
      'Tout ce que tu écoutes sur Pudim est envoyé à ton profil Last.fm.';

  @override
  String get settingsDisconnect => 'Déconnecter';

  @override
  String get settingsLastfmAuthorize => 'Autoriser sur la page Last.fm';

  @override
  String get settingsLastfmAuthorizeSubtitle =>
      'Après avoir cliqué sur « Yes, allow access » là-bas, reviens et touche Terminé.';

  @override
  String get settingsFinish => 'Terminé';

  @override
  String get settingsLastfmConnected => 'Last.fm connecté';

  @override
  String get settingsLastfmScrobbleSubtitle =>
      'Enregistre chaque titre que tu écoutes sur ton Last.fm.';

  @override
  String get settingsConnect => 'Connecter';

  @override
  String get sidebarOpenLibrary => 'Ouvrir Ta bibliothèque';

  @override
  String get sidebarCollapseLibrary => 'Réduire Ta bibliothèque';

  @override
  String sidebarOnDeviceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titres',
      one: '1 titre',
    );
    return 'Sur l’appareil • $_temp0';
  }

  @override
  String sidebarPlaylistCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titres',
      one: '1 titre',
    );
    return 'Playlist • $_temp0';
  }

  @override
  String sidebarAlbumBy(String artist) {
    return 'Album • $artist';
  }

  @override
  String get sidebarSearchLibrary => 'Rechercher dans Ta bibliothèque';

  @override
  String get sidebarSortBy => 'Trier par';

  @override
  String get sidebarSortRecents => 'Récents';

  @override
  String get sidebarSortAdded => 'Ajoutés récemment';

  @override
  String get sidebarSortAlpha => 'Ordre alphabétique';

  @override
  String get sidebarSortCreator => 'Créateur';

  @override
  String get topBarSearchHint => 'Qu’as-tu envie d’écouter ?';

  @override
  String get topBarClearSearch => 'Effacer le champ de recherche';

  @override
  String get topBarBrowse => 'Parcourir';

  @override
  String get topBarMenu => 'Menu';

  @override
  String get topBarLogoutAccount => 'Se déconnecter';

  @override
  String get topBarQuit => 'Quitter Pudim';

  @override
  String get topBarLogout => 'Se déconnecter';

  @override
  String get playerBarSmartShuffleOff => 'Désactiver Smart Shuffle';

  @override
  String get playerBarSmartShuffleOn => 'Activer Smart Shuffle';

  @override
  String get playerBarShuffleOff => 'Désactiver la lecture aléatoire';

  @override
  String get playerBarShuffleOn => 'Activer la lecture aléatoire';

  @override
  String get playerBarPlay => 'Lecture';

  @override
  String get playerBarForward => 'Suivant';

  @override
  String get playerBarRepeatOn => 'Activer la répétition';

  @override
  String get playerBarRepeatOne => 'Répéter ce titre';

  @override
  String get playerBarRepeatOff => 'Désactiver la répétition';

  @override
  String get playerBarNowPlayingView => 'Vue En cours de lecture';

  @override
  String get playerBarLyrics => 'Paroles';

  @override
  String get playerBarUnmute => 'Réactiver le son';

  @override
  String get playerBarMute => 'Couper le son';

  @override
  String get rightPanelNothingPlaying =>
      'Lance un titre pour voir ce qui est en cours de lecture ici.';

  @override
  String get rightPanelLyricsPreview => 'Aperçu des paroles';

  @override
  String get rightPanelAboutArtist => 'À propos de l’artiste';

  @override
  String get rightPanelNextUp => 'À suivre';

  @override
  String get rightPanelOpenQueue => 'Ouvrir la file d’attente';

  @override
  String get rightPanelQueueEmptyTitle => 'Ajouter à la file d’attente';

  @override
  String get rightPanelQueueEmptyHint =>
      'Clique sur « Ajouter à la file d’attente » dans le menu d’un titre pour le mettre ici';

  @override
  String get rightPanelNowPlaying => 'En cours de lecture';

  @override
  String get rightPanelNextInQueue => 'Suivant dans la file d’attente';

  @override
  String rightPanelNextFrom(String name) {
    return 'Ensuite depuis : $name';
  }

  @override
  String get nowPlayingPlayingFrom => 'LECTURE DEPUIS';

  @override
  String get nowPlayingMoreOptions => 'Plus d’options';

  @override
  String get chatChats => 'Discussions';

  @override
  String chatYouSaid(String text) {
    return 'Toi : $text';
  }

  @override
  String get chatContacts => 'Contacts';

  @override
  String get chatServerUnreachable =>
      'Impossible de joindre le serveur d’extras.';

  @override
  String get chatMessageHint => 'Message';

  @override
  String chatJoinedJam(String title) {
    return 'Tu as rejoint $title';
  }

  @override
  String chatCouldNotPlay(String error) {
    return 'Lecture impossible : $error';
  }

  @override
  String get chatJamCardSubtitle => 'Écoutez ensemble, même file d’attente';

  @override
  String get chatInJam => 'Dans le Jam';

  @override
  String get chatJoin => 'Rejoindre';

  @override
  String get chatNoOtherAccounts => 'Aucun autre compte sur le serveur.';

  @override
  String chatSongsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titres',
      one: '1 titre',
    );
    return '$_temp0';
  }

  @override
  String chatSentTo(String name) {
    return 'Envoyé à $name';
  }

  @override
  String chatShareTitle(String title) {
    return 'Partager $title';
  }

  @override
  String get chatNoteHint => 'Note (facultatif)';

  @override
  String get blendWorking => 'Création du Blend…';

  @override
  String blendAffinityButton(int affinity) {
    return 'Blend $affinity %';
  }

  @override
  String get blendCreate => 'Créer un Blend';

  @override
  String blendWith(String name) {
    return 'Blend avec $name';
  }

  @override
  String get blendExplain =>
      'Une playlist pour vous deux, avec ce que vous écoutez tous les deux, les artistes en commun et un peu de ce que chacun aime le plus. Elle montre à quel point vos goûts se rejoignent et se met à jour chaque jour.';

  @override
  String get blendNotNow => 'Pas maintenant';

  @override
  String blendAffinityTitle(int affinity) {
    return 'Vous avez $affinity % d’affinité';
  }

  @override
  String blendInCommon(String artists) {
    return 'En commun : $artists';
  }

  @override
  String blendOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ouvrir le Blend ($count titres)',
      one: 'Ouvrir le Blend (1 titre)',
    );
    return '$_temp0';
  }

  @override
  String get blendRefreshNow => 'Actualiser maintenant';

  @override
  String get blendUndo => 'Supprimer le Blend';

  @override
  String get blendRefreshing => 'Actualisation du Blend…';

  @override
  String get blendUndoTitle => 'Supprimer le Blend ?';

  @override
  String blendUndoBody(String name) {
    return 'La playlist disparaîtra pour toi et pour $name.';
  }

  @override
  String get blendUndoConfirm => 'Supprimer';

  @override
  String get blendUndone => 'Blend supprimé';

  @override
  String get jamStart => 'Démarrer un Jam';

  @override
  String jamTooltip(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jam ($count personnes)',
      one: 'Jam (1 personne)',
    );
    return '$_temp0';
  }

  @override
  String get jamSubIdle =>
      'Écoute ensemble avec d’autres comptes, sur la même file d’attente.';

  @override
  String get jamSubHost =>
      'C’est toi qui gères. Tout le monde peut proposer des titres.';

  @override
  String get jamSubGuest =>
      'Tes commandes et tes titres vont dans la file d’attente de tous.';

  @override
  String get jamPlayFirst => 'Lance un titre avant de démarrer le Jam.';

  @override
  String jamMembers(int count) {
    return 'Dans le Jam ($count)';
  }

  @override
  String jamYouSuffix(String name) {
    return '$name (toi)';
  }

  @override
  String get jamHost => 'Hôte';

  @override
  String get jamInvite => 'Inviter';

  @override
  String get jamInviteTitle => 'Inviter au Jam';

  @override
  String get jamInviteSubtitle => 'L’invitation arrive dans sa discussion.';

  @override
  String jamInviteSent(String name) {
    return 'Invitation envoyée à $name';
  }

  @override
  String get jamEnd => 'Terminer le Jam';

  @override
  String get jamLeave => 'Quitter le Jam';

  @override
  String recapTitle(int year) {
    return 'Ton Wrapped $year';
  }

  @override
  String get recapShort => 'Wrapped';

  @override
  String recapBannerBody(String minutes) {
    return '$minutes minutes de musique cette année. Découvre ce que tu as le plus écouté.';
  }

  @override
  String get recapEmpty =>
      'Il n’y a pas encore d’écoutes pour créer ton Wrapped.';

  @override
  String get recapShareCards => 'Partager les cartes';

  @override
  String get recapBigMinutes => 'minutes d’écoute';

  @override
  String get recapBigSongs => 'titres différents';

  @override
  String get recapBigArtists => 'artistes';

  @override
  String get recapBigDays => 'jours avec de la musique';

  @override
  String get recapBigStreak => 'jours d’affilée, ton record';

  @override
  String get recapTopArtists => 'Tes artistes préférés de l’année';

  @override
  String recapMinutesValue(String minutes) {
    return '$minutes minutes';
  }

  @override
  String get recapTopSongs => 'Tes titres préférés de l’année';

  @override
  String recapPlaysLine(String artist, String plays) {
    return '$artist • $plays écoutes';
  }

  @override
  String get recapSongGone => 'Ce titre n’est plus dans la bibliothèque';

  @override
  String get recapTopAlbums => 'Tes albums préférés de l’année';

  @override
  String get recapTopGenres => 'Tes genres les plus écoutés';

  @override
  String recapGenreLine(String genre, String minutes) {
    return '$genre • $minutes min';
  }

  @override
  String get recapMonthly => 'Mois par mois';

  @override
  String recapMonthTooltip(String month, String minutes) {
    return '$month : $minutes min';
  }

  @override
  String get recapListeningStyle => 'Ta façon d’écouter';

  @override
  String recapFavHour(String hour) {
    return 'Heure préférée : $hour h 00';
  }

  @override
  String recapFavWeekday(String day) {
    return 'Jour de la semaine préféré : $day';
  }

  @override
  String recapBiggestDay(String date, String minutes) {
    return 'Ton plus gros jour : $date, $minutes minutes';
  }

  @override
  String recapNewArtists(int count, String n) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$n nouveaux artistes pour toi',
      one: '$n nouvel artiste pour toi',
    );
    return '$_temp0';
  }

  @override
  String recapSpotifyAdded(String added) {
    return '$added écoutes Spotify ont été ajoutées.';
  }

  @override
  String recapSpotifyAddedDup(String added, String dup) {
    return '$added écoutes Spotify ont été ajoutées ($dup étaient déjà là depuis Pudim).';
  }

  @override
  String get recapSpotifyRemoveTitle => 'Supprimer ton historique Spotify ?';

  @override
  String get recapSpotifyRemoveBody =>
      'Ton Wrapped ne comptera plus que ce que tu as écouté sur Pudim/Jellyfin. Tu pourras l’importer à nouveau plus tard.';

  @override
  String get recapSpotifyRemoveConfirm => 'Supprimer';

  @override
  String recapSpotifyRemoved(String count) {
    return '$count écoutes Spotify supprimées';
  }

  @override
  String get recapSpotifyTitle => 'Historique Spotify';

  @override
  String recapSpotifyHasData(String count, String from, String to) {
    return '$count écoutes Spotify dans ton Wrapped ($from au $to). Tu peux envoyer un fichier plus récent : ce qui est déjà dedans ne sera pas compté deux fois.';
  }

  @override
  String get recapSpotifyIntro =>
      'Ajoute les années d’avant Pudim. Dans Spotify, va dans Compte > Confidentialité > Télécharger tes données et sélectionne « Historique de streaming étendu ». Quand l’e-mail arrive, choisis my_spotify_data.zip ici.';

  @override
  String get recapSpotifyImportAnother => 'Importer un autre fichier';

  @override
  String get recapSpotifyImport => 'Importer l’historique';

  @override
  String get recapSpotifyRemoveBtn => 'Retirer du Wrapped';

  @override
  String get recapShareSaveDialog => 'Enregistrer la carte';

  @override
  String get recapShareSaved => 'Carte enregistrée';

  @override
  String recapShareSaveFailed(String error) {
    return 'Enregistrement impossible : $error';
  }

  @override
  String recapShareShareFailed(String error) {
    return 'Partage impossible : $error';
  }

  @override
  String recapShareText(int year) {
    return 'Mon Wrapped $year sur Pudim';
  }

  @override
  String get recapShareMyArtists => 'Mes artistes préférés de l’année';

  @override
  String get recapShareMySongs => 'Mes titres préférés de l’année';

  @override
  String recapMinShort(String minutes) {
    return '$minutes min';
  }

  @override
  String get recapShareSaveImage => 'Enregistrer l’image';

  @override
  String get recapShareButton => 'Partager';

  @override
  String recapBrand(int year) {
    return 'Wrapped $year';
  }

  @override
  String get recapShareMyYear => 'Mon année en musique';

  @override
  String recapShareYearOf(String name) {
    return 'L’année en musique de $name';
  }

  @override
  String get recapShareTopArtist => 'mon artiste préféré de l’année';

  @override
  String recapShareGenres(String genres) {
    return 'Genres : $genres';
  }

  @override
  String get widgetActionsAddedToLiked => 'Ajouté aux titres likés';

  @override
  String get widgetActionsRemovedFromLiked => 'Retiré des titres likés';

  @override
  String get widgetActionsUnfollowed => 'Abonnement annulé';

  @override
  String get widgetActionsSavedToLibrary => 'Enregistré dans Ta bibliothèque';

  @override
  String get widgetActionsRemovedFromLibrary => 'Retiré de Ta bibliothèque';

  @override
  String get widgetActionsAddToQueue => 'Ajouter à la file d’attente';

  @override
  String get widgetActionsAddedToQueue => 'Ajouté à la file d’attente';

  @override
  String get widgetActionsPlayNext => 'Lire ensuite';

  @override
  String get widgetActionsGoToPodcast => 'Aller au podcast';

  @override
  String get widgetActionsRemoveFromQueue => 'Retirer de la file d’attente';

  @override
  String get widgetActionsAddToPlaylist => 'Ajouter à une playlist';

  @override
  String get widgetActionsRemoveFromThisPlaylist => 'Retirer de cette playlist';

  @override
  String get widgetActionsInviteToEdit => 'Inviter à modifier';

  @override
  String get widgetActionsKeepInPlaylist => 'Garder dans la playlist';

  @override
  String get widgetActionsDownloadTrack => 'Télécharger le titre';

  @override
  String get widgetActionsDownloadAlbum => 'Télécharger l’album';

  @override
  String get widgetActionsDownloadDiscography => 'Télécharger la discographie';

  @override
  String get widgetActionsSearchAlbums => 'Trouver des albums';

  @override
  String widgetActionsImproveQuality(int count) {
    return 'Améliorer la qualité ($count)';
  }

  @override
  String widgetActionsImprovingAlbums(int count) {
    return 'Recherche de meilleures versions de $count albums';
  }

  @override
  String get widgetActionsShare => 'Partager';

  @override
  String get widgetActionsSearchFlac => 'Chercher en FLAC';

  @override
  String widgetActionsSearchingFlac(String name) {
    return 'Recherche de $name en FLAC ; si trouvé, il remplace le MP3';
  }

  @override
  String get widgetActionsTrackRemovedFromDevice => 'Supprimé de l’appareil';

  @override
  String get widgetActionsRemovedFromDevice => 'Supprimé de l’appareil';

  @override
  String get widgetActionsDownloadingToDevice =>
      'Téléchargement sur ton appareil pour une écoute hors connexion';

  @override
  String get widgetActionsUnfollow => 'Ne plus suivre';

  @override
  String get widgetActionsRemoveFromLibrary => 'Retirer de Ta bibliothèque';

  @override
  String get widgetActionsAddToLibrary => 'Ajouter à Ta bibliothèque';

  @override
  String get widgetActionsGoToSongRadio => 'Aller à la radio du titre';

  @override
  String get widgetActionsStartMix => 'Lancer le mix';

  @override
  String widgetActionsMixOf(String name) {
    return 'Mix $name';
  }

  @override
  String get widgetActionsGoToArtist => 'Aller à l’artiste';

  @override
  String get widgetActionsGoToAlbum => 'Aller à l’album';

  @override
  String get widgetActionsCopyName => 'Copier le nom';

  @override
  String get widgetActionsCopied => 'Copié';

  @override
  String widgetDownloadsBellDownloading(int count) {
    return '$count en cours de téléchargement';
  }

  @override
  String get widgetDownloadsBellEmpty =>
      'Rien ici pour l’instant. Lance un titre avec une icône de nuage ou utilise « Télécharger » dans le menu ⋯ pour le faire venir du catalogue dans ta bibliothèque.';

  @override
  String get widgetDownloadsBellKindDiscography => 'Discographie';

  @override
  String get widgetDownloadsBellKindFlac => 'En FLAC';

  @override
  String get widgetDownloadsBellKindQuality => 'Qualité';

  @override
  String get widgetDownloadsBellOptions => 'Options';

  @override
  String get widgetDownloadsBellCancelled => 'Téléchargement annulé';

  @override
  String get widgetDownloadsBellRetrying => 'Nouvelle tentative';

  @override
  String get widgetDownloadsBellRemovedFromList => 'Retiré de la liste';

  @override
  String get widgetDownloadsBellDetails => 'Voir les détails';

  @override
  String get widgetDownloadsBellRemoveFromList => 'Retirer de la liste';

  @override
  String get widgetMixSearchingReleases => 'Recherche de nouvelles sorties…';

  @override
  String get widgetMixBuildingDaylist => 'Création de ta daylist…';

  @override
  String get widgetMixNewDiscoveriesTitle =>
      'Nouvelles Descobertas de la semaine ?';

  @override
  String get widgetMixNewMixTitle => 'Nouveau Mix de la semaine ?';

  @override
  String get widgetMixNewDiscoveriesBody =>
      'Les titres que tu n’as pas encore écoutés quittent la playlist et une trentaine de nouveaux arrivent. Ça se fait déjà tout seul chaque lundi.';

  @override
  String get widgetMixNewMixBody =>
      'Le recrée avec tes favoris, ce que tu écoutes le plus et des titres similaires. Ça se fait déjà tout seul chaque lundi.';

  @override
  String get widgetMixNotNow => 'Pas maintenant';

  @override
  String get widgetMixBuildingDiscoveries => 'Création de tes Descobertas…';

  @override
  String get widgetMixBuildingMix => 'Création de ton Mix…';

  @override
  String widgetMixBuiltOn(String date) {
    return 'Créé le $date';
  }

  @override
  String get widgetMixRedo => 'Recréer';

  @override
  String get widgetMixRefresh => 'Actualiser';

  @override
  String get widgetMixCreateDiscoveries => 'Crée tes Descobertas de la semaine';

  @override
  String get widgetMixCreateMix => 'Crée ton Mix de la semaine';

  @override
  String get widgetMixCreateRadar => 'Crée ton Radar des nouveautés';

  @override
  String get widgetMixCreateDaylist => 'Crée ta daylist';

  @override
  String get widgetOfflineBanner =>
      'Pas de connexion · affichage de ce qui est enregistré sur ton appareil';

  @override
  String widgetOfflineDownloadingProgress(int done, int total) {
    return 'Téléchargement $done sur $total';
  }

  @override
  String get widgetUpdateReady => 'Nouvelle version de Pudim prête';

  @override
  String widgetUpdateReadyNotes(String notes) {
    return 'Nouvelle version de Pudim · $notes';
  }

  @override
  String get widgetUpdateAction => 'Mettre à jour';

  @override
  String widgetSleepShortMinutes(int count) {
    return '$count min';
  }

  @override
  String widgetSleepShortSeconds(int count) {
    return '$count s';
  }

  @override
  String get widgetSleepStopsAtEnd => 'S’arrête à la fin du titre';

  @override
  String widgetSleepStopsIn(String time) {
    return 'S’arrête dans $time';
  }

  @override
  String get widgetSleepTimer => 'Minuteur de sommeil';

  @override
  String get widgetSleepTurnOff => 'Désactiver le minuteur';

  @override
  String get widgetSleepOneHour => '1 heure';

  @override
  String get widgetSleepOneAndHalfHours => '1 heure 30 minutes';

  @override
  String get widgetSleepEndOfSong => 'Fin du titre';

  @override
  String get widgetSleepTurnedOff => 'Minuteur désactivé';

  @override
  String get widgetSleepStopsWhenSongEnds =>
      'La musique s’arrête à la fin de ce titre';

  @override
  String widgetSleepSongStopsIn(String time) {
    return 'La musique s’arrête dans $time';
  }

  @override
  String get widgetSpeedPodcast => 'Vitesse du podcast';

  @override
  String get widgetCommonCatalogBadge =>
      'Du catalogue : pas encore dans ta bibliothèque';

  @override
  String get widgetCommonShowAll => 'Tout afficher';

  @override
  String get widgetCommonSomethingWentWrong => 'Une erreur s’est produite';

  @override
  String get widgetCommonListenDownloaded => 'Écouter les titres téléchargés';

  @override
  String get widgetTracksTitle => 'Titre';

  @override
  String get widgetTracksDateAdded => 'Date d’ajout';

  @override
  String widgetTracksAddedBy(String name) {
    return 'par $name';
  }

  @override
  String get widgetTracksMoreOptions => 'Plus d’options';

  @override
  String widgetTracksAddedDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get castTooltip => 'Caster';

  @override
  String get castTitle => 'Lire sur';

  @override
  String get castThisDevice => 'Cet appareil';

  @override
  String get castSearching => 'Recherche d’appareils sur le réseau…';

  @override
  String get castNone =>
      'Aucun Chromecast trouvé. Il doit être sur le même Wi-Fi.';

  @override
  String get castSearchAgain => 'Rechercher à nouveau';

  @override
  String get castStop => 'Arrêter de caster';

  @override
  String castPlayingOn(String name) {
    return 'Lecture sur $name';
  }

  @override
  String castFailed(String name) {
    return 'Impossible de se connecter à $name';
  }
}
