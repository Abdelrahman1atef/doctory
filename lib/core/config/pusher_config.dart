import 'package:doctory/core/network/config/network_config.dart';

class PusherConfig {
  static const String appId = '2103481';
  static const String appKey = '6b19b3731d3c08d3d987';
  static const String appSecret = '9d3e027a90a3e20b960f';
  static const String cluster = 'eu';

  static String authEndpointChat =
      '${NetworkConfig.production.baseUrl}/broadcasting/auth';

  static String authEndpointTracking =
      '${NetworkConfig.production.baseUrl}/broadcasting/order-auth';

  static String getChatChannelName(int chatId) => 'private-Chat-$chatId';
  static const String messageSentEvent = 'MessageSent';

  // Order tracking
  static String getOrderTrackingChannel(int orderId) =>
      'private-Order.$orderId';
  static const String locationUpdateEvent = 'OrderLocationUpdated';
}
