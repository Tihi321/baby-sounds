import 'package:flutter/material.dart';
import '../models/audio_track.dart';

class AudioTrackTile extends StatefulWidget {
  final AudioTrack track;
  final VoidCallback onPlayPressed;
  final String imagePath;
  final bool isPlaylistMode;
  final VoidCallback? onPlaylistToggle;

  const AudioTrackTile({
    super.key,
    required this.track,
    required this.imagePath,
    required this.onPlayPressed,
    this.isPlaylistMode = false,
    this.onPlaylistToggle,
  });

  @override
  State<AudioTrackTile> createState() => _AudioTrackTileState();
}

class _AudioTrackTileState extends State<AudioTrackTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPlayPressed,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: widget.track.isLoading ? 0.95 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: widget.track.isPlaying || widget.track.isLoading
                ? Colors.orange.shade200 // Playing/Loading color
                : Colors.orange.shade50, // Default color
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
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset(
                        widget.imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Center(
                    child: Text(
                      widget.track.title,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1, // Changed from 2 to 1
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ),
                ),
                if (!widget.isPlaylistMode)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        setState(() {
                          widget.track.toggleLoop();
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          widget.track.isLooping
                              ? Icons.repeat_one
                              : Icons.repeat,
                          color: widget.track.isLooping
                              ? Colors.orange
                              : Colors.orange.shade300,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                if (widget.isPlaylistMode && widget.onPlaylistToggle != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: widget.onPlaylistToggle,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          widget.track.isInPlaylist
                              ? Icons.playlist_remove
                              : Icons.playlist_add,
                          color: widget.track.isInPlaylist
                              ? Colors.orange
                              : Colors.orange.shade300,
                          size: 24,
                        ),
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
