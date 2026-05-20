import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/locator/service_locator.dart';
import '../../cubit/chat_room/chat_room_cubit.dart';
import '../../cubit/chat_room/chat_room_states.dart';
import '../../data/model/message_model.dart';
import '../widgets/chat_message_widget.dart';
import '../widgets/chat_avatar_widget.dart';
import '../../../../core/session/user_session.dart';

class ChatRoomView extends StatelessWidget {
  final String conversationId;

  const ChatRoomView({Key? key, required this.conversationId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: ChatRoomBodySection(),
      ),
    );
  }
}

class ChatRoomBodySection extends StatelessWidget {
  const ChatRoomBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        ChatRoomAppBarSection(),
        Expanded(
          child: ChatRoomSection(),
        ),
      ],
    );
  }
}

class ChatRoomAppBarSection extends StatelessWidget {
  const ChatRoomAppBarSection({super.key});

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

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: AppColors.grey200, width: 0.5)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ChatAvatarWidget(
                  name: name,
                  imageUrl: avatarUrl,
                  radius: 18,
                  isOnline: state.isOtherUserOnline,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(name, style: AppStyles.s16SemiBold),
                      if (state.isOtherUserTyping)
                        Text(
                          'يكتب...',
                          style: AppStyles.s12Medium.withColor(AppColors.primary),
                        )
                      else if (state.isOtherUserOnline)
                        Text(
                          'متصل',
                          style: AppStyles.s12Medium.withColor(AppColors.primary),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return Container(
          height: kToolbarHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: AppColors.grey200, width: 0.5)),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }
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
                return Center(
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
        BlocBuilder<ChatRoomCubit, ChatRoomState>(
          builder: (context, state) {
            if (state is ChatRoomLoaded && state.replyingToMessage != null) {
              return _buildReplyPreview(context, state.replyingToMessage!);
            }
            return const SizedBox.shrink();
          },
        ),
        _buildMessageInput(context),
      ],
    );
  }

  Widget _buildReplyPreview(BuildContext context, MessageModel message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.grey200)),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.grey200.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(color: AppColors.primary, width: 4)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                  message.senderId == UserSession.userId
                      ? 'أنت'
                      : message.senderName,
                  style: AppStyles.s12Medium.semiBold
                          .withColor(AppColors.primary),
                    ),
                    Text(
                      message.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.s12Medium.withColor(AppColors.grey600),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => context.read<ChatRoomCubit>().cancelReply(),
              icon: const Icon(Icons.close, size: 20),
            ),
          ],
        ),
      ),
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
            IconButton(
              onPressed: () => _showMediaOptions(context),
              icon: Icon(Icons.add_circle_outline, color: AppColors.primary),
            ),
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
                decoration: BoxDecoration(
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

  void _showMediaOptions(BuildContext context) {
    final cubit = context.read<ChatRoomCubit>();
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('صورة من المعرض'),
              onTap: () {
                Navigator.pop(ctx);
                cubit.pickAndSendMedia(isVideo: false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('صورة من الكاميرا'),
              onTap: () {
                Navigator.pop(ctx);
                cubit.pickAndSendMedia(isVideo: false, fromCamera: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('فيديو من المعرض'),
              onTap: () {
                Navigator.pop(ctx);
                cubit.pickAndSendMedia(isVideo: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_call),
              title: const Text('فيديو من الكاميرا'),
              onTap: () {
                Navigator.pop(ctx);
                cubit.pickAndSendMedia(isVideo: true, fromCamera: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: const Text('ملف'),
              onTap: () {
                Navigator.pop(ctx);
                cubit.pickAndSendFile();
              },
            ),
          ],
        ),
      ),
    );
  }
}
