import 'dart:math';

import 'package:flutter/material.dart';
import 'package:music_player/screens/main_screen/widgets/song_display.dart';
import 'package:music_player/screens/widgets/add_to_playlist_dialog.dart';
import 'package:music_player/services/audio_service.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AllSongsTab extends StatefulWidget {
  const AllSongsTab({super.key});

  @override
  State<AllSongsTab> createState() => _AllSongsTabState();
}

class _AllSongsTabState extends State<AllSongsTab> {
  final _audioService = AudioService();
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double alto = MediaQuery.sizeOf(context).height;

    return FutureBuilder<List<SongModel>>(
      future: _audioService.allSongs,
      builder: (context, allSongsList) {
        if (allSongsList.hasData) {
          return Stack(
            children: [
              Scrollbar(
                interactive: true,
                controller: _scrollController,
                child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                      right: 15, left: 15, top: 15, bottom: alto * 0.12),
                  itemCount: allSongsList.data!.length,
                  itemBuilder: (context, index) {
                    return Material(
                      child: InkWell(
                          onTap: () {
                            _audioService.loadSongs(
                                songs: allSongsList.data,
                                index: index,
                                shuffle: false);
                          },
                          onLongPress: () async {
                            await addSongToPlaylist(
                                context, allSongsList.data![index]);
                          },
                          child: SongDisplay(song: allSongsList.data![index])),
                    );
                  },
                ),
              ),
              StreamBuilder(
                  stream: _audioService.sequenceStateStream,
                  builder: (context, sequenceState) {
                    return Positioned(
                      bottom: sequenceState.hasData ? alto * 0.13 : 10,
                      right: 15,
                      child: FloatingActionButton(
                        child: const Icon(Icons.shuffle),
                        onPressed: () {
                          _audioService.loadSongs(
                              songs: allSongsList.data ?? List.empty(),
                              index: Random()
                                  .nextInt(allSongsList.data!.length - 1),
                              shuffle: true);
                        },
                      ),
                    );
                  }),
            ],
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
