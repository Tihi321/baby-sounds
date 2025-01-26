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
import '../widgets/custom_tab_bar.dart';
import '../widgets/tab_content.dart';
import '../widgets/track_list_view.dart';
import 'package:just_audio_background/just_audio_background.dart';

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
      if (!mounted) return;
      setState(() {
        for (var track in [...noiseTracks, ...lullabyTracks, ...songTracks]) {
          track.isPlaying = false;
        }

        if (isPlaying) {
          final currentTag =
              _audioPlayerService.audioPlayer.sequenceState?.currentSource?.tag;
          if (currentTag is MediaItem) {
            try {
              final currentTrack = [
                ...noiseTracks,
                ...lullabyTracks,
                ...songTracks
              ].firstWhere((track) => track.mediaItem.id == currentTag.id);
              currentTrack.isPlaying = true;
            } catch (e) {
              debugPrint('Track not found: ${currentTag.id}');
            }
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
    if (!mounted) return; // Add mounted check
    await _audioPlayerService.stop();
    setState(() {
      for (var track in [...noiseTracks, ...lullabyTracks, ...songTracks]) {
        track.isPlaying = false;
      }
    });
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
    final tabImages = [
      'assets/images/songs.png',
      'assets/images/lullaby.png',
      'assets/images/noise.png',
    ];

    return DefaultTabController(
      length: 3,
      initialIndex: 2,
      child: Scaffold(
        body: GradientBackground(
          child: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      24.0, 24.0, 24.0, 120.0), // Increased bottom padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: isPlaylistVisible
                            ? PlaylistTracksGrid(
                                tracks: playlistTracks,
                                onRemoveFromPlaylist: _removeFromPlaylist,
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTabBar(tabImages: tabImages),
                                  Expanded(
                                    child: TabBarView(
                                      children: [
                                        _buildTrackTab(
                                            'Songs',
                                            songTracks,
                                            (tracks, onPlay, isPlaylist,
                                                    onToggle) =>
                                                SongTracksGrid(
                                                    tracks: tracks,
                                                    onPlayPressed: onPlay,
                                                    isPlaylistMode: isPlaylist,
                                                    onPlaylistToggle:
                                                        onToggle)),
                                        _buildTrackTab(
                                            'Lullaby',
                                            lullabyTracks,
                                            (tracks, onPlay, isPlaylist,
                                                    onToggle) =>
                                                LullabyTracksGrid(
                                                    tracks: tracks,
                                                    onPlayPressed: onPlay,
                                                    isPlaylistMode: isPlaylist,
                                                    onPlaylistToggle:
                                                        onToggle)),
                                        _buildTrackTab(
                                            'Noise',
                                            noiseTracks,
                                            (tracks, onPlay, isPlaylist,
                                                    onToggle) =>
                                                NoiseTracksGrid(
                                                    tracks: tracks,
                                                    onPlayPressed: onPlay,
                                                    isPlaylistMode: isPlaylist,
                                                    onPlaylistToggle:
                                                        onToggle)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 8.0),
                    child: PlaybackControlsWidget(
                      audioPlayerService: _audioPlayerService,
                      currentTrackTitle: _getCurrentTrackTitle(),
                      onStopPressed: _stopCurrentAudio,
                      onPlayPressed: _playPlaylist,
                      onPreviousPressed: _previousTrack,
                      onNextPressed: _nextTrack,
                      isPlaylistLooping: isPlaylistLooping,
                      isPlaylistMode: _audioPlayerService.isPlaylistMode,
                      isPlaylistVisible: isPlaylistVisible,
                      onLoopChanged: (_) => _togglePlaylistLoop(),
                      onPlaylistModeChanged: (_) {
                        setState(
                            () => _audioPlayerService.togglePlaylistMode());
                      },
                      onPlaylistVisibilityChanged: (value) {
                        setState(() => isPlaylistVisible = value);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrackTab(
      String title,
      List<AudioTrack> tracks,
      Widget Function(List<AudioTrack>, Function(int), bool, Function(int)?)
          gridBuilder) {
    return TabContent(
      title: title,
      child: TrackListView(
        tracks: tracks,
        onPlayPressed: (index) async {
          if (!mounted) return;
          final track = tracks[index];

          if (track.isPlaying) {
            await _stopCurrentAudio();
          } else {
            // Set states before playing to avoid blank frame
            setState(() {
              for (var t in [...noiseTracks, ...lullabyTracks, ...songTracks]) {
                t.isPlaying = false;
              }
              track.isPlaying = true;
            });

            await track.play();

            if (mounted && !track.isPlaying) {
              // Only update state if play failed
              setState(() {
                track.isPlaying = false;
              });
            }
          }
        },
        isPlaylistMode: _audioPlayerService.isPlaylistMode,
        onPlaylistToggle: _audioPlayerService.isPlaylistMode
            ? (index) => _togglePlaylistTrack(tracks[index])
            : null,
        gridBuilder: gridBuilder,
      ),
    );
  }
}
