import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/error/failures.dart';
import 'package:doctory/features/booking/data/model/appointment_response_dto.dart';
import '../data/data_source/my_appointments_remote_data_source.dart';
import 'my_appointments_state.dart';

class MyAppointmentsCubit extends Cubit<MyAppointmentsState> {
  final MyAppointmentsRemoteDataSource _remoteDataSource;
  static const int _pageSize = 10;
  int? _currentStatusFilter;

  MyAppointmentsCubit({required MyAppointmentsRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource,
        super(MyAppointmentsInitial()) {
    loadAppointments(status: 0);
  }

  Future<void> loadAppointments({int? status}) async {
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

  void loadByStatus(int status) {
    loadAppointments(status: status);
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

  Future<void> cancelAppointment(String appointmentId) async {
    final currentState = state;
    if (currentState is! MyAppointmentsLoaded) return;

    final result = await _remoteDataSource.cancelAppointment(appointmentId);

    if (state is! MyAppointmentsLoaded) return;

    result.fold(
      onSuccess: (_) {
        final current = state as MyAppointmentsLoaded;
        final updated = current.appointments.map((a) {
          if (a.id == appointmentId) {
            return AppointmentResponseDto(
              id: a.id,
              bookedByUserId: a.bookedByUserId,
              doctorId: a.doctorId,
              doctorName: a.doctorName,
              clinicId: a.clinicId,
              clinicName: a.clinicName,
              appointmentDate: a.appointmentDate,
              startTime: a.startTime,
              endTime: a.endTime,
              appointmentType: a.appointmentType,
              status: 2,
              patientFullName: a.patientFullName,
              patientPhoneNumber: a.patientPhoneNumber,
              patientAge: a.patientAge,
              patientGender: a.patientGender,
              complaint: a.complaint,
              chronicDiseases: a.chronicDiseases,
              cancellationReason: a.cancellationReason,
              bookingReference: a.bookingReference,
              paymentId: a.paymentId,
              amount: a.amount,
              currency: a.currency,
              expiresAt: a.expiresAt,
              createdAt: a.createdAt,
              receiptUrl: a.receiptUrl,
            );
          }
          return a;
        }).toList();
        emit(MyAppointmentsLoaded(
          appointments: updated,
          pageNumber: current.pageNumber,
          totalPages: current.totalPages,
          hasMore: current.hasMore,
          statusFilter: _currentStatusFilter,
        ));
      },
      onFailure: (failure) {
        emit(MyAppointmentsError(failure.userMessage));
      },
    );
  }

  Future<void> initiatePayment(AppointmentResponseDto appointment) async {
    final currentState = state;
    if (currentState is! MyAppointmentsLoaded) return;

    emit(MyAppointmentsLoaded(
      appointments: currentState.appointments,
      pageNumber: currentState.pageNumber,
      totalPages: currentState.totalPages,
      hasMore: currentState.hasMore,
      isLoadingMore: currentState.isLoadingMore,
      statusFilter: _currentStatusFilter,
      isProcessingPayment: true,
    ));

    final result = await _remoteDataSource.initiatePayment(
      appointmentId: appointment.id,
      phoneNumber: appointment.patientPhoneNumber,
    );

    if (state is! MyAppointmentsLoaded) return;

    result.fold(
      onSuccess: (data) {
        final current = state as MyAppointmentsLoaded;
        emit(MyAppointmentsLoaded(
          appointments: current.appointments,
          pageNumber: current.pageNumber,
          totalPages: current.totalPages,
          hasMore: current.hasMore,
          isLoadingMore: current.isLoadingMore,
          statusFilter: _currentStatusFilter,
          isProcessingPayment: false,
          paymentUrl: data.redirectUrl,
        ));
      },
      onFailure: (failure) {
        final current = state as MyAppointmentsLoaded;
        emit(MyAppointmentsLoaded(
          appointments: current.appointments,
          pageNumber: current.pageNumber,
          totalPages: current.totalPages,
          hasMore: current.hasMore,
          isLoadingMore: current.isLoadingMore,
          statusFilter: _currentStatusFilter,
          isProcessingPayment: false,
        ));
        emit(MyAppointmentsError(failure.userMessage));
      },
    );
  }

  void onPaymentResult(bool success, AppointmentResponseDto appointment) {
    final currentState = state;
    if (currentState is! MyAppointmentsLoaded) return;

    if (success) {
      final updated = currentState.appointments.map((a) {
        if (a.id == appointment.id) {
          return AppointmentResponseDto(
            id: a.id,
            bookedByUserId: a.bookedByUserId,
            doctorId: a.doctorId,
            doctorName: a.doctorName,
            clinicId: a.clinicId,
            clinicName: a.clinicName,
            appointmentDate: a.appointmentDate,
            startTime: a.startTime,
            endTime: a.endTime,
            appointmentType: a.appointmentType,
            status: 1,
            patientFullName: a.patientFullName,
            patientPhoneNumber: a.patientPhoneNumber,
            patientAge: a.patientAge,
            patientGender: a.patientGender,
            complaint: a.complaint,
            chronicDiseases: a.chronicDiseases,
            cancellationReason: a.cancellationReason,
            bookingReference: a.bookingReference,
            paymentId: a.paymentId,
            amount: a.amount,
            currency: a.currency,
            expiresAt: a.expiresAt,
            createdAt: a.createdAt,
            receiptUrl: a.receiptUrl,
          );
        }
        return a;
      }).toList();
      emit(MyAppointmentsLoaded(
        appointments: updated,
        pageNumber: currentState.pageNumber,
        totalPages: currentState.totalPages,
        hasMore: currentState.hasMore,
        isLoadingMore: currentState.isLoadingMore,
        statusFilter: _currentStatusFilter,
      ));
    } else {
      emit(MyAppointmentsLoaded(
        appointments: currentState.appointments,
        pageNumber: currentState.pageNumber,
        totalPages: currentState.totalPages,
        hasMore: currentState.hasMore,
        isLoadingMore: currentState.isLoadingMore,
        statusFilter: _currentStatusFilter,
      ));
    }
  }
}