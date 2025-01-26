import 'package:flutter/material.dart';
import '../models/audio_track.dart';
import '../widgets/audio_track_tile.dart';

class SoothTracksGrid extends StatelessWidget {
  final List<AudioTrack> tracks;
  final Function(int index) onPlayPressed;

  const SoothTracksGrid({
    super.key,
    required this.tracks,
    required this.onPlayPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: tracks.length,
        itemBuilder: (context, index) {
          return AudioTrackTile(
            track: tracks[index],
            imagePath: 'assets/images/noise.png',
            onPlayPressed: () => onPlayPressed(index),
          );
        },
      ),
    );
  }
}
