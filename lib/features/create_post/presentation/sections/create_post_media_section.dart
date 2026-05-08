import 'package:doctory/features/create_post/cubit/create_post_cubit.dart';
import 'package:doctory/features/create_post/cubit/create_post_states.dart';
import 'package:doctory/features/create_post/data/model/selected_media_model.dart';
import 'package:doctory/features/create_post/presentation/widgets/media_preview_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePostMediaSection extends StatelessWidget {
  const CreatePostMediaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePostCubit, CreatePostStates>(
      buildWhen: (previous, current) => current is CreatePostMediaUpdatedState || current is CreatePostInitialState,
      builder: (context, state) {
        final cubit = context.read<CreatePostCubit>();
        if (cubit.selectedMedia.isEmpty) {
          return const SizedBox.shrink();
        }

        final mediaToShow = cubit.selectedMedia.take(4).toList();
        final hasMore = cubit.selectedMedia.length > 4;

        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _buildGrid(cubit, mediaToShow, hasMore),
        );
      },
    );
  }

  Widget _buildGrid(CreatePostCubit cubit, List<SelectedMediaModel> media, bool hasMore) {
    if (media.length == 1) {
      return _buildImage(cubit, media[0], 0, double.infinity, 400);
    } else if (media.length == 2) {
      return SizedBox(
        height: 400,
        child: Row(
          children: [
            Expanded(child: _buildImage(cubit, media[0], 0, double.infinity, double.infinity)),
            const SizedBox(width: 4),
            Expanded(child: _buildImage(cubit, media[1], 1, double.infinity, double.infinity)),
          ],
        ),
      );
    } else if (media.length == 3) {
      return SizedBox(
        height: 400,
        child: Row(
          children: [
            Expanded(flex: 1, child: _buildImage(cubit, media[0], 0, double.infinity, double.infinity)),
            const SizedBox(width: 4),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(child: _buildImage(cubit, media[1], 1, double.infinity, double.infinity)),
                  const SizedBox(height: 4),
                  Expanded(child: _buildImage(cubit, media[2], 2, double.infinity, double.infinity)),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 400,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildImage(cubit, media[0], 0, double.infinity, double.infinity)),
                  const SizedBox(width: 4),
                  Expanded(child: _buildImage(cubit, media[1], 1, double.infinity, double.infinity)),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _buildImage(cubit, media[2], 2, double.infinity, double.infinity)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: _buildImage(
                      cubit,
                      media[3],
                      3,
                      double.infinity,
                      double.infinity,
                      overlayText: hasMore ? '+${cubit.selectedMedia.length - 4}' : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildImage(
    CreatePostCubit cubit,
    SelectedMediaModel media,
    int index,
    double width,
    double height, {
    String? overlayText,
  }) {
    return MediaPreviewItem(
      media: media,
      onRemove: () => cubit.removeMedia(index),
      width: width,
      height: height,
      overlayText: overlayText,
    );
  }
}
