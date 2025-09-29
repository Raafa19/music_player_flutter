import 'dart:math';

import 'package:flutter/material.dart';
import 'package:music_player/models/song_model.dart';
import 'package:music_player/screens/main_screen/widgets/song_display.dart';
import 'package:music_player/screens/widgets/remove_from_playlist.dart';
import 'package:music_player/services/audio_service.dart';
import 'package:music_player/services/objectbox_service.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayListScreen extends StatefulWidget {
  final int? playlistId;
  const PlayListScreen({super.key, this.playlistId});

  @override
  State<PlayListScreen> createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  final _cancionesScroller = ScrollController();
  final _audioService = AudioService();
  bool loading = false;

  Future<void> editPlaylist(String playlistNameOg) {
    String playlistName = playlistNameOg;

    final formKey = GlobalKey<FormState>();
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Editar Playlist"),
            content: SingleChildScrollView(
                child: Form(
              key: formKey,
              child: TextFormField(
                initialValue: playlistName,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(hintText: "Nombre"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Debe incluir un nombre";
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    playlistName = value.trim();
                  });
                },
              ),
            )),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancelar")),
              FilledButton(
                  onPressed: playlistName.isEmpty
                      ? null
                      : () {
                          if (formKey.currentState!.validate()) {
                            obx.addPlaylist(Playlist(
                                name: playlistName, id: widget.playlistId));
                            Navigator.pop(context);
                          }
                        },
                  child: const Text("Aceptar"))
            ],
          );
        });
      },
    );
  }

  Future<void> eliminarPlaylist() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("¿Eliminar Playlist?"),
          actions: [
            TextButton(
              onPressed: loading
                  ? null
                  : () {
                      Navigator.pop(context);
                    },
              child: const Text("Cancelar"),
            ),
            FilledButton(
              onPressed: loading
                  ? null
                  : () {
                      setState(() {
                        loading = true;
                      });
                      obx.deletePlaylist(widget.playlistId);
                      setState(() {
                        loading = false;
                      });
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: obx.streamPlaylistById(widget.playlistId),
        builder: (context, playlist) {
          return StreamBuilder<List<SongModel>>(
              stream: obx.streamPlaylistSongs(playlist.data?.id),
              builder: (context, playlistSongsList) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(playlist.data?.name ?? "-"),
                    actions: [
                      playlist.data?.name == "Favoritas"
                          ? PopupMenuButton(
                              itemBuilder: (context) {
                                return [
                                  const PopupMenuItem(
                                    value: 0,
                                    child: Text("Eliminar Múltiples Canciones"),
                                  ),
                                ];
                              },
                              onSelected: (value) async {},
                            )
                          : PopupMenuButton(
                              itemBuilder: (context) {
                                return [
                                  const PopupMenuItem(
                                    value: 0,
                                    child: Text("Editar Playlist"),
                                  ),
                                  const PopupMenuItem(
                                    value: 1,
                                    child: Text("Eliminar Playlist"),
                                  ),
                                  const PopupMenuItem(
                                    value: 2,
                                    child: Text("Eliminar Múltiples Canciones"),
                                  ),
                                ];
                              },
                              onSelected: (value) async {
                                switch (value) {
                                  case 0:
                                    await editPlaylist(
                                        playlist.data?.name ?? "");
                                    break;
                                  case 1:
                                    await eliminarPlaylist();
                                    break;
                                  default:
                                }
                              },
                            )
                    ],
                  ),
                  body: Builder(
                    builder: (context) {
                      if (playlistSongsList.hasData) {
                        return Scrollbar(
                          interactive: true,
                          controller: _cancionesScroller,
                          child: ListView.builder(
                            controller: _cancionesScroller,
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            itemCount: playlistSongsList.data!.length,
                            itemBuilder: (context, index) {
                              return Material(
                                child: InkWell(
                                    onTap: () {
                                      _audioService.loadSongs(
                                          songs: playlistSongsList.data,
                                          index: index,
                                          shuffle: false);
                                      Navigator.pop(context);
                                    },
                                    onLongPress: () {
                                      removeSongFromPlaylist(
                                          context: context,
                                          audio: playlistSongsList.data?[index],
                                          playlistId: widget.playlistId);
                                    },
                                    child: SongDisplay(
                                        song: playlistSongsList.data![index])),
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
                      if (playlistSongsList.data == null ||
                          playlistSongsList.data!.isEmpty) {
                        return;
                      }
                      _audioService.loadSongs(
                          songs: playlistSongsList.data,
                          index: Random()
                              .nextInt(playlistSongsList.data!.length - 1),
                          shuffle: true);
                      Navigator.pop(context);
                    },
                  ),
                );
              });
        });
  }
}
