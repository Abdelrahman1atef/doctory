import 'package:doctory/core/common/models/shared_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/map_home_cubit.dart';
import '../../cubit/map_home_states.dart';
import '../widgets/map_home_body_widget.dart';
import '../widgets/map_home_error_widget.dart';
import '../widgets/map_home_loading_widget.dart';
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
      // TODO(dev): remove this and use the real data from the cubit
      builder: (context, state) {
        final List<ClinicModel> clinics =
            (state is MapHomeLoadedState && state.clinics.isNotEmpty)
            ? state.clinics
            : [];
        final String? selectedClinicId = (state is MapHomeLoadedState)
            ? state.selectedClinic?.id
            : null;
        final bool isNavigating = (state is MapHomeLoadedState)
            ? state.isNavigating
            : false;
        final bool isLoading = state is MapHomeLoadingState;

        Widget? errorOverlay;
        if (state is MapHomeErrorState) {
          errorOverlay = MapHomeErrorWidget(message: state.message);
        }

        // Reset sheet size notifier if clinics are empty (sheet goes away)
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
        );
      },
    );
  }
}
