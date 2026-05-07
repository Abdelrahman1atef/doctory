import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/community/data/model/community_models.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PostCardStats extends StatelessWidget {
  final PostModel post;
  final VoidCallback onPostTapped;

  const PostCardStats({
    super.key,
    required this.post,
    required this.onPostTapped,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPostTapped,
      child: Row(
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
    );
  }
}
