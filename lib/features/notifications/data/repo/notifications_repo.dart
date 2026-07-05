import 'package:doctory/core/error/error_handler.dart';
import 'package:doctory/core/network/interfaces/api_result.dart';
import 'package:doctory/features/notifications/data/data_source/notifications_mock_data_source.dart';
import 'package:doctory/features/notifications/data/model/notification_model.dart';

abstract class NotificationsRepo {
  Future<ApiResult<List<NotificationModel>>> getNotifications();
  Future<ApiResult<int>> getUnreadCount();
}

class NotificationsRepoImpl implements NotificationsRepo {
  final NotificationsDataSource _dataSource;

  NotificationsRepoImpl(this._dataSource);

  @override
  Future<ApiResult<List<NotificationModel>>> getNotifications() async {
    try {
      return await _dataSource.getNotifications();
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<ApiResult<int>> getUnreadCount() async {
    try {
      return await _dataSource.getUnreadCount();
    } on Exception catch (e) {
      return ApiResult.failure(ErrorHandler.handleException(e));
    }
  }
}
