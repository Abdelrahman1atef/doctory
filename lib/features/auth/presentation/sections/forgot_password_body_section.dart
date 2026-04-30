import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/router_names.dart';
import '../../../../core/services/alerts.dart';
import '../../../../core/utils/extensions.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_states.dart';
import '../widgets/forgot_password_form_widget.dart';

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

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().forgotPassword(_emailController.text.trim());
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

        if (state is ForgotPasswordSuccessState) {
          Alerts.showSnackBar(
            context,
            message: context.l10n('reset_link_sent_success'),
          );
          context.push(
            AppRoutes.otpVerification,
            extra: {
              'email': _emailController.text.trim(),
              'isForgotPassword': true,
            },
          );
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
        child: ForgotPasswordFormWidget(
          formKey: _formKey,
          emailController: _emailController,
          onSubmit: _onSubmit,
        ),
      ),
    );
  }
}
