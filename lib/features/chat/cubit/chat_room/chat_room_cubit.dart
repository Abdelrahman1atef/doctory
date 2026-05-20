import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/repo/chat_repo.dart';
import '../../../../core/services/chat/chat_realtime_service.dart';
import '../../data/model/message_model.dart';
import '../../data/model/chat_media_attachment.dart';
import 'dart:io';
import '../../../../core/session/user_session.dart';
import 'chat_room_states.dart';
import 'package:file_picker/file_picker.dart' as file_picker;

class ChatRoomCubit extends Cubit<ChatRoomState> {
  final ChatRepo chatRepo;
  final ChatRealtimeService realtimeService;
  final ImagePicker _picker = ImagePicker();

  StreamSubscription? _newMessageSub;
  StreamSubscription? _typingSub;
  StreamSubscription? _messagesReadSub;
  StreamSubscription? _messagesDeliveredSub;
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
          messages: (data.messages ?? []).reversed.toList(),
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
    _messagesDeliveredSub?.cancel();
    _onlineUsersSub?.cancel();

    _newMessageSub = realtimeService.onNewMessage.listen((data) {
      if (state is ChatRoomLoaded) {
        final currentState = state as ChatRoomLoaded;
        try {
          final message = MessageModel.fromJson(data);
          if (message.conversationId == _conversationId) {
            final updatedMessages = [message, ...currentState.messages];
            emit(ChatRoomLoaded(
              conversation: currentState.conversation,
              messages: updatedMessages,
              isOtherUserOnline: currentState.isOtherUserOnline,
              isOtherUserTyping: currentState.isOtherUserTyping,
              replyingToMessage: currentState.replyingToMessage,
            ));
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
          final currentState = state as ChatRoomLoaded;
          emit(ChatRoomLoaded(
            conversation: currentState.conversation,
            messages: currentState.messages,
            isOtherUserOnline: currentState.isOtherUserOnline,
            isOtherUserTyping: isTyping,
            replyingToMessage: currentState.replyingToMessage,
          ));
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
        emit(ChatRoomLoaded(
          conversation: currentState.conversation,
          messages: updatedMessages,
          isOtherUserOnline: currentState.isOtherUserOnline,
          isOtherUserTyping: currentState.isOtherUserTyping,
          replyingToMessage: currentState.replyingToMessage,
        ));
      }
    });

    _messagesDeliveredSub = realtimeService.onMessagesDelivered.listen((conversationId) {
      if (state is ChatRoomLoaded && conversationId == _conversationId) {
        final currentState = state as ChatRoomLoaded;
        final updatedMessages = currentState.messages.map((m) {
          // If message is ours and currently 'Sent' or 'Sending', mark as 'Delivered'
          if (m.senderId == UserSession.userId && !m.isRead && m.status != 'Read' && m.status != 'Delivered') {
            return m.copyWith(status: 'Delivered');
          }
          return m;
        }).toList();
        emit(ChatRoomLoaded(
          conversation: currentState.conversation,
          messages: updatedMessages,
          isOtherUserOnline: currentState.isOtherUserOnline,
          isOtherUserTyping: currentState.isOtherUserTyping,
          replyingToMessage: currentState.replyingToMessage,
        ));
      }
    });

    _onlineUsersSub = realtimeService.onOnlineUsersChanged.listen((onlineUsers) {
      if (state is ChatRoomLoaded && _otherUserId != null) {
        final isOnline = onlineUsers.contains(_otherUserId);
        final currentState = state as ChatRoomLoaded;
        emit(ChatRoomLoaded(
          conversation: currentState.conversation,
          messages: currentState.messages,
          isOtherUserOnline: isOnline,
          isOtherUserTyping: currentState.isOtherUserTyping,
          replyingToMessage: currentState.replyingToMessage,
        ));
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
          final newMessages = data.where((m) => !currentMessages.any((cm) => cm.id == m.id)).toList().reversed.toList();
          
          emit(ChatRoomLoaded(
            conversation: currentState.conversation,
            messages: [...currentMessages, ...newMessages],
            isOtherUserOnline: currentState.isOtherUserOnline,
            isOtherUserTyping: currentState.isOtherUserTyping,
            replyingToMessage: currentState.replyingToMessage,
          ));
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

  void setReplyMessage(MessageModel message) {
    if (state is ChatRoomLoaded) {
      final currentState = state as ChatRoomLoaded;
      emit(ChatRoomLoaded(
        conversation: currentState.conversation,
        messages: currentState.messages,
        isOtherUserOnline: currentState.isOtherUserOnline,
        isOtherUserTyping: currentState.isOtherUserTyping,
        replyingToMessage: message,
      ));
    }
  }

  void cancelReply() {
    if (state is ChatRoomLoaded) {
      final currentState = state as ChatRoomLoaded;
      emit(ChatRoomLoaded(
        conversation: currentState.conversation,
        messages: currentState.messages,
        isOtherUserOnline: currentState.isOtherUserOnline,
        isOtherUserTyping: currentState.isOtherUserTyping,
        replyingToMessage: null,
      ));
    }
  }

  Future<void> pickAndSendMedia({required bool isVideo, bool fromCamera = false}) async {
    final source = fromCamera ? ImageSource.camera : ImageSource.gallery;
    final XFile? media = isVideo 
        ? await _picker.pickVideo(source: source)
        : await _picker.pickImage(source: source);
    if (media != null) {
      final attachment = isVideo 
          ? ChatMediaAttachment.video(File(media.path))
          : ChatMediaAttachment.image(File(media.path));
      await sendMessage('', media: [attachment]);
    }
  }

  Future<void> pickAndSendFile() async {
    try {
      final result = await file_picker.FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        final attachment = ChatMediaAttachment.document(File(result.files.single.path!));
        await sendMessage('', media: [attachment]);
      }
    } catch (e) {
      // Handle file picker error
    }
  }

  Future<void> sendMessage(String content,
      {String? replyToMessageId, List<ChatMediaAttachment>? media}) async {
    if (_conversationId == null || state is! ChatRoomLoaded) return;

    final currentState = state as ChatRoomLoaded;
    final effectiveReplyId =
        replyToMessageId ?? currentState.replyingToMessage?.id;

    // Clear reply state immediately
    if (currentState.replyingToMessage != null) {
      emit(ChatRoomLoaded(
        conversation: currentState.conversation,
        messages: currentState.messages,
        isOtherUserOnline: currentState.isOtherUserOnline,
        isOtherUserTyping: currentState.isOtherUserTyping,
        replyingToMessage: null,
      ));
    }

    // Optimistic Update
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final tempMessage = MessageModel(
      id: tempId,
      senderId: UserSession.userId ?? '',
      senderName: '', // Usually not needed for local UI if displaying "You"
      content: (media != null && media.isNotEmpty && content.isEmpty) ? 'رسالة وسائط' : content,
      isRead: false,
      status: 'Sending',
      createdAt: DateTime.now(),
      isEdited: false,
      conversationId: _conversationId!,
      replyToMessageId: effectiveReplyId,
      replyToMessage: currentState.replyingToMessage,
      isLocalPending: true,
    );

    // Re-fetch current state because we might have emitted clearReply
    final latestState = state as ChatRoomLoaded;
    emit(ChatRoomLoaded(
      conversation: latestState.conversation,
      messages: [tempMessage, ...latestState.messages],
      isOtherUserOnline: latestState.isOtherUserOnline,
      isOtherUserTyping: latestState.isOtherUserTyping,
      replyingToMessage: latestState.replyingToMessage,
    ));

    final result = await chatRepo.sendMessage(
      _conversationId!,
      content,
      replyToMessageId: effectiveReplyId,
      media: media,
    );

    result.fold(
      onSuccess: (savedMessage) {
        if (state is ChatRoomLoaded) {
          final s = state as ChatRoomLoaded;
          final updatedMessages = s.messages.map((m) => m.id == tempId ? savedMessage : m).toList();
          emit(ChatRoomLoaded(
            conversation: s.conversation,
            messages: updatedMessages,
            isOtherUserOnline: s.isOtherUserOnline,
            isOtherUserTyping: s.isOtherUserTyping,
            replyingToMessage: s.replyingToMessage,
          ));
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
          emit(ChatRoomLoaded(
            conversation: s.conversation,
            messages: updatedMessages,
            isOtherUserOnline: s.isOtherUserOnline,
            isOtherUserTyping: s.isOtherUserTyping,
            replyingToMessage: s.replyingToMessage,
          ));
        }
      },
    );
  }

  Future<void> deleteMessage(String messageId) async {
    if (state is! ChatRoomLoaded) return;
    final currentState = state as ChatRoomLoaded;

    // Optimistic remove
    final originalMessages = List<MessageModel>.from(currentState.messages);
    final updatedMessages =
        originalMessages.where((m) => m.id != messageId).toList();
    emit(ChatRoomLoaded(
      conversation: currentState.conversation,
      messages: updatedMessages,
      isOtherUserOnline: currentState.isOtherUserOnline,
      isOtherUserTyping: currentState.isOtherUserTyping,
      replyingToMessage: currentState.replyingToMessage,
    ));

    final result = await chatRepo.deleteMessage(messageId);
    result.fold(
      onSuccess: (_) {
        // Already removed optimistically
      },
      onFailure: (failure) {
        // Rollback on failure
        if (state is ChatRoomLoaded) {
          final currentState = state as ChatRoomLoaded;
          emit(ChatRoomLoaded(
            conversation: currentState.conversation,
            messages: originalMessages,
            isOtherUserOnline: currentState.isOtherUserOnline,
            isOtherUserTyping: currentState.isOtherUserTyping,
            replyingToMessage: currentState.replyingToMessage,
          ));
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
    _messagesDeliveredSub?.cancel();
    _onlineUsersSub?.cancel();
    leaveConversation();
    return super.close();
  }
}
