import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '../models/audio_track.dart';

class AudioPlayerService {
  late final AudioPlayer _audioPlayer;
  final _playlist = ConcatenatingAudioSource(children: []);
  bool _isInitialized = false;
  bool _isPlaylistMode = false;

  AudioPlayerService() {
    _audioPlayer = AudioPlayer();
    _audioPlayer.setVolume(1.0);
    _audioPlayer.setSpeed(1.0);
    _initializePlayer();
  }

  AudioPlayer get audioPlayer => _audioPlayer;

  Future<void> _initializePlayer() async {
    try {
      await _audioPlayer.setAudioSource(_playlist);
      _isInitialized = true;
      debugPrint('Audio player initialized successfully');
    } catch (e, st) {
      debugPrint('Error initializing audio player: $e');
      debugPrint('Stack trace: $st');
    }
  }

  bool get isPlaylistMode => _isPlaylistMode;

  void togglePlaylistMode() {
    _isPlaylistMode = !_isPlaylistMode;
  }

  Future<void> loadAndPlayAsset(String assetPath, MediaItem mediaItem) async {
    try {
      debugPrint('Loading asset: $assetPath');

      // Clear previous sources
      await _playlist.clear();

      // Add new source
      await _playlist.add(
        AudioSource.asset(
          assetPath,
          tag: mediaItem,
        ),
      );

      if (!_isInitialized) {
        await _initializePlayer();
      }

      // Start playback
      await _audioPlayer.seek(Duration.zero, index: 0);
      await _audioPlayer.play();
      debugPrint('Asset loaded and playing');
    } catch (e, st) {
      debugPrint('Error loading asset: $e');
      debugPrint('Stack trace: $st');
      rethrow;
    }
  }

  Future<void> setLoopMode(bool loop) async {
    try {
      await _audioPlayer.setLoopMode(loop ? LoopMode.all : LoopMode.off);
      debugPrint('Loop mode set to: ${loop ? 'all' : 'off'}');
    } catch (e, st) {
      debugPrint('Error setting loop mode: $e');
      debugPrint('Stack trace: $st');
    }
  }

  Future<void> loadPlaylist(List<AudioTrack> tracks) async {
    try {
      debugPrint('Loading playlist with ${tracks.length} tracks');
      await _playlist.clear();

      for (var track in tracks) {
        await _playlist.add(
          AudioSource.asset(
            track.assetPath,
            tag: track.mediaItem,
          ),
        );
      }

      if (!_isInitialized) {
        await _initializePlayer();
      }

      await _audioPlayer.seek(Duration.zero, index: 0);
      await _audioPlayer.play();
      debugPrint('Playlist loaded and playing');
    } catch (e, st) {
      debugPrint('Error loading playlist: $e');
      debugPrint('Stack trace: $st');
      rethrow;
    }
  }

  Future<void> setAudioSource(AudioSource source) async {
    try {
      await _playlist.clear();
      await _playlist.add(source);
      if (!_isInitialized) {
        await _initializePlayer();
      }
      await _audioPlayer.seek(Duration.zero, index: 0);
      debugPrint('Audio source set successfully');
    } catch (e, st) {
      debugPrint('Error setting audio source: $e');
      debugPrint('Stack trace: $st');
      rethrow;
    }
  }

  void setupPlayerListener(void Function(bool isPlaying) callback) {
    _audioPlayer.playerStateStream.listen(
      (playerState) {
        try {
          callback(playerState.playing);
        } catch (e) {
          debugPrint('Error in player state callback: $e');
        }
      },
      onError: (Object e, StackTrace st) {
        debugPrint('Error in player state stream: $e');
        debugPrint('Stack trace: $st');
      },
    );

    _audioPlayer.playbackEventStream.listen(
      (event) {
        // Handle playback events if needed
      },
      onError: (Object e, StackTrace st) {
        debugPrint('Error in playback event stream: $e');
        debugPrint('Stack trace: $st');
      },
    );
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      debugPrint('Audio player stopped successfully');
    } catch (e, st) {
      debugPrint('Error stopping audio player: $e');
      debugPrint('Stack trace: $st');
    }
  }

  Future<void> setVolume(double volume) async {
    // Clamp volume between 0.0 and 1.0
    final normalizedVolume = volume.clamp(0.0, 1.0);
    try {
      await audioPlayer.setVolume(normalizedVolume);
    } catch (e) {
      debugPrint('Error setting volume: $e');
      // Set a safe default volume if there's an error
      await audioPlayer.setVolume(1.0);
    }
  }

  double getVolume() {
    return audioPlayer.volume.clamp(0.0, 1.0);
  }

  void dispose() {
    try {
      _audioPlayer.stop();
      _audioPlayer.dispose();
      debugPrint('Audio player disposed successfully');
    } catch (e, st) {
      debugPrint('Error disposing audio player: $e');
      debugPrint('Stack trace: $st');
    }
  }
}
