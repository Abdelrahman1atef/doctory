import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/community/cubit/community_cubit.dart';
import 'package:doctory/features/community/cubit/community_states.dart';
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
              // Await the future so the indicator stays until loading is done
              await cubit.getPosts(refresh: true);
            },
            // Custom styling for the indicator
            color: Theme.of(context).primaryColor, 
            child: CustomScrollView(
              controller: _scrollController,
              // AlwaysScrollable ensures we can pull-to-refresh even if the list is empty or an error occurred
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  title: Text('community'.tr()),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  floating: true,
                  snap: true,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                ),
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
                        style: const TextStyle(color: Colors.grey, fontSize: 16),
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
                        return PostCardWidget(
                          post: post,
                          onLikeTapped: () => cubit.toggleLike(post.id),
                          onCommentTapped: () =>
                              context.push(AppRoutes.postDetails, extra: post),
                          onPostTapped: () =>
                              context.push(AppRoutes.postDetails, extra: post),
                        );
                      },
                      childCount: cubit.posts.length +
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
