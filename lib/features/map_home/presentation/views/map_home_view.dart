import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/features/map_home/cubit/map_home_cubit.dart';
import 'package:doctory/features/map_home/cubit/map_home_states.dart';
import 'package:doctory/features/map_home/presentation/sections/map_search_section.dart';
import 'package:doctory/features/map_home/presentation/sections/map_section.dart';
import 'package:doctory/features/map_home/presentation/sections/nearby_clinics_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapHomeView extends StatelessWidget {
  final String? searchQuery;
  const MapHomeView({super.key, this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MapHomeCubit>()..searchClinics(searchText: searchQuery),
      child: Scaffold(
        body: BlocBuilder<MapHomeCubit, MapHomeStates>(
          builder: (context, state) {
            final List<ClinicModel> clinics =
                (state is MapHomeLoadedState) ? state.clinics : [];
            final bool isLoading = state is MapHomeLoadingState;

            return Stack(
              children: [
                // Map remains in tree
                MapSection(clinics: clinics),

                const MapSearchSection(),

                if (state is MapHomeLoadedState)
                  NearbyClinicsSheet(clinics: state.clinics),

                if (isLoading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.1),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.stitchPrimaryContainer,
                      ),
                    ),
                  ),

                if (state is MapHomeErrorState)
                  Center(child: Text(state.message)),
              ],
            );
          },
        ),
      ),
    );
  }
}
