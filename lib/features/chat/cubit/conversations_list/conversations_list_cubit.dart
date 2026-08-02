import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/session/user_session.dart';
import '../../data/repo/chat_repo.dart';
import '../../data/model/conversation_model.dart';
import '../../../../core/services/chat/chat_realtime_service.dart';
import 'conversations_list_states.dart';

class ConversationsListCubit extends Cubit<ConversationsListState> {
  final ChatRepo chatRepo;
  final ChatRealtimeService realtimeService;

  StreamSubscription? _newMessageSub;
  StreamSubscription? _conversationUpdatedSub;
  StreamSubscription? _unreadCountSub;
  StreamSubscription? _onlineUsersSub;
  StreamSubscription? _typingSub;

  int _currentPage = 1;
  bool _hasMore = true;
  Timer? _refreshDebounce;

  ConversationsListCubit(this.chatRepo, this.realtimeService) : super(ConversationsListInitial());

  void _listenToRealtimeEvents() {
    _newMessageSub?.cancel();
    _conversationUpdatedSub?.cancel();
    _unreadCountSub?.cancel();
    _onlineUsersSub?.cancel();
    _typingSub?.cancel();

    _newMessageSub = realtimeService.onNewMessage.listen((data) {
      final senderId = data['senderId'] ?? data['SenderId'];
      if (senderId != UserSession.userId) {
        _debouncedRefresh();
      }
    });

    _conversationUpdatedSub = realtimeService.onConversationUpdated.listen((data) {
      _debouncedRefresh();
    });

    _unreadCountSub = realtimeService.onUnreadCountChanged.listen((data) {
      final conversationId = data['conversationId']?.toString();
      final count = int.tryParse(data['unreadCount']?.toString() ?? '0') ?? 0;

      if (conversationId != null && state is ConversationsListLoaded) {
        final currentState = state as ConversationsListLoaded;
        final updatedConversations = currentState.conversations.map((c) {
          if (c.id == conversationId) {
            return c.copyWith(unreadMessageCount: count);
          }
          return c;
        }).toList();

        emit(ConversationsListLoaded(
          conversations: updatedConversations,
          onlineUserIds: currentState.onlineUserIds,
          typingUserIds: currentState.typingUserIds,
        ));
      }
    });

    _onlineUsersSub = realtimeService.onOnlineUsersChanged.listen((onlineUsers) {
      final currentState = state;
      if (currentState is ConversationsListLoaded) {
        emit(ConversationsListLoaded(
          conversations: currentState.conversations,
          onlineUserIds: onlineUsers,
          typingUserIds: currentState.typingUserIds,
        ));
      }
    });

    _typingSub = realtimeService.onTypingChanged.listen((data) {
      final conversationId = data['conversationId']?.toString();
      final isTyping = data['isTyping'] as bool? ?? false;

      if (conversationId != null && state is ConversationsListLoaded) {
        final currentState = state as ConversationsListLoaded;
        final updatedTyping = Set<String>.from(currentState.typingUserIds);

        if (isTyping) {
          updatedTyping.add(conversationId);
        } else {
          updatedTyping.remove(conversationId);
        }

        emit(ConversationsListLoaded(
          conversations: currentState.conversations,
          onlineUserIds: currentState.onlineUserIds,
          typingUserIds: updatedTyping,
        ));
      }
    });
  }

  void _debouncedRefresh() {
    _refreshDebounce?.cancel();
    _refreshDebounce = Timer(const Duration(milliseconds: 500), () {
      loadConversations(refresh: true);
    });
  }

  Future<void> loadConversations({bool refresh = false}) async {
    await realtimeService.initialize();
    _listenToRealtimeEvents();

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
    } else {
      if (!_hasMore) return;
    }

    if (state is! ConversationsListLoaded) {
      emit(ConversationsListLoading());
    }

    final result = await chatRepo.getConversations(pageNumber: _currentPage);
    result.fold(
      onSuccess: (data) {
        if (data.length < 10) {
          _hasMore = false;
        } else {
          _currentPage++;
        }
        
        final onlineUserIds = (state is ConversationsListLoaded) 
            ? (state as ConversationsListLoaded).onlineUserIds 
            : <String>{};
        final typingUserIds = (state is ConversationsListLoaded) 
            ? (state as ConversationsListLoaded).typingUserIds 
            : <String>{};
        
        emit(ConversationsListLoaded(
          conversations: refresh ? data : [...(state is ConversationsListLoaded ? (state as ConversationsListLoaded).conversations : []), ...data],
          onlineUserIds: onlineUserIds,
          typingUserIds: typingUserIds,
        ));
      },
      onFailure: (failure) {
        if (state is! ConversationsListLoaded) {
          emit(ConversationsListError(failure.message));
        }
      },
    );
  }

  Future<void> deleteConversation(String id) async {
    final currentState = state;
    if (currentState is! ConversationsListLoaded) return;

    final originalList = List<ConversationModel>.from(currentState.conversations);
    final updatedList = originalList.where((c) => c.id != id).toList();
    emit(ConversationsListLoaded(
      conversations: updatedList,
      onlineUserIds: currentState.onlineUserIds,
      typingUserIds: currentState.typingUserIds,
    ));

    final result = await chatRepo.deleteConversation(id);
    result.fold(
      onSuccess: (_) {},
      onFailure: (failure) {
        emit(ConversationsListLoaded(
          conversations: originalList,
          onlineUserIds: currentState.onlineUserIds,
          typingUserIds: currentState.typingUserIds,
        ));
      },
    );
  }

  @override
  Future<void> close() async {
    // Realtime lifecycle is owned by UserSession.logout() -> ChatRealtimeService.disconnect()
    _newMessageSub?.cancel();
    _conversationUpdatedSub?.cancel();
    _unreadCountSub?.cancel();
    _onlineUsersSub?.cancel();
    _typingSub?.cancel();
    _refreshDebounce?.cancel();
    return super.close();
  }
}
