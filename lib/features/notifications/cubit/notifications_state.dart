import 'package:doctory/features/notifications/data/model/notification_model.dart';

sealed class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationModel> notifications;
  final int unreadCount;

  NotificationsLoaded(this.notifications, {int? unreadCount})
      : unreadCount = unreadCount ?? notifications.where((n) => !n.isRead).length;
}

class NotificationsError extends NotificationsState {
  final String message;
  NotificationsError(this.message);
}
