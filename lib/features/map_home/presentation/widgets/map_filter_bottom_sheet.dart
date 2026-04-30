import 'package:doctory/core/common/models/specialty_model.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:doctory/features/map_home/cubit/map_home_cubit.dart';
import 'package:doctory/features/map_home/cubit/map_home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  // Dummy specialties (should ideally come from HomeCubit or a shared service)
  final List<SpecialtyModel> _specialties = [
    SpecialtyModel(id: '1', name: 'Dental', iconAsset: ''),
    SpecialtyModel(id: '2', name: 'Cardiology', iconAsset: ''),
    SpecialtyModel(id: '3', name: 'Eye Care', iconAsset: ''),
    SpecialtyModel(id: '4', name: 'Pediatrics', iconAsset: ''),
  ];

  @override
  void initState() {
    super.initState();
    _selectedSpecializationId = widget.initialState.specializationId;
    _isNearest = widget.initialState.isNearest;
    _radiusInKm = widget.initialState.radiusInKm.toDouble();
  }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'filter'.tr(),
                style: AppStyles.s20Bold.withColor(AppColors.stitchPrimaryContainer),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          24.ph,
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
                selectedColor: AppColors.stitchPrimaryContainer.withValues(alpha: 0.2),
                checkmarkColor: AppColors.stitchPrimaryContainer,
                labelStyle: AppStyles.s14Medium.withColor(
                  isSelected ? AppColors.stitchPrimaryContainer : AppColors.stitchSecondary,
                ),
              );
            }).toList(),
          ),
          24.ph,
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
          32.ph,
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                context.read<MapHomeCubit>().searchClinics(
                      specializationId: _selectedSpecializationId,
                      isNearest: _isNearest,
                      radiusInKm: _radiusInKm.toInt(),
                    );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.stitchPrimaryContainer,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
