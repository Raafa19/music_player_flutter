import 'package:flutter/material.dart';
import 'package:music_player/screens/album_screen/album_screen.dart';
import 'package:music_player/screens/main_screen/widgets/album_display.dart';
import 'package:music_player/services/audio_service.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AllAlbumsTab extends StatefulWidget {
  const AllAlbumsTab({super.key});

  @override
  State<AllAlbumsTab> createState() => _AllAlbumsTabState();
}

class _AllAlbumsTabState extends State<AllAlbumsTab> {
  final _audioService = AudioService();

  @override
  Widget build(BuildContext context) {
    double alto = MediaQuery.sizeOf(context).height;

    return FutureBuilder(
      future: _audioService.allArtists(),
      builder: (context, allArtistsList) {
        if (allArtistsList.hasData) {
          return ListView.builder(
            itemCount: allArtistsList.data!.length,
            padding: EdgeInsets.only(bottom: alto * 0.13),
            itemBuilder: (context, artistIndex) {
              return ExpansionTile(
                  title: Text(
                    allArtistsList.data![artistIndex].artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${allArtistsList.data![artistIndex].numberOfAlbums.toString()} ${allArtistsList.data![artistIndex].numberOfAlbums! > 1 ? "Álbumes" : "Álbum"}",
                    style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300),
                  ),
                  children: [
                    FutureBuilder<List<AlbumModel>>(
                      future: _audioService
                          .albumsInArtist(allArtistsList.data![artistIndex]),
                      builder: (context, artistAlbumsList) {
                        if (artistAlbumsList.hasData) {
                          return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 15,
                                    crossAxisSpacing: 15),
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            itemCount: artistAlbumsList.data!.length,
                            itemBuilder: (context, index) {
                              return Material(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return AlbumScreen(
                                            album:
                                                artistAlbumsList.data![index]);
                                      },
                                    ));
                                  },
                                  child: AlbumDisplay(
                                    album: artistAlbumsList.data![index],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ]);
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
