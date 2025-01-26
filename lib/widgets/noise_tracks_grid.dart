import 'base_audio_tracks_grid.dart';

class NoiseTracksGrid extends BaseAudioTracksGrid {
  const NoiseTracksGrid({
    super.key,
    required super.tracks,
    required super.onPlayPressed,
    super.isPlaylistMode = false,
    super.onPlaylistToggle,
  }) : super(imagePath: 'assets/images/noise.png');
}
