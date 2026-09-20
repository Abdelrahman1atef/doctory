abstract class ClinicDashboardEndpoints {
  static const String base = '/admin/clinics';
  static const String stats = '$base/dashboard/stats';
  static const String bookings = 'appointments';
  static const String acceptBooking = 'appointments/{id}/accept';
  static const String rejectBooking = 'appointments/{id}/reject';

  static String bookingConfig(String clinicId) => '/clinics/$clinicId/booking-config';
  static const String availability = '/availability';
  static String deleteAvailability(String id) => '/availability/$id';
  static String updateAvailability(String id) => '/availability/$id';
}
