import 'package:flutter/material.dart';

class PostDetailsBodyWidget extends StatelessWidget {
  final Widget scrollSection;
  final Widget commentInput;

  const PostDetailsBodyWidget({
    super.key,
    required this.scrollSection,
    required this.commentInput,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: scrollSection),
        commentInput,
      ],
    );
  }
}
