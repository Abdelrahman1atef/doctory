import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/model/message_status.dart';
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

    // Ensure realtime is initialized (e.g. after logout/login or app backgrounding)
    if (!realtimeService.isInitialized) {
      await realtimeService.initialize();
    }

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

        final messages = (data.messages ?? []).reversed.toList();
        emit(
          ChatRoomLoaded(
            conversation: data,
            messages: messages,
            isOtherUserOnline: _otherUserId != null
                ? realtimeService.isUserOnline(_otherUserId!)
                : false,
          ),
        );

        _listenToRealtimeEvents();
        _markAllAsRead(messages);
      },
      onFailure: (failure) {
        emit(ChatRoomError(failure.message));
      },
    );
  }

  void _markAllAsRead(List<MessageModel> messages) {
    final String? convId = _conversationId;
    if (convId == null) return;
    for (var m in messages) {
      if (m.senderId != UserSession.userId && !m.isRead) {
        chatRepo.markMessageAsRead(convId, m.id);
      }
    }
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
            final String convId = _conversationId!;
            // Mark as delivered immediately
            chatRepo.markMessageAsDelivered(convId, message.id);

            // If user is in chat, mark as read too
            if (message.senderId != UserSession.userId) {
              chatRepo.markMessageAsRead(convId, message.id);
            }

            final updatedMessages = [message, ...currentState.messages];
            emit(
              ChatRoomLoaded(
                conversation: currentState.conversation,
                messages: updatedMessages,
                isOtherUserOnline: currentState.isOtherUserOnline,
                isOtherUserTyping: currentState.isOtherUserTyping,
                replyingToMessage: currentState.replyingToMessage,
                highlightedMessageId: currentState.highlightedMessageId,
              ),
            );
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
          emit(
            ChatRoomLoaded(
              conversation: currentState.conversation,
              messages: currentState.messages,
              isOtherUserOnline: currentState.isOtherUserOnline,
              isOtherUserTyping: isTyping,
              replyingToMessage: currentState.replyingToMessage,
              highlightedMessageId: currentState.highlightedMessageId,
            ),
          );
        }
      }
    });

    _messagesReadSub = realtimeService.onMessagesRead.listen((data) {
      String? convId;
      String? msgId;

      if (data is String) {
        convId = data;
      } else if (data is Map) {
        convId = (data['conversationId'] ?? data['ConversationId'])?.toString();
        msgId = (data['messageId'] ?? data['MessageId'])?.toString();
      }

      if (state is ChatRoomLoaded && convId == _conversationId) {
        final currentState = state as ChatRoomLoaded;
        final updatedMessages = currentState.messages.map((m) {
          if (msgId != null) {
            if (m.id == msgId) return m.copyWith(status: MessageStatus.read);
          } else {
            if (m.senderId == UserSession.userId && m.status != MessageStatus.read) {
              return m.copyWith(status: MessageStatus.read);
            }
          }
          return m;
        }).toList();
        emit(
          ChatRoomLoaded(
            conversation: currentState.conversation,
            messages: updatedMessages,
            isOtherUserOnline: currentState.isOtherUserOnline,
            isOtherUserTyping: currentState.isOtherUserTyping,
            replyingToMessage: currentState.replyingToMessage,
            highlightedMessageId: currentState.highlightedMessageId,
          ),
        );
      }
    });

    _messagesDeliveredSub = realtimeService.onMessagesDelivered.listen((data) {
      String? convId;
      String? msgId;

      if (data is String) {
        convId = data;
      } else if (data is Map) {
        convId = (data['conversationId'] ?? data['ConversationId'])?.toString();
        msgId = (data['messageId'] ?? data['MessageId'])?.toString();
      }

      if (state is ChatRoomLoaded && convId == _conversationId) {
        final currentState = state as ChatRoomLoaded;
        final updatedMessages = currentState.messages.map((m) {
          if (msgId != null) {
            if (m.id == msgId &&
                m.status != MessageStatus.read &&
                m.status != MessageStatus.delivered) {
              return m.copyWith(status: MessageStatus.delivered);
            }
          } else {
            if (m.senderId == UserSession.userId &&
                m.status != MessageStatus.read &&
                m.status != MessageStatus.delivered) {
              return m.copyWith(status: MessageStatus.delivered);
            }
          }
          return m;
        }).toList();
        emit(
          ChatRoomLoaded(
            conversation: currentState.conversation,
            messages: updatedMessages,
            isOtherUserOnline: currentState.isOtherUserOnline,
            isOtherUserTyping: currentState.isOtherUserTyping,
            replyingToMessage: currentState.replyingToMessage,
            highlightedMessageId: currentState.highlightedMessageId,
          ),
        );
      }
    });

    _onlineUsersSub = realtimeService.onOnlineUsersChanged.listen((onlineUsers) {
      if (state is ChatRoomLoaded && _otherUserId != null) {
        final isOnline = onlineUsers.contains(_otherUserId);
        final currentState = state as ChatRoomLoaded;
        emit(
          ChatRoomLoaded(
            conversation: currentState.conversation,
            messages: currentState.messages,
            isOtherUserOnline: isOnline,
            isOtherUserTyping: currentState.isOtherUserTyping,
            replyingToMessage: currentState.replyingToMessage,
            highlightedMessageId: currentState.highlightedMessageId,
          ),
        );
      }
    });
  }

  Future<void> _loadOlderMessages({bool refresh = false}) async {
    final String? convId = _conversationId;
    if (convId == null) return;

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
    } else {
      if (!_hasMore) return;
      _currentPage++;
    }

    final result = await chatRepo.getMessages(convId, pageNumber: _currentPage);
    result.fold(
      onSuccess: (data) {
        if (data.length < 50) _hasMore = false;

        if (state is ChatRoomLoaded) {
          final currentState = state as ChatRoomLoaded;
          final currentMessages = refresh ? <MessageModel>[] : currentState.messages;

          // Filter out duplicates if refreshing or appending
          final newMessages = data
              .where((m) => !currentMessages.any((cm) => cm.id == m.id))
              .toList()
              .reversed
              .toList();

          emit(
            ChatRoomLoaded(
              conversation: currentState.conversation,
              messages: [...currentMessages, ...newMessages],
              isOtherUserOnline: currentState.isOtherUserOnline,
              isOtherUserTyping: currentState.isOtherUserTyping,
              replyingToMessage: currentState.replyingToMessage,
              highlightedMessageId: currentState.highlightedMessageId,
            ),
          );
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
    final String? convId = _conversationId;
    if (convId != null) {
      realtimeService.sendTypingIndicator(convId);
    }
  }

  void setReplyMessage(MessageModel message) {
    if (state is ChatRoomLoaded) {
      final currentState = state as ChatRoomLoaded;
      emit(
        ChatRoomLoaded(
          conversation: currentState.conversation,
          messages: currentState.messages,
          isOtherUserOnline: currentState.isOtherUserOnline,
          isOtherUserTyping: currentState.isOtherUserTyping,
          replyingToMessage: message,
          highlightedMessageId: currentState.highlightedMessageId,
        ),
      );
    }
  }

  void cancelReply() {
    if (state is ChatRoomLoaded) {
      final currentState = state as ChatRoomLoaded;
      emit(
        ChatRoomLoaded(
          conversation: currentState.conversation,
          messages: currentState.messages,
          isOtherUserOnline: currentState.isOtherUserOnline,
          isOtherUserTyping: currentState.isOtherUserTyping,
          replyingToMessage: null,
          highlightedMessageId: currentState.highlightedMessageId,
        ),
      );
    }
  }

  void jumpToMessage(String messageId) {
    if (state is ChatRoomLoaded) {
      final currentState = state as ChatRoomLoaded;
      emit(currentState.copyWith(highlightedMessageId: messageId));

      // Clear highlight after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (state is ChatRoomLoaded) {
          final s = state as ChatRoomLoaded;
          if (s.highlightedMessageId == messageId) {
            emit(s.copyWith(clearHighlight: true));
          }
        }
      });
    }
  }

  Future<void> _uploadAttachment(ChatMediaAttachment attachment) async {
    if (state is! ChatRoomLoaded) return;
    final currentState = state as ChatRoomLoaded;
    emit(
      currentState.copyWith(
        selectedFilePath: attachment.file.path,
        isUploadingMedia: true,
        uploadProgress: 0.0,
        clearMedia: false,
      ),
    );

    final result = await chatRepo.uploadChatMedia(
      attachment,
      onProgress: (sent, total) {
        if (state is ChatRoomLoaded) {
          emit((state as ChatRoomLoaded).copyWith(
            uploadProgress: total > 0 ? sent / total : 0.0,
          ));
        }
      },
    );
    result.fold(
      onSuccess: (fileName) {
        if (state is ChatRoomLoaded) {
          final s = state as ChatRoomLoaded;
          emit(
            s.copyWith(
              isUploadingMedia: false,
              uploadProgress: 1.0,
              uploadedFileName: fileName,
              uploadedMediaType: attachment.mediaType,
            ),
          );
        }
      },
      onFailure: (failure) {
        if (state is ChatRoomLoaded) {
          final s = state as ChatRoomLoaded;
          emit(s.copyWith(isUploadingMedia: false, uploadProgress: 0.0, clearMedia: true));
        }
      },
    );
  }

  Future<void> pickMedia({required bool isVideo, bool fromCamera = false}) async {
    final source = fromCamera ? ImageSource.camera : ImageSource.gallery;
    final XFile? media = isVideo
        ? await _picker.pickVideo(source: source)
        : await _picker.pickImage(source: source);
    if (media != null) {
      final attachment = isVideo
          ? ChatMediaAttachment.video(File(media.path))
          : ChatMediaAttachment.image(File(media.path));
      await _uploadAttachment(attachment);
    }
  }

  Future<void> pickFile() async {
    try {
      final result = await file_picker.FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        final attachment = ChatMediaAttachment.document(File(result.files.single.path!));
        await _uploadAttachment(attachment);
      }
    } catch (e) {
      // Handle file picker error
    }
  }

  void clearMedia() {
    if (state is ChatRoomLoaded) {
      emit((state as ChatRoomLoaded).copyWith(clearMedia: true));
    }
  }

  Future<void> sendVoiceMessage(String path) async {
    final attachment = ChatMediaAttachment.audio(File(path));
    
    if (state is ChatRoomLoaded) {
      emit((state as ChatRoomLoaded).copyWith(
        isUploadingMedia: true,
        uploadProgress: 0.0,
      ));
    }
    
    // Upload audio
    final uploadResult = await chatRepo.uploadChatMedia(
      attachment,
      onProgress: (sent, total) {
        if (state is ChatRoomLoaded) {
          emit((state as ChatRoomLoaded).copyWith(
            uploadProgress: total > 0 ? sent / total : 0.0,
          ));
        }
      },
    );
    uploadResult.fold(
      onSuccess: (fileName) async {
        if (state is ChatRoomLoaded) {
          emit((state as ChatRoomLoaded).copyWith(
            isUploadingMedia: false,
            uploadProgress: 1.0,
          ));
        }
        final mediaPayload = [
          {'mediaType': attachment.mediaType, 'fileName': fileName},
        ];
        await sendMessage("", mediaPayload: mediaPayload);
      },
      onFailure: (failure) {
        if (state is ChatRoomLoaded) {
          emit((state as ChatRoomLoaded).copyWith(
            isUploadingMedia: false,
            uploadProgress: 0.0,
          ));
        }
      },
    );
  }

  Future<void> sendMessage(String textContent, {String? replyToMessageId, List<Map<String, dynamic>>? mediaPayload}) async {
    final String? convId = _conversationId;
    if (convId == null || state is! ChatRoomLoaded) return;

    final currentState = state as ChatRoomLoaded;
    final effectiveReplyId = replyToMessageId ?? currentState.replyingToMessage?.id;

    // Use passed mediaPayload if provided (for voice notes), else fallback to cubit state
    final fileName = mediaPayload != null ? mediaPayload.first['fileName'] : currentState.uploadedFileName;
    final mediaType = mediaPayload != null ? mediaPayload.first['mediaType'] : currentState.uploadedMediaType;

    List<Map<String, dynamic>>? finalMediaPayload;
    if (fileName != null && mediaType != null) {
      finalMediaPayload = [
        {'mediaType': mediaType, 'fileName': fileName},
      ];
    }

    final content = textContent.isEmpty && finalMediaPayload != null ? " " : textContent;
    if (content.trim().isEmpty && finalMediaPayload == null) return;

    // Clear reply and media states immediately if not a voice note (voice note handles its own media state)
    if (mediaPayload == null) {
        emit(currentState.copyWith(clearReply: true, clearMedia: true));
    }

    // Optimistic Update
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final tempMessage = MessageModel(
      id: tempId,
      senderId: UserSession.userId ?? '',
      senderName: '',
      content: content.trim().isEmpty ? 'رسالة صوتية' : content,
      isRead: false,
      status: MessageStatus.pending,
      createdAt: DateTime.now(),
      isEdited: false,
      conversationId: convId,
      replyToMessageId: effectiveReplyId,
      replyToMessage: currentState.replyingToMessage,
      isLocalPending: true,
    );

    // Re-fetch current state because we emitted clear states
    final latestState = state as ChatRoomLoaded;
    emit(latestState.copyWith(messages: [tempMessage, ...latestState.messages]));

    final result = await chatRepo.sendMessage(
      convId,
      content,
      replyToMessageId: effectiveReplyId,
      mediaPayload: finalMediaPayload,
    );

    result.fold(
      onSuccess: (savedMessage) {
        if (state is ChatRoomLoaded) {
          final s = state as ChatRoomLoaded;
          final updatedMessages = s.messages.map((m) => m.id == tempId ? savedMessage : m).toList();
          emit(
            ChatRoomLoaded(
              conversation: s.conversation,
              messages: updatedMessages,
              isOtherUserOnline: s.isOtherUserOnline,
              isOtherUserTyping: s.isOtherUserTyping,
              replyingToMessage: s.replyingToMessage,
              highlightedMessageId: s.highlightedMessageId,
            ),
          );
        }
      },
      onFailure: (failure) {
        if (state is ChatRoomLoaded) {
          final s = state as ChatRoomLoaded;
          final updatedMessages = s.messages.map((m) {
            if (m.id == tempId) {
              return m.copyWith(status: MessageStatus.failed);
            }
            return m;
          }).toList();
          emit(
            ChatRoomLoaded(
              conversation: s.conversation,
              messages: updatedMessages,
              isOtherUserOnline: s.isOtherUserOnline,
              isOtherUserTyping: s.isOtherUserTyping,
              replyingToMessage: s.replyingToMessage,
              highlightedMessageId: s.highlightedMessageId,
            ),
          );
        }
      },
    );
  }

  Future<void> deleteMessage(String messageId) async {
    if (state is! ChatRoomLoaded) return;
    final currentState = state as ChatRoomLoaded;

    // Optimistic remove
    final originalMessages = List<MessageModel>.from(currentState.messages);
    final updatedMessages = originalMessages.where((m) => m.id != messageId).toList();
    emit(
      ChatRoomLoaded(
        conversation: currentState.conversation,
        messages: updatedMessages,
        isOtherUserOnline: currentState.isOtherUserOnline,
        isOtherUserTyping: currentState.isOtherUserTyping,
        replyingToMessage: currentState.replyingToMessage,
        highlightedMessageId: currentState.highlightedMessageId,
      ),
    );

    final result = await chatRepo.deleteMessage(messageId);
    result.fold(
      onSuccess: (_) {
        // Already removed optimistically
      },
      onFailure: (failure) {
        // Rollback on failure
        if (state is ChatRoomLoaded) {
          final currentState = state as ChatRoomLoaded;
          emit(
            ChatRoomLoaded(
              conversation: currentState.conversation,
              messages: originalMessages,
              isOtherUserOnline: currentState.isOtherUserOnline,
              isOtherUserTyping: currentState.isOtherUserTyping,
              replyingToMessage: currentState.replyingToMessage,
              highlightedMessageId: currentState.highlightedMessageId,
            ),
          );
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
