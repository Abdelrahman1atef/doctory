import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/doctor_details/presentation/widgets/doctor_slot_chip_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DoctorAvailabilitySection extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorAvailabilitySection({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    if (doctor.availableSlots == null || doctor.availableSlots!.isEmpty) {
      return const SizedBox.shrink();
    }

    final today = DateTime.now().toIso8601String().split('T')[0];
    final todaySlots = doctor.availableSlots![today] ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today\'s Slots', // Can localize
                style: AppStyles.s18Bold.withColor(
                  AppColors.stitchPrimaryContainer,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.push(
                    AppRoutes.bookingSelectDate,
                    extra: {'doctor': doctor},
                  );
                },
                child: Text(
                  'See All', // Can localize
                  style: AppStyles.s14Bold.withColor(
                    AppColors.stitchPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
          8.ph,
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: todaySlots
                .map((slot) => DoctorSlotChipWidget(slot: slot))
                .toList(),
          ),
          24.ph,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.push(
                  AppRoutes.bookingSelectDate,
                  extra: {'doctor': doctor},
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.stitchPrimaryContainer,
                foregroundColor: AppColors.stitchSurfaceLowest,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text('book_appointment'.tr(), style: AppStyles.s16Bold),
            ),
          ),
        ],
      ),
    );
  }
}
