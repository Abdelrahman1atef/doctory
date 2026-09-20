import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/common/widgets/buttons/stitch_button.dart';
import 'package:doctory/core/common/widgets/inputs/stitch_text_field.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BookingConfigFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController feeController;
  final TextEditingController maxAdvanceController;
  final TextEditingController ttlController;
  final TextEditingController cancellationController;
  final String currency;
  final FormFieldValidator<String> feeValidator;
  final FormFieldValidator<String> positiveIntValidator;
  final bool isLoading;
  final VoidCallback onSubmit;

  const BookingConfigFormWidget({
    super.key,
    required this.formKey,
    required this.feeController,
    required this.maxAdvanceController,
    required this.ttlController,
    required this.cancellationController,
    required this.currency,
    required this.feeValidator,
    required this.positiveIntValidator,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StitchTextField(
              controller: feeController,
              label: LocaleKeys.consultation_fee.tr(),
              hintText: '300',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: feeValidator,
              prefixIcon: const Icon(Icons.payments_outlined, color: AppColors.stitchPrimary),
              // Currency is set by the server — shown, never edited.
              suffixIcon: Padding(
                padding: const EdgeInsetsDirectional.only(end: 20),
                child: Center(
                  widthFactor: 1,
                  child: Text(
                    currency,
                    style: AppStyles.s14Bold.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ),
            ),
            20.ph,
            StitchTextField(
              controller: maxAdvanceController,
              label: LocaleKeys.max_advance_days.tr(),
              hintText: '30',
              keyboardType: TextInputType.number,
              validator: positiveIntValidator,
              prefixIcon: const Icon(Icons.calendar_month_outlined, color: AppColors.stitchPrimary),
            ),
            20.ph,
            StitchTextField(
              controller: ttlController,
              label: LocaleKeys.reservation_ttl.tr(),
              hintText: '10',
              keyboardType: TextInputType.number,
              validator: positiveIntValidator,
              prefixIcon: const Icon(Icons.timer_outlined, color: AppColors.stitchPrimary),
            ),
            20.ph,
            StitchTextField(
              controller: cancellationController,
              label: LocaleKeys.cancellation_window.tr(),
              hintText: '120',
              keyboardType: TextInputType.number,
              validator: positiveIntValidator,
              prefixIcon: const Icon(Icons.event_busy_outlined, color: AppColors.stitchPrimary),
            ),
            32.ph,
            StitchButton(
              text: LocaleKeys.save.tr(),
              onPressed: onSubmit,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
