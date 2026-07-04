import 'dart:convert';
import 'dart:developer';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../../config/pusher_config.dart';
import '../../locator/service_locator.dart';
import '../impl/dio_consumer.dart';
import 'package:dio/dio.dart';

class PusherService {
  static const String subscriptionSucceededEvent =
      'pusher:subscription_succeeded';
  static final PusherService _instance = PusherService._internal();
  factory PusherService() => _instance;
  PusherService._internal();

  PusherChannelsFlutter? _pusher;

  /// Map of channelName -> eventName -> callback
  final Map<String, Map<String, void Function(dynamic)>> _eventHandlers = {};

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;
  late String authEndPoint;

  Future<void> initialize(String channelName) async {
    // For chat, we use the realtime auth endpoint
    if (channelName.contains('Chat') || 
        channelName.contains('presence-global') || 
        channelName.contains('private-user-')) {
      authEndPoint = PusherConfig.authEndpointChat;
    } else {
      authEndPoint = PusherConfig.authEndpointTracking;
    }

    if (_isInitialized) {
      await subscribeToChannel(channelName);
      return;
    }

    try {
      _pusher = PusherChannelsFlutter.getInstance();
      log("Initializing Pusher for channel: $channelName");

      await _pusher!.init(
        apiKey: PusherConfig.appKey,
        cluster: PusherConfig.cluster,
        onConnectionStateChange: _onConnectionStateChange,
        onError: _onError,
        onSubscriptionSucceeded: _onSubscriptionSucceeded,
        onEvent: _onGlobalEvent,
        onSubscriptionError: _onSubscriptionError,
        onDecryptionFailure: _onDecryptionFailure,
        onMemberAdded: _onMemberAdded,
        onMemberRemoved: _onMemberRemoved,
        onAuthorizer: _onAuthorizer,
      );

      await _pusher!.connect();
      await _pusher?.subscribe(channelName: channelName);

      _isInitialized = true;
      log('Pusher initialized successfully');
    } catch (e) {
      log('Pusher Initialization Error: $e');
    }
  }

  // ------------------------
  // Event Handling
  // ------------------------
  void _onGlobalEvent(PusherEvent event) {
    // Skip system events handled by dedicated callbacks to avoid duplicate processing
    if (event.eventName == subscriptionSucceededEvent ||
        event.eventName == 'pusher:member_added' ||
        event.eventName == 'pusher:member_removed') {
      return;
    }

    log('Global Event received: ${event.channelName}/${event.eventName}');

    final channelHandlers = _eventHandlers[event.channelName];
    if (channelHandlers == null) {
      log("⚠ No handlers registered for channel: ${event.channelName}");
      return;
    }

    final handler = channelHandlers[event.eventName];
    if (handler == null) {
      log("⚠ No handler registered for event: ${event.eventName}");
      return;
    }

    dynamic parsedData;
    if (event.data is String) {
      try {
        parsedData = jsonDecode(event.data!);
        log("✅ JSON parsed successfully: $parsedData");
      } catch (e) {
        log("❌ JSON parsing failed: $e, passing raw data to handler");
        parsedData = event.data;
      }
    } else {
      parsedData = event.data;
    }

    try {
      handler(parsedData);
    } catch (e, s) {
      log("❌ Handler execution error: $e");
      log(s.toString());
    }
  }

  void registerEventHandler(
    String channelName,
    String eventName,
    void Function(dynamic) callback,
  ) {
    if (!_eventHandlers.containsKey(channelName)) {
      _eventHandlers[channelName] = {};
    }

    _eventHandlers[channelName]![eventName] = callback;

    log('Registered event handler for $channelName/$eventName');
  }

  void unregisterEventHandler(String channelName, String eventName) {
    _eventHandlers[channelName]?.remove(eventName);
    log('Unregistered event handler for $channelName/$eventName');
  }

  // ------------------------
  // Pusher Callbacks
  // ------------------------
  void _onConnectionStateChange(String currentState, String previousState) {
    log('Pusher Connection State: $previousState -> $currentState');
  }

