import 'dart:io';
import 'package:doctory/core/services/media/media_compression_service.dart';
import 'package:doctory/features/create_post/cubit/create_post_states.dart';
import 'package:doctory/features/create_post/data/model/selected_media_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:photo_manager/photo_manager.dart';

import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/services/post_upload_service.dart';

class CreatePostCubit extends Cubit<CreatePostStates> {
  CreatePostCubit() : super(CreatePostInitialState());

  List<SelectedMediaModel> selectedMedia = [];
  final ImagePicker _picker = ImagePicker();

  // ─────────────────── Picking ───────────────────

  void pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      for (var image in images) {
        final original = File(image.path);
        final model = SelectedMediaModel(
          file: original,
          type: MediaType.image,
          isCompressing: true,
        );
        selectedMedia.add(model);
        emit(CreatePostMediaUpdatedState());

        _compressImageInBackground(original, model);
      }
    }
  }

  Future<void> _compressImageInBackground(
    File original,
    SelectedMediaModel model,
  ) async {
    try {
      final compressed = await MediaCompressionService.compressImage(original);
      final error = await MediaCompressionService.validateImageSize(compressed);
      if (error != null) {
        emit(CreatePostErrorState(error));
        selectedMedia.remove(model);
      } else {
        model.file = compressed;
        model.isCompressing = false;
      }
    } catch (e) {
      model.isCompressing = false;
    }
    emit(CreatePostMediaUpdatedState());
  }

  void pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      final original = File(video.path);
      final model = SelectedMediaModel(
        file: original,
        type: MediaType.video,
        isCompressing: true,
      );
      selectedMedia.add(model);
      emit(CreatePostMediaUpdatedState());

      _compressVideoInBackground(original, model);
    }
  }

  Future<void> _compressVideoInBackground(
    File original,
    SelectedMediaModel model,
  ) async {
    try {
      final compressed = await MediaCompressionService.compressVideo(original);
      final error = await MediaCompressionService.validateVideoSize(compressed);
      if (error != null) {
        emit(CreatePostErrorState(error));
        selectedMedia.remove(model);
      } else {
        model.file = compressed;
        model.isCompressing = false;
      }
    } catch (e) {
      model.isCompressing = false;
    }
    emit(CreatePostMediaUpdatedState());
  }

  void pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      selectedMedia.add(
        SelectedMediaModel(
          file: File(result.files.single.path!),
          type: MediaType.file,
        ),
      );
      emit(CreatePostMediaUpdatedState());
    }
  }

  void addGalleryMedia(List<AssetEntity> assets) async {
    for (var asset in assets) {
      final file = await asset.file;
      if (file != null) {
        if (asset.type == AssetType.image) {
          final model = SelectedMediaModel(
            file: file,
            type: MediaType.image,
            isCompressing: true,
          );
          selectedMedia.add(model);
          emit(CreatePostMediaUpdatedState());
          _compressImageInBackground(file, model);
        } else if (asset.type == AssetType.video) {
          final model = SelectedMediaModel(
            file: file,
            type: MediaType.video,
            isCompressing: true,
          );
          selectedMedia.add(model);
          emit(CreatePostMediaUpdatedState());
          _compressVideoInBackground(file, model);
        }
      }
    }
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

    sl<PostUploadService>().submitPost(
      content: content,
      media: List.from(selectedMedia),
    );
  }

  @override
  Future<void> close() {
    // Cancel any ongoing video compression when the cubit is disposed
    MediaCompressionService.cancelVideoCompression();
    return super.close();
  }
}
