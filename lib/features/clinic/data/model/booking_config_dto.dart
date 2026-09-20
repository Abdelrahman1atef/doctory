import 'package:doctory/core/utils/parse_utils.dart';

class BookingConfigDto {
  final double consultationFee;
  final String currency;
  final int maxAdvanceBookingDays;
  final int reservationTtlMinutes;
  final int cancellationWindowMinutes;

  const BookingConfigDto({
    required this.consultationFee,
    required this.currency,
    required this.maxAdvanceBookingDays,
    required this.reservationTtlMinutes,
    required this.cancellationWindowMinutes,
  });

  factory BookingConfigDto.fromJson(Map<String, dynamic> json) {
    return BookingConfigDto(
      consultationFee: ParseUtils.ensureDouble(json['consultationFee']),
      currency: ParseUtils.ensureString(json['currency']),
      maxAdvanceBookingDays: ParseUtils.ensureInt(json['maxAdvanceBookingDays']),
      reservationTtlMinutes: ParseUtils.ensureInt(json['reservationTtlMinutes']),
      cancellationWindowMinutes: ParseUtils.ensureInt(json['cancellationWindowMinutes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'consultationFee': consultationFee,
      'currency': currency,
      'maxAdvanceBookingDays': maxAdvanceBookingDays,
      'reservationTtlMinutes': reservationTtlMinutes,
      'cancellationWindowMinutes': cancellationWindowMinutes,
    };
  }

  static BookingConfigDto get mock => const BookingConfigDto(
        consultationFee: 500.0,
        currency: 'EGP',
        maxAdvanceBookingDays: 30,
        reservationTtlMinutes: 15,
        cancellationWindowMinutes: 60,
      );
}
