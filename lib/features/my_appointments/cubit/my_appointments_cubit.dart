import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/features/booking/data/model/appointment_response_dto.dart';
import '../data/datasources/my_appointments_mock_data_source.dart';
import 'my_appointments_state.dart';

class MyAppointmentsCubit extends Cubit<MyAppointmentsState> {
  final MyAppointmentsMockDataSource _mockDataSource;

  MyAppointmentsCubit({required MyAppointmentsMockDataSource mockDataSource})
      : _mockDataSource = mockDataSource,
        super(MyAppointmentsInitial()) {
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    emit(MyAppointmentsLoading());
    try {
      final result = await _mockDataSource.getAppointments();
      emit(MyAppointmentsLoaded(appointments: result));
    } catch (e) {
      emit(MyAppointmentsError(e.toString()));
    }
  }

  Future<void> cancelAppointment(String appointmentId) async {
    final currentState = state;
    if (currentState is! MyAppointmentsLoaded) return;

    try {
      await _mockDataSource.cancelAppointment(appointmentId);
      final updated = currentState.appointments.map((a) {
        if (a.id == appointmentId) {
          return AppointmentResponseDto(
            id: a.id,
            doctorId: a.doctorId,
            doctorName: a.doctorName,
            clinicId: a.clinicId,
            clinicName: a.clinicName,
            appointmentDate: a.appointmentDate,
            startTime: a.startTime,
            endTime: a.endTime,
            appointmentType: a.appointmentType,
            patientFullName: a.patientFullName,
            patientPhoneNumber: a.patientPhoneNumber,
            status: 'cancelled',
            bookingRef: a.bookingRef,
            paymentId: a.paymentId,
            amount: a.amount,
            currency: a.currency,
            createdAt: a.createdAt,
            receiptUrl: a.receiptUrl,
          );
        }
        return a;
      }).toList();
      emit(MyAppointmentsLoaded(appointments: updated));
    } catch (e) {
      emit(MyAppointmentsError(e.toString()));
    }
  }
}
