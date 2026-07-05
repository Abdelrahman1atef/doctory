import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/features/notifications/cubit/notifications_cubit.dart';
import 'package:doctory/features/notifications/data/data_source/notifications_mock_data_source.dart';

void setupNotificationsDI() {
  sl.registerLazySingleton<NotificationsDataSource>(
    () => NotificationsDataSource(sl<ApiConsumer>()),
  );
  sl.registerFactory<NotificationsCubit>(
    () => NotificationsCubit(sl<NotificationsDataSource>()),
  );
}
