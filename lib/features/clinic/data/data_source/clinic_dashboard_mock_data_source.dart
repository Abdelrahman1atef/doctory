import 'package:doctory/core/network/interfaces/api_result.dart';
import 'package:doctory/features/clinic/data/model/booking_request_model.dart';
import 'package:doctory/features/clinic/data/model/dashboard_stats_model.dart';

abstract class ClinicDashboardMockDataSource {
  ApiResult<DashboardStatsModel> getStats();
  ApiResult<List<BookingRequestModel>> getBookingsByStatus(String status, int page, int perPage);
  ApiResult<bool> acceptBooking(int id);
  ApiResult<bool> rejectBooking(int id);
}

class ClinicDashboardMockDataSourceImpl
    implements ClinicDashboardMockDataSource {
  List<BookingRequestModel> _allBookings() => [
    BookingRequestModel(id: 1, patientName: 'Sulaiman Ahmed', patientPhone: '0551234567', patientAge: 34, clinicName: 'Cardiology Clinic', doctorName: 'Dr. Khalid', requestedDate: '2026-07-04', requestedTime: '10:30 AM', reason: 'Chest pain for the past 3 days', appointmentType: AppointmentType.inPerson, status: BookingStatus.pending, createdAt: '2026-07-04'),
    BookingRequestModel(id: 2, patientName: 'Huda Omar', patientPhone: '0552345678', patientAge: 28, clinicName: 'Neurology Clinic', doctorName: 'Dr. Fatima', requestedDate: '2026-07-04', requestedTime: '02:00 PM', appointmentType: AppointmentType.followUp, status: BookingStatus.pending, createdAt: '2026-07-04'),
    BookingRequestModel(id: 3, patientName: 'Mariam Al-Saud', patientPhone: '0553456789', patientAge: 45, clinicName: 'Dermatology Center', doctorName: 'Dr. Laila', requestedDate: '2026-07-05', requestedTime: '11:00 AM', reason: 'Skin rash and itching', appointmentType: AppointmentType.online, status: BookingStatus.pending, createdAt: '2026-07-04'),
    BookingRequestModel(id: 4, patientName: 'Faisal Al-Rashid', patientPhone: '0554567890', patientAge: 52, clinicName: 'Orthopedic Clinic', doctorName: 'Dr. Ahmed', requestedDate: '2026-07-05', requestedTime: '09:00 AM', reason: 'Knee pain - follow up after surgery', appointmentType: AppointmentType.followUp, status: BookingStatus.pending, createdAt: '2026-07-03'),
    BookingRequestModel(id: 5, patientName: 'Nora Al-Abdulkarim', patientPhone: '0555678901', patientAge: 31, clinicName: 'General Clinic', doctorName: 'Dr. Hassan', requestedDate: '2026-07-06', requestedTime: '04:30 PM', appointmentType: AppointmentType.inPerson, status: BookingStatus.pending, createdAt: '2026-07-04'),
    BookingRequestModel(id: 6, patientName: 'Ahmed Al-Ghamdi', patientPhone: '0556789012', patientAge: 40, clinicName: 'Eye Center', doctorName: 'Dr. Noor', requestedDate: '2026-07-06', requestedTime: '01:00 PM', reason: 'Blurred vision', appointmentType: AppointmentType.inPerson, status: BookingStatus.pending, createdAt: '2026-07-05'),
    BookingRequestModel(id: 7, patientName: 'Layla Al-Harbi', patientPhone: '0557890123', patientAge: 26, clinicName: 'Dental Clinic', requestedDate: '2026-07-07', requestedTime: '09:30 AM', reason: 'Toothache', appointmentType: AppointmentType.inPerson, status: BookingStatus.pending, createdAt: '2026-07-05'),
    BookingRequestModel(id: 8, patientName: 'Omar Al-Zahrani', patientPhone: '0558901234', patientAge: 55, clinicName: 'Cardiology Clinic', doctorName: 'Dr. Khalid', requestedDate: '2026-07-07', requestedTime: '03:00 PM', reason: 'Regular checkup', appointmentType: AppointmentType.inPerson, status: BookingStatus.pending, createdAt: '2026-07-06'),
    BookingRequestModel(id: 9, patientName: 'Samira Al-Qahtani', patientPhone: '0559012345', patientAge: 38, clinicName: 'Dermatology Center', doctorName: 'Dr. Laila', requestedDate: '2026-07-08', requestedTime: '10:00 AM', appointmentType: AppointmentType.online, status: BookingStatus.pending, createdAt: '2026-07-06'),
    BookingRequestModel(id: 10, patientName: 'Khalid Al-Otaibi', patientPhone: '0550123456', patientAge: 48, clinicName: 'Orthopedic Clinic', doctorName: 'Dr. Ahmed', requestedDate: '2026-07-08', requestedTime: '02:30 PM', reason: 'Lower back pain', appointmentType: AppointmentType.inPerson, status: BookingStatus.pending, createdAt: '2026-07-07'),
    BookingRequestModel(id: 11, patientName: 'Maha Al-Shammari', patientPhone: '0551122334', patientAge: 33, clinicName: 'General Clinic', doctorName: 'Dr. Hassan', requestedDate: '2026-06-30', requestedTime: '11:00 AM', appointmentType: AppointmentType.inPerson, status: BookingStatus.accepted, createdAt: '2026-06-28'),
    BookingRequestModel(id: 12, patientName: 'Saeed Al-Dosari', patientPhone: '0552233445', patientAge: 60, clinicName: 'Cardiology Clinic', doctorName: 'Dr. Khalid', requestedDate: '2026-07-01', requestedTime: '09:00 AM', reason: 'Chest discomfort', appointmentType: AppointmentType.inPerson, status: BookingStatus.accepted, createdAt: '2026-06-29'),
    BookingRequestModel(id: 13, patientName: 'Hessa Al-Mutairi', patientPhone: '0553344556', patientAge: 29, clinicName: 'Neurology Clinic', doctorName: 'Dr. Fatima', requestedDate: '2026-07-02', requestedTime: '01:00 PM', appointmentType: AppointmentType.online, status: BookingStatus.accepted, createdAt: '2026-06-30'),
    BookingRequestModel(id: 14, patientName: 'Nasser Al-Anazi', patientPhone: '0554455667', patientAge: 42, clinicName: 'Dental Clinic', requestedDate: '2026-07-02', requestedTime: '10:30 AM', reason: 'Root canal treatment', appointmentType: AppointmentType.inPerson, status: BookingStatus.accepted, createdAt: '2026-06-30'),
    BookingRequestModel(id: 15, patientName: 'Reem Al-Rajhi', patientPhone: '0555566778', patientAge: 36, clinicName: 'Eye Center', doctorName: 'Dr. Noor', requestedDate: '2026-07-03', requestedTime: '04:00 PM', appointmentType: AppointmentType.followUp, status: BookingStatus.accepted, createdAt: '2026-07-01'),
    BookingRequestModel(id: 16, patientName: 'Sultan Al-Habib', patientPhone: '0556677889', patientAge: 50, clinicName: 'Orthopedic Clinic', doctorName: 'Dr. Ahmed', requestedDate: '2026-07-03', requestedTime: '08:30 AM', reason: 'Shoulder pain', appointmentType: AppointmentType.inPerson, status: BookingStatus.rejected, createdAt: '2026-07-01'),
    BookingRequestModel(id: 17, patientName: 'Nouf Al-Balawi', patientPhone: '0557788990', patientAge: 27, clinicName: 'General Clinic', doctorName: 'Dr. Hassan', requestedDate: '2026-07-01', requestedTime: '12:00 PM', appointmentType: AppointmentType.online, status: BookingStatus.rejected, createdAt: '2026-06-29'),
    BookingRequestModel(id: 18, patientName: 'Yousef Al-Harbi', patientPhone: '0558899001', patientAge: 45, clinicName: 'Dermatology Center', doctorName: 'Dr. Laila', requestedDate: '2026-06-29', requestedTime: '03:30 PM', reason: 'Allergic reaction', appointmentType: AppointmentType.inPerson, status: BookingStatus.rejected, createdAt: '2026-06-28'),
    BookingRequestModel(id: 19, patientName: 'Dana Al-Shehri', patientPhone: '0559900112', patientAge: 24, clinicName: 'Neurology Clinic', doctorName: 'Dr. Fatima', requestedDate: '2026-06-28', requestedTime: '11:30 AM', appointmentType: AppointmentType.inPerson, status: BookingStatus.rejected, createdAt: '2026-06-27'),
    BookingRequestModel(id: 20, patientName: 'Talal Al-Malki', patientPhone: '0551011123', patientAge: 58, clinicName: 'Cardiology Clinic', doctorName: 'Dr. Khalid', requestedDate: '2026-06-27', requestedTime: '02:00 PM', reason: 'High blood pressure', appointmentType: AppointmentType.inPerson, status: BookingStatus.rejected, createdAt: '2026-06-26'),
    BookingRequestModel(id: 21, patientName: 'Lama Al-Saud', patientPhone: null, patientAge: 32, clinicName: 'General Clinic', requestedDate: '2026-07-09', requestedTime: '10:00 AM', appointmentType: AppointmentType.inPerson, status: BookingStatus.pending, createdAt: '2026-07-08'),
    BookingRequestModel(id: 22, patientName: 'Fahad Al-Ajmi', patientPhone: '0553033345', patientAge: 41, clinicName: 'Eye Center', doctorName: 'Dr. Noor', requestedDate: '2026-07-09', requestedTime: '01:30 PM', reason: 'Eye strain', appointmentType: AppointmentType.inPerson, status: BookingStatus.pending, createdAt: '2026-07-08'),
    BookingRequestModel(id: 23, patientName: 'Aisha Al-Zaid', patientPhone: '0554044456', patientAge: 35, clinicName: 'Dental Clinic', requestedDate: '2026-07-10', requestedTime: '09:00 AM', reason: 'Teeth cleaning', appointmentType: AppointmentType.inPerson, status: BookingStatus.pending, createdAt: '2026-07-09'),
    BookingRequestModel(id: 24, patientName: 'Majed Al-Faraj', patientPhone: '0555055567', patientAge: 53, clinicName: 'Orthopedic Clinic', doctorName: 'Dr. Ahmed', requestedDate: '2026-07-10', requestedTime: '11:00 AM', appointmentType: AppointmentType.followUp, status: BookingStatus.accepted, createdAt: '2026-07-08'),
    BookingRequestModel(id: 25, patientName: 'Hind Al-Olayan', patientPhone: '0556066678', patientAge: 30, clinicName: 'Dermatology Center', doctorName: 'Dr. Laila', requestedDate: '2026-07-07', requestedTime: '04:30 PM', reason: 'Acne treatment', appointmentType: AppointmentType.online, status: BookingStatus.accepted, createdAt: '2026-07-06'),
  ];

  @override
  ApiResult<DashboardStatsModel> getStats() {
    return ApiResult.success(DashboardStatsModel.mock());
  }

  @override
  ApiResult<List<BookingRequestModel>> getBookingsByStatus(
      String status, int page, int perPage) {
    final filtered = _allBookings()
        .where((b) => b.status.name == status)
        .toList();
    if (perPage <= 0) {
      return ApiResult.success(filtered);
    }
    final start = (page - 1) * perPage;
    final end = start + perPage;
    final items = filtered.sublist(
      start.clamp(0, filtered.length),
      end.clamp(0, filtered.length),
    );
    return ApiResult.success(items);
  }

  @override
  ApiResult<bool> acceptBooking(int id) {
    return ApiResult.success(true);
  }

  @override
  ApiResult<bool> rejectBooking(int id) {
    return ApiResult.success(true);
  }
}
