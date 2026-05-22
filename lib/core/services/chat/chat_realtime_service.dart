import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../locator/service_locator.dart';
import '../../network/services/pusher_service.dart';
import '../../config/pusher_config.dart';
import '../../network/interfaces/api_consumer.dart';
import '../../session/user_session.dart';

/// Service to handle Chat-specific Realtime events via Pusher
class ChatRealtimeService {
  final PusherService _pusherService = sl<PusherService>();
  final ApiConsumer _apiConsumer = sl<ApiConsumer>();

  // Stream Controllers for broadcasting events to Cubits
  final _newMessageController = StreamController<Map<String, dynamic>>.broadcast();
  final _conversationUpdatedController = StreamController<Map<String, dynamic>>.broadcast();
  final _typingController = StreamController<Map<String, dynamic>>.broadcast();
  final _messagesReadController = StreamController<dynamic>.broadcast();
  final _messagesDeliveredController = StreamController<dynamic>.broadcast();
  final _unreadCountController = StreamController<Map<String, dynamic>>.broadcast();
  final _onlineUsersController = StreamController<Set<String>>.broadcast();

  // Streams
  Stream<Map<String, dynamic>> get onNewMessage => _newMessageController.stream;
  Stream<Map<String, dynamic>> get onConversationUpdated => _conversationUpdatedController.stream;
  Stream<Map<String, dynamic>> get onTypingChanged => _typingController.stream;
  Stream<dynamic> get onMessagesRead => _messagesReadController.stream;
  Stream<dynamic> get onMessagesDelivered => _messagesDeliveredController.stream;
  Stream<Map<String, dynamic>> get onUnreadCountChanged => _unreadCountController.stream;
  Stream<Set<String>> get onOnlineUsersChanged => _onlineUsersController.stream;

  Set<String> _onlineUsers = {};
  Timer? _typingDebounceTimer;
  bool _isCurrentlyTyping = false;
  String? _activeConversationId;
  String? _userId;

  Future<void> initialize() async {
    final userId = UserSession.userId;
    if (userId == null) return;
    _userId = userId;

    // Initialize Pusher and subscribe to Global Presence Channel
    await _pusherService.initialize(PusherConfig.presenceGlobalChannel);
    
    // Subscribe to Private User Channel
    final privateChannel = PusherConfig.getUserPrivateChannel(userId);
    await _pusherService.subscribeToChannel(privateChannel);

    _registerEventHandlers(privateChannel);

    // Call REST endpoint to register connection
    await _registerConnection();
  }

  void _registerEventHandlers(String privateChannel) {
    // 1. New Message
    _pusherService.registerEventHandler(
      privateChannel,
      PusherConfig.newMessageEvent,
      (data) {
        debugPrint('📩 ChatRealtime: New message received');
        _newMessageController.add(data);
      },
    );

    // 2. Conversation Updated
    _pusherService.registerEventHandler(
      privateChannel,
      PusherConfig.conversationUpdatedEvent,
      (data) {
        debugPrint('🔄 ChatRealtime: Conversation updated');
        _conversationUpdatedController.add(data);
      },
    );

    // 3. Typing
    _pusherService.registerEventHandler(
      privateChannel,
      PusherConfig.typingEvent,
      (data) {
        _typingController.add(data);
      },
    );

    // 4. Messages Read
    _pusherService.registerEventHandler(
      privateChannel,
      PusherConfig.messagesReadEvent,
      (data) {
        _messagesReadController.add(data);
      },
    );

    // 5. Messages Delivered
    _pusherService.registerEventHandler(
      privateChannel,
      PusherConfig.messagesDeliveredEvent,
      (data) {
        _messagesDeliveredController.add(data);
      },
    );

    _pusherService.registerEventHandler(
      privateChannel,
      PusherConfig.unreadCountUpdatedEvent,
      (data) {
        debugPrint('🔢 ChatRealtime: Unread count updated');
        _unreadCountController.add(data);
      },
    );

    // Presence Callbacks
    _pusherService.registerEventHandler(
      PusherConfig.presenceGlobalChannel,
      PusherService.subscriptionSucceededEvent,
      (data) {
        debugPrint('🟢 ChatRealtime: Subscribed to presence channel. Parsing online users...');
        if (data is Map && data.containsKey('presence')) {
          final presence = data['presence'] as Map;
          if (presence.containsKey('hash')) {
            final hash = presence['hash'] as Map;
            _onlineUsers = hash.keys.map((e) => e.toString()).toSet();
            _onlineUsersController.add(_onlineUsers);
          }
        }
      },
    );

    _pusherService.registerEventHandler(
      PusherConfig.presenceGlobalChannel,
      'pusher:member_added',
      (member) {
        String? userId;
        if (member is Map) {
          userId = (member['user_id'] ?? member['userId'])?.toString();
        } else {
          // Fallback if it's a PusherMember object
          try {
            userId = member.userId?.toString();
          } catch (_) {}
        }
        
        if (userId != null) {
          _onlineUsers.add(userId);
          _onlineUsersController.add(_onlineUsers);
        }
      },
    );

    _pusherService.registerEventHandler(
      PusherConfig.presenceGlobalChannel,
      'pusher:member_removed',
      (member) {
        String? userId;
        if (member is Map) {
          userId = (member['user_id'] ?? member['userId'])?.toString();
        } else {
          // Fallback if it's a PusherMember object
          try {
            userId = member.userId?.toString();
          } catch (_) {}
        }

        if (userId != null) {
          _onlineUsers.remove(userId);
          _onlineUsersController.add(_onlineUsers);
        }
      },
    );
  }

