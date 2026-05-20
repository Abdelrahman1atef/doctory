import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/model/conversation_model.dart';
import 'chat_avatar_widget.dart';
import 'unread_badge_widget.dart';
import '../../../../core/session/user_session.dart';

class ConversationItemWidget extends StatelessWidget {
  final ConversationModel conversation;
  final bool isOnline;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const ConversationItemWidget({
    super.key,
    required this.conversation,
    required this.isOnline,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserId = UserSession.userId;
    final isInitiator = conversation.initiatorId == currentUserId;

    final displayName =
        isInitiator ? conversation.recipientName : conversation.initiatorName;
    final displayPicture = isInitiator
        ? conversation.recipientProfilePictureUrl
        : conversation.initiatorProfilePictureUrl;

    return Slidable(
      key: ValueKey(conversation.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onDelete?.call(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'حذف',
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              ChatAvatarWidget(
                imageUrl: displayPicture,
                name: displayName,
                isOnline: isOnline,
                radius: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            displayName,
                            style: AppStyles.s16SemiBold,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (conversation.lastMessageDate != null)
                          Text(
                            _formatDate(conversation.lastMessageDate!),
                            style:
                                AppStyles.s12Medium.withColor(AppColors.grey600),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            conversation.lastMessageContent ??
                                'Started a conversation',
                            style: conversation.unreadMessageCount > 0
                                ? AppStyles.s14SemiBold
                                    .withColor(AppColors.primary)
                                : AppStyles.s14Medium
                                    .withColor(AppColors.grey600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (conversation.unreadMessageCount > 0) ...[
                          const SizedBox(width: 8),
                          UnreadBadgeWidget(
                              count: conversation.unreadMessageCount),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      // Return time if it's today
      return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }
}
