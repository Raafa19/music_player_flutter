import 'package:flutter/material.dart';
import 'package:music_player/services/audio_service.dart';
import 'package:on_audio_query/on_audio_query.dart';

class BottomPlayer extends StatefulWidget {
  const BottomPlayer({super.key});

  @override
  State<BottomPlayer> createState() => _BottomPlayerState();
}

class _BottomPlayerState extends State<BottomPlayer> {
  final _audioService = AudioService();

  @override
  Widget build(BuildContext context) {
    double alto = MediaQuery.sizeOf(context).height;
    double ancho = MediaQuery.sizeOf(context).width;

    return StreamBuilder(
        stream: _audioService.sequenceStateStream,
        builder: (context, sequenceState) {
          return Container(
            height: alto * 0.1,
            width: ancho * 0.95,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: Row(
              children: [
                SizedBox(
                  width: ancho * 0.2,
                  height: alto * 0.09,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: QueryArtworkWidget(
                      id: int.tryParse(
                              sequenceState.data?.currentSource?.tag.id ??
                                  "0") ??
                          0,
                      type: ArtworkType.AUDIO,
                      artworkBorder: BorderRadius.circular(5),
                      keepOldArtwork: true,
                      size: 360,
                      quality: 100,
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
                const SizedBox(
                  width: 5,
                ),
                SizedBox(
                  width: ancho * 0.43,
                  height: alto * 0.1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        sequenceState.data?.currentSource?.tag.title ?? "-",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        sequenceState.data?.currentSource?.tag.artist ?? "-",
                        style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w300),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                StreamBuilder(
                    stream: _audioService.playing,
                    builder: (context, playing) {
                      return IconButton(
                        onPressed: () async {
                          await _audioService.play();
                        },
                        icon: Icon(
                            playing.data ?? false
                                ? Icons.pause_circle
                                : Icons.play_circle,
                            size: alto * 0.06),
                      );
                    }),
                IconButton(
                  onPressed: () async {
                    await _audioService.nextSong();
                  },
                  icon: Icon(Icons.skip_next, size: alto * 0.04),
                ),
              ],
            ),
          );
        });
  }
}
