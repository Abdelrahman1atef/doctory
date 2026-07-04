import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/notifications/cubit/notifications_cubit.dart';
import 'package:doctory/features/notifications/presentation/views/notifications_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NotificationsRouter {
  static final List<GoRoute> routes = [
    GoRoute(
      path: AppRoutes.notifications,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<NotificationsCubit>()..loadNotifications(),
        child: const NotificationsView(),
      ),
    ),
  ];
}
