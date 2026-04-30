import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions.dart';

class OtpFormWidget extends StatelessWidget {
  final TextEditingController otpController;
  final VoidCallback onVerify;
  final VoidCallback onResend;
  final Function(String) onCompleted;

  const OtpFormWidget({
    super.key,
    required this.otpController,
    required this.onVerify,
    required this.onResend,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        /// Pin Code Input (Using Pinput)
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: Pinput(
              length: 6,
              controller: otpController,
              autofocus: true,
              defaultPinTheme: PinTheme(
                width: 56,
                height: 56,
                textStyle: AppStyles.s24Bold.copyWith(
                  color: AppColors.stitchPrimary,
                ),
                decoration: BoxDecoration(
                  color: AppColors.stitchPrimary.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.transparent),
                ),
              ),
              focusedPinTheme: PinTheme(
                width: 60,
                height: 60,
                textStyle: AppStyles.s24Bold.copyWith(
                  color: AppColors.stitchPrimary,
                ),
                decoration: BoxDecoration(
                  color: AppColors.stitchPrimary.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.stitchPrimary, width: 2),
                ),
              ),
              onCompleted: onCompleted,
            ),
          ),
        ),

        const SizedBox(height: 48),

        /// Verify Button
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: onVerify,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.stitchPrimaryContainer,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              context.l10n('verify_and_continue'),
              style: AppStyles.s16SemiBold,
            ),
          ),
        ),

        const SizedBox(height: 24),

        /// Resend Link
        Column(
          children: [
            Text(
              context.l10n('the_code_was_not_sent'),
              style: AppStyles.s14Medium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            TextButton(
              onPressed: onResend,
              child: Text(
                context.l10n('send_again'),
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
