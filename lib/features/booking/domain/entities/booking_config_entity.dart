class BookingConfigEntity {
  final double consultationFee;
  final String currency;
  final int slotDurationMinutes;
  final int maxFutureDays;
  final int reservationTtlMinutes;
  final List<String> paymentMethods;
  final bool allowOnlineBooking;
  final bool requirePayment;

  const BookingConfigEntity({
    this.consultationFee = 150.0,
    this.currency = 'SAR',
    this.slotDurationMinutes = 30,
    this.maxFutureDays = 30,
    this.reservationTtlMinutes = 10,
    this.paymentMethods = const ['credit_card', 'cash'],
    this.allowOnlineBooking = true,
    this.requirePayment = true,
  });
}
