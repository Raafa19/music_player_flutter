import 'package:flutter/material.dart';
import 'package:music_player/models/song_model.dart';
import 'package:music_player/services/objectbox_service.dart';
import 'package:on_audio_query/on_audio_query.dart';

Future<void> removeSongFromPlaylist(
    {required BuildContext context, SongModel? audio, int? playlistId}) async {
  if (audio == null || playlistId == null) return;
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text("Remover de playlist:"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancelar")),
            FilledButton(
                onPressed: () {
                  obx.removeSongFromPlaylist(
                      song: Song.songModeltoSong(audio),
                      playlistId: playlistId);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                child: const Text("Aceptar")),
          ],
        );
      });
    },
  );
}

// Future<void> addMultipleToPlaylist(
//     {required BuildContext context,
//     AlbumModel? album,
//     ArtistModel? artist}) async {
//   final audioService = AudioService();
//   int? playlistId;

//   List<SongModel> songs;

//   double alto = MediaQuery.sizeOf(context).height;
//   double ancho = MediaQuery.sizeOf(context).width;

//   bool loading = false;

//   return await showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) {
//       return StatefulBuilder(builder: (context, setState) {
//         return AlertDialog(
//           title: const Text("Agregar a playlist:"),
//           icon:
//               loading ? const Center(child: CircularProgressIndicator()) : null,
//           content: ConstrainedBox(
//             constraints: BoxConstraints(
//                 maxHeight: alto * 0.7,
//                 minHeight: alto * 0.2,
//                 maxWidth: ancho * 0.7,
//                 minWidth: ancho * 0.7),
//             child: StreamBuilder(
//                 stream: obx.allPlaylistsStream(),
//                 builder: (context, allPlaylistList) {
//                   if (!allPlaylistList.hasData) {
//                     return SizedBox(
//                       height: alto * 0.2,
//                       child: const Center(
//                         child: CircularProgressIndicator(),
//                       ),
//                     );
//                   }
//                   return ListView.builder(
//                     itemCount: allPlaylistList.data?.length,
//                     shrinkWrap: true,
//                     itemBuilder: (context, index) {
//                       return RadioListTile<int?>(
//                         toggleable: true,
//                         contentPadding: EdgeInsets.zero,
//                         title: Text(allPlaylistList.data?[index].name ?? "-"),
//                         value: allPlaylistList.data?[index].id,
//                         groupValue: playlistId,
//                         onChanged: (value) {
//                           setState(
//                             () {
//                               playlistId = value;
//                             },
//                           );
//                         },
//                       );
//                     },
//                   );
//                 }),
//           ),
//           actions: [
//             TextButton(
//                 onPressed: loading
//                     ? null
//                     : () {
//                         Navigator.pop(context);
//                       },
//                 child: const Text("Cancelar")),
//             FilledButton(
//                 onPressed: playlistId == null || loading
//                     ? null
//                     : () async {
//                         setState(() => loading = true);
//                         if (album != null) {
//                           songs = await audioService.allSongsFromAlbum(album);
//                         } else {
//                           songs =
//                               await audioService.allSongsFromArtist(artist!);
//                         }
//                         for (SongModel song in songs) {
//                           obx.addSongToPlaylist(
//                               playlistId: playlistId,
//                               newSong: Song.songModeltoSong(song));
//                         }
//                         setState(() => loading = false);
//                         if (!context.mounted) return;
//                         Navigator.pop(context);
//                       },
//                 child: const Text("Aceptar")),
//           ],
//         );
//       });
//     },
//   );
// }
