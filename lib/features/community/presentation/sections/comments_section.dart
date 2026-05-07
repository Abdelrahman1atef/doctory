import 'package:doctory/features/community/cubit/post_details_cubit.dart';
import 'package:doctory/features/community/cubit/post_details_states.dart';
import 'package:doctory/features/community/presentation/widgets/comment_item_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentsSection extends StatefulWidget {
  const CommentsSection({super.key});

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      context.read<PostDetailsCubit>().getComments();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostDetailsCubit, PostDetailsStates>(
      buildWhen: (previous, current) => 
        current is PostDetailsSuccessState || 
        current is PostDetailsLoadingState,
      builder: (context, state) {
        final cubit = context.read<PostDetailsCubit>();
        final comments = cubit.comments;

        if (state is PostDetailsLoadingState && !state.isPagination && comments.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (comments.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: Text(
                'no_comments_yet'.tr(),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          shrinkWrap: true, // Needed because it's inside a CustomScrollView or another list
          physics: const NeverScrollableScrollPhysics(), // Scroll handled by parent View
          itemCount: comments.length + (state is PostDetailsLoadingState && state.isPagination ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= comments.length) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final comment = comments[index];
            return CommentItemWidget(
              comment: comment,
              onLikeTapped: () => cubit.toggleCommentLike(comment.id),
            );
          },
        );
      },
    );
  }
}
