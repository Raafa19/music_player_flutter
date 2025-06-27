import 'package:flutter/material.dart';
import 'package:music_player/screens/artist_screen/artist_screen.dart';
import 'package:music_player/screens/main_screen/widgets/artist_display.dart';
import 'package:music_player/screens/widgets/add_to_playlist_dialog.dart';
import 'package:music_player/services/audio_service.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AllArtistsTab extends StatefulWidget {
  const AllArtistsTab({super.key});

  @override
  State<AllArtistsTab> createState() => _AllArtistsTabState();
}

class _AllArtistsTabState extends State<AllArtistsTab> {
  final _audioService = AudioService();
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double alto = MediaQuery.sizeOf(context).height;

    return FutureBuilder<List<ArtistModel>>(
      future: _audioService.allArtists,
      builder: (context, allArtistList) {
        if (allArtistList.hasData) {
          return Scrollbar(
            interactive: true,
            controller: _scrollController,
            child: GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 15, crossAxisSpacing: 15),
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  right: 15, left: 15, top: 15, bottom: alto * 0.12 + 15),
              itemCount: allArtistList.data!.length,
              itemBuilder: (context, index) {
                return Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ArtistScreen(
                              artist: allArtistList.data![index]);
                        },
                      ));
                    },
                    onLongPress: () async {
                      await addMultipleToPlaylist(
                          context: context, artist: allArtistList.data![index]);
                    },
                    child: ArtistDisplay(
                      artist: allArtistList.data![index],
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
    );
  }
}
