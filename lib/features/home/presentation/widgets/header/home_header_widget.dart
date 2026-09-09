import 'package:doctory/core/common/models/role.dart';
import 'package:doctory/features/home/presentation/widgets/header/home_greeting_widget.dart';
import 'package:doctory/features/home/presentation/widgets/header/home_header_actions_widget.dart';
import 'package:flutter/material.dart';

/// Home screen header. Owns the status-bar inset — the layout is edge-to-edge,
/// so no ancestor adds it for us.
class HomeHeaderWidget extends StatelessWidget {
  final String userName;
  final String? imageUrl;
  final String? userRole;
  final DoctorEmploymentType? doctorType;
  final VoidCallback onNotificationTap;
  final int unreadCount;

  const HomeHeaderWidget({
    super.key,
    required this.userName,
    required this.onNotificationTap,
    this.imageUrl,
    this.userRole,
    this.doctorType,
    this.unreadCount = 0,
  });

  bool get _isDoctorOrOwner {
    final String role = userRole?.toLowerCase() ?? '';
    return role == 'doctor' || role == 'clinicowner';
  }

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.paddingOf(context).top;
    return Padding(
      padding: EdgeInsetsDirectional.only(top: topInset),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: HomeGreetingWidget(
              userName: userName,
              doctorType: doctorType,
            ),
          ),
          HomeHeaderActionsWidget(
            isDoctorOrOwner: _isDoctorOrOwner,
            imageUrl: imageUrl,
            doctorType: doctorType,
            unreadCount: unreadCount,
            onNotificationTap: onNotificationTap,
          ),
        ],
      ),
    );
  }
}
