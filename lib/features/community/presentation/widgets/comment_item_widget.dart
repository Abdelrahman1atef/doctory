import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/community/data/model/community_models.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CommentItemWidget extends StatelessWidget {
  final CommentModel comment;
  final VoidCallback onLikeTapped;

  const CommentItemWidget({
    super.key,
    required this.comment,
    required this.onLikeTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage:
                comment.authorImage != null && comment.authorImage!.isNotEmpty
                ? NetworkImage(comment.authorImage!)
                : null,
            backgroundColor: AppColors.grey100,
            child: comment.authorImage == null || comment.authorImage!.isEmpty
                ? const Icon(Icons.person, color: Colors.grey, size: 20)
                : null,
          ),
          12.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.authorName ?? 'user'.tr(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      4.ph,
                      Text(
                        comment.content,
                        style: const TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ],
                  ),
                ),
                4.ph,
                Row(
                  children: [
                    Text(
                      _formatDate(comment.createdAt),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    16.pw,
                    InkWell(
                      onTap: onLikeTapped,
                      child: Text(
                        'like'.tr(),
                        style: TextStyle(
                          fontWeight: comment.myReaction != ReactionType.none
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: comment.myReaction != ReactionType.none
                              ? AppColors.stitchPrimary
                              : AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (comment.reactionCount > 0) ...[
                      8.pw,
                      const Icon(
                        Icons.thumb_up,
                        size: 12,
                        color: AppColors.stitchPrimary,
                      ),
                      4.pw,
                      Text(
                        '${comment.reactionCount}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      // Just returning a simple format, ideally something like "2 hours ago"
      return DateFormat('dd MMM, hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
