import 'package:doctory/core/common/widgets/inputs/stitch_text_field.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/auth/cubit/auth_cubit.dart';
import 'package:doctory/features/auth/cubit/auth_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:doctory/core/services/alerts.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

class ResetPasswordBodySection extends StatefulWidget {
  final String email;
  final String token;
  const ResetPasswordBodySection({super.key, required this.email, required this.token});

  @override
  State<ResetPasswordBodySection> createState() => _ResetPasswordBodySectionState();
}

class _ResetPasswordBodySectionState extends State<ResetPasswordBodySection> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

        if (state is ResetPasswordSuccessState) {
          Alerts.showSnackBar(context, message: context.tr('password_reset_success'));
          context.go(AppRoutes.login);
        } else if (state is AuthErrorState) {
          Alerts.showSnackBar(context, message: state.message, state: SnackState.failed);
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.tr('reset_password_title'),
              style: AppStyles.s24Bold.copyWith(color: AppColors.textPrimary),
            ),
            8.ph,
            Text(
              context.tr('reset_password_subtitle'),
              style: AppStyles.s14Medium.copyWith(color: AppColors.textSecondary),
            ),
            40.ph,
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StitchTextField(
                    controller: _passwordController,
                    label: context.tr('new_password'),
                    hintText: context.tr('enter_new_password'),
                    obscureText: _obscurePassword,
                    prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.stitchPrimary),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return context.tr('password_required');
                      if (value.length < 6) return context.tr('password_too_short');
                      return null;
                    },
                  ),
                  24.ph,
                  StitchTextField(
                    controller: _confirmPasswordController,
                    label: context.tr('confirm_password'),
                    hintText: context.tr('re_enter_password'),
                    obscureText: _obscureConfirmPassword,
                    prefixIcon: const Icon(Icons.lock_reset_rounded, color: AppColors.stitchPrimary),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      icon: Icon(_obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return context.tr('confirm_password_required');
                      if (value != _passwordController.text) return context.tr('passwords_dont_match');
                      return null;
                    },
                  ),
                  40.ph,
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthCubit>().resetPassword(
                                email: widget.email,
                                token: widget.token,
                                newPassword: _passwordController.text,
                                confirmPassword: _confirmPasswordController.text,
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.stitchPrimaryContainer,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(context.tr('reset_password'), style: AppStyles.s16SemiBold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
