import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/model/message_model.dart';

class ReplyPreviewWidget extends StatelessWidget {
  final MessageModel message;
  final String currentUserId;
  final VoidCallback onCancelReply;

  const ReplyPreviewWidget({
    super.key,
    required this.message,
    required this.currentUserId,
    required this.onCancelReply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.grey200)),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.grey200.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(color: AppColors.primary, width: 4)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.senderId == currentUserId ? 'أنت' : message.senderName,
                    style: AppStyles.s12Medium.semiBold.withColor(AppColors.primary),
                  ),
                  Text(
                    message.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.s12Medium.withColor(AppColors.grey600),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onCancelReply,
              icon: const Icon(Icons.close, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
