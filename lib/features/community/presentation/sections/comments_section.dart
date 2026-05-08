import 'package:doctory/features/community/cubit/post_details_cubit.dart';
import 'package:doctory/features/community/cubit/post_details_states.dart';
import 'package:doctory/features/community/presentation/widgets/comments_list_widget.dart';
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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
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
        return CommentsListWidget(
          comments: cubit.comments,
          isLoading: state is PostDetailsLoadingState,
          isPagination: state is PostDetailsLoadingState
              ? state.isPagination
              : false,
          scrollController: _scrollController,
          onLikeTapped: (comment) => cubit.toggleCommentLike(comment.id),
        );
      },
    );
  }
}
