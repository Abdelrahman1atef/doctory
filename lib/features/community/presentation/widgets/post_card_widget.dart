import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/community/data/model/community_models.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PostCardWidget extends StatelessWidget {
  final PostModel post;
  final VoidCallback onLikeTapped;
  final VoidCallback onCommentTapped;
  final VoidCallback onPostTapped;

  const PostCardWidget({
    super.key,
    required this.post,
    required this.onLikeTapped,
    required this.onCommentTapped,
    required this.onPostTapped,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPostTapped,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Author Info
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      post.authorImage != null && post.authorImage!.isNotEmpty
                      ? NetworkImage(post.authorImage!)
                      : null,
                  backgroundColor: AppColors.grey100,
                  child: post.authorImage == null || post.authorImage!.isEmpty
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
                ),
                12.pw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName ?? 'user'.tr(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      2.ph,
                      Text(
                        _formatDate(post.createdAt),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.more_horiz,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {}, // More options
                ),
              ],
            ),
            12.ph,
            // Body: Content
            Text(
              post.content,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
            // Body: Media
            if (post.media.isNotEmpty) ...[
              12.ph,
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  post.media.first.url,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: AppColors.grey100,
                    child: const Center(child: Icon(Icons.error)),
                  ),
                ),
              ),
            ],
            16.ph,
            // Footer: Stats
            Row(
              children: [
                const Icon(
                  Icons.thumb_up,
                  size: 14,
                  color: AppColors.stitchPrimary,
                ),
                4.pw,
                Text(
                  '${post.reactionCount}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                Text(
                  '${post.commentCount} ${'comments'.tr()}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            Divider(height: 24, thickness: 1, color: AppColors.grey100),
            // Footer: Actions
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: post.isLikedByMe
                        ? Icons.thumb_up
                        : Icons.thumb_up_outlined,
                    color: post.isLikedByMe
                        ? AppColors.stitchPrimary
                        : AppColors.textSecondary,
                    label: 'like'.tr(),
                    onTap: onLikeTapped,
                  ),
                ),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.chat_bubble_outline,
                    color: AppColors.textSecondary,
                    label: 'comment'.tr(),
                    onTap: onCommentTapped,
                  ),
                ),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.share_outlined,
                    color: AppColors.textSecondary,
                    label: 'share'.tr(),
                    onTap: () {}, // Share action
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: color),
            8.pw,
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
