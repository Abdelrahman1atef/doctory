import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/create_post/cubit/create_post_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaPickerBar extends StatelessWidget {
  const MediaPickerBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.grey100)),
      ),
      child: Row(
        children: [
          Text(
            'add_to_post'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.image, color: Colors.green),
            onPressed: () async {
              final result = await context.push<List<AssetEntity>>('${AppRoutes.createPost}/galleryPicker');
              if (result != null && result.isNotEmpty && context.mounted) {
                context.read<CreatePostCubit>().addGalleryMedia(result);
              }
            },
            tooltip: 'photo'.tr(),
          ),
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.blue),
            onPressed: () async {
              final result = await context.push<List<AssetEntity>>('${AppRoutes.createPost}/galleryPicker');
              if (result != null && result.isNotEmpty && context.mounted) {
                context.read<CreatePostCubit>().addGalleryMedia(result);
              }
            },
            tooltip: 'video'.tr(),
          ),
          IconButton(
            icon: const Icon(Icons.attach_file, color: Colors.orange),
            onPressed: () => context.read<CreatePostCubit>().pickFile(),
            tooltip: 'file'.tr(),
          ),
        ],
      ),
    );
  }
}
