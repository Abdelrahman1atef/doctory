import 'package:doctory/core/enums/notification_type.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/notifications/data/model/notification_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NotificationCardWidget extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationCardWidget({super.key, required this.notification, required this.onTap});

  static final _typeIcons = <NotificationType, IconData>{
    NotificationType.appointmentReminder: Icons.alarm_rounded,
    NotificationType.newMessage: Icons.message_rounded,
    NotificationType.paymentConfirmation: Icons.credit_card_rounded,
    NotificationType.appointmentConfirmation: Icons.event_available_rounded,
    NotificationType.appointmentCancellation: Icons.cancel_rounded,
    NotificationType.systemAnnouncement: Icons.campaign_rounded,
  };

  IconData get _icon =>
      _typeIcons[notification.type ?? NotificationType.systemAnnouncement] ??
      Icons.notifications_rounded;

  String get _timeAgo {
    final diff = DateTime.now().difference(notification.createdAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${diff.inDays ~/ 7}w';
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    final title = locale == 'ar' ? notification.titleAr : notification.titleEn;
    final body = locale == 'ar' ? notification.bodyAr : notification.bodyEn;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: notification.isRead ? AppColors.white : AppColors.stitchSurfaceLow,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.stitchPrimaryContainer.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(_icon, color: AppColors.stitchPrimary, size: 20),
                    ),
                    if (!notification.isRead) ...[
                      PositionedDirectional(
                        top: -2,
                        start: -2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: AppStyles.s14SemiBold.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _timeAgo,
                            style: AppStyles.s12Medium.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        body,
                        style: AppStyles.s12Medium.copyWith(color: AppColors.textSecondary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
