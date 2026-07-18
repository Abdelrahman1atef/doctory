import 'package:doctory/features/community/data/model/community_models.dart';
import 'package:doctory/features/community/presentation/widgets/community_app_bar.dart';
import 'package:doctory/features/community/presentation/widgets/post_card_widget.dart';
import 'package:doctory/features/create_post/presentation/widgets/post_upload_banner.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PostsListWidget extends StatelessWidget {
  final List<PostModel> posts;
  final bool isLoading;
  final bool isPagination;
  final String? errorMessage;
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;
  final void Function() onRetry;
  final void Function(PostModel, ReactionType) onReactionTapped;
  final void Function(PostModel) onCommentTapped;
  final void Function(PostModel) onReactionsTapped;
  final void Function(PostModel) onPostTapped;
  final void Function(PostModel)? onAvatarTap;

  const PostsListWidget({
    super.key,
    required this.posts,
    required this.isLoading,
    this.isPagination = false,
    this.errorMessage,
    required this.scrollController,
    required this.onRefresh,
    required this.onRetry,
    required this.onReactionTapped,
    required this.onCommentTapped,
    required this.onReactionsTapped,
    required this.onPostTapped,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: Theme.of(context).primaryColor,
      child: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          CommunitySliverAppBar(title: 'community'.tr()),
          const SliverToBoxAdapter(child: PostUploadBanner()),
          if (isLoading && !isPagination)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (errorMessage != null && posts.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(errorMessage!, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: onRetry,
                      child: Text('retry'.tr()),
                    ),
                  ],
                ),
              ),
            )
          else if (posts.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  'no_posts_yet'.tr(),
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= posts.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final post = posts[index];
                  return Column(
                    children: [
                      PostCardWidget(
                        post: post,
                        onReactionTapped: (reaction) =>
                            onReactionTapped(post, reaction),
                        onCommentTapped: () => onCommentTapped(post),
                        onReactionsTapped: () => onReactionsTapped(post),
                        onPostTapped: () => onPostTapped(post),
                        onAvatarTap: onAvatarTap != null ? () => onAvatarTap!(post) : null,
                      ),
                      if (index < posts.length - 1)
                        Container(height: 5, color: AppColors.grey100),
                    ],
                  );
                },
                childCount: posts.length + (isLoading && isPagination ? 1 : 0),
              ),
            ),
        ],
      ),
    );
  }
}
