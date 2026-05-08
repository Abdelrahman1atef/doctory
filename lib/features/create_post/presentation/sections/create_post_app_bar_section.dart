import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/community/presentation/widgets/community_app_bar.dart';
import 'package:doctory/features/create_post/cubit/create_post_cubit.dart';
import 'package:doctory/features/create_post/cubit/create_post_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreatePostAppBarSection extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController contentController;

  const CreatePostAppBarSection({super.key, required this.contentController});

  @override
  Widget build(BuildContext context) {
    return CommunityAppBar(
      title: 'create_post'.tr(),
      actions: [
        BlocConsumer<CreatePostCubit, CreatePostStates>(
          listener: (context, state) {
            if (state is CreatePostSuccessState) {
              context.pop(true);
            } else if (state is CreatePostErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is CreatePostLoadingState;
            return TextButton(
              onPressed: isLoading
                  ? null
                  : () {
                      final text = contentController.text.trim();
                      context.read<CreatePostCubit>().submitPost(text);
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
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
