import 'package:doctory/core/config/deep_link_config.dart';
import 'package:doctory/core/router/app_router.dart';
import 'package:doctory/core/services/deep_link_service.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/network/interfaces/api_consumer.dart';
import '../../../../core/services/chat/chat_realtime_service.dart';
import '../../../../core/services/file_upload_service.dart';
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
      () => ChatRemoteDataSourceImpl(
        apiConsumer: sl<ApiConsumer>(),
        fileUploadService: sl<FileUploadService>(),
      ),
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

  // Deep link handler — /chat/*
  DeepLinkService.instance.register((uri) {
    if (uri.scheme != DeepLinkConfig.scheme ||
        uri.host != DeepLinkConfig.host) {
      return false;
    }
    if (uri.path.startsWith('/chat/room/')) {
      final roomId = uri.pathSegments.last;
      if (roomId.isNotEmpty) {
        DeepLinkService.instance.setPendingPath('/chat/room/$roomId');
        AppRouter.navigatorKey.currentContext?.go('/chat/room/$roomId');
        return true;
      }
    }
    if (uri.path.startsWith('/chat/')) {
      DeepLinkService.instance.setPendingPath('/chat');
      AppRouter.navigatorKey.currentContext?.go('/chat');
      return true;
    }
    return false;
  });
}
