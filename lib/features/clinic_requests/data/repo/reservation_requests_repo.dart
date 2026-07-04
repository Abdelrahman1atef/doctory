import 'package:doctory/features/clinic_requests/data/model/reservation_request.dart';

abstract class ReservationRequestsRepo {
  Future<List<ReservationRequest>> getPending();
  Future<void> accept(int requestId);
  Future<void> reject(int requestId);
}

class ReservationRequestsRepoImpl implements ReservationRequestsRepo {
  @override
  Future<List<ReservationRequest>> getPending() async {
    // TODO: Replace with actual API call
    return [];
  }

  @override
  Future<void> accept(int requestId) async {
    // TODO: Replace with actual API call
  }

  @override
  Future<void> reject(int requestId) async {
    // TODO: Replace with actual API call
  }
}
