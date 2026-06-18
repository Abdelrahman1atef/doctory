import 'package:get_it/get_it.dart';
import '../cubit/my_appointments_cubit.dart';
import '../data/datasources/my_appointments_mock_data_source.dart';

void setupMyAppointmentsDI(GetIt sl) {
  if (!sl.isRegistered<MyAppointmentsMockDataSource>()) {
    sl.registerLazySingleton<MyAppointmentsMockDataSource>(
      () => MyAppointmentsMockDataSource(),
    );
  }

  if (!sl.isRegistered<MyAppointmentsCubit>()) {
    sl.registerFactory<MyAppointmentsCubit>(
      () => MyAppointmentsCubit(
        mockDataSource: sl<MyAppointmentsMockDataSource>(),
      ),
    );
  }
}
