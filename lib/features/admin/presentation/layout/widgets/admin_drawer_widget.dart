import 'package:flutter/material.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/admin/presentation/layout/widgets/admin_drawer_item_widget.dart';
import 'package:doctory/features/admin/router/admin_router_names.dart';

class AdminDrawerWidget extends StatelessWidget {
  const AdminDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.stitchPrimary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.admin_panel_settings, size: 32, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text('Admin Panel', style: AppStyles.s20Bold.withColor(Colors.white)),
                Text('System Administrator', style: AppStyles.s14Medium.withColor(Colors.white70)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: const [
                AdminDrawerItemWidget(icon: Icons.dashboard_rounded, label: 'Dashboard', route: AdminRoutes.dashboard),
                AdminDrawerItemWidget(icon: Icons.local_hospital_rounded, label: 'Specializations', route: AdminRoutes.specializations),
                AdminDrawerItemWidget(icon: Icons.business_rounded, label: 'Clinics', route: AdminRoutes.clinicas),
                AdminDrawerItemWidget(icon: Icons.person_rounded, label: 'Doctors', route: AdminRoutes.doctors),
                AdminDrawerItemWidget(icon: Icons.headset_mic_rounded, label: 'Support', route: AdminRoutes.support),
                AdminDrawerItemWidget(icon: Icons.campaign_rounded, label: 'Ads', route: AdminRoutes.ads),
                AdminDrawerItemWidget(icon: Icons.people_rounded, label: 'Users', route: AdminRoutes.users),
                AdminDrawerItemWidget(icon: Icons.verified_rounded, label: 'Verification', route: AdminRoutes.verification),
                AdminDrawerItemWidget(icon: Icons.note_add_rounded, label: 'Pending Clinics', route: AdminRoutes.pendingClinics),
                AdminDrawerItemWidget(icon: Icons.subscriptions_rounded, label: 'Subscriptions', route: AdminRoutes.subscriptions),
                AdminDrawerItemWidget(icon: Icons.payment_rounded, label: 'Payments', route: AdminRoutes.payments),
                Divider(height: 1, color: AppColors.divider),
                AdminDrawerItemWidget(icon: Icons.person_outline_rounded, label: 'Profile', route: AdminRoutes.profile),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
