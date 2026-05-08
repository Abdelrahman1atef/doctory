import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/community/data/model/community_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PostCardMedia extends StatefulWidget {
  final PostModel post;

  const PostCardMedia({super.key, required this.post});

  @override
  State<PostCardMedia> createState() => _PostCardMediaState();
}

class _PostCardMediaState extends State<PostCardMedia> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.post.media.isEmpty) return const SizedBox.shrink();

    if (widget.post.media.length == 1) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _buildImage(
            context,
            widget.post.media[0],
            0,
            double.infinity,
            250,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 300,
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: widget.post.media.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return _buildImage(
                        context,
                        widget.post.media[index],
                        index,
                        double.infinity,
                        double.infinity,
                      );
                    },
                  ),
                  // Positioned indicator
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_currentIndex + 1}/${widget.post.media.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Small dots indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.post.media.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                      ? AppColors.stitchPrimary
                      : Colors.grey[300],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(
    BuildContext context,
    MediaModel media,
    int index,
    double width,
    double height,
  ) {
    final heroTag = "postImage_${widget.post.id}_$index";
    final imageUrl = media.fullUrl;

    return GestureDetector(
      onTap: () {
        context.push(
          AppRoutes.postImageView,
          extra: {'imageUrl': imageUrl, 'heroTag': heroTag},
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
