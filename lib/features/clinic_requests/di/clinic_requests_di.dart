import 'package:doctory/features/clinic_requests/data/repo/reservation_requests_repo.dart';
import 'package:get_it/get_it.dart';

void setupClinicRequestsDI(GetIt sl) {
  if (!sl.isRegistered<ReservationRequestsRepo>()) {
    sl.registerLazySingleton<ReservationRequestsRepo>(
      () => ReservationRequestsRepoImpl(),
    );
  }
}
