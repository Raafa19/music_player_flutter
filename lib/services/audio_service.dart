import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/utils/media_item.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  static final _audioQuery = OnAudioQuery();
  static final _player = AudioPlayer();

  // void dispose() {
  //   _player.dispose();
  // }

  void reindex() async {
    await _audioQuery.queryWithFilters("", WithFiltersType.ALBUMS);
  }

  // Load Songs
  Future<ConcatenatingAudioSource> _createLoad(List<SongModel>? songs) async {
    List<AudioSource> sources = [];
    Set<String> titulos = <String>{};

    for (var song in songs!) {
      final key =
          "${song.title.trim().toLowerCase()}-${song.artist?.trim().toLowerCase() ?? ''}";
      if (titulos.add(key)) {
        sources.add(
          AudioSource.uri(
            Uri.parse(song.uri!),
            tag: songModeltoMediaItem(song),
          ),
        );
      }
    }

    return ConcatenatingAudioSource(
      useLazyPreparation: true,
      children: sources.toSet().toList(),
    );
  }

  void loadSongs(
      {List<SongModel>? songs,
      List<IndexedAudioSource>? songsSource,
      required int index,
      required bool shuffle}) async {
    if (songs == null && songsSource == null) return;

    await stop();

    if (songsSource != null) {
      await _player.setAudioSource(
          ConcatenatingAudioSource(children: songsSource),
          initialIndex: index);
    } else {
      final playlist = await _createLoad(songs);

      await _player.setAudioSource(playlist, initialIndex: index);
    }

    _player.setShuffleModeEnabled(shuffle);

    await play();
  }

  // Query Songs
  Future<List<SongModel>> allSongs() => _audioQuery.querySongs();

  Future<SongModel> querySongById(int id) async {
    var songs = await allSongs();
    return songs
        .where(
          (element) => element.id == id,
        )
        .first;
  }

  Future<List<SongModel>> songsByArtist(ArtistModel artist) =>
      _audioQuery.queryAudiosFrom(AudiosFromType.ARTIST, artist.artist);

  Future<List<AlbumModel>> allAlbums() => _audioQuery.queryAlbums();

  Future<List<SongModel>> songsInAlbum(AlbumModel album) {
    return _audioQuery.queryAudiosFrom(AudiosFromType.ALBUM, album.album);
  }

  Future<List<ArtistModel>> allArtists() => _audioQuery.queryArtists();

  Future<List<AlbumModel>> albumsInArtist(ArtistModel artist) {
    return _audioQuery.queryAlbums().then(
      (value) {
        return value
            .where(
              (element) => element.artist == artist.artist,
            )
            .toList();
      },
    );
  }

  Future<List<SongModel>> allSongsFromArtist(ArtistModel artist) {
    return _audioQuery.queryAudiosFrom(AudiosFromType.ARTIST, artist.artist);
  }

  Future<List<SongModel>> allSongsFromAlbum(AlbumModel album) {
    return _audioQuery.queryAudiosFrom(AudiosFromType.ALBUM, album.album,
        sortType: SongSortType.DISPLAY_NAME);
  }

  // Player Actions
  Future<void> play() => _player.playing ? _player.pause() : _player.play();
  Future<void> stop() => _player.stop();
  Future<void> nextSong() => _player.seekToNext();
  Future<void> prevSong() => _player.seekToPrevious();
  Stream<bool> playing() => _player.playingStream;
  Future<void> seekTo(int index) => _player.seek(null, index: index);

  // Loop Actions
  Stream<LoopMode> loopMode() => _player.loopModeStream;
  void toggleLoop() {
    switch (_player.loopMode) {
      case LoopMode.off:
        _player.setLoopMode(LoopMode.all);
        break;
      case LoopMode.all:
        _player.setLoopMode(LoopMode.one);
        break;
      default:
        _player.setLoopMode(LoopMode.off);
    }
  }

  // Shuffle Actions
  Stream<bool> shuffleMode() => _player.shuffleModeEnabledStream;
  Future<void> toggleShuffle() {
    if (!_player.shuffleModeEnabled) {
      _player.shuffle();
    }
    return _player.setShuffleModeEnabled(!_player.shuffleModeEnabled);
  }

  // Songs Streams
  Stream<int?> currentIndexStream() =>
      _player.currentIndexStream.asBroadcastStream();

  // Stream get shuffleIndexStream => _player.sequenceStateStream;

  Stream<SequenceState?> get sequenceStateStream =>
      _player.sequenceStateStream.asBroadcastStream();

  Stream<Duration?> get _durationStream =>
      _player.durationStream.asBroadcastStream();

  Stream<Duration> get _positionStream =>
      _player.positionStream.asBroadcastStream();

// SeekBar
  Stream<DurationState> get durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
        _positionStream,
        _durationStream,
        (position, duration) =>
            DurationState(position: position, total: duration ?? Duration.zero),
      );

  Future<void> seek(Duration time) => _player.seek(time);

  // Permission
  Future<bool> permissionStatus() async {
    return await _audioQuery.permissionsStatus();
  }

  Future<bool> requestPermission() async =>
      await _audioQuery.permissionsRequest();

  Future<List<PlaylistModel>> allPlaylists() async {
    return _audioQuery.queryPlaylists(sortType: PlaylistSortType.DATE_ADDED);
  }
}

class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}
