import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/home/cubit/home_cubit.dart';
import 'package:doctory/features/home/presentation/views/home_view.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeRouter {
  static final List<GoRoute> routes = [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<HomeCubit>()..getHomeData(),
        child: const HomeView(),
      ),
    ),
  ];
}
