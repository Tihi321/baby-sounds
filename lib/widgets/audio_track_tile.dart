import 'package:flutter/material.dart';
import '../models/audio_track.dart';

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
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    String imagePath = widget.track.title == 'White Noise'
        ? 'assets/images/noise.png'
        : 'assets/images/waves.png';

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    widget.track.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          widget.track.isLooping
                              ? Icons.repeat_one
                              : Icons.repeat,
                          color: widget.track.isLooping
                              ? Colors.orange
                              : Colors.orange.shade300,
                        ),
                        onPressed: () {
                          setState(() {
                            widget.track.toggleLoop();
                          });
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              widget.track.isPlaying
                                  ? Icons.stop
                                  : Icons.play_arrow,
                              size: 32,
                              color: Colors.orange.shade800,
                            ),
                            onPressed: widget.onPlayPressed,
                          ),
                        ),
                      ),
                    ],
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
