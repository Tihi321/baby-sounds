import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../services/audio_player_service.dart';

class AudioTrack {
  final String title;
  final String assetPath;
  final AudioPlayerService audioService;
  bool isLooping = false;
  bool isPlaying = false;
  bool isInPlaylist = false;
  late final MediaItem mediaItem;

  AudioTrack({
    required this.title,
    required this.assetPath,
    required this.audioService,
  }) {
    mediaItem = MediaItem(
      id: assetPath,
      title: title,
    );
  }

  Future<void> play() async {
    try {
      debugPrint('Starting playback for: $assetPath');

      // Set loop mode
      await audioService.audioPlayer
          .setLoopMode(isLooping ? LoopMode.one : LoopMode.off);
      debugPrint('Loop mode set');

      // Load and play the asset
      await audioService.loadAndPlayAsset(assetPath, mediaItem);
      debugPrint('Playback started');
    } catch (e, stackTrace) {
      debugPrint('Error playing audio: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  void toggleLoop() {
    isLooping = !isLooping;
    if (isPlaying) {
      audioService.audioPlayer
          .setLoopMode(isLooping ? LoopMode.one : LoopMode.off);
    }
  }
}