  Future<void> _registerConnection() async {
    // Wait slightly to ensure socketId is available
    await Future.delayed(const Duration(milliseconds: 500));
    final socketId = _pusherService.socketId;
    if (socketId != null) {
      await _apiConsumer.post(
        path: 'realtime/connect',
        body: {'ConnectionId': socketId},
      );
    }
  }

  Future<void> setActiveConversation(String? conversationId) async {
    _activeConversationId = conversationId;
    
    // Only call the API if we have a valid conversationId.
    // If conversationId is null, it means the user is leaving.
    // We skip the API call for null to avoid 400 Bad Request errors 
    // until the backend is updated to handle 'exit' signals correctly.
    if (conversationId != null && conversationId.isNotEmpty) {
      try {
        await _apiConsumer.post(
          path: 'realtime/active-conversation',
          body: {'conversationId': conversationId},
        );
      } catch (e) {
        debugPrint('ChatRealtime: Error setting active conversation to $conversationId: $e');
      }
    }
  }

  /// Sends typing indicator with built-in 2-second debounce
  void sendTypingIndicator(String conversationId) {
    if (_activeConversationId != conversationId) return;

    if (!_isCurrentlyTyping) {
      _isCurrentlyTyping = true;
      _sendTypingStatus(conversationId, true);
    }

    _typingDebounceTimer?.cancel();
    _typingDebounceTimer = Timer(const Duration(seconds: 2), () {
      _isCurrentlyTyping = false;
      _sendTypingStatus(conversationId, false);
    });
  }

  Future<void> _sendTypingStatus(String conversationId, bool isTyping) async {
    await _apiConsumer.post(
      path: 'realtime/typing',
      body: {
        'ConversationId': conversationId,
        'IsTyping': isTyping,
      },
    );
  }

  Future<void> disconnect() async {
    final socketId = _pusherService.socketId;
    if (socketId != null) {
      try {
        await _apiConsumer.post(
          path: 'realtime/disconnect',
          body: {'ConnectionId': socketId},
        );
      } catch (e) {
        debugPrint('Error disconnecting realtime: $e');
      }
    }
    
    if (_userId != null) {
      final privateChannel = PusherConfig.getUserPrivateChannel(_userId!);
      await _pusherService.unsubscribeFromChannel(privateChannel);
      await _pusherService.unsubscribeFromChannel(PusherConfig.presenceGlobalChannel);
    }
    
    _onlineUsers.clear();
    _typingDebounceTimer?.cancel();
    _activeConversationId = null;
    _userId = null;
    _isCurrentlyTyping = false;
  }

  bool isUserOnline(String userId) {
    return _onlineUsers.contains(userId);
  }
}
