import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/chat_repo.dart';
import '../../../../core/services/chat/chat_realtime_service.dart';
import '../../data/model/message_model.dart';
import '../../../../core/session/user_session.dart';
import 'chat_room_states.dart';

class ChatRoomCubit extends Cubit<ChatRoomState> {
  final ChatRepo chatRepo;
  final ChatRealtimeService realtimeService;

  StreamSubscription? _newMessageSub;
  StreamSubscription? _typingSub;
  StreamSubscription? _messagesReadSub;
  StreamSubscription? _onlineUsersSub;

  String? _conversationId;
  String? _otherUserId;
  int _currentPage = 1;
  bool _hasMore = true;

  ChatRoomCubit(this.chatRepo, this.realtimeService) : super(ChatRoomInitial());

  Future<void> openConversation(String conversationId) async {
    _conversationId = conversationId;
    emit(ChatRoomLoading());

    // Call both simultaneously: Set Active Conversation AND Get Conversation Details
    await Future.wait([
      realtimeService.setActiveConversation(conversationId),
      _loadConversationDetails(conversationId),
    ]);
  }

  Future<void> _loadConversationDetails(String conversationId) async {
    final result = await chatRepo.getConversationDetail(conversationId);
    result.fold(
      onSuccess: (data) {
        // Determine the other user's ID
        final currentUserId = UserSession.userId;
        _otherUserId = data.initiatorId == currentUserId ? data.recipientId : data.initiatorId;

        emit(ChatRoomLoaded(
          conversation: data,
          messages: data.messages ?? [],
          isOtherUserOnline: _otherUserId != null ? realtimeService.isUserOnline(_otherUserId!) : false,
        ));
        
        _listenToRealtimeEvents();
      },
      onFailure: (failure) {
        emit(ChatRoomError(failure.message));
      },
    );
  }

  void _listenToRealtimeEvents() {
    _newMessageSub?.cancel();
    _typingSub?.cancel();
    _messagesReadSub?.cancel();
    _onlineUsersSub?.cancel();

    _newMessageSub = realtimeService.onNewMessage.listen((data) {
      if (state is ChatRoomLoaded) {
        final currentState = state as ChatRoomLoaded;
        try {
          final message = MessageModel.fromJson(data);
          if (message.conversationId == _conversationId) {
            final updatedMessages = [message, ...currentState.messages];
            emit(currentState.copyWith(messages: updatedMessages));
          }
        } catch (e) {
          // Fallback if parsing fails
          _loadOlderMessages(refresh: true);
        }
      }
    });

    _typingSub = realtimeService.onTypingChanged.listen((data) {
      if (state is ChatRoomLoaded) {
        final conversationId = data['conversationId']?.toString();
        final userId = data['userId']?.toString();
        final isTyping = data['isTyping'] as bool? ?? false;

        if (conversationId == _conversationId && userId == _otherUserId) {
          emit((state as ChatRoomLoaded).copyWith(isOtherUserTyping: isTyping));
        }
      }
    });

    _messagesReadSub = realtimeService.onMessagesRead.listen((conversationId) {
      if (state is ChatRoomLoaded && conversationId == _conversationId) {
        final currentState = state as ChatRoomLoaded;
        final updatedMessages = currentState.messages.map((m) {
          if (m.senderId == UserSession.userId && !m.isRead) {
            return m.copyWith(isRead: true, readAt: DateTime.now(), status: 'Read');
          }
          return m;
        }).toList();
        emit(currentState.copyWith(messages: updatedMessages));
      }
    });

    _onlineUsersSub = realtimeService.onOnlineUsersChanged.listen((onlineUsers) {
      if (state is ChatRoomLoaded && _otherUserId != null) {
        final isOnline = onlineUsers.contains(_otherUserId);
        emit((state as ChatRoomLoaded).copyWith(isOtherUserOnline: isOnline));
      }
    });
  }

  Future<void> _loadOlderMessages({bool refresh = false}) async {
    if (_conversationId == null) return;
    
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
    } else {
      if (!_hasMore) return;
      _currentPage++;
    }

    final result = await chatRepo.getMessages(_conversationId!, pageNumber: _currentPage);
    result.fold(
      onSuccess: (data) {
        if (data.length < 50) _hasMore = false;

        if (state is ChatRoomLoaded) {
          final currentState = state as ChatRoomLoaded;
          final currentMessages = refresh ? <MessageModel>[] : currentState.messages;
          
          // Filter out duplicates if refreshing or appending
          final newMessages = data.where((m) => !currentMessages.any((cm) => cm.id == m.id)).toList();
          
          emit(currentState.copyWith(messages: [...currentMessages, ...newMessages]));
        }
      },
      onFailure: (_) {
        // Handle failure silently or show toast
        if (!refresh) _currentPage--;
      },
    );
  }

  void loadMoreMessages() {
    _loadOlderMessages();
  }

  void onTyping() {
    if (_conversationId != null) {
      realtimeService.sendTypingIndicator(_conversationId!);
    }
  }

  Future<void> sendMessage(String content, {String? replyToMessageId}) async {
    if (_conversationId == null || state is! ChatRoomLoaded) return;

    final currentState = state as ChatRoomLoaded;
    
    // Optimistic Update
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final tempMessage = MessageModel(
      id: tempId,
      senderId: UserSession.userId ?? '',
      senderName: '', // Usually not needed for local UI if displaying "You"
      content: content,
      isRead: false,
      status: 'Sending',
      createdAt: DateTime.now(),
      isEdited: false,
      conversationId: _conversationId!,
      replyToMessageId: replyToMessageId,
      isLocalPending: true,
    );

    emit(currentState.copyWith(messages: [tempMessage, ...currentState.messages]));

    final result = await chatRepo.sendMessage(
      _conversationId!,
      content,
      replyToMessageId: replyToMessageId,
    );

    result.fold(
      onSuccess: (savedMessage) {
        if (state is ChatRoomLoaded) {
          final s = state as ChatRoomLoaded;
          final updatedMessages = s.messages.map((m) => m.id == tempId ? savedMessage : m).toList();
          emit(s.copyWith(messages: updatedMessages));
        }
      },
      onFailure: (failure) {
        if (state is ChatRoomLoaded) {
          final s = state as ChatRoomLoaded;
          // Mark as failed instead of removing
          final updatedMessages = s.messages.map((m) {
            if (m.id == tempId) {
              return m.copyWith(status: 'Failed');
            }
            return m;
          }).toList();
          emit(s.copyWith(messages: updatedMessages));
        }
      },
    );
  }

  Future<void> leaveConversation() async {
    await realtimeService.setActiveConversation(null);
  }

  @override
  Future<void> close() {
    _newMessageSub?.cancel();
    _typingSub?.cancel();
    _messagesReadSub?.cancel();
    _onlineUsersSub?.cancel();
    leaveConversation();
    return super.close();
  }
}
