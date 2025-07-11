import 'dart:math';

import 'package:flutter/material.dart';
import 'package:music_player/screens/main_screen/widgets/song_display.dart';
import 'package:music_player/screens/widgets/add_to_playlist_dialog.dart';
import 'package:music_player/services/audio_service.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumScreen extends StatefulWidget {
  final AlbumModel album;
  const AlbumScreen({super.key, required this.album});

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  final _audioService = AudioService();
  final _cancionesScroller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SongModel>>(
        future: _audioService.allSongsFromAlbum(widget.album),
        builder: (context, albumSongsList) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.album.album),
            ),
            body: Builder(
              builder: (context) {
                if (albumSongsList.hasData) {
                  return Scrollbar(
                    interactive: true,
                    controller: _cancionesScroller,
                    child: ListView.builder(
                      controller: _cancionesScroller,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(
                          right: 15, left: 15, top: 15, bottom: 50),
                      itemCount: albumSongsList.data!.length,
                      itemBuilder: (context, index) {
                        return Material(
                          child: InkWell(
                              onTap: () {
                                _audioService.loadSongs(
                                    songs: albumSongsList.data,
                                    index: index,
                                    shuffle: false);
                                Navigator.pop(context);
                              },
                              onLongPress: () async {
                                await addSongToPlaylist(
                                    context, albumSongsList.data![index]);
                              },
                              child: SongDisplay(
                                  song: albumSongsList.data![index])),
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
                    songs: albumSongsList.data ?? List.empty(),
                    index: Random().nextInt(albumSongsList.data!.length - 1),
                    shuffle: true);
                Navigator.pop(context);
              },
            ),
          );
        });
  }
}
