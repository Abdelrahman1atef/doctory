import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/map_home/presentation/views/map_home_view.dart';
import 'package:go_router/go_router.dart';

class MapHomeRouter {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.mapHome,
      builder: (context, state) {
        final query = state.extra as String?;
        return MapHomeView(searchQuery: query);
      },
    ),
  ];
}
