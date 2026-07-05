import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/features/notifications/data/data_source/notifications_endpoints.dart';
import 'package:doctory/features/notifications/data/model/notification_model.dart';

class NotificationsDataSource {
  final ApiConsumer _apiConsumer;

  NotificationsDataSource(this._apiConsumer);

  Future<ApiResult<List<NotificationModel>>> getNotifications() async {
    return await _apiConsumer.get(
      path: NotificationsEndpoints.pagginated,
      queryParameters: const {'PageNumber': 1, 'PageSize': 50},
      parser: (json) {
        final data = json['data'] as Map<String, dynamic>?;
        final items = data?['items'] as List<dynamic>?;
        if (items != null) {
          return items
              .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        return <NotificationModel>[];
      },
    );
  }

  Future<ApiResult<int>> getUnreadCount() async {
    return await _apiConsumer.get(
      path: NotificationsEndpoints.count,
      queryParameters: const {'IsRead': true},
      parser: (json) {
        return json['data'] as int;
      },
    );
  }
}
