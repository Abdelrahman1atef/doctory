import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/locator/service_locator.dart';
import '../../../../core/session/user_session.dart';
import '../../../../core/common/widgets/layout/custom_appbar.dart';
import '../../../../core/common/widgets/layout/abher_empty_state.dart';
import '../../cubit/conversations_list/conversations_list_cubit.dart';
import '../../cubit/conversations_list/conversations_list_states.dart';
import '../widgets/conversation_item_widget.dart';
import '../../router/chat_router_names.dart';

class ConversationsListView extends StatelessWidget {
  const ConversationsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: ConversationsListBodySection()),
      floatingActionButton: _NewChatFAB(),
    );
  }
}

class ConversationsListBodySection extends StatelessWidget {
  const ConversationsListBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        CustomAppBar(title: 'الرسائل'),
        Expanded(child: ConversationsListSection()),
      ],
    );
  }
}

class _NewChatFAB extends StatelessWidget {
  const _NewChatFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.pushNamed(ChatRouterNames.newChat);
      },
      backgroundColor: AppColors.primary,
      child: const Icon(Icons.message, color: Colors.white),
    );
  }
}

class ConversationsListSection extends StatelessWidget {
  const ConversationsListSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationsListCubit, ConversationsListState>(
      builder: (context, state) {
        if (state is ConversationsListLoading) {
          return Center(child: CircularProgressIndicator(color: AppColors.primary));
        } else if (state is ConversationsListError) {
          return Center(child: Text(state.message, style: AppStyles.s16SemiBold));
        } else if (state is ConversationsListLoaded) {
          if (state.conversations.isEmpty) {
            return const AbherEmptyState(
              title: 'لا توجد محادثات',
              subtitle: 'ابدأ محادثة جديدة الآن',
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<ConversationsListCubit>().loadConversations(refresh: true);
            },
            color: AppColors.primary,
            child: ListView.separated(
              itemCount: state.conversations.length,
              separatorBuilder: (context, index) => const Divider(height: 1, indent: 80),
              itemBuilder: (context, index) {
                final conversation = state.conversations[index];

                // Determine other user id for online status
                final isInitiator = conversation.initiatorId == UserSession.userId;
                final otherUserId = isInitiator
                    ? conversation.recipientId
                    : conversation.initiatorId;

                final isOnline = state.onlineUserIds.contains(otherUserId);
                final isTyping = state.typingUserIds.contains(conversation.id);

                return ConversationItemWidget(
                  conversation: conversation,
                  isOnline: isOnline,
                  isTyping: isTyping,
                  onDelete: () {
                    context.read<ConversationsListCubit>().deleteConversation(conversation.id);
                  },
                  onTap: () {
                    context.pushNamed(
                      ChatRouterNames.chatRoom,
                      pathParameters: {'id': conversation.id},
                    );
                  },
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
