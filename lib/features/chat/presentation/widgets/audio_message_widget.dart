import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/theme/app_colors.dart';

class AudioMessageWidget extends StatefulWidget {
  final String audioUrl;
  final bool isMe;

  const AudioMessageWidget({super.key, required this.audioUrl, required this.isMe});

  @override
  State<AudioMessageWidget> createState() => _AudioMessageWidgetState();
}

class _AudioMessageWidgetState extends State<AudioMessageWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _isPlaying = state == PlayerState.playing);
    });
    _audioPlayer.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });
    _audioPlayer.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlaybackSpeed() {
    setState(() {
      if (_playbackSpeed == 1.0) _playbackSpeed = 1.5;
      else if (_playbackSpeed == 1.5) _playbackSpeed = 2.0;
      else _playbackSpeed = 1.0;
      _audioPlayer.setPlaybackRate(_playbackSpeed);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: widget.isMe ? Colors.white.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  if (_isPlaying) await _audioPlayer.pause();
                  else await _audioPlayer.play(UrlSource(widget.audioUrl));
                },
                icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle),
                color: widget.isMe ? Colors.white : AppColors.primary,
              ),
              Expanded(
                child: Slider(
                  value: _position.inSeconds.toDouble(),
                  max: _duration.inSeconds.toDouble().clamp(0.0, double.infinity),
                  onChanged: (val) => _audioPlayer.seek(Duration(seconds: val.toInt())),
                  activeColor: widget.isMe ? Colors.white : AppColors.primary,
                  inactiveColor: (widget.isMe ? Colors.white : AppColors.primary).withValues(alpha: 0.3),
                ),
              ),
              InkWell(
                onTap: _togglePlaybackSpeed,
                child: Text('${_playbackSpeed}x', style: TextStyle(color: widget.isMe ? Colors.white : AppColors.primary)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(_position), style: TextStyle(fontSize: 10, color: widget.isMe ? Colors.white70 : Colors.black54)),
                Text(_formatDuration(_duration), style: TextStyle(fontSize: 10, color: widget.isMe ? Colors.white70 : Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) => "${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}";
}
