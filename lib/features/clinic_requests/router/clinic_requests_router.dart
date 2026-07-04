import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/clinic_requests/cubit/reservation_requests_cubit.dart';
import 'package:doctory/features/clinic_requests/data/repo/reservation_requests_repo.dart';
import 'package:doctory/features/clinic_requests/presentation/views/requests_inbox_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

abstract class ClinicRequestsRouter {
  static GoRoute get route => GoRoute(
    path: AppRoutes.clinicRequests,
    builder: (context, state) => BlocProvider(
      create: (_) => ReservationRequestsCubit(
        sl<ReservationRequestsRepo>(),
      ),
      child: const RequestsInboxView(),
    ),
  );
}
