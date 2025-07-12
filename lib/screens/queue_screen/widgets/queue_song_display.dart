import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class QueueSongDisplay extends StatelessWidget {
  final SongModel song;
  const QueueSongDisplay({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    double alto = MediaQuery.of(context).size.height;
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
                nullArtworkWidget: Container(
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
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  song.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  song.artist ?? "Desconocido",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
