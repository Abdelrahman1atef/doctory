import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:doctory/core/locator/service_locator.dart';
import '../cubit/conversations_list/conversations_list_cubit.dart';
import '../cubit/chat_room/chat_room_cubit.dart';
import '../cubit/new_chat/new_chat_cubit.dart';
import '../presentation/views/conversations_list_view.dart';
import '../presentation/views/chat_room_view.dart';
import '../presentation/views/new_chat_view.dart';
import 'chat_router_names.dart';

class ChatRouter {
  static List<GoRoute> routes = [
    GoRoute(
      path: '/chat',
      name: ChatRouterNames.conversationsList,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<ConversationsListCubit>()..loadConversations(refresh: true),
        child: const ConversationsListView(),
      ),
    ),
    GoRoute(
      path: '/chat/room/:id',
      name: ChatRouterNames.chatRoom,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return BlocProvider(
          create: (_) => sl<ChatRoomCubit>()..openConversation(id),
          child: ChatRoomView(conversationId: id),
        );
      },
    ),
    GoRoute(
      path: '/chat/new',
      name: ChatRouterNames.newChat,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<NewChatCubit>(),
        child: const NewChatView(),
      ),
    ),
  ];
}
