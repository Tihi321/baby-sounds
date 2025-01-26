import 'package:flutter/material.dart';
import '../services/audio_player_service.dart';
import '../models/audio_track.dart';
import '../widgets/gradient_background.dart';
import '../widgets/sound_title.dart';
import '../widgets/noise_tracks_grid.dart';
import '../widgets/lullaby_tracks_grid.dart';
import '../widgets/song_tracks_grid.dart';

class SoundListScreen extends StatefulWidget {
  const SoundListScreen({super.key});

  @override
  State<SoundListScreen> createState() => _SoundListScreenState();
}

class _SoundListScreenState extends State<SoundListScreen> {
  final AudioPlayerService _audioPlayerService = AudioPlayerService();
  late final List<AudioTrack> noiseTracks;
  late final List<AudioTrack> lullabyTracks;
  late final List<AudioTrack> songTracks;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayerListener();
    noiseTracks = [
      AudioTrack(
        title: 'White Noise',
        assetPath: 'assets/audio/noise/white-noise.mp3',
        audioService: _audioPlayerService,
      ),
      AudioTrack(
        title: 'Waves',
        assetPath: 'assets/audio/noise/waves-noise.mp3',
        audioService: _audioPlayerService,
      ),
    ];

    lullabyTracks = [
      AudioTrack(
        title: 'Calm Lullaby',
        assetPath: 'assets/audio/lullaby/calm-and-focused-lull.mp3',
        audioService: _audioPlayerService,
      ),
      AudioTrack(
        title: 'Mozart Lullaby',
        assetPath: 'assets/audio/lullaby/mozart-brahms-lull.mp3',
        audioService: _audioPlayerService,
      ),
      AudioTrack(
        title: 'Mozart Lullaby Second',
        assetPath: 'assets/audio/lullaby/mozart-brahms-sec-lull.mp3',
        audioService: _audioPlayerService,
      ),
    ];

    songTracks = [
      AudioTrack(
        title: 'Cujem Te',
        assetPath: 'assets/audio/pjesme/cujem-te meri-jaman.mp3',
        audioService: _audioPlayerService,
      ),
      AudioTrack(
        title: 'Cuvajmo Boje Vode',
        assetPath: 'assets/audio/pjesme/cuvajmo-boje-vode-jelena-radan.mp3',
        audioService: _audioPlayerService,
      ),
      AudioTrack(
        title: 'Jedan Djecak',
        assetPath: 'assets/audio/pjesme/jedan-djecak-anita-valo.mp3',
        audioService: _audioPlayerService,
      ),
      AudioTrack(
        title: 'Kuca Luda',
        assetPath: 'assets/audio/pjesme/kuca-luda.mp3',
        audioService: _audioPlayerService,
      ),
      AudioTrack(
        title: 'Leti Poput Petra Pana',
        assetPath: 'assets/audio/pjesme/leti-poput-petra-pana-aljosa-seric.mp3',
        audioService: _audioPlayerService,
      ),
      AudioTrack(
        title: 'Mjesto Za Mene',
        assetPath:
            'assets/audio/pjesme/mjesto-za-mene-goran-boskovic-meri-jaman-jelena-radan.mp3',
        audioService: _audioPlayerService,
      ),
      AudioTrack(
        title: 'Place For Us',
        assetPath:
            'assets/audio/pjesme/place-for-us-goran-boskovic-meri-jaman-jelena-radan.mp3',
        audioService: _audioPlayerService,
      ),
      AudioTrack(
        title: 'Rejna',
        assetPath: 'assets/audio/pjesme/rejna-viktorija-novosel.mp3',
        audioService: _audioPlayerService,
      ),
    ];
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
                      Tab(
                        icon: Image.asset('assets/images/songs.png', width: 24),
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
