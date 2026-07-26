import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:get_it/get_it.dart';
import '../cubit/doctor_details_cubit.dart';
import '../data/data_source/doctor_details_remote_data_source.dart';

void setupDoctorDetailsDI(GetIt sl) {
  if (!sl.isRegistered<DoctorDetailsRemoteDataSource>()) {
    sl.registerLazySingleton<DoctorDetailsRemoteDataSource>(
      () => DoctorDetailsRemoteDataSourceImpl(
        apiConsumer: sl<ApiConsumer>(),
      ),
    );
  }

  if (!sl.isRegistered<DoctorDetailsCubit>()) {
    sl.registerFactory<DoctorDetailsCubit>(
      () => DoctorDetailsCubit(
        remoteDataSource: sl<DoctorDetailsRemoteDataSource>(),
      ),
    );
  }
}
