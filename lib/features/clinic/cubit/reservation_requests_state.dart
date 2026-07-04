import 'package:doctory/features/clinic/data/model/booking_request_model.dart';

sealed class ReservationRequestsState {}

class RequestsInitial extends ReservationRequestsState {}

class RequestsLoading extends ReservationRequestsState {}

class RequestsLoaded extends ReservationRequestsState {
  final List<BookingRequestModel> requests;
  RequestsLoaded(this.requests);
}

class RequestsError extends ReservationRequestsState {
  final String message;
  RequestsError(this.message);
}
