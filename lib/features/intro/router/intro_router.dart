import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/features/intro/cubit/intro_cubit.dart';
import 'package:doctory/features/intro/presentation/views/intro_view.dart';
import 'package:doctory/features/intro/presentation/views/splash_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class IntroRouter {
  static final List<GoRoute> routes = [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<IntroCubit>(),
        child: const SplashView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.intro,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<IntroCubit>(),
        child: const IntroView(),
      ),
    ),
  ];
}
