import 'package:doctory/core/config/deep_link_config.dart';
import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/core/router/app_router.dart';
import 'package:doctory/core/services/deep_link_service.dart';
import 'package:doctory/features/clinic/cubit/clinic_dashboard_cubit.dart';
import 'package:doctory/features/clinic/cubit/reservation_requests_cubit.dart';
import 'package:doctory/features/clinic/data/data_source/clinic_dashboard_api_data_source.dart';
import 'package:doctory/features/clinic/data/data_source/clinic_dashboard_data_source.dart';
import 'package:doctory/features/clinic/data/repo/clinic_dashboard_repo.dart';
import 'package:doctory/features/clinic/data/repo/clinic_dashboard_repo_impl.dart';
import 'package:doctory/features/clinic/data/repo/reservation_requests_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

void setupClinicDI(GetIt sl) {
  if (!sl.isRegistered<ClinicDashboardDataSource>()) {
    sl.registerLazySingleton<ClinicDashboardDataSource>(
      () => ClinicDashboardApiDataSource(sl<ApiConsumer>()),
    );
  }

  if (!sl.isRegistered<ClinicDashboardRepo>()) {
    sl.registerLazySingleton<ClinicDashboardRepo>(
      () => ClinicDashboardRepoImpl(sl<ClinicDashboardDataSource>()),
    );
  }

  if (!sl.isRegistered<ReservationRequestsRepo>()) {
    sl.registerLazySingleton<ReservationRequestsRepo>(
      () => ReservationRequestsRepoImpl(sl<ClinicDashboardDataSource>()),
    );
  }

  if (!sl.isRegistered<ClinicDashboardCubit>()) {
    sl.registerFactory<ClinicDashboardCubit>(
      () => ClinicDashboardCubit(sl<ClinicDashboardRepo>()),
    );
  }

  if (!sl.isRegistered<ReservationRequestsCubit>()) {
    sl.registerFactory<ReservationRequestsCubit>(
      () => ReservationRequestsCubit(sl<ReservationRequestsRepo>()),
    );
  }

  // Deep link handler — clinic dashboard links
  DeepLinkService.instance.register((uri) {
    if (uri.scheme != DeepLinkConfig.scheme ||
        uri.host != DeepLinkConfig.host) {
      return false;
    }
    if (uri.path.startsWith('/clinic/')) {
      AppRouter.navigatorKey.currentContext?.go('/clinic-dashboard');
      return true;
    }
    return false;
  });
}
