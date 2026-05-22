import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class MessageInputWidget extends StatefulWidget {
  final ValueChanged<String> onSend;
  final VoidCallback onTyping;
  final Function({required bool isVideo, required bool fromCamera}) onPickMedia;
  final VoidCallback onPickFile;

  const MessageInputWidget({
    super.key,
    required this.onSend,
    required this.onTyping,
    required this.onPickMedia,
    required this.onPickFile,
  });

  @override
  State<MessageInputWidget> createState() => _MessageInputWidgetState();
}

class _MessageInputWidgetState extends State<MessageInputWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: () => _showMediaOptions(context),
              icon: Icon(Icons.add_circle_outline, color: AppColors.primary),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.grey200.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'اكتب رسالة...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (text) {
                    if (text.isNotEmpty) {
                      widget.onTyping();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _handleSend,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
