import 'package:flutter/material.dart';
import '../models/audio_track.dart';

class TrackListView extends StatelessWidget {
  final List<AudioTrack> tracks;
  final Function(int) onPlayPressed;
  final bool isPlaylistMode;
  final Function(int)? onPlaylistToggle;
  final Widget Function(List<AudioTrack>, Function(int), bool, Function(int)?)
      gridBuilder;

  const TrackListView({
    super.key,
    required this.tracks,
    required this.onPlayPressed,
    required this.isPlaylistMode,
    this.onPlaylistToggle,
    required this.gridBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return gridBuilder(tracks, onPlayPressed, isPlaylistMode, onPlaylistToggle);
  }
}
