import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/appointment_response_dto.dart';
import '../model/booking_config_dto.dart';

class BookingLocalDataSource {
  static const String _appointmentsKey = 'cached_appointments';
  static const String _configKey = 'cached_booking_config';

  Future<void> cacheAppointments(List<AppointmentResponseDto> appointments) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = appointments.map((a) => jsonEncode({
      'id': a.id,
      'doctorId': a.doctorId,
      'doctorName': a.doctorName,
      'clinicId': a.clinicId,
      'appointmentDate': a.appointmentDate.toIso8601String(),
      'startTime': a.startTime,
      'endTime': a.endTime,
      'appointmentType': a.appointmentType,
      'patientFullName': a.patientFullName,
      'patientPhoneNumber': a.patientPhoneNumber,
      'status': a.status,
      'bookingReference': a.bookingReference,
      'createdAt': a.createdAt.toIso8601String(),
    })).toList();
    await prefs.setString(_appointmentsKey, jsonEncode(jsonList));
  }

  List<AppointmentResponseDto> getCachedAppointments() {
    final prefs = SharedPreferences.getInstance();
    final jsonStr = prefs.toString();
    if (jsonStr.isEmpty) return [];
    try {
      final List<dynamic> jsonList = jsonDecode(jsonStr);
      return jsonList
          .map((e) => AppointmentResponseDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> cacheConfig(BookingConfigDto config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_configKey, jsonEncode({
      'consultationFee': config.consultationFee,
      'currency': config.currency,
      'slotDurationMinutes': config.slotDurationMinutes,
      'maxFutureDays': config.maxFutureDays,
      'reservationTtlMinutes': config.reservationTtlMinutes,
    }));
  }

  BookingConfigDto? getCachedConfig() {
    final prefs = SharedPreferences.getInstance();
    final jsonStr = prefs.toString();
    if (jsonStr.isEmpty) return null;
    try {
      return BookingConfigDto.fromJson(
        jsonDecode(jsonStr) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }
}
