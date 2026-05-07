import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/community/cubit/community_cubit.dart';
import 'package:doctory/features/community/cubit/community_states.dart';
import 'package:doctory/features/community/presentation/widgets/community_app_bar.dart';
import 'package:doctory/features/community/presentation/widgets/post_card_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PostsListSection extends StatefulWidget {
  const PostsListSection({super.key});

  @override
  State<PostsListSection> createState() => _PostsListSectionState();
}

class _PostsListSectionState extends State<PostsListSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CommunityCubit>().getPosts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<CommunityCubit, CommunityStates>(
        buildWhen: (previous, current) =>
            current is CommunityLoadingState ||
            current is CommunitySuccessState ||
            current is CommunityErrorState,
        builder: (context, state) {
          final cubit = context.read<CommunityCubit>();

          return RefreshIndicator(
            onRefresh: () async {
              await cubit.getPosts(refresh: true);
            },
            // Custom styling for the indicator
            color: Theme.of(context).primaryColor,
            child: CustomScrollView(
              controller: _scrollController,
              // AlwaysScrollable ensures we can pull-to-refresh even if the list is empty or an error occurred
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                CommunitySliverAppBar(title: 'community'.tr()),
                if (state is CommunityLoadingState && !state.isPagination)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state is CommunityErrorState && cubit.posts.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.message, textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => cubit.getPosts(refresh: true),
                            child: Text('retry'.tr()),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (cubit.posts.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        'no_posts_yet'.tr(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= cubit.posts.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final post = cubit.posts[index];
                        return Column(
                          children: [
                            PostCardWidget(
                              post: post,
                              onReactionTapped: (reaction) =>
                                  cubit.toggleLike(post.id, type: reaction),
                              onCommentTapped: () => context.push(
                                AppRoutes.postDetails,
                                extra: {'post': post, 'focusComment': true},
                              ),
                              onPostTapped: () => context.push(
                                AppRoutes.postDetails,
                                extra: {'post': post, 'focusComment': false},
                              ),
                            ),
                            if (index < cubit.posts.length - 1)
                              Container(
                                height: 5,
                                color: AppColors.grey100,
                              ),
                          ],
                        );


                      },
                      childCount:
                          cubit.posts.length +
                          (state is CommunityLoadingState && state.isPagination
                              ? 1
                              : 0),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
