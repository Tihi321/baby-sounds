import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/audio_track.dart';
import '../widgets/audio_track_tile.dart';

class SoundListScreen extends StatefulWidget {
  const SoundListScreen({super.key});

  @override
  State<SoundListScreen> createState() => _SoundListScreenState();
}

class _SoundListScreenState extends State<SoundListScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late final List<AudioTrack> tracks;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayerListener();
    tracks = [
      AudioTrack(
        title: 'White Noise',
        assetPath: 'assets/audio/white-noise.mp3',
        audioPlayer: _audioPlayer,
      ),
      AudioTrack(
        title: 'Waves',
        assetPath: 'assets/audio/waves.mp3',
        audioPlayer: _audioPlayer,
      ),
    ];
  }

  void _setupAudioPlayerListener() {
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      setState(() {
        for (var track in tracks) {
          if (isPlaying &&
              _audioPlayer.sequenceState?.currentSource?.tag ==
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
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _stopCurrentAudio() async {
    await _audioPlayer.stop();
    for (var track in tracks) {
      track.isPlaying = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange.shade200,
              Colors.orange.shade50,
            ],
          ),
        ),
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
                Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Baby Sounds',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                      shadows: [
                        Shadow(
                          color: Colors.orange.shade200,
                          offset: const Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: tracks.length,
                      itemBuilder: (context, index) {
                        return AudioTrackTile(
                          track: tracks[index],
                          onPlayPressed: () async {
                            if (tracks[index].isPlaying) {
                              await _stopCurrentAudio();
                            } else {
                              await _stopCurrentAudio();
                              await tracks[index].play();
                              tracks[index].isPlaying = true;
                            }
                            setState(() {});
                          },
                        );
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
}
