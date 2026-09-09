import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/common/widgets/layout/custom_appbar.dart';
import '../../cubit/new_chat/new_chat_cubit.dart';
import '../../cubit/new_chat/new_chat_states.dart';
import '../widgets/chat_avatar_widget.dart';
import '../../router/chat_router_names.dart';

class NewChatView extends StatelessWidget {
  const NewChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: NewChatBodySection(),
      ),
    );
  }
}

class NewChatBodySection extends StatelessWidget {
  const NewChatBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CustomAppBar(title: 'محادثة جديدة'),
        Expanded(
          child: NewChatSection(),
        ),
      ],
    );
  }
}

class NewChatSection extends StatefulWidget {
  const NewChatSection({super.key});

  @override
  State<NewChatSection> createState() => _NewChatSectionState();
}

class _NewChatSectionState extends State<NewChatSection> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'ابحث عن مستخدمين...',
              prefixIcon: const Icon(Icons.search, color: AppColors.grey600),
              filled: true,
              fillColor: AppColors.grey200.withValues(alpha: 0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              context.read<NewChatCubit>().searchUsers(value);
            },
          ),
        ),
        Expanded(
          child: BlocConsumer<NewChatCubit, NewChatState>(
            listener: (context, state) {
              if (state is NewChatCreated) {
                // Navigate to ChatRoom and pop NewChat
                context.pushReplacementNamed(
                  ChatRouterNames.chatRoom,
                  pathParameters: {'id': state.conversationId},
                );
              } else if (state is NewChatCreateError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              if (state is NewChatSearchLoading || state is NewChatCreating) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              } else if (state is NewChatSearchError) {
                return Center(
                  child: Text(state.message, style: AppStyles.s16SemiBold),
                );
              } else if (state is NewChatSearchLoaded) {
                if (state.users.isEmpty) {
                  return const Center(child: Text('لا يوجد مستخدمين'));
                }
                return ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    final user = state.users[index];
                    final userId = user['id']?.toString() ?? '';
                    final name = user['fullName'] ?? user['name'] ?? 'مستخدم';
                    final profilePicture =
                        user['profilePictureUrl'] ?? user['imageUrl'];

                    return ListTile(
                      leading: ChatAvatarWidget(
                        name: name,
                        imageUrl: profilePicture,
                        radius: 20,
                      ),
                      title: Text(name, style: AppStyles.s14SemiBold),
                      onTap: () {
                        context.read<NewChatCubit>().createConversation(userId);
                      },
                    );
                  },
                );
              }
              return const Center(child: Text('ابحث لبدء محادثة'));
            },
          ),
        ),
      ],
    );
  }
}
