import 'package:doctory/core/enums/notification_type.dart';

class NotificationModel {
  final String id;
  final String titleEn;
  final String titleAr;
  final String bodyEn;
  final String bodyAr;
  final NotificationType? type;
  final DateTime createdAt;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.bodyEn,
    required this.bodyAr,
    this.type,
    required this.createdAt,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleEn': titleEn,
      'titleAr': titleAr,
      'bodyEn': bodyEn,
      'bodyAr': bodyAr,
      'type': type?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }
}
