import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PostImageFullScreenView extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const PostImageFullScreenView({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Hero(
            tag: heroTag,
            child: Image.network(
              imageUrl,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
