import 'package:doctory/features/community/cubit/post_details_cubit.dart';
import 'package:doctory/features/community/cubit/post_details_states.dart';
import 'package:doctory/features/community/presentation/sections/comments_section.dart';
import 'package:doctory/features/community/presentation/widgets/post_card_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDetailsScrollSection extends StatelessWidget {
  const PostDetailsScrollSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: BlocBuilder<PostDetailsCubit, PostDetailsStates>(
            buildWhen: (previous, current) => current is PostDetailsSuccessState,
            builder: (context, state) {
              final cubit = context.read<PostDetailsCubit>();
              return PostCardWidget(
                post: cubit.post,
                onReactionTapped: (reaction) => cubit.togglePostLike(type: reaction),
                onCommentTapped: () {},
                onPostTapped: () {},
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'comments'.tr(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: CommentsSection()),
      ],
    );
  }
}
