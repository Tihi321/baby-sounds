import 'package:flutter/material.dart';
import '../services/audio_player_service.dart';

class PlaybackControlsWidget extends StatelessWidget {
  final AudioPlayerService audioPlayerService;
  final String? currentTrackTitle;
  final VoidCallback onStopPressed;
  final VoidCallback onPlayPressed;
  final VoidCallback onPreviousPressed;
  final VoidCallback onNextPressed;
  final bool isPlaylistLooping;
  final bool isPlaylistMode;
  final bool isPlaylistVisible;
  final ValueChanged<bool> onLoopChanged;
  final ValueChanged<bool> onPlaylistModeChanged;
  final ValueChanged<bool> onPlaylistVisibilityChanged;

  const PlaybackControlsWidget({
    super.key,
    required this.audioPlayerService,
    this.currentTrackTitle,
    required this.onStopPressed,
    required this.onPlayPressed,
    required this.onPreviousPressed,
    required this.onNextPressed,
    required this.isPlaylistLooping,
    required this.isPlaylistMode,
    required this.isPlaylistVisible,
    required this.onLoopChanged,
    required this.onPlaylistModeChanged,
    required this.onPlaylistVisibilityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ProgressSection(
          audioPlayerService: audioPlayerService,
          currentTrackTitle: currentTrackTitle,
        ),
        _ControlsSection(
          audioPlayerService: audioPlayerService,
          onStopPressed: onStopPressed,
          onPlayPressed: onPlayPressed,
          onPreviousPressed: onPreviousPressed,
          onNextPressed: onNextPressed,
        ),
        _PlaylistControlsSection(
          isPlaylistLooping: isPlaylistLooping,
          isPlaylistMode: isPlaylistMode,
          isPlaylistVisible: isPlaylistVisible,
          onLoopChanged: onLoopChanged,
          onPlaylistModeChanged: onPlaylistModeChanged,
          onPlaylistVisibilityChanged: onPlaylistVisibilityChanged,
        ),
      ],
    );
  }
}

class _ProgressSection extends StatefulWidget {
  final AudioPlayerService audioPlayerService;
  final String? currentTrackTitle;

  const _ProgressSection({
    required this.audioPlayerService,
    this.currentTrackTitle,
  });

  @override
  State<_ProgressSection> createState() => _ProgressSectionState();
}

class _ProgressSectionState extends State<_ProgressSection> {
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _subscribeToStreams();
  }

  void _subscribeToStreams() {
    widget.audioPlayerService.audioPlayer.positionStream.listen((position) {
      if (!_isDragging && mounted) {
        setState(() => _position = position);
      }
    });

    widget.audioPlayerService.audioPlayer.durationStream.listen((duration) {
      if (mounted) {
        setState(() => _duration = duration ?? Duration.zero);
      }
    });
  }

  String _formatDuration(Duration duration) {
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final double normalizedValue = _duration.inMilliseconds > 0
        ? _position.inMilliseconds / _duration.inMilliseconds
        : 0.0;

    return Column(
      children: [
        RepaintBoundary(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4.0,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 6.0,
              ),
              overlayShape: const RoundSliderOverlayShape(
                overlayRadius: 14.0,
              ),
            ),
            child: Slider(
              value: normalizedValue.clamp(0.0, 1.0),
              min: 0.0,
              max: 1.0,
              activeColor: Colors.orange.shade800,
              inactiveColor: Colors.orange.shade100,
              onChangeStart: (_) => _isDragging = true,
              onChangeEnd: (_) => _isDragging = false,
              onChanged: widget.audioPlayerService.audioPlayer.playing
                  ? (value) {
                      final position = Duration(
                        milliseconds:
                            (value * _duration.inMilliseconds).toInt(),
                      );
                      setState(() => _position = position);
                      widget.audioPlayerService.audioPlayer.seek(position);
                    }
                  : null,
            ),
          ),
        ),
        if (widget.currentTrackTitle != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.currentTrackTitle!,
              style: TextStyle(
                color: Colors.orange.shade800,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_position),
                style: TextStyle(color: Colors.orange.shade800),
              ),
              Text(
                _formatDuration(_duration),
                style: TextStyle(color: Colors.orange.shade800),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ControlsSection extends StatelessWidget {
  final AudioPlayerService audioPlayerService;
  final VoidCallback onStopPressed;
  final VoidCallback onPlayPressed;
  final VoidCallback onPreviousPressed;
  final VoidCallback onNextPressed;

  const _ControlsSection({
    required this.audioPlayerService,
    required this.onStopPressed,
    required this.onPlayPressed,
    required this.onPreviousPressed,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: audioPlayerService.audioPlayer.playingStream,
      builder: (context, snapshot) {
        final isPlaying = snapshot.data ?? false;

        return SizedBox(
          width: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous),
                onPressed: onPreviousPressed,
                color: Colors.orange.shade800,
              ),
              const SizedBox(width: 2),
              IconButton(
                icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                onPressed: isPlaying ? onStopPressed : onPlayPressed,
                color: Colors.orange.shade800,
                iconSize: 32,
              ),
              const SizedBox(width: 2),
              IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: onNextPressed,
                color: Colors.orange.shade800,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PlaylistControlsSection extends StatelessWidget {
  final bool isPlaylistLooping;
  final bool isPlaylistMode;
  final bool isPlaylistVisible;
  final ValueChanged<bool> onLoopChanged;
  final ValueChanged<bool> onPlaylistModeChanged;
  final ValueChanged<bool> onPlaylistVisibilityChanged;

  const _PlaylistControlsSection({
    required this.isPlaylistLooping,
    required this.isPlaylistMode,
    required this.isPlaylistVisible,
    required this.onLoopChanged,
    required this.onPlaylistModeChanged,
    required this.onPlaylistVisibilityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  isPlaylistVisible
                      ? Icons.playlist_play
                      : Icons.playlist_play_outlined,
                  color: Colors.orange.shade800,
                ),
                onPressed: () =>
                    onPlaylistVisibilityChanged(!isPlaylistVisible),
                tooltip: 'Show Playlist',
              ),
              IconButton(
                icon: Icon(
                  isPlaylistLooping ? Icons.repeat_one : Icons.repeat,
                  color: Colors.orange.shade800,
                ),
                onPressed: () => onLoopChanged(!isPlaylistLooping),
                tooltip: 'Loop Playlist',
              ),
              IconButton(
                icon: Icon(
                  isPlaylistMode
                      ? Icons.playlist_add_check
                      : Icons.playlist_add,
                  color: Colors.orange.shade800,
                ),
                onPressed: () => onPlaylistModeChanged(!isPlaylistMode),
                tooltip: 'Playlist Mode',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
