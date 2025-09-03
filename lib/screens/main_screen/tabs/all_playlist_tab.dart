import 'package:flutter/material.dart';
import 'package:music_player/models/song_model.dart';
import 'package:music_player/screens/main_screen/widgets/playlist_display.dart';
import 'package:music_player/screens/playlist_screen/playlist_screen.dart';
import 'package:music_player/services/audio_service.dart';
import 'package:music_player/services/objectbox_service.dart';

class AllPlaylistsTab extends StatefulWidget {
  const AllPlaylistsTab({super.key});

  @override
  State<AllPlaylistsTab> createState() => _AllPlaylistsTabState();
}

class _AllPlaylistsTabState extends State<AllPlaylistsTab> {
  final _audioService = AudioService();
  final _scrollController = ScrollController();

  Future<void> addPlaylist() {
    String? playlistName;
    final formKey = GlobalKey<FormState>();
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Nueva Playlist"),
            content: SingleChildScrollView(
                child: Form(
              key: formKey,
              child: TextFormField(
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
                    playlistName = null;
                    Navigator.pop(context);
                  },
                  child: const Text("Cancelar")),
              FilledButton(
                  onPressed: playlistName == null
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            obx.addPlaylist(Playlist(name: playlistName!));

                            playlistName = null;

                            if (!context.mounted) return;
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

  @override
  Widget build(BuildContext context) {
    double alto = MediaQuery.sizeOf(context).height;

    return Stack(
      children: [
        StreamBuilder<List<Playlist>>(
          stream: obx.allPlaylistsStream(),
          builder: (context, allPlaylistsList) {
            if (allPlaylistsList.hasData) {
              if (allPlaylistsList.data?.isEmpty ?? true) {
                return const Center(
                  child: Text("Agrega una nueva playlist"),
                );
              }
              return Scrollbar(
                interactive: true,
                controller: _scrollController,
                child: GridView.builder(
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15),
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                      right: 15, left: 15, top: 15, bottom: alto * 0.12 + 15),
                  itemCount: allPlaylistsList.data?.length,
                  itemBuilder: (context, index) {
                    return Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return PlayListScreen(
                                playlistId: allPlaylistsList.data?[index].id,
                              );
                            },
                          ));
                        },
                        child: PlaylistDisplay(
                          playlistId: allPlaylistsList.data?[index].id,
                        ),
                      ),
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
        StreamBuilder(
            stream: _audioService.sequenceStateStream,
            builder: (context, sequenceState) {
              return Positioned(
                bottom: sequenceState.hasData &&
                        sequenceState.data!.sequence.isNotEmpty
                    ? alto * 0.13
                    : 10,
                right: 10,
                child: FloatingActionButton.extended(
                  heroTag: "AddPlaylist",
                  label: const Text("Nueva Playlist"),
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    await addPlaylist();
                    if (!context.mounted) return;
                    setState(() {});
                  },
                ),
              );
            })
      ],
    );
  }
}
