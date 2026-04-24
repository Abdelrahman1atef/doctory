import 'package:doctory/core/common/widgets/inputs/stitch_text_field.dart';
import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/services/social_auth_service.dart';
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
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

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

  Future<void> _handleSocialAuth(Future<SocialAuthResult?> Function() signInMethod) async {
    final result = await signInMethod();
    if (result != null && mounted) {
      context.read<AuthCubit>().socialLogin(
        provider: result.provider,
        accessToken: result.accessToken,
        name: result.name,
        email: result.email,
      );
    }
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

        if (state is AuthSuccessState) {
          context.go(AppRoutes.locationPermission);
        } else if (state is AuthErrorState) {
          SmartDialog.showToast(state.message);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Email Field
            Text(
              context.tr('email_address'),
              style: AppStyles.s14Medium.copyWith(color: AppColors.stitchSecondary),
            ),
            8.ph,
            StitchTextField(
              controller: _emailController,
              hintText: context.tr('enter_your_email'),
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined, size: 20),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.tr('email_required');
                }
                if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return context.tr('invalid_email');
                }
                return null;
              },
            ),

            24.ph,

            /// Password Field
            Text(
              context.tr('password'),
              style: AppStyles.s14Medium.copyWith(color: AppColors.stitchSecondary),
            ),
            8.ph,
            StitchTextField(
              controller: _passwordController,
              hintText: context.tr('enter_your_password'),
              obscureText: _obscurePassword,
              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
              suffixIcon: IconButton(
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 20,
                  color: AppColors.stitchSecondary,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return context.tr('password_required');
                }
                if (value.length < 6) {
                  return context.tr('password_too_short');
                }
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

            /// Login Button
            SizedBox(
              height: 56,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<AuthCubit>().login(
                      email: _emailController.text.trim(),
                      password: _passwordController.text,
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
                  context.tr('login'),
                  style: AppStyles.s16SemiBold,
                ),
              ),
            ),

            24.ph,

            /// Divider
            Row(
              children: [
                const Expanded(
                  child: Divider(color: AppColors.cardBorder, thickness: 1),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    context.tr('or_login_with'),
                    style: AppStyles.s14Medium.copyWith(color: AppColors.stitchSecondary),
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
              onTap: () => _handleSocialAuth(sl<SocialAuthService>().signInWithGoogle),
            ),

            16.ph,

            SocialAuthButton(
              title: context.tr('continue_with_facebook'),
              icon: const Icon(
                Icons.facebook_rounded,
                color: Colors.blue,
                size: 28,
              ),
              onTap: () => _handleSocialAuth(sl<SocialAuthService>().signInWithFacebook),
            ),

            24.ph,

            /// Register Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.tr('dont_have_account'),
                  style: AppStyles.s14Medium.copyWith(
                    color: AppColors.stitchSecondary,
                  ),
                ),
                TextButton(
                  onPressed: () => context.push(AppRoutes.register),
                  child: Text(
                    context.tr('register_now'),
                    style: AppStyles.s14SemiBold.copyWith(
                      color: AppColors.stitchPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
