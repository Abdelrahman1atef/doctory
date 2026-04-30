import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/map_home/presentation/widgets/map_clinic_card_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:doctory/features/map_home/cubit/map_home_cubit.dart';
import 'package:doctory/features/map_home/cubit/map_home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NearbyClinicsSheet extends StatefulWidget {
  final List<ClinicModel> clinics;

  const NearbyClinicsSheet({super.key, required this.clinics});

  @override
  State<NearbyClinicsSheet> createState() => _NearbyClinicsSheetState();
}

class _NearbyClinicsSheetState extends State<NearbyClinicsSheet> {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<MapHomeCubit, MapHomeStates>(
      listenWhen: (previous, current) {
        if (previous is MapHomeLoadedState && current is MapHomeLoadedState) {
          return previous.selectedClinic?.id != current.selectedClinic?.id;
        }
        return current is MapHomeLoadedState;
      },
      listener: (context, state) {
        if (state is MapHomeLoadedState && state.selectedClinic != null) {
          // If sheet is expanded, collapse it to initial size to show map
          if (_sheetController.size > 0.35) {
            _sheetController.animateTo(
              0.35,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        }
      },
      child: DraggableScrollableSheet(
        controller: _sheetController,
        initialChildSize: 0.35,
        minChildSize: 0.15,
        maxChildSize: 0.85,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.stitchSurface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 16),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.stitchSurfaceLow,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        'nearby_clinics'.tr(),
                        style: AppStyles.s18Bold.withColor(
                          AppColors.stitchPrimaryContainer,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${widget.clinics.length} ${'results'.tr()}',
                        style: AppStyles.s14Medium.withColor(
                          AppColors.stitchSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                16.ph,
                // List
                Expanded(
                  child: BlocBuilder<MapHomeCubit, MapHomeStates>(
                    builder: (context, state) {
                      final selectedClinicId = (state is MapHomeLoadedState)
                          ? state.selectedClinic?.id
                          : null;

                      return ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: widget.clinics.length,
                        itemBuilder: (context, index) {
                          final clinic = widget.clinics[index];
                          final isSelected = clinic.id == selectedClinicId;

                          return MapClinicCardWidget(
                            clinic: clinic,
                            isSelected: isSelected,
                            onTap: () {
                              if (isSelected) {
                                context.push(AppRoutes.clinicDetails,
                                    extra: clinic);
                              } else {
                                context
                                    .read<MapHomeCubit>()
                                    .selectClinic(clinic);
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
