class PaymentRequestDto {
  final String reservationId;
  final double amount;
  final String currency;
  final String paymentMethod;
  final Map<String, String>? paymentDetails;

  const PaymentRequestDto({
    required this.reservationId,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    this.paymentDetails,
  });

  Map<String, dynamic> toJson() => {
    'reservationId': reservationId,
    'amount': amount,
    'currency': currency,
    'paymentMethod': paymentMethod,
    'paymentDetails': paymentDetails,
  };
}

class PaymentResponseDto {
  final String paymentId;
  final String reservationId;
  final double amount;
  final String currency;
  final String status;
  final String? transactionId;
  final String? redirectUrl;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? failureReason;
  final String? receiptUrl;

  const PaymentResponseDto({
    required this.paymentId,
    required this.reservationId,
    required this.amount,
    required this.currency,
    required this.status,
    this.transactionId,
    this.redirectUrl,
    required this.createdAt,
    this.completedAt,
    this.failureReason,
    this.receiptUrl,
  });

  factory PaymentResponseDto.fromJson(Map<String, dynamic> json) =>
      PaymentResponseDto(
        paymentId: json['paymentId']?.toString() ?? '',
        reservationId: json['reservationId']?.toString() ?? '',
        amount: (json['amount'] ?? 0).toDouble(),
        currency: json['currency'] ?? 'EGP',
        status: json['status'] ?? 'pending',
        transactionId: json['transactionId']?.toString(),
        redirectUrl: json['redirectUrl']?.toString(),
        createdAt: DateTime.parse(json['createdAt']),
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'])
            : null,
        failureReason: json['failureReason']?.toString(),
        receiptUrl: json['receiptUrl']?.toString(),
      );
}
