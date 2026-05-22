import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/booking/cubit/booking_cubit.dart';
import 'package:doctory/features/booking/cubit/booking_states.dart';
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
                  consultationFee: 200.0, // Hardcoded fallback
                  currency: 'EGP', // Hardcoded fallback
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
              Row(
                children: [
                  Expanded(
                    child: BookingTextField(
                      label: 'patient_age'.tr(),
                      icon: Icons.calendar_today_outlined,
                      keyboardType: TextInputType.number,
                      onChanged: (val) => cubit.updatePatientInfo(age: val),
                    ),
                  ),
                  12.pw,
                  Expanded(
                    child: _buildDropdown(
                      label: 'gender'.tr(),
                      icon: Icons.wc_rounded,
                      value: state.patientGender,
                      items: [
                        DropdownMenuItem(value: 1, child: Text('male'.tr())),
                        DropdownMenuItem(value: 2, child: Text('female'.tr())),
                      ],
                      onChanged: (val) => cubit.updatePatientInfo(gender: val),
                    ),
                  ),
                ],
              ),
              14.ph,
              BookingTextField(
                label: 'phone_number'.tr(),
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                onChanged: (val) => cubit.updatePatientInfo(phone: val),
              ),
              14.ph,
              _buildDropdown(
                label: 'appointment_type'.tr(),
                icon: Icons.medical_services_outlined,
                value: state.appointmentType,
                items: [
                  DropdownMenuItem(value: 1, child: Text('in_person'.tr())),
                  DropdownMenuItem(value: 2, child: Text('online'.tr())),
                  DropdownMenuItem(value: 3, child: Text('follow_up'.tr())),
                ],
                onChanged: (val) => cubit.updatePatientInfo(appointmentType: val),
              ),
              14.ph,
              BookingTextField(
                label: 'complaint'.tr(),
                icon: Icons.healing_outlined,
                maxLines: 2,
                onChanged: (val) => cubit.updatePatientInfo(complaint: val),
              ),
              14.ph,
              BookingTextField(
                label: 'chronic_diseases_optional'.tr(),
                icon: Icons.notes_rounded,
                maxLines: 2,
                onChanged: (val) => cubit.updatePatientInfo(notes: val),
              ),
              24.ph,
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required IconData icon,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: AppColors.stitchPrimary),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.grey200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.grey200),
            ),
          ),
        ),
      ],
    );
  }
}
