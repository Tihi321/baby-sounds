import 'package:flutter/material.dart';

class PlaylistControlsWidget extends StatelessWidget {
  final bool isPlaylistLooping;
  final bool isPlaylistMode;
  final bool isPlaylistVisible;
  final ValueChanged<bool> onLoopChanged;
  final ValueChanged<bool> onPlaylistModeChanged;
  final ValueChanged<bool> onPlaylistVisibilityChanged;

  const PlaylistControlsWidget({
    super.key,
    required this.isPlaylistLooping,
    required this.isPlaylistMode,
    required this.isPlaylistVisible,
    required this.onLoopChanged,
    required this.onPlaylistModeChanged,
    required this.onPlaylistVisibilityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            isPlaylistLooping ? Icons.repeat : Icons.repeat_outlined,
            color: Colors.orange.shade800,
          ),
          onPressed: () => onLoopChanged(!isPlaylistLooping),
          tooltip: 'Loop Playlist',
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: Icon(
            isPlaylistVisible
                ? Icons.playlist_play
                : Icons.playlist_play_outlined,
            color: Colors.orange.shade800,
          ),
          onPressed: () => onPlaylistVisibilityChanged(!isPlaylistVisible),
          tooltip: 'Show Playlist',
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: Icon(
            isPlaylistMode ? Icons.playlist_add_check : Icons.playlist_add,
            color: Colors.orange.shade800,
          ),
          onPressed: () => onPlaylistModeChanged(!isPlaylistMode),
          tooltip: 'Playlist Mode',
        ),
      ],
    );
  }
}
