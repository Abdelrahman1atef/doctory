import 'package:doctory/features/notifications/data/model/notification_model.dart';

class NotificationsMockDataSource {
  final List<NotificationModel> _notifications = [];

  NotificationsMockDataSource() {
    _init();
  }

  void _init() {
    final now = DateTime.now();
    _notifications.addAll([
      NotificationModel(
        id: 1,
        title: 'notification_title_new_offer',
        message: 'notification_message_new_offer',
        type: 'offer',
        createdAt: now.subtract(const Duration(minutes: 30)),
        isRead: false,
      ),
      NotificationModel(
        id: 2,
        title: 'notification_title_trip_soon',
        message: 'notification_message_trip_soon',
        type: 'reminder',
        createdAt: now.subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      NotificationModel(
        id: 3,
        title: 'modification_accepted',
        message: 'booking_confirmed_message',
        type: 'booking',
        createdAt: now.subtract(const Duration(hours: 5)),
        isRead: false,
      ),
      NotificationModel(
        id: 4,
        title: 'payment_received_title',
        message: 'payment_received_message',
        type: 'payment',
        createdAt: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationModel(
        id: 5,
        title: 'notification_title_admin',
        message: 'notification_message_admin',
        type: 'announcement',
        createdAt: now.subtract(const Duration(days: 2)),
        isRead: true,
      ),
      NotificationModel(
        id: 6,
        title: 'prescription_ready_title',
        message: 'prescription_ready_message',
        type: 'prescription',
        createdAt: now.subtract(const Duration(days: 3)),
        isRead: true,
      ),
      NotificationModel(
        id: 7,
        title: 'appointment_reminder_title',
        message: 'appointment_reminder_message',
        type: 'reminder',
        createdAt: now.subtract(const Duration(days: 5)),
        isRead: true,
      ),
      NotificationModel(
        id: 8,
        title: 'clinic_announcement_title',
        message: 'clinic_announcement_message',
        type: 'announcement',
        createdAt: now.subtract(const Duration(days: 7)),
        isRead: true,
      ),
    ]);
  }

  List<NotificationModel> getNotifications() => List.unmodifiable(_notifications);

  void markAsRead(int id) {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx >= 0) {
      _notifications[idx] = _notifications[idx].copyWith(isRead: true);
    }
  }

  void deleteNotification(int id) {
    _notifications.removeWhere((n) => n.id == id);
  }

  void deleteAll() {
    _notifications.clear();
  }

  int get unreadCount => _notifications.where((n) => !n.isRead).length;
}
