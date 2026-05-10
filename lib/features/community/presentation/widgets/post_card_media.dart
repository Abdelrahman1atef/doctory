import 'package:doctory/core/common/widgets/images/abher_image.dart';
import 'package:doctory/core/router/router_names.dart';
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
           SizedBox(
              height: 300,
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: widget.post.media.length,
                    scrollDirection: Axis.horizontal,
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
        child: Container(
          color: Colors.grey[200],
          child: AbherImage(
            imageUrl,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
