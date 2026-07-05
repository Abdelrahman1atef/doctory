import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/features/notifications/data/data_source/notifications_endpoints.dart';
import 'package:doctory/features/notifications/data/model/notification_model.dart';

class NotificationsDataSource {
  final ApiConsumer _apiConsumer;

  NotificationsDataSource(this._apiConsumer);

  Future<ApiResult<List<NotificationModel>>> getNotifications() async {
    return await _apiConsumer.get(
      path: NotificationsEndpoints.list,
      parser: (json) {
        final data = json['data'] ?? json;
        if (data is List) {
          return data
              .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return <NotificationModel>[];
      },
    );
  }

  Future<ApiResult<void>> markAsRead(int id) async {
    return await _apiConsumer.patch(
      path: NotificationsEndpoints.markReadById(id),
    );
  }

  Future<ApiResult<void>> markAllAsRead() async {
    return await _apiConsumer.patch(
      path: NotificationsEndpoints.markAllRead,
    );
  }

  Future<ApiResult<void>> deleteNotification(int id) async {
    return await _apiConsumer.delete(
      path: NotificationsEndpoints.deleteById(id),
    );
  }

  Future<ApiResult<void>> deleteAll() async {
    return await _apiConsumer.delete(
      path: NotificationsEndpoints.deleteAll,
    );
  }
}
