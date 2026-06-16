import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/specializations/cubit/specializations_cubit.dart';
import 'package:doctory/features/specializations/presentation/views/specializations_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

abstract class SpecializationsRouter {
  static List<RouteBase> get routes => [
        GoRoute(
          path: AppRoutes.specializations,
          builder: (context, state) => BlocProvider(
            create: (context) => sl<SpecializationsCubit>(),
            child: const SpecializationsView(),
          ),
        ),
      ];
}
