class BookingConfigDto {
  final double consultationFee;
  final String currency;
  final int slotDurationMinutes;
  final int maxFutureDays;
  final int reservationTtlMinutes;
  final List<String> paymentMethods;
  final bool allowOnlineBooking;
  final bool requirePayment;

  const BookingConfigDto({
    this.consultationFee = 150.0,
    this.currency = 'SAR',
    this.slotDurationMinutes = 30,
    this.maxFutureDays = 30,
    this.reservationTtlMinutes = 10,
    this.paymentMethods = const ['credit_card', 'cash'],
    this.allowOnlineBooking = true,
    this.requirePayment = true,
  });

  factory BookingConfigDto.fromJson(Map<String, dynamic> json) =>
      BookingConfigDto(
        consultationFee: (json['consultationFee'] as num?)?.toDouble() ?? 150.0,
        currency: json['currency'] ?? 'SAR',
        slotDurationMinutes: json['slotDurationMinutes'] as int? ?? 30,
        maxFutureDays: json['maxFutureDays'] as int? ?? 30,
        reservationTtlMinutes: json['reservationTtlMinutes'] as int? ?? 10,
        paymentMethods: json['paymentMethods'] != null
            ? List<String>.from(json['paymentMethods'])
            : const ['credit_card', 'cash'],
        allowOnlineBooking: json['allowOnlineBooking'] as bool? ?? true,
        requirePayment: json['requirePayment'] as bool? ?? true,
      );
}
