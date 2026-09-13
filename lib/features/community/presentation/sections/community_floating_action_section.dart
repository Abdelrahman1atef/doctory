import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/community/presentation/widgets/community_floating_action_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctory/core/session/user_session.dart';
import 'package:doctory/core/common/models/role.dart';

class CommunityFloatingActionSection extends StatelessWidget {
  const CommunityFloatingActionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: UserSession.userNotifier,
      builder: (context, user, child) {
        if (UserSession.currentRole != UserRole.clinicOwner && UserSession.currentRole != UserRole.doctor) {
          return const SizedBox.shrink();
        }
        return CommunityFloatingActionWidget(
          onPressed: () {
            context.push(AppRoutes.createPost);
          },
        );
      },
    );
  }
}
