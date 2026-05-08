import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/booking/cubit/booking_cubit.dart';
import 'package:doctory/features/booking/cubit/booking_states.dart';
import 'package:doctory/features/booking/data/data_source/booking_mock_data.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_summary_card.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Section for the confirm step — summary card + patient form.
class ConfirmBookingSection extends StatelessWidget {
  const ConfirmBookingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingStates>(
      buildWhen: (prev, curr) => curr is BookingStateUpdated,
      builder: (context, state) {
        if (state is! BookingStateUpdated) return const SizedBox.shrink();

        final cubit = context.read<BookingCubit>();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'confirm_booking'.tr(),
                style: AppStyles.s18Bold.withColor(
                  AppColors.stitchPrimaryContainer,
                ),
              ),
              6.ph,
              Text(
                'review_details'.tr(),
                style: AppStyles.s14Medium.withColor(AppColors.grey500),
              ),
              20.ph,
              // Summary Card
              if (state.selectedDate != null && state.selectedTime != null)
                BookingSummaryCard(
                  doctor: state.doctor,
                  selectedDate: state.selectedDate!,
                  selectedTime: state.selectedTime!,
                  consultationFee: BookingMockData.consultationFee,
                  currency: BookingMockData.currency,
                ),
              24.ph,
              // Patient Details Form
              Text(
                'patient_details'.tr(),
                style: AppStyles.s16Bold.withColor(
                  AppColors.stitchPrimaryContainer,
                ),
              ),
              16.ph,
              BookingTextField(
                label: 'full_name'.tr(),
                icon: Icons.person_outline_rounded,
                onChanged: (val) => cubit.updatePatientInfo(name: val),
              ),
              14.ph,
              BookingTextField(
                label: 'phone_number'.tr(),
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                onChanged: (val) => cubit.updatePatientInfo(phone: val),
              ),
              14.ph,
              BookingTextField(
                label: 'additional_notes'.tr(),
                icon: Icons.notes_rounded,
                maxLines: 3,
                onChanged: (val) => cubit.updatePatientInfo(notes: val),
              ),
              24.ph,
            ],
          ),
        );
      },
    );
  }
}
