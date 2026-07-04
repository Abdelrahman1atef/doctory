import 'package:flutter/material.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/clinic_dashboard/data/model/quick_patient_model.dart';

class PatientSearchTileWidget extends StatelessWidget {
  final QuickPatientModel patient;
  final VoidCallback onTap;

  const PatientSearchTileWidget({
    super.key,
    required this.patient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.stitchSurfaceLow,
              child: Icon(
                Icons.person,
                size: 20,
                color: AppColors.stitchPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: AppStyles.s14SemiBold.withColor(AppColors.textPrimary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    patient.phone,
                    style: AppStyles.s12Medium.withColor(AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Icons.chevron_right, color: AppColors.textSecondary),
                Text(
                  'Last: ${patient.lastVisit}',
                  style: AppStyles.s10Medium.withColor(AppColors.textHint),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
