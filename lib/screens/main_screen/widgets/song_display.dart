import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongDisplay extends StatelessWidget {
  final dynamic song;
  const SongDisplay({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    double alto = MediaQuery.sizeOf(context).height;
    double ancho = MediaQuery.sizeOf(context).width;

    return SizedBox(
      width: ancho,
      height: alto * 0.1,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: SizedBox(
              width: ancho * 0.2,
              height: alto * 0.1,
              child: QueryArtworkWidget(
                id: song.id is String ? int.tryParse(song.id) : song.id ?? 0,
                type: ArtworkType.AUDIO,
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
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    song?.title ?? "-",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    song?.artist ?? "Desconocido",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
