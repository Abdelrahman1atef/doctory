import 'package:doctory/features/booking/data/model/appointment_response_dto.dart';

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
  final int? statusFilter;
  final bool isProcessingPayment;
  final String? paymentUrl;

  MyAppointmentsLoaded({
    required this.appointments,
    this.pageNumber = 1,
    this.totalPages = 1,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.statusFilter,
    this.isProcessingPayment = false,
    this.paymentUrl,
  });
}

class MyAppointmentsError extends MyAppointmentsState {
  final String message;

  MyAppointmentsError(this.message);
}
