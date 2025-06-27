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
        child: Column(
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
      ),
    );
  }
}
