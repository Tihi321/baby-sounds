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
  bool isLoading = false; // Add this line
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
      await audioService.loadAndPlayAsset(assetPath, mediaItem);
      // Note: isPlaying will be set by the player state listener in SoundListScreen
    } catch (e) {
      debugPrint('Error playing track: $e');
      rethrow; // Rethrow to let caller handle loading state
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
