import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/community/cubit/community_cubit.dart';
import 'package:doctory/features/community/cubit/community_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CommunityCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('create_post'.tr()),
          actions: [
            BlocConsumer<CommunityCubit, CommunityStates>(
              listener: (context, state) {
                if (state is CommunityCreatePostSuccessState) {
                  context.pop(true);
                } else if (state is CommunityCreatePostErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is CommunityActionLoadingState;
                return TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          final text = _contentController.text.trim();
                          if (text.isNotEmpty) {
                            context.read<CommunityCubit>().createPost(text);
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          'post_action'.tr(),
                          style: const TextStyle(
                            color: AppColors.stitchPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                );
              },
            ),
            16.pw,
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.grey100,
                    child: const Icon(Icons.person, color: Colors.grey),
                  ),
                  12.pw,
                  Text(
                    'user'.tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              16.ph,
              Expanded(
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'post_content_hint'.tr(),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
