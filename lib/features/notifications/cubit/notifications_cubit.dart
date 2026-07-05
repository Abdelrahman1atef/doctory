import 'package:doctory/core/error/failures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/features/notifications/cubit/notifications_state.dart';
import 'package:doctory/features/notifications/data/data_source/notifications_mock_data_source.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsDataSource _dataSource;

  NotificationsCubit(this._dataSource) : super(NotificationsInitial());

  Future<void> loadNotifications() async {
    emit(NotificationsLoading());
    final result = await _dataSource.getNotifications();
    result.fold(
      onSuccess: (notifications) => emit(
        NotificationsLoaded(notifications),
      ),
      onFailure: (failure) => emit(
        NotificationsError(failure.userMessage),
      ),
    );
  }

  Future<void> markAsRead(int id) async {
    final result = await _dataSource.markAsRead(id);
    result.fold(
      onSuccess: (_) => loadNotifications(),
      onFailure: (_) => loadNotifications(),
    );
  }

  Future<void> markAllAsRead() async {
    final result = await _dataSource.markAllAsRead();
    result.fold(
      onSuccess: (_) => loadNotifications(),
      onFailure: (_) => loadNotifications(),
    );
  }

  Future<void> deleteNotification(int id) async {
    final result = await _dataSource.deleteNotification(id);
    result.fold(
      onSuccess: (_) => loadNotifications(),
      onFailure: (_) => loadNotifications(),
    );
  }

  Future<void> deleteAll() async {
    final result = await _dataSource.deleteAll();
    result.fold(
      onSuccess: (_) => loadNotifications(),
      onFailure: (_) => loadNotifications(),
    );
  }
}