  void _onError(String message, int? code, dynamic e) {
    log('Pusher Error: $message (code: $code)');
  }

  void _onSubscriptionSucceeded(String channelName, dynamic data) {
    log('Subscribed successfully to: $channelName');
    final channelHandlers = _eventHandlers[channelName];
    final handler = channelHandlers?[subscriptionSucceededEvent];
    if (handler != null) {
      handler(data);
    }
  }

  void _onSubscriptionError(String message, dynamic e) {
    log('Subscription Error: $message');
  }

  void _onDecryptionFailure(String event, String reason) {
    log('Decryption Failure: $event, reason: $reason');
  }

  void _onMemberAdded(String channelName, PusherMember member) {
    log('Member added to $channelName: ${member.userId}');
    final channelHandlers = _eventHandlers[channelName];
    final handler = channelHandlers?['pusher:member_added'];
    if (handler != null) {
      handler(member);
    }
  }

  void _onMemberRemoved(String channelName, PusherMember member) {
    log('Member removed from $channelName: ${member.userId}');
    final channelHandlers = _eventHandlers[channelName];
    final handler = channelHandlers?['pusher:member_removed'];
    if (handler != null) {
      handler(member);
    }
  }

  // ------------------------
  // Subscribe/Unsubscribe
  // ------------------------
  Future<void> subscribeToChannel(String channelName) async {
    log(
      "🔌 subscribeToChannel called for: $channelName. _pusher: $_pusher, _isInitialized: $_isInitialized",
    );
    if (_pusher == null || !_isInitialized) {
      log('❌ Pusher not initialized, cannot subscribe.');
      return;
    }

    try {
      log("⏳ Subscribing to $channelName...");
      await _pusher!.subscribe(channelName: channelName);
      log('✅ Subscribed to channel: $channelName');
    } catch (e) {
      log('❌ Error subscribing to channel $channelName: $e');
    }
  }

  Future<void> unsubscribeFromChannel(String channelName) async {
    try {
      await _pusher?.unsubscribe(channelName: channelName);
      _eventHandlers.remove(channelName);
      log('Unsubscribed from channel: $channelName');
    } catch (e) {
      log('Error unsubscribing from channel $channelName: $e');
    }
  }

  void disconnect() {
    _pusher?.disconnect();
    _isInitialized = false;
  }

  String? _socketId;
  String? get socketId => _socketId;

  Future<Map<String, dynamic>?> _onAuthorizer(
    String channel,
    String socketId,
    options,
  ) async {
    try {
      _socketId = socketId;
      log('🔑 Authorizing channel: $channel with socket: $socketId');
      
      final dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer ${sl<DioConsumer>().config.defaultHeaders["Authorization"] ?? ""}', // Note: UserSession.token handles this better, let's use the dioConsumer below instead
      };

      final dioConsumer = sl<DioConsumer>();
      
      // Determine if we need application/x-www-form-urlencoded
      final isChatAuth = authEndPoint.contains('realtime/auth');
      
      final headers = {
        if (isChatAuth) 'Content-Type': 'application/x-www-form-urlencoded'
      };
      
      // For some APIs, the body parameters must be precise
      final body = {
        'socket_id': socketId,
        'channel_name': channel,
      };

      final result = await dioConsumer.post<dynamic>(
        path: authEndPoint,
        body: body,
        headers: headers,
        parser: (json) => json, // DioConsumer will decode it if it's JSON
      );

      return result.fold(
        onSuccess: (data) {
          log('✅ Pusher Auth Success');
          if (data is String) {
            return jsonDecode(data) as Map<String, dynamic>;
          }
          return data as Map<String, dynamic>;
        },
        onFailure: (failure) {
          log('❌ Pusher Auth Failure: ${failure.message}');
          return null;
        },
      );
    } catch (e) {
      log('❌ Pusher Auth Error: $e');
      return null;
    }
  }
}
