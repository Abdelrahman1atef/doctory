class AdminPaymentModel {
  final String id;
  final String code;
  final String payerName;
  final String type;
  final double amount;
  final String method;
  final String status;
  final String date;
  final String? payerEmail;
  final String? payerPhone;
  final String? transactionId;
  final String? referenceNumber;
  final List<PaymentItemModel>? items;
  final List<PaymentTimelineModel>? timeline;

  const AdminPaymentModel({
    required this.id,
    required this.code,
    this.payerName = '',
    this.type = '',
    this.amount = 0,
    this.method = '',
    this.status = '',
    this.date = '',
    this.payerEmail,
    this.payerPhone,
    this.transactionId,
    this.referenceNumber,
    this.items,
    this.timeline,
  });

  factory AdminPaymentModel.fromJson(Map<String, dynamic> json) {
    return AdminPaymentModel(
      id: json['id']?.toString() ?? '',
      code: json['code'] ?? '',
      payerName: json['payerName'] ?? '',
      type: json['type'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      method: json['method'] ?? '',
      status: json['status'] ?? '',
      date: json['date'] ?? '',
      payerEmail: json['payerEmail'],
      payerPhone: json['payerPhone'],
      transactionId: json['transactionId'],
      referenceNumber: json['referenceNumber'],
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => PaymentItemModel.fromJson(e))
          .toList(),
      timeline: (json['timeline'] as List<dynamic>?)
          ?.map((e) => PaymentTimelineModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'payerName': payerName,
    'type': type,
    'amount': amount,
    'method': method,
    'status': status,
    'date': date,
  };
}

class PaymentItemModel {
  final String name;
  final int quantity;
  final double price;
  final double total;

  const PaymentItemModel({
    this.name = '',
    this.quantity = 1,
    this.price = 0,
    this.total = 0,
  });

  factory PaymentItemModel.fromJson(Map<String, dynamic> json) {
    return PaymentItemModel(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 1,
      price: (json['price'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
    );
  }
}

class PaymentTimelineModel {
  final String label;
  final String date;
  final bool isCompleted;

  const PaymentTimelineModel({
    this.label = '',
    this.date = '',
    this.isCompleted = false,
  });

  factory PaymentTimelineModel.fromJson(Map<String, dynamic> json) {
    return PaymentTimelineModel(
      label: json['label'] ?? '',
      date: json['date'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
