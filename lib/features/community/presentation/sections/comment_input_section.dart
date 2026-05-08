import 'package:doctory/features/community/cubit/post_details_cubit.dart';
import 'package:doctory/features/community/cubit/post_details_states.dart';
import 'package:doctory/features/community/presentation/widgets/comment_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentInputSection extends StatefulWidget {
  final bool autoFocus;

  const CommentInputSection({super.key, this.autoFocus = false});

  @override
  State<CommentInputSection> createState() => _CommentInputSectionState();
}

class _CommentInputSectionState extends State<CommentInputSection> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _commentFocusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostDetailsCubit, PostDetailsStates>(
      builder: (context, state) {
        final isSubmitting = state is PostDetailsActionLoadingState;

        return CommentInputWidget(
          controller: _commentController,
          focusNode: _commentFocusNode,
          isSubmitting: isSubmitting,
          onSend: (text) {
            context.read<PostDetailsCubit>().addComment(text);
            _commentController.clear();
            FocusScope.of(context).unfocus();
          },
        );
      },
    );
  }
}
