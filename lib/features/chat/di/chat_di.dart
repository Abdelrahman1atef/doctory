import 'package:get_it/get_it.dart';
import '../../../../core/network/interfaces/api_consumer.dart';
import '../../../../core/services/chat/chat_realtime_service.dart';
import '../data/data_source/chat_remote_data_source.dart';
import '../data/repo/chat_repo.dart';
import '../cubit/conversations_list/conversations_list_cubit.dart';
import '../cubit/chat_room/chat_room_cubit.dart';
import '../cubit/new_chat/new_chat_cubit.dart';

void setupChatDI(GetIt sl) {
  // Services
  if (!sl.isRegistered<ChatRealtimeService>()) {
    sl.registerLazySingleton<ChatRealtimeService>(() => ChatRealtimeService());
  }

  // Data Sources
  if (!sl.isRegistered<ChatRemoteDataSource>()) {
    sl.registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(apiConsumer: sl<ApiConsumer>()),
    );
  }

  // Repositories
  if (!sl.isRegistered<ChatRepo>()) {
    sl.registerLazySingleton<ChatRepo>(
      () => ChatRepoImpl(remoteDataSource: sl<ChatRemoteDataSource>()),
    );
  }

  // Cubits
  if (!sl.isRegistered<ConversationsListCubit>()) {
    sl.registerFactory<ConversationsListCubit>(
      () => ConversationsListCubit(sl<ChatRepo>(), sl<ChatRealtimeService>()),
    );
  }

  if (!sl.isRegistered<ChatRoomCubit>()) {
    sl.registerFactory<ChatRoomCubit>(
      () => ChatRoomCubit(sl<ChatRepo>(), sl<ChatRealtimeService>()),
    );
  }

  if (!sl.isRegistered<NewChatCubit>()) {
    sl.registerFactory<NewChatCubit>(
      () => NewChatCubit(sl<ChatRepo>()),
    );
  }
}
