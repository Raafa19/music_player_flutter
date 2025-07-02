import 'package:flutter/material.dart';
import 'package:music_player/screens/main_screen/tabs/all_albums_tab.dart';
import 'package:music_player/screens/main_screen/tabs/all_artists_tab.dart';
import 'package:music_player/screens/main_screen/tabs/all_playlist_tab.dart';
import 'package:music_player/screens/main_screen/tabs/all_songs_tab.dart';
import 'package:music_player/screens/main_screen/widgets/bottom_player.dart';
import 'package:music_player/screens/player_screen/player_screen.dart';
import 'package:music_player/services/audio_service.dart';
import 'package:music_player/services/objectbox_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  static const List<Tab> tabs = [
    Tab(
      text: "Playlists",
    ),
    Tab(
      text: "Artistas",
    ),
    Tab(
      text: "Álbumes",
    ),
    Tab(
      text: "Canciones",
    )
  ];

  final _audioService = AudioService();
  late TabController _tabController;

  Future<void> cleanObx() async {
    return await obx.cleanSongs();
  }

  @override
  void initState() {
    cleanObx();
    _tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 15,
          bottom: TabBar(
            controller: _tabController,
            tabs: tabs,
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const AllPlaylistsTab(),
                PopScope(
                  canPop: false,
                  onPopInvokedWithResult: (didPop, result) {
                    if (didPop) return;
                    _tabController.animateTo(0);
                  },
                  child: const AllArtistsTab(),
                ),
                PopScope(
                    canPop: false,
                    onPopInvokedWithResult: (didPop, result) {
                      if (didPop) return;
                      _tabController.animateTo(0);
                    },
                    child: const AllAlbumsTab()),
                PopScope(
                  canPop: false,
                  onPopInvokedWithResult: (didPop, result) {
                    if (didPop) return;
                    _tabController.animateTo(0);
                  },
                  child: const AllSongsTab(),
                ),
              ],
            ),
            StreamBuilder(
                stream: _audioService.sequenceStateStream,
                builder: (context, sequenceState) {
                  if (sequenceState.hasData) {
                    return Positioned(
                      bottom: 15,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, _toMainPlayerRoute());
                        },
                        child: const BottomPlayer(),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
          ],
        ),
      ),
    );
  }

  Route _toMainPlayerRoute() {
    return PageRouteBuilder<void>(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => const PlayerModalScreen(),
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
