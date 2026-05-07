import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/community/data/model/community_models.dart';
import 'package:doctory/features/community/presentation/views/community_view.dart';
import 'package:doctory/features/community/presentation/views/create_post_view.dart';
import 'package:doctory/features/community/presentation/views/post_details_view.dart';
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
        final post = state.extra as PostModel;
        return PostDetailsView(post: post);
      },
    ),
  ];
}
