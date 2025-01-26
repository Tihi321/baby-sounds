import 'base_audio_tracks_grid.dart';

class SongTracksGrid extends BaseAudioTracksGrid {
  const SongTracksGrid({
    super.key,
    required super.tracks,
    required super.onPlayPressed,
    super.isPlaylistMode = false,
    super.onPlaylistToggle,
  }) : super(imagePath: 'assets/images/songs.png');
}
