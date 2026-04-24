import 'package:doctory/core/common/widgets/inputs/stitch_text_field.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/core/common/widgets/buttons/social_auth_button.dart';
import 'package:doctory/features/auth/cubit/auth_cubit.dart';
import 'package:doctory/features/auth/cubit/auth_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginInputSection extends StatefulWidget {
  const LoginInputSection({super.key});

  @override
  State<LoginInputSection> createState() => _LoginInputSectionState();
}

class _LoginInputSectionState extends State<LoginInputSection> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is AuthSuccessState) {
          // In Phone login, success means OTP sent
          context.push(AppRoutes.otpVerification);
        } else if (state is AuthErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Form(
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

              20.ph,

              StitchTextField(
                controller: _passwordController,
                label: context.tr('password'),
                hintText: '••••••••',
                obscureText: _obscurePassword,
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.stitchPrimary,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return context.tr('required_password');
                  return null;
                },
              ),

              const SizedBox(height: 12),

              /// Forgot Password Link
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: () => context.push(AppRoutes.forgotPassword),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    context.tr('forgot_password'),
                    style: AppStyles.s14Medium.copyWith(
                      color: AppColors.stitchPrimary,
                    ),
                  ),
                ),
              ),

              32.ph,

              /// Login Button (Primary Container style)
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Trigger OTP sending logic here via Cubit if needed
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
                  child: state is AuthLoadingState
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          context.tr('login_action'),
                          style: AppStyles.s16SemiBold,
                        ),
                ),
              ),

              32.ph,

              /// OR Divider
              Row(
                children: [
                  const Expanded(
                    child: Divider(color: AppColors.cardBorder, thickness: 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      context.tr('or_continue_with'),
                      style: AppStyles.s14Medium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(color: AppColors.cardBorder, thickness: 1),
                  ),
                ],
              ),

              32.ph,

              /// Social Auth Buttons
              SocialAuthButton(
                title: context.tr('continue_with_google'),
                icon: const Icon(
                  Icons.g_mobiledata_rounded,
                  color: Colors.red,
                  size: 36,
                ),
                onTap: () => context.push(AppRoutes.completeProfile),
              ),

              16.ph,

              SocialAuthButton(
                title: context.tr('continue_with_facebook'),
                icon: const Icon(
                  Icons.facebook_rounded,
                  color: Colors.blue,
                  size: 28,
                ),
                onTap: () => context.push(AppRoutes.completeProfile),
              ),

              24.ph,

              /// Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.tr('dont_have_account'),
                    style: AppStyles.s14Medium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push(AppRoutes.register),
                    child: Text(
                      context.tr('register_now'),
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
      },
    );
  }
}
