import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'dart:async';
import '../models/audio_track.dart';

class AudioPlayerService {
  late final AudioPlayer _audioPlayer;
  final _playlist = ConcatenatingAudioSource(children: []);
  bool _isInitialized = false;
  bool _isPlaylistMode = false;
  Completer<void>? _currentOperation;

  AudioPlayerService() {
    _audioPlayer = AudioPlayer();
    _audioPlayer.setVolume(1.0);
    _audioPlayer.setSpeed(1.0);
    _initializePlayer();
  }

  AudioPlayer get audioPlayer => _audioPlayer;

  Future<void> _initializePlayer() async {
    try {
      if (!_isInitialized) {
        await _audioPlayer.setAudioSource(_playlist);
        _isInitialized = true;
        debugPrint('Audio player initialized successfully');
      }
    } catch (e, st) {
      debugPrint('Error initializing audio player: $e');
      debugPrint('Stack trace: $st');
    }
  }

  bool get isPlaylistMode => _isPlaylistMode;

  void togglePlaylistMode() {
    _isPlaylistMode = !_isPlaylistMode;
  }

  static AudioSource _createAudioSource(Map<String, dynamic> params) {
    return AudioSource.asset(
      params['assetPath'] as String,
      tag: params['mediaItem'] as MediaItem,
    );
  }

  Future<void> _setSourceAndPlay(AudioSource source) async {
    try {
      await _currentOperation?.future;

      final completer = Completer<void>();
      _currentOperation = completer;

      try {
        unawaited(_audioPlayer.stop());
        await _playlist.clear();
        await _playlist.add(source);
        await _initializePlayer();
        await _audioPlayer.seek(Duration.zero);
        await _audioPlayer.play();
        debugPrint('Playback started successfully');
      } catch (e) {
        debugPrint('Error during playback: $e');
        rethrow;
      } finally {
        completer.complete();
        _currentOperation = null;
      }
    } catch (e) {
      debugPrint('Error setting source and playing: $e');
    }
  }

  Future<void> loadAndPlayAsset(String assetPath, MediaItem mediaItem) async {
    final source = _createAudioSource({'assetPath': assetPath, 'mediaItem': mediaItem});
    await _setSourceAndPlay(source);
  }

  Future<void> setLoopMode(bool isLooping) async {
    await _audioPlayer.setLoopMode(isLooping ? LoopMode.one : LoopMode.off);
  }

  void initializePlayerListener(ValueChanged<bool> onPlayerStateChanged) {
    _audioPlayer.playerStateStream.listen((state) {
      final isPlaying = state.playing;
      onPlayerStateChanged(isPlaying);
    });
  }

  Future<void> loadPlaylist(List<AudioTrack> tracks) async {
    try {
      debugPrint('Loading playlist with ${tracks.length} tracks');

      await _currentOperation?.future;

      final completer = Completer<void>();
      _currentOperation = completer;

      try {
        await _playlist.clear();

        final sources = await Future.wait(
          tracks.map((track) => compute(_createAudioSource, {
                'assetPath': track.assetPath,
                'mediaItem': track.mediaItem,
              })),
        );

        await _playlist.addAll(sources);

        await _initializePlayer();

        await _audioPlayer.seek(Duration.zero, index: 0);
        await _audioPlayer.play();

        completer.complete();
        debugPrint('Playlist loaded and playing');
      } catch (e) {
        completer.completeError(e);
        rethrow;
      }
    } catch (e, st) {
      debugPrint('Error loading playlist: $e');
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
    final normalizedVolume = volume.clamp(0.0, 1.0);
    try {
      await _audioPlayer.setVolume(normalizedVolume);
    } catch (e) {
      debugPrint('Error setting volume: $e');
      await _audioPlayer.setVolume(1.0);
    }
  }

  double getVolume() {
    return _audioPlayer.volume.clamp(0.0, 1.0);
  }

  Future<void> setAudioSource(AudioSource source) async {
    try {
      await _setSourceAndPlay(source);
      debugPrint('Audio source set successfully');
    } catch (e, st) {
      debugPrint('Error setting audio source: $e');
      debugPrint('Stack trace: $st');
      rethrow;
    }
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
