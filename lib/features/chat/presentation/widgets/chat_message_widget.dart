import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/model/message_model.dart';
import '../../../../core/session/user_session.dart';

class ChatMessageWidget extends StatelessWidget {
  final MessageModel message;
  final VoidCallback? onLongPress;

  const ChatMessageWidget({
    Key? key,
    required this.message,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMe = message.senderId == UserSession.userId;
    
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          padding: const EdgeInsets.all(12.0),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: isMe ? AppColors.primary : AppColors.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
              bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.replyToMessage != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    message.replyToMessage!.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isMe ? Colors.white70 : Colors.black54,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
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
