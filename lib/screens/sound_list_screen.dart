import 'package:flutter/material.dart';
import '../services/audio_player_service.dart';
import '../models/audio_track.dart';
import '../widgets/gradient_background.dart';
import '../widgets/noise_tracks_grid.dart';
import '../widgets/lullaby_tracks_grid.dart';
import '../widgets/song_tracks_grid.dart';
import '../widgets/playlist_tracks_grid.dart';
import '../widgets/playback_controls_widget.dart';
import '../repositories/track_repository.dart';

class SoundListScreen extends StatefulWidget {
  const SoundListScreen({super.key});

  @override
  State<SoundListScreen> createState() => _SoundListScreenState();
}

class _SoundListScreenState extends State<SoundListScreen> {
  final AudioPlayerService _audioPlayerService = AudioPlayerService();
  late final TrackRepository _trackRepository;
  late final List<AudioTrack> noiseTracks;
  late final List<AudioTrack> lullabyTracks;
  late final List<AudioTrack> songTracks;
  final List<AudioTrack> playlistTracks = [];
  bool isPlaylistLooping = false;
  bool isPlaylistVisible = false;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayerListener();
    _trackRepository = TrackRepository(_audioPlayerService);
    noiseTracks = _trackRepository.getNoiseTracks();
    lullabyTracks = _trackRepository.getLullabyTracks();
    songTracks = _trackRepository.getSongTracks();
  }

  void _setupAudioPlayerListener() {
    _audioPlayerService.setupPlayerListener((isPlaying) {
      setState(() {
        for (var track in [...noiseTracks, ...lullabyTracks, ...songTracks]) {
          if (isPlaying &&
              _audioPlayerService
                      .audioPlayer.sequenceState?.currentSource?.tag ==
                  track.mediaItem) {
            track.isPlaying = true;
          } else {
            track.isPlaying = false;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _audioPlayerService.dispose();
    super.dispose();
  }

  Future<void> _stopCurrentAudio() async {
    await _audioPlayerService.stop();
    for (var track in [...noiseTracks, ...lullabyTracks, ...songTracks]) {
      track.isPlaying = false;
    }
  }

  void _togglePlaylistTrack(AudioTrack track) {
    setState(() {
      if (track.isInPlaylist) {
        track.isInPlaylist = false;
        playlistTracks.remove(track);
      } else {
        track.isInPlaylist = true;
        playlistTracks.add(track);
      }
    });
  }

  void _removeFromPlaylist(int index) {
    setState(() {
      playlistTracks[index].isInPlaylist = false;
      playlistTracks.removeAt(index);
    });
  }

  void _togglePlaylistLoop() async {
    setState(() {
      isPlaylistLooping = !isPlaylistLooping;
    });
    await _audioPlayerService.setLoopMode(isPlaylistLooping);
  }

  Future<void> _playPlaylist() async {
    if (playlistTracks.isEmpty) return;

    await _stopCurrentAudio();
    await _audioPlayerService.loadPlaylist(playlistTracks);
    await _audioPlayerService.setLoopMode(isPlaylistLooping);
  }

  Future<void> _nextTrack() async {
    if (playlistTracks.isEmpty) return;
    await _audioPlayerService.audioPlayer.seekToNext();
  }

  Future<void> _previousTrack() async {
    if (playlistTracks.isEmpty) return;
    await _audioPlayerService.audioPlayer.seekToPrevious();
  }

  String? _getCurrentTrackTitle() {
    if (playlistTracks.isEmpty) return null;
    final currentIndex = _audioPlayerService.audioPlayer.currentIndex;
    if (currentIndex == null) return null;
    return playlistTracks[currentIndex].title;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: GradientBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 24.0,
                bottom: 48.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Playback controls
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        PlaybackControlsWidget(
                          audioPlayerService: _audioPlayerService,
                          currentTrackTitle: _getCurrentTrackTitle(),
                          onStopPressed: () async {
                            await _stopCurrentAudio();
                            setState(() {});
                          },
                          onPlayPressed: () async {
                            await _playPlaylist();
                            setState(() {});
                          },
                          onPreviousPressed: _previousTrack,
                          onNextPressed: _nextTrack,
                          isPlaylistLooping: isPlaylistLooping,
                          isPlaylistMode: _audioPlayerService.isPlaylistMode,
                          isPlaylistVisible: isPlaylistVisible,
                          onLoopChanged: (_) => _togglePlaylistLoop(),
                          onPlaylistModeChanged: (_) {
                            setState(() {
                              _audioPlayerService.togglePlaylistMode();
                            });
                          },
                          onPlaylistVisibilityChanged: (value) {
                            setState(() {
                              isPlaylistVisible = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  if (!isPlaylistVisible) ...[
                    TabBar(
                      indicatorColor: Colors.orange.shade800,
                      labelColor: Colors.orange.shade800,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(
                          icon:
                              Image.asset('assets/images/noise.png', width: 24),
                          text: 'Noise',
                        ),
                        Tab(
                          icon: Image.asset('assets/images/lullaby.png',
                              width: 24),
                          text: 'Lullaby',
                        ),
                        Tab(
                          icon:
                              Image.asset('assets/images/songs.png', width: 24),
                          text: 'Songs',
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          NoiseTracksGrid(
                            tracks: noiseTracks,
                            onPlayPressed: (index) async {
                              if (noiseTracks[index].isPlaying) {
                                await _stopCurrentAudio();
                              } else {
                                await _stopCurrentAudio();
                                await noiseTracks[index].play();
                                noiseTracks[index].isPlaying = true;
                              }
                              setState(() {});
                            },
                            isPlaylistMode: _audioPlayerService.isPlaylistMode,
                            onPlaylistToggle: _audioPlayerService.isPlaylistMode
                                ? (index) =>
                                    _togglePlaylistTrack(noiseTracks[index])
                                : null,
                          ),
                          LullabyTracksGrid(
                            tracks: lullabyTracks,
                            onPlayPressed: (index) async {
                              if (lullabyTracks[index].isPlaying) {
                                await _stopCurrentAudio();
                              } else {
                                await _stopCurrentAudio();
                                await lullabyTracks[index].play();
                                lullabyTracks[index].isPlaying = true;
                              }
                              setState(() {});
                            },
                            isPlaylistMode: _audioPlayerService.isPlaylistMode,
                            onPlaylistToggle: _audioPlayerService.isPlaylistMode
                                ? (index) =>
                                    _togglePlaylistTrack(lullabyTracks[index])
                                : null,
                          ),
                          SongTracksGrid(
                            tracks: songTracks,
                            onPlayPressed: (index) async {
                              if (songTracks[index].isPlaying) {
                                await _stopCurrentAudio();
                              } else {
                                await _stopCurrentAudio();
                                await songTracks[index].play();
                                songTracks[index].isPlaying = true;
                              }
                              setState(() {});
                            },
                            isPlaylistMode: _audioPlayerService.isPlaylistMode,
                            onPlaylistToggle: _audioPlayerService.isPlaylistMode
                                ? (index) =>
                                    _togglePlaylistTrack(songTracks[index])
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ] else
                    Expanded(
                      child: PlaylistTracksGrid(
                        tracks: playlistTracks,
                        onRemoveFromPlaylist: _removeFromPlaylist,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
