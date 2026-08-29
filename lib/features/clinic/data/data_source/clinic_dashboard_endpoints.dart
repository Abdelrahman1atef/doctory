abstract class ClinicDashboardEndpoints {
  static const String base = '/admin/clinics';
  static const String stats = '$base/dashboard/stats';
  static const String bookings = 'appointments'; // Or whatever it is for clinic bookings? 
  // Wait, the README doesn't specify clinic bookings list endpoint clearly except maybe /appointments or something. I'll leave bookings as is.
  static const String acceptBooking = 'appointments/{id}/accept';
  static const String rejectBooking = 'appointments/{id}/reject';
}
