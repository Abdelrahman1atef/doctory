import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import '../../../../core/theme/app_colors.dart';

class MessageInputWidget extends StatefulWidget {
  final ValueChanged<String> onSend;
  final ValueChanged<String> onSendVoice;
  final VoidCallback onTyping;
  final Function({required bool isVideo, required bool fromCamera}) onPickMedia;
  final VoidCallback onPickFile;
  final bool showSend;

  const MessageInputWidget({
    super.key,
    required this.onSend,
    required this.onSendVoice,
    required this.onTyping,
    required this.onPickMedia,
    required this.onPickFile,
    required this.showSend,
  });

  @override
  State<MessageInputWidget> createState() => _MessageInputWidgetState();
}

class _MessageInputWidgetState extends State<MessageInputWidget> {
  final TextEditingController _controller = TextEditingController();
  final RecorderController _recorderController = RecorderController();
  bool _isRecording = false;

  @override
  void dispose() {
    _controller.dispose();
    _recorderController.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty || widget.showSend) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final path = await _recorderController.stop(false);
      setState(() => _isRecording = false);
      if (path != null) {
        widget.onSendVoice(path);
      }
    } else {
      await _recorderController.record(path: '${DateTime.now().millisecondsSinceEpoch}.m4a');
      setState(() => _isRecording = true);
    }
  }

  void _showMediaOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('صورة من المعرض'),
              onTap: () {
                Navigator.pop(ctx);
                widget.onPickMedia(isVideo: false, fromCamera: false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('صورة من الكاميرا'),
              onTap: () {
                Navigator.pop(ctx);
                widget.onPickMedia(isVideo: false, fromCamera: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('فيديو من المعرض'),
              onTap: () {
                Navigator.pop(ctx);
                widget.onPickMedia(isVideo: true, fromCamera: false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_call),
              title: const Text('فيديو من الكاميرا'),
              onTap: () {
                Navigator.pop(ctx);
                widget.onPickMedia(isVideo: true, fromCamera: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: const Text('ملف'),
              onTap: () {
                Navigator.pop(ctx);
                widget.onPickFile();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0).copyWith(bottom: kBottomNavigationBarHeight),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          if (!_isRecording)
            IconButton(
              onPressed: () => _showMediaOptions(context),
              icon: Icon(Icons.add_circle_outline, color: AppColors.primary),
            ),
          Expanded(
            child: _isRecording
                ? AudioWaveforms(
                    enableGesture: true,
                    size: Size(MediaQuery.of(context).size.width, 50),
                    recorderController: _recorderController,
                    waveStyle: const WaveStyle(
                      waveColor: Colors.red,
                      extendWaveform: true,
                      showMiddleLine: false,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: AppColors.grey200.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'اكتب رسالة...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onChanged: (text) {
                        setState(() {});
                        if (text.isNotEmpty) widget.onTyping();
                      },
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: (_controller.text.trim().isNotEmpty || widget.showSend)
                ? _handleSend
                : _toggleRecording,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isRecording ? Colors.red : AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isRecording
                    ? Icons.stop
                    : ((_controller.text.trim().isNotEmpty || widget.showSend) ? Icons.send : Icons.mic),
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
