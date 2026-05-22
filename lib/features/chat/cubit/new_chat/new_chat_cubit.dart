import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/chat_repo.dart';
import 'new_chat_states.dart';

class NewChatCubit extends Cubit<NewChatState> {
  final ChatRepo chatRepo;
  Timer? _debounce;

  NewChatCubit(this.chatRepo) : super(NewChatInitial());

  void searchUsers(String query) {
    if (query.isEmpty) {
      emit(NewChatInitial());
      return;
    }

    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      emit(NewChatSearchLoading());
      final result = await chatRepo.searchUsers(query);
      
      result.fold(
        onSuccess: (users) {
          emit(NewChatSearchLoaded(users));
        },
        onFailure: (failure) {
          emit(NewChatSearchError(failure.message));
        },
      );
    });
  }

  Future<void> createConversation(String recipientId) async {
    emit(NewChatCreating());
    final result = await chatRepo.createConversation(recipientId);
    
    result.fold(
      onSuccess: (conversationId) {
        emit(NewChatCreated(conversationId));
      },
      onFailure: (failure) {
        emit(NewChatCreateError(failure.message));
      },
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
