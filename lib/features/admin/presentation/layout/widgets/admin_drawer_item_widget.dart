import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';

class AdminDrawerItemWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;

  const AdminDrawerItemWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = GoRouterState.of(context).matchedLocation == route;

    return ListTile(
      leading: Icon(icon, color: isActive ? AppColors.stitchPrimary : AppColors.textSecondary),
      title: Text(
        label,
        style: isActive
            ? AppStyles.s14Bold.withColor(AppColors.stitchPrimary)
            : AppStyles.s14Medium.withColor(AppColors.textSecondary),
      ),
      trailing: isActive
          ? Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.stitchPrimary,
                borderRadius: BorderRadius.circular(2),
              ),
            )
          : null,
      onTap: () {
        Navigator.of(context).pop();
        context.pushReplacement(route);
      },
    );
  }
}
