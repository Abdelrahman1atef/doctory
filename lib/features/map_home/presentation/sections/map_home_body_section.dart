import 'package:doctory/core/common/models/shared_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/map_home_cubit.dart';
import '../../cubit/map_home_states.dart';
import '../widgets/map_home_body_widget.dart';
import '../widgets/map_home_empty_widget.dart';
import '../widgets/map_home_error_widget.dart';
import '../widgets/map_home_loading_widget.dart';
import '../widgets/map_home_location_banner_widget.dart';
import 'map_search_section.dart';
import 'map_section.dart';
import 'nearby_clinics_sheet.dart';

class MapHomeBodySection extends StatefulWidget {
  const MapHomeBodySection({super.key});

  @override
  State<MapHomeBodySection> createState() => _MapHomeBodySectionState();
}

class _MapHomeBodySectionState extends State<MapHomeBodySection> {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  final ValueNotifier<double> _sheetSizeNotifier = ValueNotifier<double>(0.35);

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(_onSheetChanged);
  }

  void _onSheetChanged() {
    if (_sheetController.isAttached) {
      _sheetSizeNotifier.value = _sheetController.size;
    }
  }

  @override
  void dispose() {
    _sheetController.removeListener(_onSheetChanged);
    _sheetController.dispose();
    _sheetSizeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapHomeCubit, MapHomeStates>(
      buildWhen: (prev, curr) {
        if (prev.runtimeType != curr.runtimeType) return true;
        if (prev is MapHomeLoadedState && curr is MapHomeLoadedState) {
          return prev.clinics != curr.clinics ||
              prev.selectedClinic?.id != curr.selectedClinic?.id ||
              prev.isNavigating != curr.isNavigating;
        }
        return true;
      },
      builder: (context, state) {
        final isLoaded = state is MapHomeLoadedState;
        final clinics = isLoaded ? state.clinics : <ClinicModel>[];
        final selectedClinicId = isLoaded ? state.selectedClinic?.id : null;
        final isNavigating = isLoaded && state.isNavigating;
        final isLoading = state is MapHomeLoadingState;
        final isError = state is MapHomeErrorState;
        final isEmpty =
            isLoaded && clinics.isEmpty && !isLoading;

        Widget? errorOverlay;
        if (isError) {
          errorOverlay = MapHomeErrorWidget(
            message: state.message,
            onRetry: () => context.read<MapHomeCubit>().searchClinics(),
          );
        }

        Widget? emptyOverlay;
        if (isEmpty && !isError && !isLoading) {
          emptyOverlay = const MapHomeEmptyWidget();
        }

        Widget? locationBanner;
        if (isLoaded && !state.isLocationAvailable) {
          locationBanner = MapHomeLocationBannerWidget(
            onEnableTap: () => context.read<MapHomeCubit>().requestLocationPermission(),
          );
        }

        if ((clinics.isEmpty || isNavigating) &&
            _sheetSizeNotifier.value != 0.0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _sheetSizeNotifier.value = 0.0;
          });
        } else if (clinics.isNotEmpty &&
            !isNavigating &&
            _sheetSizeNotifier.value == 0.0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _sheetSizeNotifier.value = 0.35;
          });
        }

        return MapHomeBodyWidget(
          mapSection: MapSection(
            clinics: clinics,
            selectedClinicId: selectedClinicId,
            sheetSizeNotifier: _sheetSizeNotifier,
          ),
          searchSection: isNavigating
              ? const SizedBox.shrink()
              : const MapSearchSection(),
          bottomSheetSection: (clinics.isNotEmpty && !isNavigating)
              ? NearbyClinicsSheet(
                  clinics: clinics,
                  sheetController: _sheetController,
                )
              : null,
          loadingOverlay: isLoading
              ? MapHomeLoadingWidget(
                  onCancel: () =>
                      context.read<MapHomeCubit>().cancelSearch(),
                )
              : null,
          errorOverlay: errorOverlay,
          emptyOverlay: emptyOverlay,
          locationBanner: locationBanner,
        );
      },
    );
  }
}
