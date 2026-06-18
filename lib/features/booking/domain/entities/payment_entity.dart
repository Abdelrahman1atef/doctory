import '../enums/payment_status.dart';

class PaymentEntity {
  final String id;
  final String reservationId;
  final double amount;
  final String currency;
  final PaymentStatus status;
  final String? transactionId;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? failureReason;

  const PaymentEntity({
    required this.id,
    required this.reservationId,
    required this.amount,
    required this.currency,
    required this.status,
    this.transactionId,
    required this.createdAt,
    this.completedAt,
    this.failureReason,
  });

  bool get isSuccessful => status == PaymentStatus.completed;
  bool get isFinal => status.isFinal;
}
