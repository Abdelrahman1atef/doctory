import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/features/notifications/cubit/notifications_state.dart';
import 'package:doctory/features/notifications/data/model/notification_model.dart';
import 'package:doctory/features/notifications/data/data_source/notifications_mock_data_source.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsMockDataSource _dataSource;

  NotificationsCubit(this._dataSource) : super(NotificationsInitial());

  void loadNotifications() {
    emit(NotificationsLoading());
    try {
      final notifications = _dataSource.getNotifications();
      emit(NotificationsLoaded(notifications));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  void markAsRead(int id) {
    _dataSource.markAsRead(id);
    final notifications = _dataSource.getNotifications();
    emit(NotificationsLoaded(notifications));
  }

  void deleteNotification(int id) {
    _dataSource.deleteNotification(id);
    final notifications = _dataSource.getNotifications();
    if (notifications.isEmpty) {
      emit(NotificationsLoaded(notifications));
    } else {
      emit(NotificationsLoaded(notifications));
    }
  }

  void deleteAll() {
    _dataSource.deleteAll();
    emit(NotificationsLoaded([]));
  }

  void addNotification(NotificationModel notification) {
    _dataSource.getNotifications();
    loadNotifications();
  }
}
