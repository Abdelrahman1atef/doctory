import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/community/data/model/community_models.dart';
import 'package:doctory/features/community/presentation/widgets/post_options_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart' as easy_localization;
import 'package:flutter/material.dart';

class PostCardHeader extends StatelessWidget {
  final PostModel post;

  const PostCardHeader({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
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
          icon: const Icon(Icons.more_horiz, color: AppColors.textSecondary),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              useRootNavigator: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => PostOptionsBottomSheet(post: post),
            );
          },
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return easy_localization.DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
