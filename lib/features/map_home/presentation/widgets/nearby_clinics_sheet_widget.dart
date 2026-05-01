import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/map_home/presentation/widgets/map_clinic_card_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NearbyClinicsSheetWidget extends StatelessWidget {
  final List<ClinicModel> clinics;
  final String? selectedClinicId;
  final ScrollController scrollController;
  final Function(ClinicModel) onClinicTap;

  const NearbyClinicsSheetWidget({
    super.key,
    required this.clinics,
    required this.selectedClinicId,
    required this.scrollController,
    required this.onClinicTap,
  });

  @override
  Widget build(BuildContext context) {
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
                  '${clinics.length} ${'results'.tr()}',
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
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              itemCount: clinics.length,
              itemBuilder: (context, index) {
                final clinic = clinics[index];
                final isSelected = clinic.id == selectedClinicId;

                return MapClinicCardWidget(
                  clinic: clinic,
                  isSelected: isSelected,
                  onTap: () => onClinicTap(clinic),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
