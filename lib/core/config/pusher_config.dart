import 'package:doctory/core/network/config/network_config.dart';

class PusherConfig {
  static const String appId = '2152275';
  static const String appKey = '9b5941864596e85a6f57';
  static const String appSecret = 'fc47104b54b84beb561c';
  static const String cluster = 'eu';

  static String authEndpointChat =
      '${NetworkConfig.production.baseUrl}realtime/auth';

  static String authEndpointTracking =
      '${NetworkConfig.production.baseUrl}broadcasting/order-auth';

  // Chat Channels
  static const String presenceGlobalChannel = 'presence-global';
  static String getUserPrivateChannel(String userId) =>
      'private-user-${userId.toLowerCase()}';

  // Chat Events
  static const String newMessageEvent = 'new-message';
  static const String conversationUpdatedEvent = 'conversation-updated';
  static const String typingEvent = 'typing';
  static const String messagesReadEvent = 'messages-read';
  static const String messagesDeliveredEvent = 'messages-delivered';
  static const String unreadCountUpdatedEvent = 'unread-count.updated';

  // Order tracking
  static String getOrderTrackingChannel(int orderId) =>
      'private-Order.$orderId';
  static const String locationUpdateEvent = 'OrderLocationUpdated';
}
