import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../data/model/message_model.dart';
import '../../../../core/session/user_session.dart';
import '../../cubit/chat_room/chat_room_cubit.dart';
import '../../data/model/message_status.dart';
import 'image_preview_widget.dart';
import 'video_player_widget.dart';
import 'audio_message_widget.dart';

class ChatMessageWidget extends StatelessWidget {
  final MessageModel message;
  final bool isHighlighted;

  const ChatMessageWidget({
    super.key,
    required this.message,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.senderId == UserSession.userId;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () => _showMessageOptions(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isHighlighted
                ? (isMe ? AppColors.primary.withValues(alpha: 0.8) : Colors.yellow.withValues(alpha: 0.3))
                : (isMe ? AppColors.primary : Colors.white),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
              bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
            ),
            border: isHighlighted ? Border.all(color: AppColors.primary, width: 1) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.media != null && message.media!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: _buildMediaContent(message.media!.first, isMe),
                ),
              
              if (message.content.trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ),
                
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(message.createdAt),
                      style: TextStyle(
                        color: isMe ? Colors.white70 : Colors.black54,
                        fontSize: 10,
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      Icon(
                        _getStatusIcon(message.status, message.isRead),
                        size: 12,
                        color: message.isRead ? Colors.blue : Colors.white70,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaContent(dynamic media, bool isMe) {
    final isImage = media.type == 'image' || media.mediaType == 0;
    final isVideo = media.type == 'video' || media.mediaType == 1;
    final isAudio = media.type == 'audio' || media.mediaType == 2;

    if (isImage) {
      return ImagePreviewWidget(imageUrl: media.url ?? media.fileName.toImageUrl);
    } else if (isVideo) {
      return VideoPlayerWidget(videoUrl: media.url ?? media.fileName.toImageUrl);
    } else if (isAudio) {
      return AudioMessageWidget(audioUrl: media.url ?? media.fileName.toImageUrl, isMe: isMe);
    }
    return const SizedBox.shrink();
  }

  String _formatTime(DateTime date) => "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

  IconData _getStatusIcon(MessageStatus status, bool isRead) {
    if (status == MessageStatus.failed) return Icons.error_outline;
    if (status == MessageStatus.pending) return Icons.access_time;
    if (status == MessageStatus.read) return Icons.done_all;
    if (status == MessageStatus.delivered) return Icons.done_all;
    return Icons.check;
  }

  void _showMessageOptions(BuildContext context) {
    final cubit = context.read<ChatRoomCubit>();
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.reply),
              title: const Text('رد'),
              onTap: () {
                cubit.setReplyMessage(message);
                Navigator.pop(context);
              },
            ),
            if (message.senderId == UserSession.userId)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('حذف', style: TextStyle(color: Colors.red)),
                onTap: () {
                  cubit.deleteMessage(message.id);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}
