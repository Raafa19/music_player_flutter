import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_player/services/audio_service.dart';

class PlayerSeekbar extends StatefulWidget {
  const PlayerSeekbar({super.key});

  @override
  State<PlayerSeekbar> createState() => _PlayerSeekbarState();
}

class _PlayerSeekbarState extends State<PlayerSeekbar> {
  final _audioService = AudioService();

  @override
  Widget build(BuildContext context) {
    // double alto = MediaQuery.sizeOf(context).height;
    double ancho = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        width: ancho,
        child: StreamBuilder<DurationState>(
            stream: _audioService.durationStateStream,
            builder: (context, durationSnapshot) {
              final durationState = durationSnapshot.data;
              final progress = durationState?.position ?? Duration.zero;
              final total = durationState?.total ?? Duration.zero;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ProgressBar(
                      progress: progress,
                      total: total,
                      onSeek: (time) {
                        _audioService.seek(time);
                      },
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
