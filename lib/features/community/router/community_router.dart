import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/community/data/model/community_models.dart';
import 'package:doctory/features/community/presentation/views/community_view.dart';
import 'package:doctory/features/community/presentation/views/create_post_view.dart';
import 'package:doctory/features/community/presentation/views/post_details_view.dart';
import 'package:doctory/features/community/presentation/widgets/post_image_full_screen_view.dart';
import 'package:go_router/go_router.dart';

class CommunityRouter {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.community,
      builder: (context, state) => const CommunityView(),
    ),
  ];

  static final List<RouteBase> globalRoutes = [
    GoRoute(
      path: AppRoutes.createPost,
      builder: (context, state) => const CreatePostView(),
    ),
    GoRoute(
      path: AppRoutes.postDetails,
      builder: (context, state) {
        if (state.extra is Map<String, dynamic>) {
          final data = state.extra as Map<String, dynamic>;
          final post = data['post'] as PostModel;
          final focusComment = data['focusComment'] as bool? ?? false;
          return PostDetailsView(post: post, focusComment: focusComment);
        }
        final post = state.extra as PostModel;
        return PostDetailsView(post: post);
      },
    ),
    GoRoute(
      path: AppRoutes.postImageView,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return PostImageFullScreenView(
          imageUrl: data['imageUrl'] as String,
          heroTag: data['heroTag'] as String,
        );
      },
    ),
  ];
}
