import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/features/auth/cubit/auth_cubit.dart';
import 'package:doctory/features/auth/presentation/views/login_view.dart';
import 'package:doctory/features/auth/presentation/views/otp_verification_view.dart';
import 'package:doctory/features/auth/presentation/views/complete_profile_view.dart';
import 'package:doctory/features/auth/presentation/views/clinic_complete_profile_view.dart';
import 'package:doctory/features/auth/presentation/views/forgot_password_view.dart';
import 'package:doctory/features/auth/presentation/views/register_view.dart';
import 'package:doctory/features/auth/presentation/views/reset_password_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthRouter {
  static final List<GoRoute> routes = [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<AuthCubit>(),
        child: const LoginView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<AuthCubit>(),
        child: const RegisterView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.otpVerification,
      builder: (context, state) {
        final extra = state.extra;
        String? email;
        bool isForgotPassword = false;

        if (extra is Map<String, dynamic>) {
          email = extra['email'] as String?;
          isForgotPassword = extra['isForgotPassword'] as bool? ?? false;
        } else if (extra is String) {
          email = extra;
        }

        return BlocProvider(
          create: (context) => sl<AuthCubit>(),
          child: OtpVerificationView(
            email: email,
            isForgotPassword: isForgotPassword,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.completeProfile,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<AuthCubit>(),
        child: const CompleteProfileView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.clinicCompleteProfile,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<AuthCubit>(),
        child: const ClinicCompleteProfileView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<AuthCubit>(),
        child: const ForgotPasswordView(),
      ),
    ),
    GoRoute(
      path: AppRoutes.resetPassword,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return BlocProvider(
          create: (context) => sl<AuthCubit>(),
          child: ResetPasswordView(
            email: extra['email'] as String,
            token: extra['token'] as String,
          ),
        );
      },
    ),
  ];
}
