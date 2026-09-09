import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctory/core/common/models/specialty_model.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

/// A reusable bottom sheet that lists specializations with cached icons.
///
/// Use [SpecializationPickerSheet.show] as a convenience static method.
class SpecializationPickerSheet extends StatelessWidget {
  /// The specializations to display.
  final List<SpecialtyModel> specializations;

  /// Id of the currently selected specialization (highlighted with a check).
  final String? selectedId;

  const SpecializationPickerSheet({
    super.key,
    required this.specializations,
    this.selectedId,
  });

  /// Convenience method – shows the sheet and returns the picked
  /// specialization (or null if dismissed).
  static Future<SpecialtyModel?> show(
    BuildContext context, {
    required List<SpecialtyModel> specializations,
    String? selectedId,
  }) {
    return showModalBottomSheet<SpecialtyModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SpecializationPickerSheet(
        specializations: specializations,
        selectedId: selectedId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              8.ph,
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              16.ph,
              Text(
                'select_specialization'.tr(),
                style: AppStyles.s16Bold.copyWith(color: AppColors.onSurface),
              ),
              16.ph,
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: specializations.length,
                  separatorBuilder: (_, _) => const Divider(
                    height: 1,
                    color: AppColors.cardBorder,
                  ),
                  itemBuilder: (context, index) {
                    final specialty = specializations[index];
                    final isSelected = specialty.id == selectedId;
                    return InkWell(
                      onTap: () => Navigator.pop(context, specialty),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            _SpecializationIconWidget(
                              iconUrl: specialty.iconUrl,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                specialty.displayName,
                                style: AppStyles.s16Medium.copyWith(
                                  color: isSelected
                                      ? AppColors.stitchPrimary
                                      : AppColors.onSurface,
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.stitchPrimary,
                                size: 22,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SpecializationIconWidget extends StatelessWidget {
  final String? iconUrl;

  const _SpecializationIconWidget({this.iconUrl});

  @override
  Widget build(BuildContext context) {
    final url = iconUrl;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.stitchPrimary.withValues(alpha: 0.05),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: (url != null && url.isNotEmpty)
            ? CachedNetworkImage(
                imageUrl: url.toImageUrl,
                width: 22,
                height: 22,
                placeholder: (context, url) => const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.medical_services_outlined,
                  color: AppColors.stitchPrimary,
                  size: 20,
                ),
              )
            : const Icon(
                Icons.medical_services_outlined,
                color: AppColors.stitchPrimary,
                size: 20,
              ),
      ),
    );
  }
}
