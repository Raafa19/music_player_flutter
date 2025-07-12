import 'package:music_player/models/song_model.dart';
import 'package:music_player/objectbox.g.dart';
import 'package:music_player/services/audio_service.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ObxService {
  late final Store _store;

  // Boxes
  late Box<Playlist> _playlistBox;
  late Box<Song> _songsBox;

  final _audioService = AudioService();

  void addPlaylist(Playlist playlist) {
    _playlistBox.put(playlist);
  }

  void deletePlaylist(int? playlistId) {
    if (playlistId == null) return;
    _playlistBox.remove(playlistId);
  }

  Stream<List<Playlist>> allPlaylistsStream() {
    return _playlistBox.query().watch(triggerImmediately: true).map(
          (event) => event.find(),
        );
  }

  Stream<Playlist> streamPlaylistById(int? id) {
    if (id == null) return const Stream.empty();
    return _playlistBox
        .query(Playlist_.id.equals(id))
        .watch(triggerImmediately: true)
        .map((event) => event.find().first);
  }

  Stream<List<SongModel>> streamPlaylistSongs(int? playlistId) {
    if (playlistId == null) return const Stream.empty();
    return _playlistBox
        .query(Playlist_.id.equals(playlistId))
        .watch(triggerImmediately: true)
        .map((query) {
      final playlist = query.findFirst();
      return playlist?.songsList.songListToSongModelList() ?? [];
    });
  }

  void addSongToPlaylist({required Song newSong, required int? playlistId}) {
    if (playlistId == null) return;
    if (newSong.audioQueryId == null) return;

    final playlist = _playlistBox.get(playlistId);
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
      _playlistBox.put(playlist);
    }
  }

  void removeSongFromPlaylist({required Song song, required int? playlistId}) {
    if (playlistId == null) return;

    final playlist = _playlistBox.get(playlistId);
    if (playlist == null) return;

    playlist.songsList.removeWhere(
      (e) => e.audioQueryId == song.audioQueryId,
    );
    playlist.songsList.applyToDb();
    _playlistBox.put(playlist);
  }

  Future<void> cleanSongs() async {
    final currentDeviceSongs = await _audioService.allSongs;
    final Set<int> currentIds = currentDeviceSongs.map((s) => s.id).toSet();

    final currentBoxSongs = _songsBox.getAll();

    final deletedSongs = currentBoxSongs
        .where((song) => !currentIds.contains(song.audioQueryId))
        .toList();

    for (final playlist in _playlistBox.getAll()) {
      playlist.songsList.removeWhere(
          (song) => deletedSongs.any((deleted) => deleted.id == song.id));
      playlist.songsList.applyToDb();
      _playlistBox.put(playlist);
    }

    _songsBox.removeMany(deletedSongs.map((s) => s.id!).toList());
  }

  // Favoritos
  void createFavoritePlaylist() {
    List<Playlist> playlists = _playlistBox.getAll();

    if (playlists
        .where(
          (playlist) => playlist.name == "Favoritas",
        )
        .isEmpty) {
      addPlaylist(Playlist(name: "Favoritas"));
    }
  }

  void addSongToFavorites(Song song) {
    List<Playlist> playlists = _playlistBox.getAll();
    Playlist favorites = playlists.firstWhere(
      (playlist) => playlist.name == "Favoritas",
    );
    addSongToPlaylist(newSong: song, playlistId: favorites.id);
  }

  void removeSongFromFavorite(Song? song) {
    if (song == null) {
      return;
    }
    List<Playlist> playlists = _playlistBox.getAll();
    Playlist favorites = playlists.firstWhere(
      (playlist) => playlist.name == "Favoritas",
    );
    removeSongFromPlaylist(song: song, playlistId: favorites.id);
  }

  Stream<List<SongModel>> streamFavoritePlaylistSongs() {
    return _playlistBox
        .query(Playlist_.name.equals("Favoritas"))
        .watch(triggerImmediately: true)
        .map((query) {
      final playlist = query.findFirst();
      return playlist?.songsList.songListToSongModelList() ?? [];
    });
  }

  ObxService._create(this._store) {
    _playlistBox = Box<Playlist>(_store);
    _songsBox = Box<Song>(_store);
    createFavoritePlaylist();
  }

  static Future<ObxService> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store =
        await openStore(directory: p.join(docsDir.path, "obx-example"));

    return ObxService._create(store);
  }
}

late ObxService obx;
