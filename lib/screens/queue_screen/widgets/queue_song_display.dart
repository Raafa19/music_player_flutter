import 'package:flutter/material.dart';
import 'package:music_player/services/objectbox_service.dart';
import 'package:music_player/utils/duration_utils.dart';
import 'package:on_audio_query/on_audio_query.dart';

class QueueSongDisplay extends StatelessWidget {
  final SongModel song;
  const QueueSongDisplay({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    double alto = MediaQuery.of(context).size.height;
    double ancho = MediaQuery.of(context).size.width;
    return Container(
      height: alto * 0.09,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context)
                .colorScheme
                .onPrimaryContainer
                .withValues(alpha: 0.8),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 50,
                  child: StreamBuilder(
                      stream: obx.streamFavoritePlaylistSongs(),
                      builder: (context, favorites) {
                        List<SongModel>? songs = favorites.data;
                        return Stack(
                          children: [
                            QueryArtworkWidget(
                              id: song.id,
                              type: ArtworkType.AUDIO,
                              size: 100,
                              quality: 100,
                              artworkBorder: BorderRadius.zero,
                              keepOldArtwork: true,
                              nullArtworkWidget: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  width: 50,
                                  color: const Color.fromARGB(255, 78, 76, 76),
                                  child: const Center(
                                    child: Icon(
                                      Icons.music_note,
                                      size: 35,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            songs != null && songs.isNotEmpty
                                ? songs
                                        .where(
                                          (element) => element.id == song.id,
                                        )
                                        .isNotEmpty
                                    ? Positioned(
                                        bottom: 2,
                                        right: 2,
                                        child: Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          shadows: [
                                            BoxShadow(
                                                spreadRadius: 5,
                                                blurRadius: 5,
                                                color: Colors.black
                                                    .withValues(alpha: 0.5),
                                                offset: Offset(1, 1))
                                          ],
                                        ),
                                      )
                                    : SizedBox()
                                : SizedBox()
                          ],
                        );
                      }),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: ancho * 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        song.title,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        song.artist ?? "Desconocido",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              durationToString(Duration(milliseconds: song.duration ?? 0)),
              style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
