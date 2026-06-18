import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/model/conversation_model.dart';
import '../../data/model/last_message_content_type.dart';
import '../../data/model/media_type.dart';
import 'chat_avatar_widget.dart';
import 'unread_badge_widget.dart';
import '../../../../core/session/user_session.dart';

import '../../../../core/app_strings/locale_keys.dart';

class ConversationItemWidget extends StatelessWidget {
  final ConversationModel conversation;
  final bool isOnline;
  final bool isTyping;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const ConversationItemWidget({
    super.key,
    required this.conversation,
    required this.isOnline,
    required this.isTyping,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserId = UserSession.userId;
    final isInitiator = conversation.initiatorId == currentUserId;

    final displayName = isInitiator ? conversation.recipientName : conversation.initiatorName;
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
                            _formatDate(context, conversation.lastMessageDate!),
                            style: AppStyles.s12Medium.withColor(AppColors.grey600),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: _buildLastMessagePreview()),
                        if (conversation.unreadMessageCount > 0 && !isTyping) ...[
                          const SizedBox(width: 8),
                          UnreadBadgeWidget(count: conversation.unreadMessageCount),
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

  Widget _buildLastMessagePreview() {
    if (isTyping) {
      return Text(
        'يكتب...',
        style: AppStyles.s14SemiBold.withColor(AppColors.primary),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    final hasUnread = conversation.unreadMessageCount > 0;
    final textStyle = hasUnread
        ? AppStyles.s14SemiBold.withColor(AppColors.primary)
        : AppStyles.s14Medium.withColor(AppColors.grey600);

    final showMediaIcon =
        conversation.lastMessageContentType == LastMessageContentType.media ||
        conversation.lastMessageContentType == LastMessageContentType.textAndMedia;

    String content = conversation.lastMessageContent?.trim() ?? '';
    IconData? mediaIcon;

    if (showMediaIcon) {
      switch (conversation.lastMessageMediaType) {
        case MediaType.image:
          mediaIcon = Icons.image_outlined;
          if (content.isEmpty) content = LocaleKeys.photo.tr();
          break;
        case MediaType.video:
          mediaIcon = Icons.play_circle_outline;
          if (content.isEmpty) content = LocaleKeys.video.tr();
          break;
        case MediaType.audio:
          mediaIcon = Icons.mic_none_outlined;
          if (content.isEmpty) content = LocaleKeys.voice.tr();
          break;
        case MediaType.file:
          mediaIcon = Icons.insert_drive_file_outlined;
          if (content.isEmpty) content = LocaleKeys.file.tr();
          break;
        }
    }

    if (content.isEmpty) {
      content = LocaleKeys.chat_last_message_placeholder.tr();
    }

    if (showMediaIcon && mediaIcon != null) {
      return Row(
        children: [
          Icon(mediaIcon, size: 16, color: hasUnread ? AppColors.primary : AppColors.grey600),
          const SizedBox(width: 4),
          Expanded(
            child: Text(content, style: textStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      );
    }

    return Text(content, style: textStyle, maxLines: 1, overflow: TextOverflow.ellipsis);
  }

  String _formatDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      // Return time in 12h format if it's today
      return DateFormat('hh:mm a', context.locale.languageCode).format(date);
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }
}
