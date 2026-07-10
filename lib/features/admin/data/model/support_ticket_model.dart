class AdminSupportTicketModel {
  final String id;
  final String code;
  final String subject;
  final String reporter;
  final String priority;
  final String status;
  final String date;
  final bool hasAttachments;
  final String? description;

  const AdminSupportTicketModel({
    required this.id,
    this.code = '',
    this.subject = '',
    this.reporter = '',
    this.priority = 'medium',
    this.status = 'open',
    this.date = '',
    this.hasAttachments = false,
    this.description,
  });

  factory AdminSupportTicketModel.fromJson(Map<String, dynamic> json) {
    return AdminSupportTicketModel(
      id: json['id']?.toString() ?? '',
      code: json['code'] ?? '',
      subject: json['subject'] ?? '',
      reporter: json['reporter'] ?? '',
      priority: json['priority'] ?? 'medium',
      status: json['status'] ?? 'open',
      date: json['date'] ?? '',
      hasAttachments: json['hasAttachments'] ?? false,
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'subject': subject,
    'reporter': reporter,
    'priority': priority,
    'status': status,
    'date': date,
    'hasAttachments': hasAttachments,
    'description': description,
  };
}
