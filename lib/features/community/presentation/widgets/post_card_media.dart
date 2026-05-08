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
    
    // Only dealing with the first 4 images to make a compact grid
    final mediaToShow = post.media.take(4).toList();
    final hasMore = post.media.length > 4;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _buildGrid(context, mediaToShow, hasMore),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<MediaModel> media, bool hasMore) {
    if (media.length == 1) {
      return _buildImage(context, media[0], 0, double.infinity, 250);
    } else if (media.length == 2) {
      return SizedBox(
        height: 200,
        child: Row(
          children: [
            Expanded(child: _buildImage(context, media[0], 0, double.infinity, double.infinity)),
            const SizedBox(width: 4),
            Expanded(child: _buildImage(context, media[1], 1, double.infinity, double.infinity)),
          ],
        ),
      );
    } else if (media.length == 3) {
      return SizedBox(
        height: 250,
        child: Row(
          children: [
            Expanded(flex: 2, child: _buildImage(context, media[0], 0, double.infinity, double.infinity)),
            const SizedBox(width: 4),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(child: _buildImage(context, media[1], 1, double.infinity, double.infinity)),
                  const SizedBox(height: 4),
                  Expanded(child: _buildImage(context, media[2], 2, double.infinity, double.infinity)),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 250,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildImage(context, media[0], 0, double.infinity, double.infinity)),
                  const SizedBox(width: 4),
                  Expanded(child: _buildImage(context, media[1], 1, double.infinity, double.infinity)),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildImage(context, media[2], 2, double.infinity, double.infinity)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _buildImage(context, media[3], 3, double.infinity, double.infinity),
                        if (hasMore)
                          Container(
                            color: Colors.black54,
                            alignment: Alignment.center,
                            child: Text(
                              '+${post.media.length - 4}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildImage(BuildContext context, MediaModel media, int index, double width, double height) {
    final heroTag = "postImage_${post.id}_$index";
    final imageUrl = media.url;

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
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
