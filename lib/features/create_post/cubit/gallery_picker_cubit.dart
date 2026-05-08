import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import 'gallery_picker_states.dart';

class GalleryPickerCubit extends Cubit<GalleryPickerStates> {
  GalleryPickerCubit() : super(GalleryPickerInitialState());

  final List<AssetEntity> _assets = [];
  final List<AssetEntity> _selectedAssets = [];
  int _currentPage = 0;
  final int _pageSize = 60;
  bool _hasMore = true;
  AssetPathEntity? _recentAlbum;

  void loadGallery() async {
    emit(GalleryPickerLoadingState());

    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      _fetchAssets();
    } else {
      PhotoManager.openSetting();
      emit(GalleryPickerPermissionDeniedState());
    }
  }

  Future<void> _fetchAssets() async {
    if (!_hasMore) return;

    if (_recentAlbum == null) {
      final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
        type: RequestType.common, // Images and Videos
        hasAll: true,
      );

      if (paths.isEmpty) {
        _hasMore = false;
        _emitLoadedState();
        return;
      }

      _recentAlbum = paths.first; // Usually "Recent" or "All"
    }

    final List<AssetEntity> newAssets = await _recentAlbum!.getAssetListPaged(
      page: _currentPage,
      size: _pageSize,
    );

    if (newAssets.isEmpty) {
      _hasMore = false;
    } else {
      _assets.addAll(newAssets);
      _currentPage++;
    }

    _emitLoadedState();
  }

  void loadMore() {
    if (_hasMore && state is GalleryPickerLoadedState) {
      _fetchAssets();
    }
  }

  void toggleSelection(AssetEntity asset) {
    if (_selectedAssets.contains(asset)) {
      _selectedAssets.remove(asset);
    } else {
      // Max 10 items? Or unlimited? Let's cap it at 10 to avoid huge memory spikes
      if (_selectedAssets.length < 10) {
        _selectedAssets.add(asset);
      }
    }
    _emitLoadedState();
  }

  void _emitLoadedState() {
    emit(GalleryPickerLoadedState(
      assets: List.from(_assets),
      selectedAssets: List.from(_selectedAssets),
      hasMore: _hasMore,
    ));
  }
}
