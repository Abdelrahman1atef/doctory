import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/error/failures.dart';
import 'package:doctory/features/booking/data/model/appointment_response_dto.dart';
import 'package:doctory/features/booking/domain/enums/appointment_status.dart';
import 'package:doctory/features/booking/domain/enums/payment_method.dart';
import '../data/data_source/my_appointments_remote_data_source.dart';
import 'my_appointments_state.dart';

class MyAppointmentsCubit extends Cubit<MyAppointmentsState> {
  final MyAppointmentsRemoteDataSource _remoteDataSource;
  static const int _pageSize = 10;
  static const String _paymentReturnUrl = 'doctory://payment-result';
  AppointmentStatus? _currentStatusFilter;

  MyAppointmentsCubit({
    required MyAppointmentsRemoteDataSource remoteDataSource,
    bool autoLoad = true,
  })  : _remoteDataSource = remoteDataSource,
        super(MyAppointmentsInitial()) {
    if (autoLoad) loadAppointments(status: AppointmentStatus.pending);
  }

  Future<void> loadAppointments({AppointmentStatus? status}) async {
    _currentStatusFilter = status;
    final isRefresh = state is MyAppointmentsLoaded;

    if (isRefresh) {
      final current = state as MyAppointmentsLoaded;
      emit(MyAppointmentsLoaded(
        appointments: current.appointments,
        pageNumber: current.pageNumber,
        totalPages: current.totalPages,
        hasMore: current.hasMore,
        statusFilter: current.statusFilter,
        isRefreshing: true,
      ));
    } else {
      emit(MyAppointmentsLoading());
    }

    final result = await _remoteDataSource.getAppointments(
      pageNumber: 1,
      pageSize: _pageSize,
      status: status,
    );

    if (isRefresh && state is! MyAppointmentsLoaded) return;
    if (!isRefresh && state is! MyAppointmentsInitial && state is! MyAppointmentsLoading) return;

    result.fold(
      onSuccess: (data) {
        emit(MyAppointmentsLoaded(
          appointments: data.items,
          pageNumber: data.pageNumber,
          totalPages: data.totalPages,
          hasMore: data.hasNextPage,
          statusFilter: status,
        ));
      },
      onFailure: (failure) {
        if (isRefresh) {
          final current = state as MyAppointmentsLoaded;
          emit(MyAppointmentsLoaded(
            appointments: current.appointments,
            pageNumber: current.pageNumber,
            totalPages: current.totalPages,
            hasMore: current.hasMore,
            statusFilter: current.statusFilter,
            isRefreshing: false,
          ));
        } else {
          emit(MyAppointmentsError(failure.userMessage));
        }
      },
    );
  }

  void loadByStatus(AppointmentStatus status) {
    loadAppointments(status: status);
  }

  Future<void> refresh() {
    return loadAppointments(status: _currentStatusFilter ?? AppointmentStatus.pending);
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! MyAppointmentsLoaded) return;
    if (!currentState.hasMore || currentState.isLoadingMore) return;

    emit(MyAppointmentsLoaded(
      appointments: currentState.appointments,
      pageNumber: currentState.pageNumber,
      totalPages: currentState.totalPages,
      hasMore: currentState.hasMore,
      isLoadingMore: true,
      statusFilter: _currentStatusFilter,
    ));

    final nextPage = currentState.pageNumber + 1;
    final result = await _remoteDataSource.getAppointments(
      pageNumber: nextPage,
      pageSize: _pageSize,
      status: _currentStatusFilter,
    );

    if (state is! MyAppointmentsLoaded) return;

