import 'dart:math';

import 'package:flutter/material.dart';
import 'package:music_player/screens/main_screen/widgets/song_display.dart';
import 'package:music_player/screens/widgets/add_to_playlist_dialog.dart';
import 'package:music_player/services/audio_service.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ArtistScreen extends StatefulWidget {
  final ArtistModel artist;
  const ArtistScreen({super.key, required this.artist});

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  final _audioService = AudioService();
  final _cancionesScroller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SongModel>>(
        future: _audioService.allSongsFromArtist(widget.artist),
        builder: (context, artistSongsList) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.artist.artist),
            ),
            body: Builder(
              builder: (context) {
                if (artistSongsList.hasData) {
                  return Scrollbar(
                    interactive: true,
                    controller: _cancionesScroller,
                    child: ListView.builder(
                      controller: _cancionesScroller,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(
                          right: 15, left: 15, top: 15, bottom: 50),
                      itemCount: artistSongsList.data!.length,
                      itemBuilder: (context, index) {
                        return Material(
                          child: InkWell(
                              onTap: () {
                                _audioService.loadSongs(
                                    songs: artistSongsList.data,
                                    index: index,
                                    shuffle: false);
                                Navigator.pop(context);
                              },
                              onLongPress: () async {
                                await addSongToPlaylist(
                                    context, artistSongsList.data![index]);
                              },
                              child: SongDisplay(
                                  song: artistSongsList.data![index])),
                        );
                      },
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.shuffle),
              onPressed: () {
                _audioService.loadSongs(
                    songs: artistSongsList.data ?? List.empty(),
                    index: Random().nextInt(artistSongsList.data!.length - 1),
                    shuffle: true);
                Navigator.pop(context);
              },
            ),
          );
        });
  }
}
