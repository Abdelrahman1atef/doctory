import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/locator/service_locator.dart';
import '../../cubit/chat_room/chat_room_cubit.dart';
import '../../cubit/chat_room/chat_room_states.dart';
import '../widgets/chat_message_widget.dart';
import '../widgets/chat_avatar_widget.dart';
import '../../../../core/session/user_session.dart';

class ChatRoomView extends StatelessWidget {
  final String conversationId;

  const ChatRoomView({Key? key, required this.conversationId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ChatRoomCubit>()..openConversation(conversationId),
      child: Scaffold(appBar: _ChatRoomAppBar(), body: const ChatRoomSection()),
    );
  }
}

class _ChatRoomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatRoomCubit, ChatRoomState>(
      builder: (context, state) {
        if (state is ChatRoomLoaded) {
          final isInitiator =
              state.conversation.initiatorId == UserSession.userId;
          final name = isInitiator
              ? state.conversation.recipientName
              : state.conversation.initiatorName;
          final avatarUrl = isInitiator
              ? state.conversation.recipientProfilePictureUrl
              : state.conversation.initiatorProfilePictureUrl;

          return AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            scrolledUnderElevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            titleSpacing: 0,
            title: Row(
              children: [
                ChatAvatarWidget(
                  name: name,
                  imageUrl: avatarUrl,
                  radius: 18,
                  isOnline: state.isOtherUserOnline,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppStyles.s16SemiBold),
                    if (state.isOtherUserTyping)
                      Text(
                        'يكتب...',
                        style: AppStyles.s12Medium.withColor(AppColors.primary),
                      )
                    else if (state.isOtherUserOnline)
                      Text('متصل', style: AppStyles.s12Medium.withColor(AppColors.primary)),
                  ],
                ),
              ],
            ),
          );
        }
        return AppBar(backgroundColor: Colors.white, elevation: 0.5);
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ChatRoomSection extends StatefulWidget {
  const ChatRoomSection({Key? key}) : super(key: key);

  @override
  State<ChatRoomSection> createState() => _ChatRoomSectionState();
}

class _ChatRoomSectionState extends State<ChatRoomSection> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<ChatRoomCubit, ChatRoomState>(
            builder: (context, state) {
              if (state is ChatRoomLoading) {
                return  Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              } else if (state is ChatRoomError) {
                return Center(
                  child: Text(
                    state.message,
                    style: AppStyles.s16SemiBold,
                  ),
                );
              } else if (state is ChatRoomLoaded) {
                return ListView.builder(
                  reverse: true, // Show newest messages at bottom (0th index)
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    return ChatMessageWidget(message: message);
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        _buildMessageInput(context),
      ],
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.grey200.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'اكتب رسالة...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (text) {
                    if (text.isNotEmpty) {
                      context.read<ChatRoomCubit>().onTyping();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                final content = _messageController.text.trim();
                if (content.isNotEmpty) {
                  context.read<ChatRoomCubit>().sendMessage(content);
                  _messageController.clear();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration:  BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
