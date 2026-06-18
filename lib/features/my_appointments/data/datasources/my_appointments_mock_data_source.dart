import 'package:doctory/features/booking/data/model/appointment_response_dto.dart';

class MyAppointmentsMockDataSource {
  List<AppointmentResponseDto> _appointments = [];

  MyAppointmentsMockDataSource() {
    _appointments = _generateMockAppointments();
  }

  List<AppointmentResponseDto> _generateMockAppointments() {
    final now = DateTime.now();
    return [
      AppointmentResponseDto(
        id: 'apt_1',
        doctorId: 'doc_1',
        doctorName: 'Dr. Ahmed Hassan',
        clinicId: 'clinic_1',
        clinicName: 'Al Noor Clinic',
        appointmentDate: now.add(const Duration(days: 2)),
        startTime: '09:00',
        endTime: '09:30',
        appointmentType: 1,
        patientFullName: 'Ahmed Mohammed',
        patientPhoneNumber: '+966501234567',
        status: 'confirmed',
        bookingRef: 'BOK001',
        paymentId: 'pay_001',
        amount: 150.0,
        currency: 'SAR',
        createdAt: now.subtract(const Duration(days: 1)),
        receiptUrl: 'https://receipts.example.com/BOK001',
      ),
      AppointmentResponseDto(
        id: 'apt_2',
        doctorId: 'doc_2',
        doctorName: 'Dr. Sara Khalid',
        clinicId: 'clinic_1',
        clinicName: 'Al Noor Clinic',
        appointmentDate: now.add(const Duration(days: 5)),
        startTime: '14:00',
        endTime: '14:30',
        appointmentType: 2,
        patientFullName: 'Ahmed Mohammed',
        patientPhoneNumber: '+966501234567',
        status: 'pending',
        bookingRef: 'BOK002',
        amount: 200.0,
        currency: 'SAR',
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      AppointmentResponseDto(
        id: 'apt_3',
        doctorId: 'doc_3',
        doctorName: 'Dr. Fahad Al-Otaibi',
        clinicId: 'clinic_2',
        clinicName: 'International Medical Center',
        appointmentDate: now.subtract(const Duration(days: 7)),
        startTime: '11:00',
        endTime: '11:30',
        appointmentType: 1,
        patientFullName: 'Ahmed Mohammed',
        patientPhoneNumber: '+966501234567',
        status: 'completed',
        bookingRef: 'BOK003',
        paymentId: 'pay_003',
        amount: 150.0,
        currency: 'SAR',
        createdAt: now.subtract(const Duration(days: 14)),
        receiptUrl: 'https://receipts.example.com/BOK003',
      ),
      AppointmentResponseDto(
        id: 'apt_4',
        doctorId: 'doc_4',
        doctorName: 'Dr. Noura Al-Saud',
        clinicId: 'clinic_3',
        clinicName: 'Riyadh Specialized Clinic',
        appointmentDate: now.subtract(const Duration(days: 14)),
        startTime: '10:00',
        endTime: '10:30',
        appointmentType: 2,
        patientFullName: 'Ahmed Mohammed',
        patientPhoneNumber: '+966501234567',
        status: 'completed',
        bookingRef: 'BOK004',
        paymentId: 'pay_004',
        amount: 200.0,
        currency: 'SAR',
        createdAt: now.subtract(const Duration(days: 21)),
        receiptUrl: 'https://receipts.example.com/BOK004',
      ),
      AppointmentResponseDto(
        id: 'apt_5',
        doctorId: 'doc_1',
        doctorName: 'Dr. Ahmed Hassan',
        clinicId: 'clinic_1',
        clinicName: 'Al Noor Clinic',
        appointmentDate: now.subtract(const Duration(days: 30)),
        startTime: '09:00',
        endTime: '09:30',
        appointmentType: 1,
        patientFullName: 'Ahmed Mohammed',
        patientPhoneNumber: '+966501234567',
        status: 'cancelled',
        bookingRef: 'BOK005',
        amount: 150.0,
        currency: 'SAR',
        createdAt: now.subtract(const Duration(days: 35)),
      ),
      AppointmentResponseDto(
        id: 'apt_6',
        doctorId: 'doc_5',
        doctorName: 'Dr. Khalid Al-Ghamdi',
        clinicId: 'clinic_4',
        clinicName: 'Jeddah Medical Tower',
        appointmentDate: now.subtract(const Duration(days: 3)),
        startTime: '16:00',
        endTime: '16:30',
        appointmentType: 3,
        patientFullName: 'Ahmed Mohammed',
        patientPhoneNumber: '+966501234567',
        status: 'cancelled',
        bookingRef: 'BOK006',
        paymentId: 'pay_006',
        amount: 180.0,
        currency: 'SAR',
        createdAt: now.subtract(const Duration(days: 10)),
      ),
    ];
  }

  Future<List<AppointmentResponseDto>> getAppointments() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.from(_appointments);
  }

  Future<void> cancelAppointment(String appointmentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _appointments = _appointments.map((a) {
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
  }
}
