import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/common/widgets/buttons/stitch_button.dart';
import 'package:doctory/core/common/widgets/inputs/stitch_text_field.dart';
import 'package:doctory/core/enums/week_day.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/digit_extensions.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/clinic/data/model/availability_dto.dart';
import 'package:doctory/features/clinic/presentation/widgets/week_day_chips_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Bottom sheet that collects one working-hours window and hands the
/// resulting [AvailabilityDto] to [onSave].
class AvailabilityWindowSheet extends StatefulWidget {
  final String doctorId;
  final String clinicId;
  final void Function(AvailabilityDto window) onSave;

  const AvailabilityWindowSheet({
    super.key,
    required this.doctorId,
    required this.clinicId,
    required this.onSave,
  });

  @override
  State<AvailabilityWindowSheet> createState() => _AvailabilityWindowSheetState();
}

class _AvailabilityWindowSheetState extends State<AvailabilityWindowSheet> {
  final _formKey = GlobalKey<FormState>();
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  final _slotController = TextEditingController(text: '30');
  WeekDay _day = WeekDay.sunday;
  TimeOfDay _start = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _end = const TimeOfDay(hour: 14, minute: 0);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncTimeFields();
  }

  void _syncTimeFields() {
    _startController.text = _start.format(context);
    _endController.text = _end.format(context);
  }

  int _minutes(TimeOfDay time) => time.hour * 60 + time.minute;

  /// API contract: `HH:mm:ss` (24h).
  String _toApi(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _start : _end,
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (isStart) {
        _start = picked;
      } else {
        _end = picked;
      }
      _syncTimeFields();
    });
  }

  String? _validateEnd(String? _) =>
      _minutes(_end) <= _minutes(_start) ? LocaleKeys.end_time_after_start.tr() : null;

  String? _validateSlot(String? value) {
    final number = int.tryParse((value ?? '').trim().toEnglishDigits);
    if (number == null) return LocaleKeys.required_field.tr();
    if (number <= 0) return LocaleKeys.must_be_positive.tr();
    return null;
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.onSave(
      AvailabilityDto(
        id: '', // Empty for create
        doctorId: widget.doctorId,
        clinicId: widget.clinicId,
        dayOfWeek: _day.index,
        startTime: _toApi(_start),
        endTime: _toApi(_end),
        slotDurationMinutes: int.parse(_slotController.text.trim().toEnglishDigits),
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
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 32),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.add_availability.tr(),
                style: AppStyles.s20Bold.withColor(AppColors.stitchPrimaryContainer),
              ),
              24.ph,
              Text(
                LocaleKeys.day_of_week.tr(),
                style: AppStyles.s14Bold.copyWith(color: AppColors.onSurface),
              ),
              8.ph,
              WeekDayChipsWidget(
                selected: _day,
                onSelected: (day) => setState(() => _day = day),
              ),
              20.ph,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: StitchTextField(
                      controller: _startController,
                      label: LocaleKeys.start_time.tr(),
                      readOnly: true,
                      onTap: () => _pickTime(isStart: true),
                      prefixIcon: const Icon(Icons.access_time, color: AppColors.stitchPrimary),
                    ),
                  ),
                  12.pw,
                  Expanded(
                    child: StitchTextField(
                      controller: _endController,
                      label: LocaleKeys.end_time.tr(),
                      readOnly: true,
                      onTap: () => _pickTime(isStart: false),
                      validator: _validateEnd,
                      prefixIcon: const Icon(Icons.access_time, color: AppColors.stitchPrimary),
                    ),
                  ),
                ],
              ),
              20.ph,
              StitchTextField(
                controller: _slotController,
                label: LocaleKeys.slot_duration.tr(),
                hintText: '30',
                keyboardType: TextInputType.number,
                validator: _validateSlot,
                prefixIcon: const Icon(Icons.timer_outlined, color: AppColors.stitchPrimary),
              ),
              32.ph,
              StitchButton(text: LocaleKeys.save.tr(), onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
