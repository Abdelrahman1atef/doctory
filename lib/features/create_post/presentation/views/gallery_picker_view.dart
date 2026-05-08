import 'package:doctory/core/common/widgets/buttons/custom_button.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/create_post/cubit/gallery_picker_cubit.dart';
import 'package:doctory/features/create_post/cubit/gallery_picker_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';

class GalleryPickerView extends StatefulWidget {
  const GalleryPickerView({super.key});

  @override
  State<GalleryPickerView> createState() => _GalleryPickerViewState();
}

class _GalleryPickerViewState extends State<GalleryPickerView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<GalleryPickerCubit>().loadGallery();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<GalleryPickerCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'gallery'.tr(),
          style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          BlocBuilder<GalleryPickerCubit, GalleryPickerStates>(
            builder: (context, state) {
              if (state is GalleryPickerLoadedState && state.selectedAssets.isNotEmpty) {
                return TextButton(
                  onPressed: () {
                    context.pop(state.selectedAssets);
                  },
                  child: Text(
                    'done'.tr(),
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          )
        ],
      ),
      body: BlocBuilder<GalleryPickerCubit, GalleryPickerStates>(
        builder: (context, state) {
          if (state is GalleryPickerLoadingState || state is GalleryPickerInitialState) {
            return Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is GalleryPickerPermissionDeniedState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.photo_library, size: 60, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'gallery_permission_denied'.tr(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'open_settings'.tr(),
                      onPressed: () => PhotoManager.openSetting(),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is GalleryPickerLoadedState) {
            if (state.assets.isEmpty) {
              return Center(child: Text('no_media_found'.tr()));
            }

            return GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: state.assets.length + (state.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.assets.length) {
                  return Center(child: CircularProgressIndicator(color: AppColors.primary));
                }

                final asset = state.assets[index];
                final isSelected = state.selectedAssets.contains(asset);
                final selectedIndex = state.selectedAssets.indexOf(asset);

                return GestureDetector(
                  onTap: () => context.read<GalleryPickerCubit>().toggleSelection(asset),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      FutureBuilder<Uint8List?>(
                        future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Container(color: AppColors.grey100);
                          }
                          if (snapshot.hasData) {
                            return Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            );
                          }
                          return Container(color: AppColors.grey100);
                        },
                      ),
                      if (asset.type == AssetType.video)
                        const Positioned(
                          bottom: 4,
                          right: 4,
                          child: Icon(Icons.videocam, color: Colors.white, size: 20),
                        ),
                      if (isSelected)
                        Container(
                          color: Colors.black.withValues(alpha: 0.4),
                          alignment: Alignment.topRight,
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${selectedIndex + 1}',
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      if (!isSelected)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