    result.fold(
      onSuccess: (data) {
        final current = state as MyAppointmentsLoaded;
        emit(MyAppointmentsLoaded(
          appointments: [...current.appointments, ...data.items],
          pageNumber: data.pageNumber,
          totalPages: data.totalPages,
          hasMore: data.hasNextPage,
          statusFilter: _currentStatusFilter,
        ));
      },
      onFailure: (failure) {
        final current = state as MyAppointmentsLoaded;
        emit(MyAppointmentsLoaded(
          appointments: current.appointments,
          pageNumber: current.pageNumber,
          totalPages: current.totalPages,
          hasMore: current.hasMore,
          isLoadingMore: false,
          statusFilter: _currentStatusFilter,
        ));
      },
    );
  }

  /// Creates the payment for an accepted appointment and returns the gateway
  /// redirect URL, or null when the request failed (an error state is emitted).
  ///
  /// Payment only happens here, after the clinic accepted the request — the
  /// booking flow never charges the patient.
  Future<String?> initiatePayment({
    required String appointmentId,
    required PaymentMethod paymentMethod,
    String returnUrl = _paymentReturnUrl,
  }) async {
    final result = await _remoteDataSource.initiatePayment(
      appointmentId: appointmentId,
      paymentMethod: paymentMethod.serverValue,
      returnUrl: returnUrl,
    );

    return result.fold(
      onSuccess: (data) =>
          (data['redirectUrl'] ?? data['paymentUrl'])?.toString(),
      onFailure: (failure) {
        emit(MyAppointmentsError(failure.userMessage));
        return null;
      },
    );
  }

  /// Confirms a returned payment with the server and emits the refreshed
  /// appointment. Returns true when the appointment came back paid.
  Future<bool> verifyPayment({
    required String paymentId,
    String? transactionId,
  }) async {
    final result = await _remoteDataSource.verifyPayment(
      paymentId: paymentId,
      transactionId: transactionId,
    );

    return result.fold(
      onSuccess: (appointment) {
        emit(MyAppointmentsDetailsLoaded(appointment));
        return appointment.paidAt != null ||
            appointment.appointmentStatus == AppointmentStatus.confirmed;
      },
      onFailure: (failure) {
        emit(MyAppointmentsError(failure.userMessage));
        return false;
      },
    );
  }

  Future<bool> cancelAppointment({
    required String id,
    required String cancellationReason,
  }) async {
    final result = await _remoteDataSource.cancelAppointment(
      id: id,
      cancellationReason: cancellationReason,
    );

    return result.fold(
      onSuccess: (_) {
        if (state is MyAppointmentsLoaded) {
          refresh();
        } else if (state is MyAppointmentsDetailsLoaded) {
          final current = state as MyAppointmentsDetailsLoaded;
          final appointment = current.appointment;
          emit(MyAppointmentsDetailsLoaded(
            AppointmentResponseDto(
              id: appointment.id,
              bookedByUserId: appointment.bookedByUserId,
              doctorId: appointment.doctorId,
              doctorName: appointment.doctorName,
              clinicId: appointment.clinicId,
              clinicName: appointment.clinicName,
              appointmentDate: appointment.appointmentDate,
              startTime: appointment.startTime,
              endTime: appointment.endTime,
              appointmentType: appointment.appointmentType,
              appointmentStatus: AppointmentStatus.cancelled,
              patientFullName: appointment.patientFullName,
              patientPhoneNumber: appointment.patientPhoneNumber,
              patientAge: appointment.patientAge,
              patientGender: appointment.patientGender,
              complaint: appointment.complaint,
              chronicDiseases: appointment.chronicDiseases,
              cancellationReason: cancellationReason,
              rejectionReason: appointment.rejectionReason,
              bookingReference: appointment.bookingReference,
              paymentId: appointment.paymentId,
              amount: appointment.amount,
              currency: appointment.currency,
              expiresAt: appointment.expiresAt,
              createdAt: appointment.createdAt,
              receiptUrl: appointment.receiptUrl,
              payment: appointment.payment,
            ),
          ));
        }
        return true;
      },
      onFailure: (failure) {
        emit(MyAppointmentsError(failure.userMessage));
        return false;
      },
    );
  }

  Future<void> loadAppointmentById(String id) async {
    emit(MyAppointmentsDetailsLoading());

    final result = await _remoteDataSource.getAppointmentById(id);

    if (state is! MyAppointmentsDetailsLoading) return;

    result.fold(
      onSuccess: (appointment) {
        emit(MyAppointmentsDetailsLoaded(appointment));
      },
      onFailure: (failure) {
        emit(MyAppointmentsError(failure.userMessage));
      },
    );
  }
}
