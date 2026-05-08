import 'package:doctory/features/community/presentation/sections/comment_input_section.dart';
import 'package:doctory/features/community/presentation/sections/post_details_scroll_section.dart';
import 'package:doctory/features/community/presentation/widgets/post_details_body_widget.dart';
import 'package:flutter/material.dart';

class PostDetailsBodySection extends StatelessWidget {
  final bool focusComment;

  const PostDetailsBodySection({super.key, required this.focusComment});

  @override
  Widget build(BuildContext context) {
    return PostDetailsBodyWidget(
      scrollSection: const PostDetailsScrollSection(),
      commentInput: CommentInputSection(autoFocus: focusComment),
    );
  }
}
