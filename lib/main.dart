import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/screens/main_screen/main_screen.dart';
import 'package:music_player/services/audio_service.dart';
import 'package:music_player/services/objectbox_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await JustAudioBackground.init(
      androidNotificationChannelId:
          'com.rafamsuarez.music_player.channel.audio',
      androidNotificationChannelName: 'Music Player Audio',
      androidNotificationOngoing: false,
      androidStopForegroundOnPause: false);

  obx = await ObxService.create();

  runApp(const MusicPlayerApp());
}

class MusicPlayerApp extends StatefulWidget {
  const MusicPlayerApp({super.key});

  @override
  State<MusicPlayerApp> createState() => _MusicPlayerAppState();
}

class _MusicPlayerAppState extends State<MusicPlayerApp> {
  final _audioService = AudioService();

  Future<void> _checkPermisos() async {
    await _audioService.requestPermission();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  // @override
  // void dispose() {
  //   _audioService.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white,
            brightness: Brightness.dark,
          ),
        ),
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white,
          ),
        ),
        home: FutureBuilder(
            initialData: false,
            future: _audioService.permissionStatus(),
            builder: (context, permissionStatus) {
              final permiso = permissionStatus.data ?? false;
              return Scaffold(
                body: Center(
                    child: permiso
                        ? const MainScreen()
                        : FilledButton(
                            onPressed: _checkPermisos,
                            child: const Text("Otorgar permisos"))),
              );
            }));
  }
}
