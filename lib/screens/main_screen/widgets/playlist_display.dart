import 'package:flutter/material.dart';
import 'package:music_player/models/song_model.dart';
import 'package:music_player/services/objectbox_service.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistDisplay extends StatelessWidget {
  final int? playlistId;
  const PlaylistDisplay({super.key, this.playlistId});

  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.sizeOf(context).width;
    return StreamBuilder(
        stream: obx.streamPlaylistById(playlistId),
        builder: (context, playlist) {
          Playlist? thisPlaylist = playlist.data;
          if (thisPlaylist == null) {
            return Container(
              color: const Color.fromARGB(255, 78, 76, 76),
              child: const Center(
                child: Icon(
                  Icons.music_note,
                  size: 35,
                ),
              ),
            );
          }
          if (thisPlaylist.name == "Favoritas") {
            return Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: const Color.fromARGB(255, 99, 88, 96),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Icon(
                          Icons.favorite,
                          size: 100,
                          color: Colors.red,
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
                            thisPlaylist.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Stack(
            children: [
              Positioned.fill(
                child: QueryArtworkWidget(
                  id: thisPlaylist.songsList.isEmpty
                      ? 0
                      : thisPlaylist.songsList.first.albumId ?? 0,
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
                          thisPlaylist.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
