import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/common/models/role.dart';
import 'package:doctory/core/session/user_session.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import '../../../../core/common/functions/location_helper.dart';
import '../../../../core/router/router_names.dart';
import '../../../../core/services/alerts.dart';
import '../../../../features/admin/router/admin_router_names.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_states.dart';
import '../widgets/login_form_widget.dart';

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

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  Future<void> _resolveAndNavigate() async {
    if (UserSession.currentRole == UserRole.superAdmin) {
      context.go(AdminRoutes.admin);
      return;
    }

    String destination;
    Object? extra;

    if (UserSession.clinicStatus == null) {
      destination = AppRoutes.home;
    } else if (UserSession.verificationStatus == 'Pending') {
      destination = AppRoutes.clinicPendingApproval;
    } else if (UserSession.verificationStatus == 'Rejected') {
      destination = AppRoutes.clinicRejected;
    } else if (UserSession.clinicStatus == 'Suspended') {
      destination = AppRoutes.clinicPendingApproval;
    } else if (!UserSession.isClinicSetupComplete) {
      destination = AppRoutes.clinicCompleteProfile;
      extra = {'isSetupMode': true};
    } else {
      destination = AppRoutes.clinicDashboard;
    }

    if (destination != AppRoutes.home &&
        destination != AppRoutes.clinicDashboard) {
      if (mounted) context.go(destination, extra: extra);
      return;
    }

    final bool isGranted = await LocationHelper.isPermissionGranted();
    if (!mounted) return;
    if (isGranted) {
      context.go(destination, extra: extra);
    } else {
      context.go(AppRoutes.locationPermission);
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
          _resolveAndNavigate();
        } else if (state is AuthErrorState) {
          if (state.code == 'PERMISSION_ERROR') {
            Alerts.dialog(
              context,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.info_outline, size: 48, color: AppColors.errorColor),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: AppStyles.s16Bold,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(LocaleKeys.ok.tr()),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            Alerts.showSnackBar(context, message: state.message, state: SnackState.failed);
          }
        }
      },
      child: LoginFormWidget(
        formKey: _formKey,
        emailController: _emailController,
        passwordController: _passwordController,
        obscurePassword: _obscurePassword,
        onTogglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
        onForgotPassword: () => context.push(AppRoutes.forgotPassword),
        onLogin: _onLogin,
        onGoogleSignIn: () => context.read<AuthCubit>().signInWithGoogle(),
        onFacebookSignIn: () => context.read<AuthCubit>().signInWithFacebook(),
        onRegister: () => context.push(AppRoutes.register),
      ),
    );
  }
}
