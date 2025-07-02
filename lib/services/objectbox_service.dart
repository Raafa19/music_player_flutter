import 'package:music_player/models/song_model.dart';
import 'package:music_player/objectbox.g.dart';
import 'package:music_player/services/audio_service.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ObxService {
  /// The Store of this app.
  late final Store _store;

  // Boxes
  late Box<Playlist> _playListBox;
  late Box<Song> _songsBox;

  final _audioService = AudioService();

  /// Nueva Playlist
  void addPlaylist(Playlist playlist) {
    _playListBox.put(playlist);
  }

  /// Borrar Playlist
  void deletePlaylist(int? playlistId) {
    if (playlistId == null) return;
    _playListBox.remove(playlistId);
  }

  /// Stream de Playlists
  Stream<List<Playlist>> allPlaylistsStream() {
    return _playListBox.query().watch(triggerImmediately: true).map(
          (event) => event.find(),
        );
  }

  /// Stream de una playlist
  Stream<Playlist> playlistById(int? id) {
    if (id == null) return const Stream.empty();
    return _playListBox
        .query(Playlist_.id.equals(id))
        .watch(triggerImmediately: true)
        .map((event) => event.find().first);
  }

  /// Stream con canciones de un playlist
  Stream<List<SongModel>> streamCancionesDePlaylist(int? playlistId) {
    if (playlistId == null) return const Stream.empty();
    return _playListBox
        .query(Playlist_.id.equals(playlistId))
        .watch(triggerImmediately: true)
        .map((query) {
      final playlist = query.findFirst();
      return playlist?.songsList.songListToSongModelList() ?? [];
    });
  }

  /// Agrega una canción a una playlist
  void addSongToPlaylist({required Song newSong, required int? playlistId}) {
    if (playlistId == null) return;
    if (newSong.audioQueryId == null) return;

    final playlist = _playListBox.get(playlistId);
    if (playlist == null) return;

    Song? existingSong = _songsBox
        .query(Song_.audioQueryId.equals(newSong.audioQueryId!))
        .build()
        .findFirst();

    if (existingSong == null) {
      _songsBox.put(newSong);
    }

    final songToAdd = existingSong ?? newSong;

    final alreadyInPlaylist =
        playlist.songsList.any((s) => s.id == songToAdd.id);

    if (!alreadyInPlaylist) {
      playlist.songsList.add(songToAdd);
      playlist.songsList.applyToDb();
      _playListBox.put(playlist);
    }
  }

  /// Elimina una canción de una playlist
  void removeSongFromPlaylist({required Song song, required int? playlistId}) {
    if (playlistId == null) return;

    final playlist = _playListBox.get(playlistId);
    if (playlist == null) return;

    playlist.songsList.removeWhere(
      (e) => e.audioQueryId == song.audioQueryId,
    );
    playlist.songsList.applyToDb();
    _playListBox.put(playlist);
  }

  Future<void> cleanSongs() async {
    final currentDeviceSongs = await _audioService.allSongs;
    final Set<int> currentIds = currentDeviceSongs.map((s) => s.id).toSet();

    final currentBoxSongs = _songsBox.getAll();

    final deletedSongs = currentBoxSongs
        .where((song) => !currentIds.contains(song.audioQueryId))
        .toList();

    for (final playlist in _playListBox.getAll()) {
      playlist.songsList.removeWhere(
          (song) => deletedSongs.any((deleted) => deleted.id == song.id));
      playlist.songsList.applyToDb();
      _playListBox.put(playlist);
    }

    _songsBox.removeMany(deletedSongs.map((s) => s.id!).toList());
  }

  ObxService._create(this._store) {
    _playListBox = Box<Playlist>(_store);
    _songsBox = Box<Song>(_store);
  }

  static Future<ObxService> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store =
        await openStore(directory: p.join(docsDir.path, "obx-example"));

    return ObxService._create(store);
  }
}

late ObxService obx;
