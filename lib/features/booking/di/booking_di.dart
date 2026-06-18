import 'package:get_it/get_it.dart';
import 'package:doctory/core/common/models/shared_models.dart';
import '../domain/repositories/booking_repository.dart';
import '../data/datasources/booking_mock_data_source.dart';
import '../data/repositories/booking_repository_impl.dart';
import '../cubit/booking_cubit.dart';

void setupBookingDI(GetIt sl) {
  if (!sl.isRegistered<BookingMockDataSource>()) {
    sl.registerLazySingleton<BookingMockDataSource>(
      () => BookingMockDataSource(),
    );
  }

  if (!sl.isRegistered<BookingRepository>()) {
    sl.registerLazySingleton<BookingRepository>(
      () => BookingRepositoryImpl(
        mockDataSource: sl<BookingMockDataSource>(),
      ),
    );
  }

  if (!sl.isRegistered<BookingCubit>()) {
    sl.registerFactoryParam<BookingCubit, DoctorModel, String>(
      (doctor, clinicId) => BookingCubit(
        bookingRepo: sl<BookingRepository>(),
        doctor: doctor,
        clinicId: clinicId,
      ),
    );
  }
}
