import 'package:doctory/features/clinic_requests/data/model/reservation_request.dart';

sealed class ReservationRequestsState {}

class RequestsLoading extends ReservationRequestsState {}

class RequestsLoaded extends ReservationRequestsState {
  final List<ReservationRequest> requests;
  RequestsLoaded(this.requests);
}

class RequestsError extends ReservationRequestsState {
  final String message;
  RequestsError(this.message);
}
