import 'package:doctory/core/error/failures.dart';
import 'package:doctory/features/notifications/data/repo/notifications_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/features/notifications/cubit/notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepo _repo;

  NotificationsCubit(this._repo) : super(NotificationsInitial());

  Future<void> loadNotifications() async {
    emit(NotificationsLoading());
    final result = await _repo.getNotifications();
    result.fold(
      onSuccess: (notifications) => emit(
        NotificationsLoaded(notifications),
      ),
      onFailure: (failure) => emit(
        NotificationsError(failure.userMessage),
      ),
    );
  }

  Future<int> getUnreadCount() async {
    final result = await _repo.getUnreadCount();
    return result.fold(
      onSuccess: (count) => count,
      onFailure: (_) => 0,
    );
  }
}
