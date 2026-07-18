import 'package:doctory/core/session/user_session.dart';
import 'package:doctory/features/home/cubit/home_cubit.dart';
import 'package:doctory/features/home/cubit/home_states.dart';
import 'package:doctory/features/home/presentation/widgets/home_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final unreadCount = context.select<HomeCubit, int>((cubit) {
      final state = cubit.state;
      if (state is HomeSuccessState) return state.unreadCount;
      return 0;
    });

    return ValueListenableBuilder(
      valueListenable: UserSession.userNotifier,
      builder: (context, user, child) {
        final String userName = (user is Map)
            ? (user['fullName'] ?? user['name'] ?? 'User').toString()
            : 'User';
        final String? imageUrl = (user is Map)
            ? (user['profilePictureUrl'] ?? user['avatar'])?.toString()
            : null;
        final String? role = (user is Map)
            ? (user['role'] ?? user['roles'])?.toString()
            : null;

        return HomeHeaderWidget(
          userName: userName,
          imageUrl: imageUrl,
          userRole: role,
          doctorType: UserSession.currentDoctorType,
          unreadCount: unreadCount,
        );
      },
    );
  }
}
