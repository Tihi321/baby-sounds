import 'base_audio_tracks_grid.dart';

class LullabyTracksGrid extends BaseAudioTracksGrid {
  const LullabyTracksGrid({
    super.key,
    required super.tracks,
    required super.onPlayPressed,
    super.isPlaylistMode = false,
    super.onPlaylistToggle,
  }) : super(imagePath: 'assets/images/lullaby.png');
}
