import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ArtistDisplay extends StatelessWidget {
  final ArtistModel artist;
  const ArtistDisplay({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.sizeOf(context).width;
    return Stack(
      children: [
        Positioned.fill(
          child: QueryArtworkWidget(
            id: artist.id,
            type: ArtworkType.ARTIST,
            size: 360,
            quality: 100,
            artworkBorder: BorderRadius.zero,
            keepOldArtwork: true,
            nullArtworkWidget: Container(
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
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.black.withValues(alpha: 0.7),
                width: ancho,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    artist.artist,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
