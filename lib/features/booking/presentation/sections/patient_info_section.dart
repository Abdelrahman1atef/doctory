import 'package:doctory/features/booking/cubit/booking_cubit.dart';
import 'package:doctory/features/booking/cubit/booking_state.dart';
import 'package:doctory/features/booking/domain/enums/gender.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_gender_dropdown.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_section_header.dart';
import 'package:doctory/features/booking/presentation/widgets/booking_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientInfoSection extends StatelessWidget {
  const PatientInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      buildWhen: (prev, curr) => curr is BookingData,
      builder: (context, state) {
        if (state is! BookingData) return const SizedBox.shrink();

        final cubit = context.read<BookingCubit>();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookingSectionHeader(
                title: 'patient_details'.tr(),
                subtitle: 'enter_patient_details'.tr(),
              ),
              const SizedBox(height: 20),
              BookingTextField(
                label: 'full_name'.tr(),
                icon: Icons.person_outline_rounded,
                initialValue: state.patientName,
                onChanged: (val) => cubit.updatePatientInfo(name: val),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: BookingTextField(
                      label: 'patient_age'.tr(),
                      icon: Icons.calendar_today_outlined,
                      keyboardType: TextInputType.number,
                      initialValue: state.patientAge,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                        const _MaxAgeInputFormatter(120),
                      ],
                      onChanged: (val) => cubit.updatePatientInfo(age: val),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: BookingGenderDropdown(
                      value: state.patientGender.value,
                      onChanged: (val) => cubit.updatePatientInfo(
                        gender: Gender.fromValue(val ?? 1),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              BookingTextField(
                label: 'complaint'.tr(),
                icon: Icons.healing_outlined,
                maxLines: 2,
                initialValue: state.complaint,
                onChanged: (val) => cubit.updatePatientInfo(complaint: val),
              ),
              const SizedBox(height: 14),
              BookingTextField(
                label: 'chronic_diseases_optional'.tr(),
                icon: Icons.notes_rounded,
                maxLines: 2,
                initialValue: state.notes,
                onChanged: (val) => cubit.updatePatientInfo(notes: val),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

class _MaxAgeInputFormatter extends TextInputFormatter {
  final int max;
  const _MaxAgeInputFormatter(this.max);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final age = int.tryParse(newValue.text);
    if (age != null && age > max) return oldValue;
    return newValue;
  }
}
