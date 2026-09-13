import 'package:doctory/core/common/models/role.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/services/deep_link_service.dart';
import 'package:doctory/core/session/user_session.dart';
import 'package:doctory/features/intro/cubit/intro_cubit.dart';
import 'package:doctory/features/intro/cubit/intro_states.dart';
import 'package:doctory/features/intro/presentation/sections/splash_body_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../features/admin/router/admin_router_names.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<IntroCubit, IntroStates>(
      listener: (context, state) {
        if (state is NavigateToIntroState) {
          context.go(AppRoutes.intro);
        } else if (state is NavigateToLoginState) {
          context.go(AppRoutes.welcome);
        } else if (state is NavigateToMainState) {
          final pendingPath = DeepLinkService.instance.consumePendingPath();
          if (pendingPath != null) {
            context.go(pendingPath);
            return;
          }

          if (UserSession.currentRole == UserRole.superAdmin) {
            context.go(AdminRoutes.admin);
            return;
          }

          String destination;
          Object? extra;

          if (UserSession.currentRole == UserRole.clinicOwner) {
            if (!UserSession.isClinicSetupComplete) {
              destination = AppRoutes.clinicCompleteProfile;
              extra = {'isSetupMode': true};
            } else if (UserSession.verificationStatus == 'Pending' || UserSession.clinicStatus == 'Suspended') {
              destination = AppRoutes.clinicPendingApproval;
            } else if (UserSession.verificationStatus == 'Rejected') {
              destination = AppRoutes.clinicRejected;
            } else {
              destination = AppRoutes.clinicDashboard;
            }
          } else {
            destination = AppRoutes.home;
          }

          context.go(destination, extra: extra);
        }
      },
      child: const Scaffold(body: SplashBodySection()),
    );
  }
}
