import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/screens/main_screen/widgets/song_display.dart';
import 'package:music_player/screens/player_screen/widgets/player_playbar.dart';
import 'package:music_player/screens/queue_screen/widgets/queue_song_display.dart';
import 'package:music_player/services/audio_service.dart';
import 'package:music_player/utils/media_item.dart';

class QueueScreen extends StatefulWidget {
  const QueueScreen({super.key});

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  final _audioService = AudioService();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double alto = MediaQuery.of(context).size.height;
    double ancho = MediaQuery.of(context).size.width;

    return StreamBuilder(
        stream: _audioService.sequenceStateStream,
        builder: (context, sequenceState) {
          int queueCount() {
            int count = 0;

            count = (sequenceState.data?.effectiveSequence.length ?? 0) -
                (sequenceState.data?.effectiveSequence.indexOf(
                        sequenceState.data?.currentSource ??
                            AudioSource.uri(Uri.parse(""))) ??
                    0);
            return (count > 0 ? count - 1 : 0);
          }

          int trueCurrentIndex() {
            if (sequenceState.data?.shuffleModeEnabled ?? false) {
              return sequenceState.data?.effectiveSequence.indexOf(
                      sequenceState.data?.currentSource ??
                          AudioSource.uri(Uri.parse(""))) ??
                  0;
            }
            return sequenceState.data?.currentIndex ?? 0;
          }

          int indexOfSong(String uri) {
            return sequenceState.data?.sequence.indexWhere(
                    (element) => element.tag.extras["url"] == uri) ??
                0;
          }

          return Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: SizedBox(
              height: alto,
              width: ancho,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Reproduciendo",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    sequenceState.hasData &&
                            sequenceState.data!.sequence.isNotEmpty
                        ? SongDisplay(
                            song: sequenceState.data
                                ?.effectiveSequence[trueCurrentIndex()].tag)
                        : const SizedBox(),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Siguiente:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: queueCount(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            child: QueueSongDisplay(
                                song: mediaItemtoSongModel(sequenceState
                                        .data
                                        ?.effectiveSequence[
                                            trueCurrentIndex() + index + 1]
                                        .tag ??
                                    const MediaItem(id: "0", title: "-"))),
                            onTap: () {
                              _audioService.seekTo(indexOfSong(sequenceState
                                  .data
                                  ?.effectiveSequence[
                                      trueCurrentIndex() + index + 1]
                                  .tag
                                  .extras["url"]));
                              scrollController.animateTo(0,
                                  duration: const Duration(milliseconds: 150),
                                  curve: Curves.easeIn);
                            },
                          );
                        },
                      ),
                    ),
                    const PlayerPlaybar()
                  ],
                ),
              ),
            ),
          );
        });
  }
}
