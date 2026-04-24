import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/auth/cubit/auth_cubit.dart';
import 'package:doctory/features/auth/cubit/auth_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:easy_localization/easy_localization.dart';

class OtpInputSection extends StatefulWidget {
  final String? email;
  const OtpInputSection({super.key, this.email});

  @override
  State<OtpInputSection> createState() => _OtpInputSectionState();
}

class _OtpInputSectionState extends State<OtpInputSection> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is AuthLoadingState) {
          SmartDialog.showLoading();
        } else {
          SmartDialog.dismiss();
        }

        if (state is VerifySuccessState) {
          context.go(AppRoutes.completeProfile);
        } else if (state is AuthErrorState) {
          SmartDialog.showToast(state.message);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Pin Code Input (Using Pinput)
          Center(
            child: Pinput(
              length: 6, // Adjusted to 6 as it's common, or keep 4 if specified
              controller: _otpController,
              defaultPinTheme: PinTheme(
                width: 56,
                height: 56,
                textStyle: AppStyles.s24Bold.copyWith(color: AppColors.stitchPrimary),
                decoration: BoxDecoration(
                  color: AppColors.stitchPrimary.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.transparent),
                ),
              ),
              focusedPinTheme: PinTheme(
                width: 60,
                height: 60,
                textStyle: AppStyles.s24Bold.copyWith(color: AppColors.stitchPrimary),
                decoration: BoxDecoration(
                  color: AppColors.stitchPrimary.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.stitchPrimary, width: 2),
                ),
              ),
              onCompleted: (pin) {
                if (widget.email != null) {
                  context.read<AuthCubit>().verify(widget.email!, pin);
                }
              },
            ),
          ),

          const SizedBox(height: 48),

          /// Verify Button
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                if (_otpController.text.length >= 4 && widget.email != null) {
                  context.read<AuthCubit>().verify(widget.email!, _otpController.text);
                } else if (widget.email == null) {
                  SmartDialog.showToast('Email is missing');
                }
              },
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
                onPressed: () {
                  if (widget.email != null) {
                    context.read<AuthCubit>().forgotPassword(widget.email!);
                  }
                },
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
      ),
    );
  }
}
