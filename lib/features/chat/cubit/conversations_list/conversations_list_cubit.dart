import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/chat_repo.dart';
import '../../data/model/conversation_model.dart';
import '../../../../core/services/chat/chat_realtime_service.dart';
import 'conversations_list_states.dart';

class ConversationsListCubit extends Cubit<ConversationsListState> {
  final ChatRepo chatRepo;
  final ChatRealtimeService realtimeService;

  StreamSubscription? _newMessageSub;
  StreamSubscription? _conversationUpdatedSub;
  StreamSubscription? _onlineUsersSub;

  int _currentPage = 1;
  bool _hasMore = true;

  ConversationsListCubit(this.chatRepo, this.realtimeService) : super(ConversationsListInitial()) {
    _listenToRealtimeEvents();
  }

  void _listenToRealtimeEvents() {
    _newMessageSub = realtimeService.onNewMessage.listen((data) {
      loadConversations(refresh: true); // Simple approach: reload list on new message to get updated snippet
    });

    _conversationUpdatedSub = realtimeService.onConversationUpdated.listen((data) {
      loadConversations(refresh: true);
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
    _onlineUsersSub?.cancel();
    return super.close();
  }
}
