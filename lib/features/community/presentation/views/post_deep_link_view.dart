import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/community/cubit/post_details_cubit.dart';
import 'package:doctory/features/community/data/model/community_models.dart';
import 'package:doctory/features/community/data/repo/community_repo.dart';
import 'package:doctory/features/community/presentation/sections/post_details_body_section.dart';
import 'package:doctory/features/community/presentation/widgets/community_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PostDeepLinkView extends StatefulWidget {
  final String postId;

  const PostDeepLinkView({super.key, required this.postId});

  @override
  State<PostDeepLinkView> createState() => _PostDeepLinkViewState();
}

class _PostDeepLinkViewState extends State<PostDeepLinkView> {
  PostModel? _post;
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
      onSuccess: (post) => setState(() => _post = post),
      onFailure: (failure) => setState(() => _error = failure.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommunityAppBar(title: 'post_action'.tr()),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(
        child: Column(
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
        ),
      );
    }

    if (_post == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return BlocProvider(
      create: (_) => sl<PostDetailsCubit>()..initPost(_post!),
      child: const PostDetailsBodySection(focusComment: false),
    );
  }
}
