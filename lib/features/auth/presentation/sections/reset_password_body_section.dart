import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/router_names.dart';
import '../../../../core/services/alerts.dart';
import '../../../../core/utils/extensions.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_states.dart';
import '../widgets/reset_password_form_widget.dart';

class ResetPasswordBodySection extends StatefulWidget {
  final String email;
  final String token;
  const ResetPasswordBodySection({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  State<ResetPasswordBodySection> createState() =>
      _ResetPasswordBodySectionState();
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

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().resetPassword(
        email: widget.email,
        token: widget.token,
        newPassword: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
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

        if (state is ResetPasswordSuccessState) {
          Alerts.showSnackBar(
            context,
            message: context.l10n('password_reset_success'),
          );
          context.go(AppRoutes.login);
        } else if (state is AuthErrorState) {
          Alerts.showSnackBar(
            context,
            message: state.message,
            state: SnackState.failed,
          );
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ResetPasswordFormWidget(
          formKey: _formKey,
          passwordController: _passwordController,
          confirmPasswordController: _confirmPasswordController,
          obscurePassword: _obscurePassword,
          obscureConfirmPassword: _obscureConfirmPassword,
          onTogglePassword: () =>
              setState(() => _obscurePassword = !_obscurePassword),
          onToggleConfirmPassword: () => setState(
            () => _obscureConfirmPassword = !_obscureConfirmPassword,
          ),
          onSubmit: _onSubmit,
        ),
      ),
    );
  }
}
