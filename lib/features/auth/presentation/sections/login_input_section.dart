import 'package:doctory/core/common/models/role.dart';
import 'package:doctory/core/session/user_session.dart';
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
          LocationHelper.isPermissionGranted().then((isGranted) {
            final destination = UserSession.currentRole == UserRole.superAdmin
                ? AdminRoutes.admin
                : UserSession.currentRole == UserRole.clinicOwner
                    ? AppRoutes.clinicDashboard
                    : AppRoutes.home;
            if (isGranted && context.mounted) {
              context.go(destination);
            } else if (context.mounted) {
              context.go(AppRoutes.locationPermission);
            }
          });
        } else if (state is AuthErrorState) {
          Alerts.showSnackBar(
            context,
            message: state.message,
            state: SnackState.failed,
          );
        }
      },
      child: LoginFormWidget(
        formKey: _formKey,
        emailController: _emailController,
        passwordController: _passwordController,
        obscurePassword: _obscurePassword,
        onTogglePassword: () =>
            setState(() => _obscurePassword = !_obscurePassword),
        onForgotPassword: () => context.push(AppRoutes.forgotPassword),
        onLogin: _onLogin,
        onGoogleSignIn: () => context.read<AuthCubit>().signInWithGoogle(),
        onFacebookSignIn: () => context.read<AuthCubit>().signInWithFacebook(),
        onRegister: () => context.push(AppRoutes.register),
      ),
    );
  }
}
