import 'dart:io';
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
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _messageController.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _handleSend(BuildContext context) {
    final content = _messageController.text.trim();
    context.read<ChatRoomCubit>().sendMessage(content);
    _messageController.clear();
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
                  reverse: true,
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
        // Media Preview
        BlocBuilder<ChatRoomCubit, ChatRoomState>(
          buildWhen: (prev, curr) {
            if (prev is ChatRoomLoaded && curr is ChatRoomLoaded) {
              return prev.selectedFilePath != curr.selectedFilePath ||
                  prev.isUploadingMedia != curr.isUploadingMedia ||
                  prev.uploadedFileName != curr.uploadedFileName;
            }
            return true;
          },
          builder: (context, state) {
            if (state is ChatRoomLoaded && state.selectedFilePath != null) {
              return _buildMediaPreview(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
        // Reply Preview
        BlocBuilder<ChatRoomCubit, ChatRoomState>(
          buildWhen: (prev, curr) {
            if (prev is ChatRoomLoaded && curr is ChatRoomLoaded) {
              return prev.replyingToMessage != curr.replyingToMessage;
            }
            return true;
          },
          builder: (context, state) {
            if (state is ChatRoomLoaded && state.replyingToMessage != null) {
              return _buildReplyPreview(context, state.replyingToMessage!);
            }
            return const SizedBox.shrink();
          },
        ),
        // Message Input
        _buildMessageInput(context),
      ],
    );
  }

  Widget _buildMediaPreview(BuildContext context, ChatRoomLoaded state) {
    final isImage = state.uploadedMediaType == 0;
    final filePath = state.selectedFilePath!;
    final fileName = filePath.split('/').last.split('\\').last;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.grey200, width: 0.5)),
      ),
      child: Row(
        children: [
          // Thumbnail or file icon
          if (isImage)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(filePath),
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.grey200.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.broken_image, color: AppColors.grey600),
                ),
              ),
            )
          else
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_getMediaIcon(state.uploadedMediaType), color: AppColors.primary, size: 24),
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      fileName,
                      style: AppStyles.s10Medium.withColor(AppColors.grey600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(width: 12),
          // Upload status
          Expanded(
            child: state.isUploadingMedia
                ? Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('جاري الرفع...', style: AppStyles.s12Medium.withColor(AppColors.grey600)),
                    ],
                  )
                : Text(
                    state.uploadedFileName != null ? 'جاهز للإرسال' : fileName,
                    style: AppStyles.s12Medium.withColor(AppColors.grey600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
          // Remove button
          IconButton(
            onPressed: () => context.read<ChatRoomCubit>().clearMedia(),
            icon: const Icon(Icons.close, size: 20),
            splashRadius: 20,
          ),
        ],
      ),
    );
  }

  IconData _getMediaIcon(int? mediaType) {
    switch (mediaType) {
      case 0:
        return Icons.image;
      case 1:
        return Icons.videocam;
      case 2:
        return Icons.audiotrack;
      case 3:
        return Icons.insert_drive_file;
      default:
        return Icons.attach_file;
    }
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
    return BlocBuilder<ChatRoomCubit, ChatRoomState>(
      buildWhen: (prev, curr) {
        if (prev is ChatRoomLoaded && curr is ChatRoomLoaded) {
          return prev.uploadedFileName != curr.uploadedFileName ||
              prev.isUploadingMedia != curr.isUploadingMedia;
        }
        return true;
      },
      builder: (context, state) {
        final hasMedia = state is ChatRoomLoaded && state.uploadedFileName != null;
        final isUploading = state is ChatRoomLoaded && state.isUploadingMedia;
        final showSend = _hasText || hasMedia;

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
                  onTap: (showSend && !isUploading)
                      ? () => _handleSend(context)
                      : null,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: showSend ? AppColors.primary : AppColors.grey200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      showSend ? Icons.send : Icons.mic,
                      color: showSend ? Colors.white : AppColors.grey600,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
                cubit.pickMedia(isVideo: false);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('صورة من الكاميرا'),
              onTap: () {
                Navigator.pop(ctx);
                cubit.pickMedia(isVideo: false, fromCamera: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('فيديو من المعرض'),
              onTap: () {
                Navigator.pop(ctx);
                cubit.pickMedia(isVideo: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_call),
              title: const Text('فيديو من الكاميرا'),
              onTap: () {
                Navigator.pop(ctx);
                cubit.pickMedia(isVideo: true, fromCamera: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: const Text('ملف'),
              onTap: () {
                Navigator.pop(ctx);
                cubit.pickFile();
              },
            ),
          ],
        ),
      ),
    );
  }
}
