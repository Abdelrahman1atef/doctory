import 'package:photo_manager/photo_manager.dart';

abstract class GalleryPickerStates {}

class GalleryPickerInitialState extends GalleryPickerStates {}

class GalleryPickerLoadingState extends GalleryPickerStates {}

class GalleryPickerLoadedState extends GalleryPickerStates {
  final List<AssetEntity> assets;
  final List<AssetEntity> selectedAssets;
  final bool hasMore;

  GalleryPickerLoadedState({
    required this.assets,
    required this.selectedAssets,
    required this.hasMore,
  });
}

class GalleryPickerErrorState extends GalleryPickerStates {
  final String message;

  GalleryPickerErrorState(this.message);
}

class GalleryPickerPermissionDeniedState extends GalleryPickerStates {}
