import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/map_home/cubit/map_home_cubit.dart';
import 'package:doctory/features/map_home/presentation/views/map_home_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MapHomeRouter {
  static final List<RouteBase> routes = [
    GoRoute(
      path: AppRoutes.mapHome,
      builder: (context, state) {
        final query = state.extra is String ? state.extra as String : null;
        return BlocProvider(
          create: (_) => sl<MapHomeCubit>()..init(searchQuery: query),
          child: MapHomeView(searchQuery: query),
        );
      },
    ),
  ];
}
