import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

MediaItem songModeltoMediaItem(SongModel songModel) {
  return MediaItem(
      id: songModel.id.toString(),
      title: songModel.title,
      album: songModel.album,
      artist: songModel.artist,
      displayTitle: songModel.displayNameWOExt,
      duration: Duration(milliseconds: songModel.duration!),
      extras: {
        'url': songModel.uri,
      });
}

SongModel mediaItemtoSongModel(MediaItem mediaItem) {
  return SongModel({
    '_id': int.tryParse(mediaItem.id) ?? 0,
    'title': mediaItem.title,
    'artist': mediaItem.artist,
    'album': mediaItem.album,
    'duration': mediaItem.duration?.inMilliseconds,
    '_display_name_wo_ext': mediaItem.displayTitle,
    '_uri': mediaItem.extras!['url'],
  });
}
