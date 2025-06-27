import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/services/audio_service.dart';

class PlayerPlaybar extends StatefulWidget {
  const PlayerPlaybar({super.key});

  @override
  State<PlayerPlaybar> createState() => _PlayerPlaybarState();
}

class _PlayerPlaybarState extends State<PlayerPlaybar> {
  final _audioService = AudioService();

  IconData loopIcon(LoopMode loopMode) {
    switch (loopMode) {
      case LoopMode.off:
        return Icons.repeat;
      case LoopMode.one:
        return Icons.repeat_one;
      default:
        return Icons.repeat_on;
    }
  }

  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.sizeOf(context).width;
    double alto = MediaQuery.of(context).size.height;
    double smallIconSize = alto * 0.04;
    double bigIconSize = alto * 0.08;

    return SizedBox(
      width: ancho,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StreamBuilder(
              stream: _audioService.loopMode,
              builder: (context, loopMode) {
                return IconButton(
                  onPressed: () {
                    _audioService.toggleLoop();
                  },
                  icon: Icon(
                    loopIcon(loopMode.data ?? LoopMode.off),
                    size: smallIconSize,
                  ),
                );
              }),
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  await _audioService.prevSong();
                },
                icon: Icon(
                  Icons.skip_previous,
                  size: smallIconSize,
                ),
              ),
              StreamBuilder<bool>(
                  stream: _audioService.playing,
                  initialData: false,
                  builder: (context, playing) {
                    return IconButton(
                      onPressed: () async {
                        await _audioService.play();
                      },
                      icon: Icon(
                        playing.data ?? false
                            ? Icons.pause_circle
                            : Icons.play_circle,
                        size: bigIconSize,
                      ),
                    );
                  }),
              IconButton(
                onPressed: () async {
                  await _audioService.nextSong();
                },
                icon: Icon(
                  Icons.skip_next,
                  size: smallIconSize,
                ),
              ),
            ],
          ),
          StreamBuilder(
              stream: _audioService.shuffleMode,
              initialData: false,
              builder: (context, shuffleOn) {
                return IconButton(
                  onPressed: () async {
                    await _audioService.toggleShuffle();
                  },
                  icon: Icon(
                    shuffleOn.data ?? false
                        ? Icons.shuffle_on_rounded
                        : Icons.shuffle,
                    size: smallIconSize,
                  ),
                );
              }),
        ],
      ),
    );
  }
}
