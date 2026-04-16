import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/features/auth/cubit/auth_cubit.dart';
import 'package:doctory/features/auth/presentation/views/login_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthRouter {
  static final List<GoRoute> routes = [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<AuthCubit>(),
        child: const LoginView(),
      ),
    ),
  ];
}
