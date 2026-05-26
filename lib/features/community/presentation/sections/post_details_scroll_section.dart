import 'package:doctory/features/community/cubit/post_details_cubit.dart';
import 'package:doctory/features/community/cubit/post_details_states.dart';
import 'package:doctory/features/community/presentation/sections/comments_section.dart';
import 'package:doctory/features/community/presentation/widgets/post_card_widget.dart';
import 'package:doctory/features/community/presentation/widgets/post_details_scroll_widget.dart';
import 'package:doctory/features/community/presentation/widgets/reactions_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDetailsScrollSection extends StatelessWidget {
  const PostDetailsScrollSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostDetailsCubit, PostDetailsStates>(
      buildWhen: (previous, current) => current is PostDetailsSuccessState,
      builder: (context, state) {
        final cubit = context.read<PostDetailsCubit>();
        return PostDetailsScrollWidget(
          postCard: PostCardWidget(
            post: cubit.post,
            onReactionTapped: (reaction) =>
                cubit.togglePostLike(type: reaction),
            onCommentTapped: () {},
            onPostTapped: () {},
            onReactionsTapped: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: cubit,
                  child: BlocBuilder<PostDetailsCubit, PostDetailsStates>(
                    builder: (context, state) {
                      if (state is PostReactionsLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is PostReactionsSuccessState) {
                        return ReactionsBottomSheet(
                          fetchReactions: (p) => cubit.getPostReactions(cubit.post.id, page: p),
                          reactions: state.reactions,
                          isLoading: false,
                        );
                      }
                      // Trigger fetch on first open
                      cubit.getPostReactions(cubit.post.id);
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              );
            },
          ),
          commentsTitle: 'comments'.tr(),
          commentsSection: const CommentsSection(),
        );
      },
    );
  }
}
