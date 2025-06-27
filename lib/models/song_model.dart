import 'package:objectbox/objectbox.dart';
import 'package:on_audio_query/on_audio_query.dart';

@Entity()
class Playlist {
  @Id()
  int? id;

  @Unique()
  String name;

  final songsList = ToMany<Song>();

  Playlist({this.id, required this.name});
}

@Entity()
class Song {
  @Id()
  int? id;

  int? audioQueryId;

  String data;

  final playlist = ToMany<Playlist>();

  String? uri;

  String displayName;

  String? displayNameWOExt;

  int size;

  String? album;

  int? albumId;

  String? artist;

  int? artistId;

  String? composer;

  int? dateAdded;

  int? duration;

  String title;

  int? track;

  String? fileExtension;

  Song(
      {this.audioQueryId,
      this.id,
      required this.data,
      this.uri,
      required this.displayName,
      this.displayNameWOExt,
      required this.size,
      this.album,
      this.albumId,
      this.artist,
      this.artistId,
      this.composer,
      this.dateAdded,
      this.duration,
      required this.title,
      this.track,
      this.fileExtension});

  static Song songModeltoSong(SongModel songModel) {
    return Song(
      audioQueryId: songModel.id,
      data: songModel.data,
      uri: songModel.uri,
      displayNameWOExt: songModel.displayNameWOExt,
      displayName: songModel.displayName,
      size: songModel.size,
      album: songModel.album,
      albumId: songModel.albumId,
      artist: songModel.artist,
      artistId: songModel.artistId,
      composer: songModel.composer,
      dateAdded: songModel.dateAdded,
      duration: songModel.duration,
      title: songModel.title,
      track: songModel.track,
      fileExtension: songModel.fileExtension,
    );
  }

  static SongModel songToSongModel(Song song) {
    return SongModel({
      "_id": song.audioQueryId,
      "_data": song.data,
      "_uri": song.uri,
      "_displayNameWOExt": song.displayNameWOExt,
      "_displayName": song.displayName,
      "_size": song.size,
      "album": song.album,
      "albumId": song.albumId,
      "artist": song.artist,
      "artistId": song.artistId,
      "composer": song.composer,
      "dateAdded": song.dateAdded,
      "duration": song.duration,
      "title": song.title,
      "track": song.track,
      "fileExtension": song.fileExtension,
    });
  }
}

extension SongFormatter on List<Song> {
  List<SongModel> songListToSongModelList() {
    return map(
      (e) => Song.songToSongModel(e),
    ).toList();
  }
}
