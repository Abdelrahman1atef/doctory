import 'package:doctory/core/session/user_session.dart';
import 'package:doctory/features/home/presentation/widgets/home_header_widget.dart';
import 'package:flutter/material.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: UserSession.userNotifier,
      builder: (context, user, child) {
        final String userName = (user is Map)
            ? (user['fullName'] ?? user['name'] ?? 'User').toString()
            : 'User';
        final String? imageUrl = (user is Map)
            ? (user['image'] ?? user['avatar'])?.toString()
            : null;
        final String? role = (user is Map)
            ? (user['role']?.toString())
            : null;

        return HomeHeaderWidget(
          userName: userName,
          imageUrl: imageUrl,
          userRole: role,
        );
      },
    );
  }
}
