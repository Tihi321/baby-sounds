import 'package:flutter/material.dart';
import '../services/audio_player_service.dart';
import '../models/audio_track.dart';
import '../widgets/gradient_background.dart';
import '../widgets/sound_title.dart';
import '../widgets/sooth_tracks_grid.dart';
import '../widgets/lullaby_tracks_grid.dart';

class SoundListScreen extends StatefulWidget {
  const SoundListScreen({super.key});

  @override
  State<SoundListScreen> createState() => _SoundListScreenState();
}

class _SoundListScreenState extends State<SoundListScreen> {
  final AudioPlayerService _audioPlayerService = AudioPlayerService();
  late final List<AudioTrack> soothTracks;
  late final List<AudioTrack> lullabyTracks;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayerListener();
    soothTracks = [
      AudioTrack(
        title: 'White Noise',
        assetPath: 'assets/audio/noise/white-noise.mp3',
        audioPlayer: _audioPlayerService.audioPlayer,
      ),
      AudioTrack(
        title: 'Waves',
        assetPath: 'assets/audio/noise/waves-noise.mp3',
        audioPlayer: _audioPlayerService.audioPlayer,
      ),
    ];

    lullabyTracks = [
      AudioTrack(
        title: 'Calm Lullaby',
        assetPath: 'assets/audio/lullaby/calm-and-focused-lull.mp3',
        audioPlayer: _audioPlayerService.audioPlayer,
      ),
      AudioTrack(
        title: 'Mozart Lullaby',
        assetPath: 'assets/audio/lullaby/mozart-brahms-lull.mp3',
        audioPlayer: _audioPlayerService.audioPlayer,
      ),
      AudioTrack(
        title: 'Mozart Lullaby Second',
        assetPath: 'assets/audio/lullaby/mozart-brahms-sec-lull.mp3',
        audioPlayer: _audioPlayerService.audioPlayer,
      ),
    ];
  }

  void _setupAudioPlayerListener() {
    _audioPlayerService.setupPlayerListener((isPlaying) {
      setState(() {
        for (var track in [...soothTracks, ...lullabyTracks]) {
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
    for (var track in [...soothTracks, ...lullabyTracks]) {
      track.isPlaying = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
                  const SoundTitle(),
                  TabBar(
                    indicatorColor: Colors.orange.shade800,
                    labelColor: Colors.orange.shade800,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(
                        icon: Image.asset('assets/images/noise.png', width: 24),
                        text: 'Noise',
                      ),
                      Tab(
                        icon:
                            Image.asset('assets/images/lullaby.png', width: 24),
                        text: 'Lullaby',
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        SoothTracksGrid(
                          tracks: soothTracks,
                          onPlayPressed: (index) async {
                            if (soothTracks[index].isPlaying) {
                              await _stopCurrentAudio();
                            } else {
                              await _stopCurrentAudio();
                              await soothTracks[index].play();
                              soothTracks[index].isPlaying = true;
                            }
                            setState(() {});
                          },
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
                        ),
                      ],
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
