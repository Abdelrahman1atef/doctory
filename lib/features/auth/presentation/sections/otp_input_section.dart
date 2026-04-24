import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:easy_localization/easy_localization.dart';

class OtpInputSection extends StatefulWidget {
  const OtpInputSection({super.key});

  @override
  State<OtpInputSection> createState() => _OtpInputSectionState();
}

class _OtpInputSectionState extends State<OtpInputSection> {
  late final PinInputController _otpController;

  @override
  void initState() {
    super.initState();
    _otpController = PinInputController();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        /// Pin Code Input
        Center(
          child: MaterialPinField(
            length: 4,
            pinController: _otpController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            theme: MaterialPinTheme(
              shape: MaterialPinShape.filled,
              cellSize: const Size(76, 76),
              borderRadius: BorderRadius.circular(16),
              spacing: 12,
              fillColor: AppColors.stitchPrimary.withValues(alpha: 0.1),
              borderColor: Colors.transparent,
              focusedBorderColor: AppColors.stitchPrimary,
              borderWidth: 0,
              focusedBorderWidth: 2,
              textStyle: AppStyles.s24Bold.copyWith(
                color: AppColors.stitchPrimary,
              ),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),

        const SizedBox(height: 48),

        /// Verify Button
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: () => context.push(AppRoutes.completeProfile),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.stitchPrimaryContainer,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              context.tr('verify_and_continue'),
              style: AppStyles.s16SemiBold,
            ),
          ),
        ),

        const SizedBox(height: 24),

        /// Resend Link
        Column(
          children: [
            Text(
              context.tr('the_code_was_not_sent'),
              style: AppStyles.s14Medium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                context.tr('send_again'),
                style: AppStyles.s14Bold.copyWith(
                  color: AppColors.stitchPrimary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
