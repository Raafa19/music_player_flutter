import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumDisplay extends StatelessWidget {
  final AlbumModel album;
  const AlbumDisplay({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.sizeOf(context).width;
    return Stack(
      children: [
        Positioned.fill(
          child: QueryArtworkWidget(
            id: album.id,
            type: ArtworkType.ALBUM,
            size: 360,
            quality: 100,
            artworkBorder: BorderRadius.zero,
            //keepOldArtwork: true,
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
                    album.album,
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
