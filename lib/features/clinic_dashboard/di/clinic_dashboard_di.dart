import 'package:doctory/features/clinic_dashboard/cubit/clinic_dashboard_cubit.dart';
import 'package:doctory/features/clinic_dashboard/data/data_source/clinic_dashboard_mock_data_source.dart';
import 'package:doctory/features/clinic_dashboard/data/repo/clinic_dashboard_repo.dart';
import 'package:doctory/features/clinic_dashboard/data/repo/clinic_dashboard_repo_impl.dart';
import 'package:get_it/get_it.dart';

void setupClinicDashboardDI(GetIt sl) {
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

  if (!sl.isRegistered<ClinicDashboardCubit>()) {
    sl.registerFactory<ClinicDashboardCubit>(
      () => ClinicDashboardCubit(sl<ClinicDashboardRepo>()),
    );
  }
}
