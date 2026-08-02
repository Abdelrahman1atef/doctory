import 'package:doctory/core/common/models/clinic_model.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/map_home/presentation/widgets/clinic_card_image_widget.dart';
import 'package:doctory/features/map_home/presentation/widgets/clinic_card_info_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MapClinicCardWidget extends StatelessWidget {
  final ClinicModel clinic;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onNavPressed;

  const MapClinicCardWidget({
    super.key,
    required this.clinic,
    this.isSelected = false,
    required this.onTap,
    this.onNavPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.stitchPrimaryContainer.withValues(alpha: 0.05)
              : AppColors.stitchSurfaceLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.stitchPrimaryContainer
                : Colors.transparent,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                ClinicCardImageWidget(imageUrl: clinic.imageUrl),
                12.pw,
                Expanded(
                  child: ClinicCardInfoWidget(
                    clinic: clinic,
                    showDistance: isSelected,
                  ),
                ),
              ],
            ),
            if (isSelected) _buildActionsRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          // if (clinic.isRegistered)
          //   Container(
          //     padding: const EdgeInsets.all(10),
          //     decoration: BoxDecoration(
          //       color: AppColors.stitchPrimaryContainer.withValues(alpha: 0.1),
          //       shape: BoxShape.circle,
          //     ),
          //     child: const Icon(
          //       Icons.phone,
          //       color: AppColors.stitchPrimaryContainer,
          //       size: 20,
          //     ),
          //   ),
          if (clinic.isRegistered) 12.pw,
          Expanded(
            child: ElevatedButton(
              onPressed: clinic.isRegistered ? onTap : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: clinic.isRegistered
                    ? AppColors.stitchPrimaryContainer
                    : AppColors.stitchSurfaceLow,
                foregroundColor: clinic.isRegistered
                    ? Colors.white
                    : AppColors.stitchSecondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                clinic.isRegistered ? 'book_appointment'.tr() : 'selected'.tr(),
                style: AppStyles.s14Bold,
              ),
            ),
          ),
          if (isSelected && onNavPressed != null) ...[
            8.pw,
            IconButton.filled(
              onPressed: onNavPressed,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.success,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
              ),
              icon: const Icon(Icons.navigation, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }
}
