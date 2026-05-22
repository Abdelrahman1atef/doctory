import 'package:get_it/get_it.dart';
import '../../../../core/network/interfaces/api_consumer.dart';
import '../data/data_source/booking_remote_data_source.dart';
import '../data/repo/booking_repo.dart';
import '../cubit/booking_cubit.dart';
import '../../../../core/common/models/shared_models.dart';

void setupBookingDI(GetIt sl) {
  // Data Sources
  if (!sl.isRegistered<BookingRemoteDataSource>()) {
    sl.registerLazySingleton<BookingRemoteDataSource>(
      () => BookingRemoteDataSourceImpl(apiConsumer: sl<ApiConsumer>()),
    );
  }

  // Repositories
  if (!sl.isRegistered<BookingRepo>()) {
    sl.registerLazySingleton<BookingRepo>(
      () => BookingRepoImpl(remoteDataSource: sl<BookingRemoteDataSource>()),
    );
  }

  // Cubits
  if (!sl.isRegistered<BookingCubit>()) {
    sl.registerFactoryParam<BookingCubit, DoctorModel, String>(
      (doctor, clinicId) => BookingCubit(
        bookingRepo: sl<BookingRepo>(),
        doctor: doctor,
        clinicId: clinicId,
      ),
    );
  }
}
