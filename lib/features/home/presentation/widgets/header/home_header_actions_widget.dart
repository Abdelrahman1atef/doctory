import 'package:doctory/core/common/models/role.dart';
import 'package:doctory/core/common/widgets/images/doctor_avatar_badge.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/home/presentation/widgets/header/home_avatar_widget.dart';
import 'package:doctory/features/home/presentation/widgets/header/home_notification_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Trailing side of the home header: notifications plus the profile avatar.
class HomeHeaderActionsWidget extends StatelessWidget {
  final String? imageUrl;
  final bool isDoctorOrOwner;
  final DoctorEmploymentType? doctorType;
  final int unreadCount;
  final VoidCallback onNotificationTap;

  const HomeHeaderActionsWidget({
    super.key,
    required this.isDoctorOrOwner,
    required this.unreadCount,
    required this.onNotificationTap,
    this.imageUrl,
    this.doctorType,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        HomeNotificationButtonWidget(
          unreadCount: unreadCount,
          onTap: onNotificationTap,
        ),
        4.pw,
        if (isDoctorOrOwner)
          DoctorAvatarBadge(
            imageUrl: imageUrl?.toImageUrl,
            size: 60,
            isFreelance: doctorType == DoctorEmploymentType.freelance,
            onTap: () => context.push(AppRoutes.clinicDashboard),
          )
        else
          HomeAvatarWidget(imageUrl: imageUrl),
      ],
    );
  }
}
