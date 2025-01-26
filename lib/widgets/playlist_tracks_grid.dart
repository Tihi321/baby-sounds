import 'package:flutter/material.dart';
import '../models/audio_track.dart';

class PlaylistTracksGrid extends StatelessWidget {
  final List<AudioTrack> tracks;
  final Function(int) onPlayPressed;
  final Function(int) onRemoveFromPlaylist;
  final bool isLooping;
  final Function() onLoopToggle;

  const PlaylistTracksGrid({
    super.key,
    required this.tracks,
    required this.onPlayPressed,
    required this.onRemoveFromPlaylist,
    required this.isLooping,
    required this.onLoopToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (tracks.isEmpty) {
      return const Center(
        child: Text(
          'No tracks in playlist',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Loop Playlist',
                style: TextStyle(
                  color: Colors.orange.shade800,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: isLooping,
                onChanged: (_) => onLoopToggle(),
                activeColor: Colors.orange.shade800,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              final track = tracks[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(
                    track.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          track.isPlaying ? Icons.stop : Icons.play_arrow,
                          color: Colors.orange.shade800,
                        ),
                        onPressed: () => onPlayPressed(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        color: Colors.red,
                        onPressed: () => onRemoveFromPlaylist(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
