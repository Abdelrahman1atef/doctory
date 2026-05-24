import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import '../../../../core/theme/app_colors.dart';

class AudioMessageWidget extends StatefulWidget {
  final String audioUrl;
  final bool isMe;

  const AudioMessageWidget({super.key, required this.audioUrl, required this.isMe});

  @override
  State<AudioMessageWidget> createState() => _AudioMessageWidgetState();
}

class _AudioMessageWidgetState extends State<AudioMessageWidget> {
  late PlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = PlayerController();
    _preparePlayer();
  }

  Future<void> _preparePlayer() async {
    await _controller.preparePlayer(
      path: widget.audioUrl,
      shouldExtractWaveform: true,
      noOfSamples: 50,
      volume: 1.0,
    );
    _controller.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _isPlaying = state == PlayerState.playing);
    });
  }

  @override
  void dispose() {
    _controller.stopAllPlayers();
    _controller.dispose();
    super.dispose();
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
      child: Row(
        children: [
          IconButton(
            onPressed: () async {
              if (_isPlaying) await _controller.pausePlayer();
              else await _controller.startPlayer();
            },
            icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle),
            color: widget.isMe ? Colors.white : AppColors.primary,
          ),
          Expanded(
            child: AudioFileWaveforms(
              size: Size(MediaQuery.of(context).size.width, 50),
              playerController: _controller,
              waveformType: WaveformType.fitWidth,
              playerWaveStyle: PlayerWaveStyle(
                fixedWaveColor: widget.isMe ? Colors.white.withValues(alpha: 0.3) : AppColors.primary.withValues(alpha: 0.3),
                liveWaveColor: widget.isMe ? Colors.white : AppColors.primary,
                spacing: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
