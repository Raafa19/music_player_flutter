import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

MediaItem songModeltoMediaItem(SongModel songModel) {
  return MediaItem(
      id: songModel.id.toString(),
      title: songModel.title,
      album: songModel.album,
      artist: songModel.artist,
      displayTitle: songModel.title,
      duration: Duration(milliseconds: songModel.duration!),
      extras: {
        'url': songModel.uri,
        'displayNameWoExt': songModel.displayNameWOExt,
        'data': songModel.data,
        'displayName': songModel.displayName,
        'size': songModel.size,
        'fileExtension': songModel.fileExtension
      });
}

SongModel mediaItemtoSongModel(MediaItem mediaItem) {
  return SongModel({
    '_id': int.tryParse(mediaItem.id) ?? 0,
    'title': mediaItem.title,
    'artist': mediaItem.artist,
    'album': mediaItem.album,
    'duration': mediaItem.duration?.inMilliseconds,
    '_display_name_wo_ext': mediaItem.extras!['displayNameWoExt'],
    '_uri': mediaItem.extras!['url'],
    '_data': mediaItem.extras!['data'],
    '_display_name': mediaItem.extras!['displayName'],
    '_size': mediaItem.extras!['size'],
    'file_extension': mediaItem.extras!['fileExtension']
  });
}
