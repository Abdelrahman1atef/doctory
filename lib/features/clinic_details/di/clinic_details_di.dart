import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:get_it/get_it.dart';
import '../cubit/clinic_details_cubit.dart';
import '../data/data_source/clinic_details_remote_data_source.dart';

void setupClinicDetailsDI(GetIt sl) {
  if (!sl.isRegistered<ClinicDetailsRemoteDataSource>()) {
    sl.registerLazySingleton<ClinicDetailsRemoteDataSource>(
      () => ClinicDetailsRemoteDataSourceImpl(
        apiConsumer: sl<ApiConsumer>(),
      ),
    );
  }

  if (!sl.isRegistered<ClinicDetailsCubit>()) {
    sl.registerFactory<ClinicDetailsCubit>(
      () => ClinicDetailsCubit(
        remoteDataSource: sl<ClinicDetailsRemoteDataSource>(),
      ),
    );
  }
}
