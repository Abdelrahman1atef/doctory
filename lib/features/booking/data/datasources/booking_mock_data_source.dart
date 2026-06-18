import 'dart:math';
import 'package:doctory/core/common/models/time_slot_model.dart';
import '../model/available_slots_dto.dart';
import '../model/create_appointment_request_dto.dart';
import '../model/payment_dto.dart';
import '../model/appointment_response_dto.dart';
import '../model/booking_config_dto.dart';

class BookingMockDataSource {
  static const double consultationFee = 150.0;
  static const String currency = 'SAR';
  static const int reservationTtlMinutes = 10;

  final Random _random = Random();
  final Map<String, DateTime> _reservations = {};
  final Map<String, Map<String, dynamic>> _appointments = {};
  int _idCounter = 0;

  String _nextId() => 'MOCK_${++_idCounter}';

  Duration get _simulatedDelay => Duration(milliseconds: 300 + _random.nextInt(700));

  bool _shouldFail(double probability) => _random.nextDouble() < probability;

  Future<AvailableSlotsDto> getAvailableSlots({
    required String doctorId,
    required String clinicId,
    required DateTime date,
  }) async {
    await Future.delayed(_simulatedDelay);

    if (_shouldFail(0.05)) {
      throw Exception('Server temporarily unavailable');
    }

    final isToday = _isSameDay(date, DateTime.now());
    final isPast = date.isBefore(DateTime.now().subtract(const Duration(days: 1)));

    if (isPast) {
      return AvailableSlotsDto(
        doctorId: doctorId,
        clinicId: clinicId,
        date: date,
        slots: [],
      );
    }

    final slots = <TimeSlotModel>[];
    final startHour = 8;
    final endHour = 21;

    for (var hour = startHour; hour < endHour; hour++) {
      for (var minute = 0; minute < 60; minute += 30) {
        final slotStart = date.copyWith(hour: hour, minute: minute);

        if (isToday && slotStart.isBefore(DateTime.now())) continue;

        final isBooked = _random.nextDouble() < 0.3;
        final isHoliday = _isWeekend(date) && hour >= 17;

        slots.add(TimeSlotModel(
          id: _nextId(),
          startTime: slotStart,
          endTime: slotStart.add(const Duration(minutes: 30)),
          isAvailable: !isBooked && !isHoliday,
        ));
      }
    }

    if (slots.isEmpty) {
      return AvailableSlotsDto(
        doctorId: doctorId,
        clinicId: clinicId,
        date: date,
        slots: [],
      );
    }

    return AvailableSlotsDto(
      doctorId: doctorId,
      clinicId: clinicId,
      date: date,
      slots: slots,
      slotDurationMinutes: 30,
    );
  }

  Future<CreateReservationResponseDto> createReservation(
    CreateAppointmentRequestDto request,
  ) async {
    await Future.delayed(_simulatedDelay);

    if (_shouldFail(0.08)) {
      throw Exception('Slot already booked by another patient');
    }

    final reservationId = _nextId();
    final expiresAt = DateTime.now().add(
      Duration(minutes: reservationTtlMinutes),
    );

    _reservations[reservationId] = expiresAt;

    return CreateReservationResponseDto(
      reservationId: reservationId,
      expiresAt: expiresAt,
      status: 'active',
      amount: consultationFee,
      currency: currency,
    );
  }

  Future<AppointmentResponseDto> confirmAppointment({
    required String reservationId,
    required String patientId,
  }) async {
    await Future.delayed(_simulatedDelay);

    if (!_reservations.containsKey(reservationId)) {
      throw Exception('Reservation not found or expired');
    }

    final expiresAt = _reservations[reservationId]!;
    if (DateTime.now().isAfter(expiresAt)) {
      _reservations.remove(reservationId);
      throw Exception('Reservation has expired. Please try again');
    }

    _reservations.remove(reservationId);

    return AppointmentResponseDto(
      id: _nextId(),
      doctorId: 'doc_1',
      doctorName: 'Dr. Ahmed',
      clinicId: 'clinic_1',
      clinicName: 'Al Noor Clinic',
      appointmentDate: DateTime.now().add(const Duration(days: 1)),
      startTime: '10:00',
      endTime: '10:30',
      appointmentType: 1,
      patientFullName: 'Patient',
      patientPhoneNumber: '0550000000',
      status: 'confirmed',
      bookingRef: 'BOK$_idCounter',
      createdAt: DateTime.now(),
    );
  }

  Future<PaymentResponseDto> processPayment(PaymentRequestDto request) async {
    await Future.delayed(Duration(seconds: 1 + _random.nextInt(2)));

    if (_shouldFail(0.12)) {
      return PaymentResponseDto(
        paymentId: _nextId(),
        reservationId: request.reservationId,
        amount: request.amount,
        currency: request.currency,
        status: 'failed',
        createdAt: DateTime.now(),
        failureReason: 'Insufficient funds',
      );
    }

    if (_shouldFail(0.05)) {
      throw Exception('Payment gateway timeout');
    }

    return PaymentResponseDto(
      paymentId: _nextId(),
      reservationId: request.reservationId,
      amount: request.amount,
      currency: request.currency,
      status: 'processing',
      transactionId: 'TXN${_nextId()}',
      redirectUrl: 'https://mock-payment-gateway.com/pay/${_nextId()}',
      createdAt: DateTime.now(),
    );
  }

  Future<PaymentResponseDto> verifyPayment({
    required String paymentId,
    required String transactionId,
  }) async {
    await Future.delayed(Duration(seconds: 1 + _random.nextInt(2)));

    if (_shouldFail(0.08)) {
      return PaymentResponseDto(
        paymentId: paymentId,
        reservationId: 'res_1',
        amount: consultationFee,
        currency: currency,
        status: 'failed',
        createdAt: DateTime.now(),
        completedAt: DateTime.now(),
        failureReason: 'Payment verification failed',
      );
    }

    final bookingRef = 'BOK${_nextId()}';

    _appointments[bookingRef] = {
      'id': bookingRef,
      'paymentId': paymentId,
      'transactionId': transactionId,
      'status': 'completed',
    };

    return PaymentResponseDto(
      paymentId: paymentId,
      reservationId: 'res_1',
      amount: consultationFee,
      currency: currency,
      status: 'completed',
      transactionId: transactionId,
      createdAt: DateTime.now(),
      completedAt: DateTime.now(),
      receiptUrl: 'https://mock-receipts.com/$bookingRef',
    );
  }

  Future<AppointmentResponseDto> getAppointment({
    required String appointmentId,
  }) async {
    await Future.delayed(_simulatedDelay);

    return AppointmentResponseDto(
      id: appointmentId,
      doctorId: 'doc_1',
      doctorName: 'Dr. Ahmed',
      clinicId: 'clinic_1',
      appointmentDate: DateTime.now().add(const Duration(days: 1)),
      startTime: '10:00',
      endTime: '10:30',
      appointmentType: 1,
      patientFullName: 'Patient',
      patientPhoneNumber: '0550000000',
      status: 'confirmed',
      bookingRef: appointmentId,
      createdAt: DateTime.now(),
    );
  }

  Future<BookingConfigDto> getBookingConfig({
    required String clinicId,
  }) async {
    await Future.delayed(_simulatedDelay);
    return const BookingConfigDto();
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isWeekend(DateTime date) =>
      date.weekday == DateTime.friday || date.weekday == DateTime.saturday;
}
