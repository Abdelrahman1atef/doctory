import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/community/presentation/views/community_view.dart';
import 'package:doctory/features/more/presentation/views/more_view.dart';
import 'package:doctory/features/more/profile/cubit/profile_cubit.dart';
import 'package:doctory/features/more/profile/presentation/views/profile_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MoreRouter {
  static final List<GoRoute> routes = [
    GoRoute(
      path: AppRoutes.more,
      builder: (context, state) => const MoreView(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<ProfileCubit>()..getProfile(),
        child: const ProfileView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.community,
      builder: (context, state) => const CommunityView(),
    ),
  ];
}
