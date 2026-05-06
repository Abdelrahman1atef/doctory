import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/community/cubit/post_details_cubit.dart';
import 'package:doctory/features/community/cubit/post_details_states.dart';
import 'package:doctory/features/community/data/model/community_models.dart';
import 'package:doctory/features/community/presentation/sections/comments_section.dart';
import 'package:doctory/features/community/presentation/widgets/post_card_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDetailsView extends StatefulWidget {
  final PostModel post;

  const PostDetailsView({super.key, required this.post});

  @override
  State<PostDetailsView> createState() => _PostDetailsViewState();
}

class _PostDetailsViewState extends State<PostDetailsView> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PostDetailsCubit>()..initPost(widget.post),
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,

          title: Text('post_action'.tr()),
        ),
        body: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: BlocBuilder<PostDetailsCubit, PostDetailsStates>(
                      buildWhen: (previous, current) => current is PostDetailsSuccessState,
                      builder: (context, state) {
                        final cubit = context.read<PostDetailsCubit>();
                        return PostCardWidget(
                          post: cubit.post,
                          onLikeTapped: () => cubit.togglePostLike(),
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
                  const SliverToBoxAdapter(
                    child: CommentsSection(),
                  ),
                ],
              ),
            ),
            _buildCommentInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentInput() {
    return BlocBuilder<PostDetailsCubit, PostDetailsStates>(
      builder: (context, state) {
        final isSubmitting = state is PostDetailsActionLoadingState;
        
        return Container(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(context).padding.bottom + 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'write_comment'.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.grey100,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  maxLines: null,
                ),
              ),
              8.pw,
              FloatingActionButton(
                mini: true,
                onPressed: isSubmitting
                    ? null
                    : () {
                        final text = _commentController.text.trim();
                        if (text.isNotEmpty) {
                          context.read<PostDetailsCubit>().addComment(text);
                          _commentController.clear();
                          // Hide keyboard
                          FocusScope.of(context).unfocus();
                        }
                      },
                backgroundColor: AppColors.stitchPrimary,
                elevation: 0,
                child: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.send, color: Colors.white, size: 18),
              ),
            ],
          ),
        );
      },
    );
  }
}
