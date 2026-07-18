import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/community/data/model/community_models.dart';
import 'package:doctory/features/community/presentation/widgets/expandable_text_widget.dart';
import 'package:doctory/features/community/presentation/widgets/post_card_actions.dart';
import 'package:doctory/features/community/presentation/widgets/post_card_header.dart';
import 'package:doctory/features/community/presentation/widgets/post_card_media.dart';
import 'package:doctory/features/community/presentation/widgets/post_card_stats.dart';
import 'package:flutter/material.dart';

class PostCardWidget extends StatelessWidget {
  final PostModel post;
  final Function(ReactionType) onReactionTapped;
  final VoidCallback onCommentTapped;
  final VoidCallback onReactionsTapped;
  final VoidCallback? onPostTapped;
  final VoidCallback? onAvatarTap;

  const PostCardWidget({
    super.key,
    required this.post,
    required this.onReactionTapped,
    required this.onCommentTapped,
    required this.onReactionsTapped,
    this.onPostTapped,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PostCardHeader(post: post, onAvatarTap: onAvatarTap),
                12.ph,
                ExpandableTextWidget(text: post.content),
              ],
            ),
          ),
          PostCardMedia(post: post),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                PostCardStats(
                  post: post,
                  onPostTapped: onPostTapped ?? onCommentTapped,
                  onReactionsTapped: onReactionsTapped,
                ),
                Divider(height: 24, thickness: 1, color: AppColors.grey100),
                PostCardActions(
                  post: post,
                  onReactionTapped: onReactionTapped,
                  onCommentTapped: onCommentTapped,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
