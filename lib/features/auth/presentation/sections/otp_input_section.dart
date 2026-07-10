import 'package:doctory/core/common/models/role.dart';
import 'package:doctory/core/session/user_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/common/functions/location_helper.dart';
import '../../../../core/router/router_names.dart';
import '../../../../core/services/alerts.dart';
import '../../../../features/admin/router/admin_router_names.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_states.dart';
import '../widgets/otp_form_widget.dart';

class OtpInputSection extends StatefulWidget {
  final String? email;
  final bool isForgotPassword;
  const OtpInputSection({super.key, this.email, this.isForgotPassword = false});

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

  void _onVerify() {
    if (_otpController.text.length >= 4 && widget.email != null) {
      if (widget.isForgotPassword) {
        context.read<AuthCubit>().verifyResetToken(
          widget.email!,
          _otpController.text,
        );
      } else {
        context.read<AuthCubit>().verify(widget.email!, _otpController.text);
      }
    } else if (widget.email == null) {
      Alerts.showSnackBar(
        context,
        message: 'Email is missing',
        state: SnackState.failed,
      );
    }
  }

  void _onResend() {
    if (widget.email != null) {
      context.read<AuthCubit>().forgotPassword(widget.email!);
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
        } else if (state is ResetTokenVerifiedState) {
          if (state.isValid) {
            context.push(
              AppRoutes.resetPassword,
              extra: {'email': widget.email, 'token': _otpController.text},
            );
          } else {
            Alerts.showSnackBar(
              context,
              message: 'Invalid OTP',
              state: SnackState.failed,
            );
          }
        } else if (state is AuthErrorState) {
          Alerts.showSnackBar(
            context,
            message: state.message,
            state: SnackState.failed,
          );
        }
      },
      child: OtpFormWidget(
        otpController: _otpController,
        onVerify: _onVerify,
        onResend: _onResend,
        onCompleted: (pin) {
          if (widget.email != null) {
            if (widget.isForgotPassword) {
              context.read<AuthCubit>().verifyResetToken(widget.email!, pin);
            } else {
              context.read<AuthCubit>().verify(widget.email!, pin);
            }
          }
        },
      ),
    );
  }
}
