import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/community/data/model/community_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PostCardMedia extends StatelessWidget {
  final PostModel post;

  const PostCardMedia({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    if (post.media.isEmpty) return const SizedBox.shrink();
    
    final heroTag = "postImage_${post.id}";
    final imageUrl = post.media.first.url;

    return GestureDetector(
      onTap: () {
        context.push(
          AppRoutes.postImageView,
          extra: {
            'imageUrl': imageUrl,
            'heroTag': heroTag,
          },
        );
      },
      child: Hero(
        tag: heroTag,
        child: Image.network(
          imageUrl,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: double.infinity,
            height: 200,
            color: Colors.grey[200],
            child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
