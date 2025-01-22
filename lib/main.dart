import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.example.baby_sounds.channel.audio',
    androidNotificationChannelName: 'Baby Sounds',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Sounds',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SoundListScreen(),
    );
  }
}

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
      // Update all tracks' playing state
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
      appBar: AppBar(
        title: const Text('Baby Sounds'),
      ),
      body: ListView.builder(
        itemCount: tracks.length,
        itemBuilder: (context, index) {
          return AudioTrackTile(
            track: tracks[index],
            onPlayPressed: () async {
              if (tracks[index].isPlaying) {
                // If the current track is playing, stop it
                await _stopCurrentAudio();
              } else {
                // If a different track is to be played, stop current and play new
                await _stopCurrentAudio();
                await tracks[index].play();
                tracks[index].isPlaying = true;
              }
              setState(() {});
            },
          );
        },
      ),
    );
  }
}

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

class AudioTrackTile extends StatefulWidget {
  final AudioTrack track;
  final VoidCallback onPlayPressed;

  const AudioTrackTile({
    super.key,
    required this.track,
    required this.onPlayPressed,
  });

  @override
  State<AudioTrackTile> createState() => _AudioTrackTileState();
}

class _AudioTrackTileState extends State<AudioTrackTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.track.title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              widget.track.isLooping ? Icons.repeat_one : Icons.repeat,
              color: widget.track.isLooping ? Colors.blue : null,
            ),
            onPressed: () {
              setState(() {
                widget.track.toggleLoop();
              });
            },
          ),
          IconButton(
            icon: Icon(
              widget.track.isPlaying ? Icons.stop : Icons.play_arrow,
            ),
            onPressed: widget.onPlayPressed,
          ),
        ],
      ),
    );
  }
}
