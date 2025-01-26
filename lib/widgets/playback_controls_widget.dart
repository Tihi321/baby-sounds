import 'package:flutter/material.dart';
import '../services/audio_player_service.dart';

class PlaybackControlsWidget extends StatelessWidget {
  final AudioPlayerService audioPlayerService;
  final String? currentTrackTitle;
  final VoidCallback onStopPressed;
  final VoidCallback onPlayPressed;
  final VoidCallback onPreviousPressed;
  final VoidCallback onNextPressed;
  final bool isPlaylistLooping;
  final bool isPlaylistMode;
  final bool isPlaylistVisible;
  final ValueChanged<bool> onLoopChanged;
  final ValueChanged<bool> onPlaylistModeChanged;
  final ValueChanged<bool> onPlaylistVisibilityChanged;

  const PlaybackControlsWidget({
    super.key,
    required this.audioPlayerService,
    this.currentTrackTitle,
    required this.onStopPressed,
    required this.onPlayPressed,
    required this.onPreviousPressed,
    required this.onNextPressed,
    required this.isPlaylistLooping,
    required this.isPlaylistMode,
    required this.isPlaylistVisible,
    required this.onLoopChanged,
    required this.onPlaylistModeChanged,
    required this.onPlaylistVisibilityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (currentTrackTitle != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Now Playing: $currentTrackTitle',
              style: TextStyle(
                color: Colors.orange.shade800,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        StreamBuilder<Duration?>(
          stream: audioPlayerService.audioPlayer.positionStream,
          builder: (context, snapshot) {
            final position = snapshot.data ?? Duration.zero;
            final duration =
                audioPlayerService.audioPlayer.duration ?? Duration.zero;
            return Column(
              children: [
                if (duration.inMilliseconds > 0)
                  Slider(
                    value: position.inMilliseconds
                        .clamp(0, duration.inMilliseconds)
                        .toDouble(),
                    min: 0,
                    max: duration.inMilliseconds.toDouble(),
                    activeColor: Colors.orange.shade800,
                    onChanged: (value) {
                      audioPlayerService.audioPlayer.seek(
                        Duration(milliseconds: value.toInt()),
                      );
                    },
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}',
                        style: TextStyle(color: Colors.orange.shade800),
                      ),
                      SizedBox(
                        width: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.skip_previous),
                              onPressed: onPreviousPressed,
                              color: Colors.orange.shade800,
                            ),
                            const SizedBox(width: 2),
                            IconButton(
                              icon: Icon(audioPlayerService.audioPlayer.playing
                                  ? Icons.stop
                                  : Icons.play_arrow),
                              onPressed: audioPlayerService.audioPlayer.playing
                                  ? onStopPressed
                                  : onPlayPressed,
                              color: Colors.orange.shade800,
                              iconSize: 32,
                            ),
                            const SizedBox(width: 2),
                            IconButton(
                              icon: const Icon(Icons.skip_next),
                              onPressed: onNextPressed,
                              color: Colors.orange.shade800,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                        style: TextStyle(color: Colors.orange.shade800),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      isPlaylistVisible
                          ? Icons.playlist_play
                          : Icons.playlist_play_outlined,
                      color: Colors.orange.shade800,
                    ),
                    onPressed: () =>
                        onPlaylistVisibilityChanged(!isPlaylistVisible),
                    tooltip: 'Show Playlist',
                  ),
                  IconButton(
                    icon: Icon(
                      isPlaylistLooping ? Icons.repeat_one : Icons.repeat,
                      color: Colors.orange.shade800,
                    ),
                    onPressed: () => onLoopChanged(!isPlaylistLooping),
                    tooltip: 'Loop Playlist',
                  ),
                  IconButton(
                    icon: Icon(
                      isPlaylistMode
                          ? Icons.playlist_add_check
                          : Icons.playlist_add,
                      color: Colors.orange.shade800,
                    ),
                    onPressed: () => onPlaylistModeChanged(!isPlaylistMode),
                    tooltip: 'Playlist Mode',
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
