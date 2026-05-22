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

  int _currentPage = 1;
  bool _hasMore = true;
  Timer? _refreshDebounce;

  ConversationsListCubit(this.chatRepo, this.realtimeService) : super(ConversationsListInitial()) {
    _listenToRealtimeEvents();
  }

  void _listenToRealtimeEvents() {
    _newMessageSub = realtimeService.onNewMessage.listen((data) {
      final senderId = data['senderId'] ?? data['SenderId'];
      // Only refresh if someone else sent the message
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
        ));
      }
    });

    _onlineUsersSub = realtimeService.onOnlineUsersChanged.listen((onlineUsers) {
      final currentState = state;
      if (currentState is ConversationsListLoaded) {
        emit(ConversationsListLoaded(
          conversations: currentState.conversations,
          onlineUserIds: onlineUsers,
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
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
    } else {
      if (!_hasMore) return;
    }

    if (state is! ConversationsListLoaded || refresh) {
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
        
        
        emit(ConversationsListLoaded(
          conversations: data,
          onlineUserIds: {}, // Will be populated by the stream immediately
        ));
      },
      onFailure: (failure) {
        emit(ConversationsListError(failure.message));
      },
    );
  }

  Future<void> deleteConversation(String id) async {
    final currentState = state;
    if (currentState is! ConversationsListLoaded) return;

    // Optimistic remove
    final originalList = List<ConversationModel>.from(currentState.conversations);
    final updatedList = originalList.where((c) => c.id != id).toList();
    emit(ConversationsListLoaded(
      conversations: updatedList,
      onlineUserIds: currentState.onlineUserIds,
    ));

    final result = await chatRepo.deleteConversation(id);
    result.fold(
      onSuccess: (_) {
        // Already removed
      },
      onFailure: (failure) {
        // Rollback
        emit(ConversationsListLoaded(
          conversations: originalList,
          onlineUserIds: currentState.onlineUserIds,
        ));
      },
    );
  }

  @override
  Future<void> close() {
    _newMessageSub?.cancel();
    _conversationUpdatedSub?.cancel();
    _unreadCountSub?.cancel();
    _onlineUsersSub?.cancel();
    _refreshDebounce?.cancel();
    return super.close();
  }
}
