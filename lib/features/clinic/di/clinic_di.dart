import 'package:doctory/features/clinic/cubit/clinic_dashboard_cubit.dart';
import 'package:doctory/features/clinic/cubit/reservation_requests_cubit.dart';
import 'package:doctory/features/clinic/data/data_source/clinic_dashboard_mock_data_source.dart';
import 'package:doctory/features/clinic/data/repo/clinic_dashboard_repo.dart';
import 'package:doctory/features/clinic/data/repo/clinic_dashboard_repo_impl.dart';
import 'package:doctory/features/clinic/data/repo/reservation_requests_repo.dart';
import 'package:get_it/get_it.dart';

void setupClinicDI(GetIt sl) {
  if (!sl.isRegistered<ClinicDashboardMockDataSource>()) {
    sl.registerLazySingleton<ClinicDashboardMockDataSource>(
      () => ClinicDashboardMockDataSourceImpl(),
    );
  }

  if (!sl.isRegistered<ClinicDashboardRepo>()) {
    sl.registerLazySingleton<ClinicDashboardRepo>(
      () => ClinicDashboardRepoImpl(sl<ClinicDashboardMockDataSource>()),
    );
  }

  if (!sl.isRegistered<ReservationRequestsRepo>()) {
    sl.registerLazySingleton<ReservationRequestsRepo>(
      () => ReservationRequestsRepoImpl(sl<ClinicDashboardMockDataSource>()),
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
}
