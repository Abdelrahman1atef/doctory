import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../utils/extensions.dart';

class StitchUploadField extends StatelessWidget {
  final String label;
  final String? fileName;
  final String hint;
  final bool isRequired;
  final VoidCallback onPick;

  const StitchUploadField({
    super.key,
    required this.label,
    required this.fileName,
    required this.hint,
    this.isRequired = true,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = fileName != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: AppStyles.s14Bold.copyWith(color: AppColors.onSurface),
              ),
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: AppStyles.s14Bold.copyWith(color: Colors.red),
                ),
            ],
          ),
        ),
        8.ph,
        GestureDetector(
          onTap: onPick,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.stitchSurfaceLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: hasFile
                        ? AppColors.stitchPrimary.withValues(alpha: 0.1)
                        : AppColors.stitchPrimary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    hasFile
                        ? Icons.check_circle_rounded
                        : Icons.cloud_upload_outlined,
                    color: hasFile
                        ? AppColors.stitchPrimary
                        : AppColors.textSecondary,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    hasFile ? fileName! : hint,
                    style: AppStyles.s16Medium.copyWith(
                      color: hasFile
                          ? AppColors.onSurface
                          : AppColors.textHint,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!hasFile)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.textHint,
                    size: 14,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
