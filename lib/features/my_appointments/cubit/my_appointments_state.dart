import 'package:doctory/features/booking/data/model/appointment_response_dto.dart';
import 'package:doctory/features/booking/domain/enums/appointment_status.dart';

sealed class MyAppointmentsState {}

class MyAppointmentsInitial extends MyAppointmentsState {}

class MyAppointmentsLoading extends MyAppointmentsState {}

class MyAppointmentsLoaded extends MyAppointmentsState {
  final List<AppointmentResponseDto> appointments;
  final int pageNumber;
  final int totalPages;
  final bool hasMore;
  final bool isLoadingMore;
  final bool isRefreshing;
  final AppointmentStatus? statusFilter;

  MyAppointmentsLoaded({
    required this.appointments,
    this.pageNumber = 1,
    this.totalPages = 1,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.statusFilter,
  });
}

class MyAppointmentsDetailsLoading extends MyAppointmentsState {}

class MyAppointmentsDetailsLoaded extends MyAppointmentsState {
  final AppointmentResponseDto appointment;

  MyAppointmentsDetailsLoaded(this.appointment);
}

class MyAppointmentsError extends MyAppointmentsState {
  final String message;

  MyAppointmentsError(this.message);
}
