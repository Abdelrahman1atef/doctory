import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/community/data/repo/community_repo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PostDeepLinkView extends StatefulWidget {
  final String postId;

  const PostDeepLinkView({super.key, required this.postId});

  @override
  State<PostDeepLinkView> createState() => _PostDeepLinkViewState();
}

class _PostDeepLinkViewState extends State<PostDeepLinkView> {
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPost();
  }

  Future<void> _loadPost() async {
    final repo = sl<CommunityRepo>();
    final result = await repo.getPostById(widget.postId);

    if (!mounted) return;

    result.fold(
      onSuccess: (post) {
        context.go(AppRoutes.postDetails, extra: post);
      },
      onFailure: (failure) {
        setState(() => _error = failure.message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _error != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(_error!, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go(AppRoutes.home),
                    child: const Text('Back to Home'),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
