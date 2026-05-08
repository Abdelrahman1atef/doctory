import 'dart:io';
import 'package:doctory/core/services/media/media_compression_service.dart';
import 'package:doctory/features/create_post/cubit/create_post_states.dart';
import 'package:doctory/features/create_post/data/model/selected_media_model.dart';
import 'package:doctory/features/create_post/data/repo/create_post_repo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:photo_manager/photo_manager.dart';

class CreatePostCubit extends Cubit<CreatePostStates> {
  final CreatePostRepo _repo;

  CreatePostCubit(this._repo) : super(CreatePostInitialState());

  List<SelectedMediaModel> selectedMedia = [];
  final ImagePicker _picker = ImagePicker();

  // ─────────────────── Picking ───────────────────

  void pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      emit(CreatePostLoadingState(message: 'compressing_media'.tr()));

      for (var image in images) {
        final original = File(image.path);
        final compressed = await MediaCompressionService.compressImage(original);

        final error = await MediaCompressionService.validateImageSize(compressed);
        if (error != null) {
          emit(CreatePostErrorState(error));
          return;
        }

        selectedMedia.add(SelectedMediaModel(
          file: compressed,
          type: MediaType.image,
        ));
      }
      emit(CreatePostMediaUpdatedState());
    }
  }

  void pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      emit(CreatePostLoadingState(message: 'compressing_media'.tr()));

      final original = File(video.path);
      final compressed = await MediaCompressionService.compressVideo(original);

      final error = await MediaCompressionService.validateVideoSize(compressed);
      if (error != null) {
        emit(CreatePostErrorState(error));
        return;
      }

      selectedMedia.add(SelectedMediaModel(
        file: compressed,
        type: MediaType.video,
      ));
      emit(CreatePostMediaUpdatedState());
    }
  }

  void pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      selectedMedia.add(SelectedMediaModel(
        file: File(result.files.single.path!),
        type: MediaType.file,
      ));
      emit(CreatePostMediaUpdatedState());
    }
  }

  void addGalleryMedia(List<AssetEntity> assets) async {
    emit(CreatePostLoadingState(message: 'compressing_media'.tr()));

    for (var asset in assets) {
      final file = await asset.file;
      if (file != null) {
        if (asset.type == AssetType.image) {
          final compressed = await MediaCompressionService.compressImage(file);
          final error = await MediaCompressionService.validateImageSize(compressed);
          if (error != null) {
            emit(CreatePostErrorState(error));
            return;
          }
          selectedMedia.add(SelectedMediaModel(
            file: compressed,
            type: MediaType.image,
          ));
        } else if (asset.type == AssetType.video) {
          final compressed = await MediaCompressionService.compressVideo(file);
          final error = await MediaCompressionService.validateVideoSize(compressed);
          if (error != null) {
            emit(CreatePostErrorState(error));
            return;
          }
          selectedMedia.add(SelectedMediaModel(
            file: compressed,
            type: MediaType.video,
          ));
        }
      }
    }
    emit(CreatePostMediaUpdatedState());
  }

  // ─────────────────── Removing ───────────────────

  void removeMedia(int index) {
    if (index >= 0 && index < selectedMedia.length) {
      selectedMedia.removeAt(index);
      emit(CreatePostMediaUpdatedState());
    }
  }

  // ─────────────────── Submitting ───────────────────

  void submitPost(String content) async {
    if (content.trim().isEmpty && selectedMedia.isEmpty) return;

    emit(CreatePostLoadingState(message: 'uploading_media'.tr()));

    final result = await _repo.createPostWithMedia(
      content: content,
      media: selectedMedia,
    );

    result.fold(
      onSuccess: (id) {
        emit(CreatePostSuccessState('post_created_successfully'.tr()));
      },
      onFailure: (failure) {
        emit(CreatePostErrorState(failure.message));
      },
    );
  }

  @override
  Future<void> close() {
    // Cancel any ongoing video compression when the cubit is disposed
    MediaCompressionService.cancelVideoCompression();
    return super.close();
  }
}
