import 'package:flutter/material.dart';
import 'package:music_player/models/song_model.dart';
import 'package:music_player/screens/player_screen/widgets/player_playbar.dart';
import 'package:music_player/screens/player_screen/widgets/player_seekbar.dart';
import 'package:music_player/screens/queue_screen/queue_screen.dart';
import 'package:music_player/services/audio_service.dart';
import 'package:music_player/services/objectbox_service.dart';
import 'package:music_player/utils/media_item.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerModalScreen extends StatefulWidget {
  const PlayerModalScreen({
    super.key,
  });

  @override
  State<PlayerModalScreen> createState() => _PlayerModalScreenState();
}

class _PlayerModalScreenState extends State<PlayerModalScreen> {
  final _audioService = AudioService();

  @override
  Widget build(BuildContext context) {
    double alto = MediaQuery.sizeOf(context).height;
    double ancho = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_downward),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder(
          stream: _audioService.sequenceStateStream,
          builder: (context, sequenceState) {
            return StreamBuilder(
                stream: _audioService.currentIndexStream,
                builder: (context, currentIndex) {
                  return Container(
                    color: Theme.of(context).colorScheme.surface,
                    height: alto,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: ancho,
                            height: alto * 0.45,
                            child: QueryArtworkWidget(
                              id: int.tryParse(sequenceState
                                          .data?.currentSource?.tag.id ??
                                      "0") ??
                                  0,
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
                          const SizedBox(
                            height: 25,
                          ),
                          SizedBox(
                            height: alto * 0.1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      sequenceState
                                              .data?.currentSource?.tag.title
                                              .toString() ??
                                          "-",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis),
                                      maxLines: 1,
                                    ),
                                    Text(
                                      sequenceState
                                              .data?.currentSource?.tag.artist
                                              .toString() ??
                                          "Desconocido",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          overflow: TextOverflow.ellipsis),
                                      maxLines: 1,
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
                                              (element) =>
                                                  element.id.toString() ==
                                                  sequenceState.data
                                                      ?.currentSource?.tag.id,
                                            )
                                            .isNotEmpty) {
                                          return IconButton(
                                              onPressed: () {
                                                obx.removeSongFromFavorite(
                                                    Song.songModeltoSong(
                                                        mediaItemtoSongModel(
                                                            sequenceState
                                                                .data
                                                                ?.currentSource
                                                                ?.tag)));
                                                setState(() {});
                                              },
                                              icon: const Icon(Icons.favorite,
                                                  size: 30, color: Colors.red));
                                        }
                                        return IconButton(
                                            onPressed: () {
                                              obx.addSongToFavorites(
                                                  Song.songModeltoSong(
                                                      mediaItemtoSongModel(
                                                          sequenceState
                                                              .data
                                                              ?.currentSource
                                                              ?.tag)));
                                              setState(() {});
                                            },
                                            icon: const Icon(
                                              Icons.favorite_border,
                                              size: 30,
                                            ));
                                      } else {
                                        return IconButton(
                                            onPressed: () {
                                              obx.addSongToFavorites(
                                                  Song.songModeltoSong(
                                                      mediaItemtoSongModel(
                                                          sequenceState
                                                              .data
                                                              ?.currentSource
                                                              ?.tag)));
                                              setState(() {});
                                            },
                                            icon: const Icon(
                                              Icons.favorite_border,
                                              size: 30,
                                            ));
                                      }
                                    }),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const PlayerSeekbar(),
                          const SizedBox(
                            height: 10,
                          ),
                          const PlayerPlaybar(),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(context, _toQueueRoute());
                                  },
                                  icon: const Icon(Icons.menu))
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }

  Route _toQueueRoute() {
    return PageRouteBuilder<void>(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => const QueueScreen(),
        transitionsBuilder:
            (context, Animation<double> animation, ___, Widget child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }
}
