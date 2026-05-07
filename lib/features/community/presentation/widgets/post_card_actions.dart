import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/community/data/model/community_models.dart';
import 'package:doctory/features/community/presentation/widgets/post_card_action_button.dart';
import 'package:doctory/features/community/presentation/widgets/reaction_button_content_widget.dart';
import 'package:easy_localization/easy_localization.dart'as easy_localization;
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';

class PostCardActions extends StatelessWidget {
  final PostModel post;
  final Function(ReactionType) onReactionTapped;
  final VoidCallback onCommentTapped;

  const PostCardActions({
    super.key,
    required this.post,
    required this.onReactionTapped,
    required this.onCommentTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: ReactionButton<ReactionType>(
              onReactionChanged: (Reaction<ReactionType>? reaction) {
                if (reaction != null && reaction.value != null) {
                  onReactionTapped(reaction.value!);
                } else {
                  onReactionTapped(post.myReaction);
                }
              },
              reactions: ReactionType.values
                  .where((r) => r != ReactionType.none)
                  .map((reaction) {
                return Reaction<ReactionType>(
                  value: reaction,
                  previewIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                    child: Text(
                      ReactionEmojiHelper.getReactionEmoji(reaction),
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                  icon: ReactionButtonContentWidget(type: reaction),
                );
              }).toList(),
              placeholder: const Reaction<ReactionType>(
                value: ReactionType.none,
                icon: ReactionButtonContentWidget(type: ReactionType.none),
              ),
              selectedReaction: post.myReaction != ReactionType.none
                  ? Reaction<ReactionType>(
                      value: post.myReaction,
                      icon: ReactionButtonContentWidget(type: post.myReaction),
                    )
                  : null,
              itemSize: const Size(40, 40),
              boxElevation: 4,
              boxRadius: 24,
              boxColor: Colors.white,
              boxPadding: const EdgeInsets.all(4),
            ),
          ),
        ),
        Expanded(
          child: PostCardActionButton(
            icon: Icons.chat_bubble_outline,
            color: AppColors.textSecondary,
            label: 'comment'.tr(),
            onTap: onCommentTapped,
          ),
        ),
        Expanded(
          child: PostCardActionButton(
            icon: Icons.share_outlined,
            color: AppColors.textSecondary,
            label: 'share'.tr(),
            onTap: () {}, // Share action
          ),
        ),
      ],
    );
  }
}
