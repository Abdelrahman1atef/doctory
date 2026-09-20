import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:doctory/core/common/widgets/buttons/custom_button.dart';
import 'package:doctory/core/common/widgets/inputs/custom_text_form_field.dart';
import 'package:doctory/core/session/user_session.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/clinic/data/model/availability_dto.dart';
import 'package:doctory/core/utils/digit_extensions.dart';
import 'package:doctory/core/utils/extensions.dart';

class AvailabilityWindowDialog extends StatefulWidget {
  final void Function(AvailabilityDto) onSave;

  const AvailabilityWindowDialog({super.key, required this.onSave});

  @override
  State<AvailabilityWindowDialog> createState() => _AvailabilityWindowDialogState();
}

class _AvailabilityWindowDialogState extends State<AvailabilityWindowDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _selectedDay = 1; // 1 to 7
  final TextEditingController _startController = TextEditingController(text: '09:00');
  final TextEditingController _endController = TextEditingController(text: '17:00');
  final TextEditingController _slotController = TextEditingController(text: '30');

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final doctorId = UserSession.userModel?['doctorId']?.toString() ?? '';
    final clinicId = UserSession.userModel?['clinicId']?.toString() ?? '';

    widget.onSave(
      AvailabilityDto(
        id: '',
        // Empty for create
        doctorId: doctorId,
        clinicId: clinicId,
        dayOfWeek: _selectedDay,
        startTime: _startController.text.toEnglishDigits,
        endTime: _endController.text.toEnglishDigits,
        slotDurationMinutes: int.parse(_slotController.text.toEnglishDigits),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    _slotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      width: double.infinity,
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16)),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('clinic.add_availability'.tr(), style: AppStyles.s18Bold.withColor(AppColors.primary)),
            24.ph,
            DropdownButtonFormField<int>(
              initialValue: _selectedDay,
              decoration: InputDecoration(labelText: 'clinic.day_of_week'.tr()),
              items: List.generate(
                7,
                (index) => DropdownMenuItem(value: index + 1, child: Text('Day ${index + 1}')),
              ),
              onChanged: (val) {
                if (val != null) setState(() => _selectedDay = val);
              },
            ),
            16.ph,
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    controller: _startController,
                    labelText: 'clinic.start_time'.tr(),
                    hintText: 'HH:MM',
                    validator: (val) => val == null || val.isEmpty ? 'validation.required'.tr() : null,
                  ),
                ),
                16.pw,
                Expanded(
                  child: CustomTextFormField(
                    controller: _endController,
                    labelText: 'clinic.end_time'.tr(),
                    hintText: 'HH:MM',
                    validator: (val) => val == null || val.isEmpty ? 'validation.required'.tr() : null,
                  ),
                ),
              ],
            ),
            16.ph,
            CustomTextFormField(
              controller: _slotController,
              labelText: 'clinic.slot_duration'.tr(),
              hintText: '30',
              keyboardType: TextInputType.number,
              validator: (val) => val == null || val.isEmpty ? 'validation.required'.tr() : null,
            ),
            32.ph,
            CustomButton(text: 'common.save'.tr(), onPressed: _submit),
          ],
        ),
      ),
    );
  }
}

