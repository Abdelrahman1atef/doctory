import 'package:doctory/core/common/widgets/inputs/stitch_text_field.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

class ForgotPasswordBodySection extends StatefulWidget {
  const ForgotPasswordBodySection({super.key});

  @override
  State<ForgotPasswordBodySection> createState() =>
      _ForgotPasswordBodySectionState();
}

class _ForgotPasswordBodySectionState extends State<ForgotPasswordBodySection> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Header
          Text(
            context.tr('forgot_password_title'),
            style: AppStyles.s24Bold.copyWith(color: AppColors.textPrimary),
          ),
          8.ph,
          Text(
            context.tr('forgot_password_subtitle'),
            style: AppStyles.s14Medium.copyWith(color: AppColors.textSecondary),
          ),

          40.ph,

          /// Form
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StitchTextField(
                  controller: _emailController,
                  label: context.tr('email'),
                  hintText: 'name@example.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: AppColors.stitchPrimary,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.tr('required_email');
                    }
                    if (!value.contains('@')) {
                      return context.tr('wrong_email_validation');
                    }
                    return null;
                  },
                ),

                40.ph,

                /// Submit Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.push(
                          AppRoutes.otpVerification,
                          extra: _emailController.text,
                        );
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
                      context.tr('send_reset_link'),
                      style: AppStyles.s16SemiBold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
