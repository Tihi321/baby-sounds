import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class AudioTrack {
  final String title;
  final String assetPath;
  final AudioPlayer audioPlayer;
  bool isLooping = false;
  bool isPlaying = false;
  late final MediaItem mediaItem;

  AudioTrack({
    required this.title,
    required this.assetPath,
    required this.audioPlayer,
  }) {
    mediaItem = MediaItem(
      id: assetPath,
      title: title,
      artUri: Uri.parse('asset:///assets/audio_icon.png'),
    );
  }

  Future<void> play() async {
    try {
      await audioPlayer.setAudioSource(
        AudioSource.asset(
          assetPath,
          tag: mediaItem,
        ),
      );
      await audioPlayer.setLoopMode(isLooping ? LoopMode.one : LoopMode.off);
      await audioPlayer.play();
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  void toggleLoop() {
    isLooping = !isLooping;
    if (isPlaying) {
      audioPlayer.setLoopMode(isLooping ? LoopMode.one : LoopMode.off);
    }
  }
}
