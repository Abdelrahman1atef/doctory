import 'package:doctory/features/booking/data/model/appointment_response_dto.dart';

sealed class MyAppointmentsState {}

class MyAppointmentsInitial extends MyAppointmentsState {}

class MyAppointmentsLoading extends MyAppointmentsState {}

class MyAppointmentsLoaded extends MyAppointmentsState {
  final List<AppointmentResponseDto> appointments;

  MyAppointmentsLoaded({required this.appointments});
}

class MyAppointmentsError extends MyAppointmentsState {
  final String message;

  MyAppointmentsError(this.message);
}
