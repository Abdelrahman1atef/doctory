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

class MapHomeBodySection extends StatelessWidget {
  const MapHomeBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapHomeCubit, MapHomeStates>(
      builder: (context, state) {
        final List<ClinicModel> clinics =
            (state is MapHomeLoadedState) ? state.clinics : [];
        final String? selectedClinicId =
            (state is MapHomeLoadedState) ? state.selectedClinic?.id : null;
        final bool isLoading = state is MapHomeLoadingState;

        Widget? errorOverlay;
        if (state is MapHomeErrorState) {
          errorOverlay = MapHomeErrorWidget(message: state.message);
        }

        return MapHomeBodyWidget(
          mapSection: MapSection(
            clinics: clinics,
            selectedClinicId: selectedClinicId,
          ),
          searchSection: const MapSearchSection(),
          loadingOverlay: isLoading ? const MapHomeLoadingWidget() : null,
          errorOverlay: errorOverlay,
        );
      },
    );
  }
}
