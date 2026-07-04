import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/notifications/data/model/notification_model.dart';
import 'package:doctory/features/notifications/presentation/widgets/notification_card_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NotificationsListSection extends StatelessWidget {
  final List<NotificationModel> notifications;
  final void Function(int id) onMarkAsRead;
  final void Function(int id) onDelete;
  final void Function(int id) onTap;

  const NotificationsListSection({
    super.key,
    required this.notifications,
    required this.onMarkAsRead,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.notifications_off_rounded,
              size: 64,
              color: AppColors.grey400,
            ),
            const SizedBox(height: 16),
            Text(
              LocaleKeys.notifications_empty_message.tr(),
              style: AppStyles.s16Medium.copyWith(
                color: AppColors.stitchSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return Dismissible(
          key: ValueKey(notification.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete_outline, color: AppColors.white),
          ),
          onDismissed: (_) => onDelete(notification.id),
          child: NotificationCardWidget(
            notification: notification,
            onTap: () => onTap(notification.id),
          ),
        );
      },
    );
  }
}
