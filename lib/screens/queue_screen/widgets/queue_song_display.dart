import 'package:flutter/material.dart';
import 'package:music_player/services/objectbox_service.dart';
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
                  child: QueryArtworkWidget(
                    id: song.id,
                    type: ArtworkType.AUDIO,
                    size: 100,
                    quality: 100,
                    artworkBorder: BorderRadius.zero,
                    keepOldArtwork: true,
                    nullArtworkWidget: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
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
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: ancho * 0.65,
                      child: Text(
                        song.title,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ancho * 0.65,
                      child: Text(
                        song.artist ?? "Desconocido",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            StreamBuilder(
                stream: obx.streamFavoritePlaylistSongs(),
                builder: (context, favorites) {
                  List<SongModel>? songs = favorites.data;
                  if (songs != null) {
                    if (songs
                        .where(
                          (element) => element.id == song.id,
                        )
                        .isNotEmpty) {
                      return const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      );
                    }
                  }
                  return const SizedBox();
                })
          ],
        ),
      ),
    );
  }
}
