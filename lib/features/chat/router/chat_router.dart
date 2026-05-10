import 'package:go_router/go_router.dart';
import '../presentation/views/conversations_list_view.dart';
import '../presentation/views/chat_room_view.dart';
import '../presentation/views/new_chat_view.dart';
import 'chat_router_names.dart';

class ChatRouter {
  static List<GoRoute> routes = [
    GoRoute(
      path: '/chat',
      name: ChatRouterNames.conversationsList,
      builder: (context, state) => const ConversationsListView(),
    ),
    GoRoute(
      path: '/chat/room/:id',
      name: ChatRouterNames.chatRoom,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ChatRoomView(conversationId: id);
      },
    ),
    GoRoute(
      path: '/chat/new',
      name: ChatRouterNames.newChat,
      builder: (context, state) => const NewChatView(),
    ),
  ];
}
