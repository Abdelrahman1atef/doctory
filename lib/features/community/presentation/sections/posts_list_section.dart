import 'dart:async';
import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/services/post_upload_service.dart';
import 'package:doctory/features/community/cubit/community_cubit.dart';
import 'package:doctory/features/community/cubit/community_states.dart';
import 'package:doctory/features/community/presentation/widgets/posts_list_widget.dart';
import 'package:doctory/features/community/presentation/widgets/reactions_bottom_sheet.dart';
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
  late final StreamSubscription _uploadSubscription;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Listen to background uploads to refresh the feed on success
    _uploadSubscription = sl<PostUploadService>().tasksStream.listen((tasks) {
      if (tasks.any((t) => t.status == UploadStatus.success)) {
        if (mounted) {
          context.read<CommunityCubit>().getPosts(refresh: true);
        }
      }
    });
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
    _uploadSubscription.cancel();
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

          return PostsListWidget(
            posts: cubit.posts,
            isLoading: state is CommunityLoadingState,
            isPagination: state is CommunityLoadingState
                ? state.isPagination
                : false,
            errorMessage: state is CommunityErrorState ? state.message : null,
            scrollController: _scrollController,
            onRefresh: () => cubit.getPosts(refresh: true),
            onRetry: () => cubit.getPosts(refresh: true),
            onReactionTapped: (post, reaction) =>
                cubit.toggleLike(post.id, type: reaction),
            onCommentTapped: (post) => context.push(
              AppRoutes.postDetails,
              extra: {'post': post, 'focusComment': true},
            ),
            onPostTapped: (post) => context.push(
              AppRoutes.postDetails,
              extra: {'post': post, 'focusComment': false},
            ),
            onReactionsTapped: (post) {
              final cubit = context.read<CommunityCubit>();
              showModalBottomSheet(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: cubit,
                  child: BlocBuilder<CommunityCubit, CommunityStates>(
                    builder: (context, state) {
                      if (state is CommunityReactionsLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is CommunityReactionsSuccessState) {
                        return ReactionsBottomSheet(
                          fetchReactions: (p) =>
                              cubit.getPostReactions(post.id, page: p),
                          reactions: state.reactions,
                          isLoading: false,
                        );
                      }
                      // Fetch reactions when the bottom sheet is first built
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        cubit.getPostReactions(post.id);
                      });
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
