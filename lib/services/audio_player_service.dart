import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayer get audioPlayer => _audioPlayer;

  void setupPlayerListener(void Function(bool isPlaying) callback) {
    _audioPlayer.playerStateStream.listen((playerState) {
      callback(playerState.playing);
    });
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
