import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:get_it/get_it.dart';
import '../cubit/my_appointments_cubit.dart';
import '../data/data_source/my_appointments_remote_data_source.dart';

void setupMyAppointmentsDI(GetIt sl) {
  if (!sl.isRegistered<MyAppointmentsRemoteDataSource>()) {
    sl.registerLazySingleton<MyAppointmentsRemoteDataSource>(
      () => MyAppointmentsRemoteDataSourceImpl(
        apiConsumer: sl<ApiConsumer>(),
      ),
    );
  }

  if (!sl.isRegistered<MyAppointmentsCubit>()) {
    sl.registerFactory<MyAppointmentsCubit>(
      () => MyAppointmentsCubit(
        remoteDataSource: sl<MyAppointmentsRemoteDataSource>(),
      ),
    );
  }
}
