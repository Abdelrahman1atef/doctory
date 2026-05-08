import 'package:flutter/material.dart';

class PostDetailsScrollWidget extends StatelessWidget {
  final Widget postCard;
  final String commentsTitle;
  final Widget commentsSection;

  const PostDetailsScrollWidget({
    super.key,
    required this.postCard,
    required this.commentsTitle,
    required this.commentsSection,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: postCard),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              commentsTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SliverToBoxAdapter(child: commentsSection),
      ],
    );
  }
}
