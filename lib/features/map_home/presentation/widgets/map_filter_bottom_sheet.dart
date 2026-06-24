import 'package:doctory/core/common/models/specialty_model.dart';
import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/map_home/presentation/widgets/pick_location_screen.dart';
import 'package:doctory/shared/cubit/specializations_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:doctory/features/map_home/cubit/map_home_cubit.dart';
import 'package:doctory/features/map_home/cubit/map_home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapFilterBottomSheet extends StatefulWidget {
  final MapHomeLoadedState initialState;

  const MapFilterBottomSheet({super.key, required this.initialState});

  @override
  State<MapFilterBottomSheet> createState() => _MapFilterBottomSheetState();
}

class _MapFilterBottomSheetState extends State<MapFilterBottomSheet> {
  late String? _selectedSpecializationId;
  late bool _isNearest;
  late double _radiusInKm;
  double? _customLat;
  double? _customLng;

  List<SpecialtyModel> _specialties = [];

  @override
  void initState() {
    super.initState();
    _selectedSpecializationId = widget.initialState.specializationId;
    _isNearest = widget.initialState.isNearest;
    _radiusInKm = widget.initialState.radiusInKm.toDouble();
    _customLat = widget.initialState.customLat;
    _customLng = widget.initialState.customLng;

    final specState = sl<SharedSpecializationsCubit>().state;
    if (specState is SharedSpecializationsLoaded) {
      _specialties = specState.specializations;
    }
  }

  bool get _hasCustomLocation => _customLat != null && _customLng != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.stitchSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'filter'.tr(),
                style: AppStyles.s20Bold.withColor(
                  AppColors.stitchPrimaryContainer,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          24.ph,

          // Specialization
          Text(
            'specialization'.tr(),
            style: AppStyles.s16Bold.withColor(AppColors.stitchSecondary),
          ),
          12.ph,
          Wrap(
            spacing: 8,
            children: _specialties.map((spec) {
              final isSelected = _selectedSpecializationId == spec.id;
              return FilterChip(
                label: Text(spec.name),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedSpecializationId = selected ? spec.id : null;
                  });
                },
                selectedColor: AppColors.stitchPrimaryContainer.withValues(
                  alpha: 0.2,
                ),
                checkmarkColor: AppColors.stitchPrimaryContainer,
                labelStyle: AppStyles.s14Medium.withColor(
                  isSelected
                      ? AppColors.stitchPrimaryContainer
                      : AppColors.stitchSecondary,
                ),
              );
            }).toList(),
          ),
          24.ph,

          // Sort by nearest
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'sort_by_nearest'.tr(),
                style: AppStyles.s16Bold.withColor(AppColors.stitchSecondary),
              ),
              Switch(
                value: _isNearest,
                onChanged: (value) {
                  setState(() {
                    _isNearest = value;
                  });
                },
                activeTrackColor: AppColors.stitchPrimaryContainer,
              ),
            ],
          ),
          24.ph,

          // Search radius
          Text(
            '${'search_radius'.tr()} (${_radiusInKm.toInt()} km)',
            style: AppStyles.s16Bold.withColor(AppColors.stitchSecondary),
          ),
          Slider(
            value: _radiusInKm,
            min: 1,
            max: 50,
            divisions: 49,
            label: '${_radiusInKm.toInt()} km',
            activeColor: AppColors.stitchPrimaryContainer,
            onChanged: (value) {
              setState(() {
                _radiusInKm = value;
              });
            },
          ),
          24.ph,

          // Search location
          Text(
            'search_location'.tr(),
            style: AppStyles.s16Bold.withColor(AppColors.stitchSecondary),
          ),
          12.ph,
          InkWell(
            onTap: () async {
              final LatLng? picked = await Navigator.push<LatLng>(
                context,
                MaterialPageRoute(
                  builder: (_) => PickLocationScreen(
                    initialLocation: _hasCustomLocation
                        ? LatLng(_customLat!, _customLng!)
                        : null,
                  ),
                ),
              );
              if (picked != null) {
                setState(() {
                  _customLat = picked.latitude;
                  _customLng = picked.longitude;
                });
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.stitchSurfaceLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _hasCustomLocation
                      ? AppColors.stitchPrimaryContainer
                      : AppColors.stitchSurfaceLow,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _hasCustomLocation ? Icons.location_on : Icons.my_location,
                    color: _hasCustomLocation
                        ? AppColors.stitchPrimaryContainer
                        : AppColors.stitchSecondary,
                  ),
                  12.pw,
                  Expanded(
                    child: Text(
                      _hasCustomLocation
                          ? '${_customLat!.toStringAsFixed(4)}, ${_customLng!.toStringAsFixed(4)}'
                          : 'current_location'.tr(),
                      style: AppStyles.s14Medium.withColor(
                        _hasCustomLocation
                            ? AppColors.stitchPrimaryContainer
                            : AppColors.stitchSecondary,
                      ),
                    ),
                  ),
                  if (_hasCustomLocation)
                    InkWell(
                      onTap: () {
                        setState(() {
                          _customLat = null;
                          _customLng = null;
                        });
                      },
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: AppColors.stitchSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ),
          32.ph,

          // Apply button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                final cubit = context.read<MapHomeCubit>();

                // Set or clear custom location
                if (_hasCustomLocation) {
                  cubit.setCustomLocation(_customLat!, _customLng!);
                } else {
                  cubit.clearCustomLocation();
                }

                // Search with filters + custom location
                cubit.searchClinics(
                  specializationId: _selectedSpecializationId,
                  isNearest: _isNearest,
                  radiusInKm: _radiusInKm.toInt(),
                  userLat: _customLat,
                  userLng: _customLng,
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.stitchPrimaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'apply_filters'.tr(),
                style: AppStyles.s16Bold.withColor(Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
