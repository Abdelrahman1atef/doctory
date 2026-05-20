import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions.dart';
import '../../data/model/message_model.dart';
import '../../../../core/session/user_session.dart';
import '../../cubit/chat_room/chat_room_cubit.dart';

class ChatMessageWidget extends StatelessWidget {
  final MessageModel message;

  const ChatMessageWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.senderId == UserSession.userId;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () => _showMessageOptions(context),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          padding: const EdgeInsets.all(12.0),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: isMe
                ? AppColors.primary
                : AppColors.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft:
                  isMe ? const Radius.circular(16) : const Radius.circular(4),
              bottomRight:
                  isMe ? const Radius.circular(4) : const Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.replyToMessage != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border(
                      left: BorderSide(
                        color: isMe ? Colors.white70 : AppColors.primary,
                        width: 4,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.replyToMessage!.senderId == UserSession.userId
                            ? 'أنت'
                            : message.replyToMessage!.senderName,
                        style: TextStyle(
                          color: isMe ? Colors.white : AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        message.replyToMessage!.content,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isMe ? Colors.white70 : Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              if (message.media != null && message.media!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Builder(builder: (context) {
                    final mediaItem = message.media!.first;
                    if (mediaItem.mediaType == 0) { // Image
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: mediaItem.fileName.toImageUrl,
                          placeholder: (context, url) => Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.black12,
                            child: const Center(
                                child: CircularProgressIndicator(strokeWidth: 2)),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                      );
                    } else {
                      IconData iconData = Icons.insert_drive_file;
                      String typeName = 'مستند';
                      if (mediaItem.mediaType == 1) {
                        iconData = Icons.videocam;
                        typeName = 'فيديو';
                      } else if (mediaItem.mediaType == 2) {
                        iconData = Icons.audiotrack;
                        typeName = 'صوت';
                      }
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(iconData, color: isMe ? Colors.white : AppColors.primary),
                            const SizedBox(width: 8),
                            Text(
                              typeName,
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
                ),
              Text(
                message.content,
                style: isMe
                    ? AppStyles.s14Medium.withColor(Colors.white)
                    : AppStyles.s14Medium.withColor(Colors.black),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
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
            ],
          ),
        ),
      ),
    );
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

  String _formatTime(DateTime date) {
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  IconData _getStatusIcon(String status, bool isRead) {
    if (status == 'Failed') return Icons.error_outline;
    if (status == 'Sending') return Icons.access_time;
    if (isRead) return Icons.done_all;
    if (status == 'Delivered') return Icons.done_all;
    return Icons.check; // Sent
  }
}
