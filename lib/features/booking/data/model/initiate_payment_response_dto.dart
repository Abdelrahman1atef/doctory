class InitiatePaymentResponseDto {
  final String paymentKey;
  final String redirectUrl;
  final String paymentId;

  const InitiatePaymentResponseDto({
    required this.paymentKey,
    required this.redirectUrl,
    required this.paymentId,
  });

  factory InitiatePaymentResponseDto.fromJson(Map<String, dynamic> json) {
    return InitiatePaymentResponseDto(
      paymentKey: json['paymentKey']?.toString() ?? '',
      redirectUrl: json['redirectUrl']?.toString() ?? '',
      paymentId: json['paymentId']?.toString() ?? '',
    );
  }
}
