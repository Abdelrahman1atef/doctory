import 'dart:ui';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/map_home/presentation/widgets/map_filter_chip_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:doctory/features/map_home/cubit/map_home_cubit.dart';
import 'package:doctory/features/map_home/cubit/map_home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapSearchSection extends StatefulWidget {
  const MapSearchSection({super.key});

  @override
  State<MapSearchSection> createState() => _MapSearchSectionState();
}

class _MapSearchSectionState extends State<MapSearchSection> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.paddingOf(context).top + 16,
      left: 16,
      right: 16,
      child: BlocConsumer<MapHomeCubit, MapHomeStates>(
        listener: (context, state) {
          if (state is MapHomeLoaded && state.query != _searchController.text) {
            _searchController.text = state.query ?? '';
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Glassmorphic Search Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4, // Reduced vertical padding for TextField
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.stitchSurfaceLowest.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.stitchSurfaceLowest.withValues(alpha: 0.5),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: AppColors.stitchSecondary),
                        12.pw,
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onSubmitted: (value) {
                              context.read<MapHomeCubit>().fetchNearbyClinics(query: value);
                            },
                            style: AppStyles.s14Medium.withColor(
                              AppColors.stitchSecondary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'search'.tr(),
                              hintStyle: AppStyles.s14Medium.withColor(
                                AppColors.stitchSecondary.withValues(alpha: 0.6),
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.tune,
                          color: AppColors.stitchPrimaryContainer,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              16.ph,
              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    MapFilterChipWidget(
                      label: 'All',
                      isSelected: state is MapHomeLoaded && (state.query == null || state.query!.isEmpty),
                      onTap: () {
                        context.read<MapHomeCubit>().fetchNearbyClinics();
                      },
                    ),
                    MapFilterChipWidget(
                      label: 'Dental',
                      isSelected: state is MapHomeLoaded && state.query == 'Dental',
                      onTap: () {
                        context.read<MapHomeCubit>().fetchNearbyClinics(query: 'Dental');
                      },
                    ),
                    MapFilterChipWidget(
                      label: 'Cardiology',
                      isSelected: state is MapHomeLoaded && state.query == 'Cardiology',
                      onTap: () {
                        context.read<MapHomeCubit>().fetchNearbyClinics(query: 'Cardiology');
                      },
                    ),
                    MapFilterChipWidget(
                      label: 'Eye Care',
                      isSelected: state is MapHomeLoaded && state.query == 'Eye Care',
                      onTap: () {
                        context.read<MapHomeCubit>().fetchNearbyClinics(query: 'Eye Care');
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
