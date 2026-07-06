import 'package:doctory/core/enums/notification_type.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String titleEn;
  final String titleAr;
  final String bodyEn;
  final String bodyAr;
  final NotificationType? type;
  final DateTime createdAt;
  final bool isRead;

  final String? senderUserId;
  final String? appointmentId;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.titleEn,
    required this.titleAr,
    required this.bodyEn,
    required this.bodyAr,
    this.type,
    required this.createdAt,
    this.isRead = false,
    this.senderUserId,
    this.appointmentId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      senderUserId: json['senderUserId'] as String?,
      appointmentId: json['appointmentId'] as String?,
      titleEn: json['titleEn'] as String? ?? '',
      titleAr: json['titleAr'] as String? ?? '',
      bodyEn: json['bodyEn'] as String? ?? '',
      bodyAr: json['bodyAr'] as String? ?? '',
      type: json['type'] != null
          ? NotificationType.fromJson(json['type'])
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );
  }
}
