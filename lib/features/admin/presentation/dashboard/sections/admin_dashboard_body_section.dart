import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import '../../../cubit/dashboard/admin_dashboard_cubit.dart';
import '../../../cubit/dashboard/admin_dashboard_states.dart';

class AdminDashboardBodySection extends StatelessWidget {
  const AdminDashboardBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
      builder: (context, state) {
        if (state is AdminDashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is AdminDashboardError) {
          return Center(child: Text(state.message));
        }
        if (state is AdminDashboardLoaded) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dashboard', style: AppStyles.s24Bold.withColor(AppColors.textPrimary)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _StatCard(title: 'Verifications', value: '${state.stats.totalVerifications}', icon: Icons.verified, color: AppColors.stitchPrimary),
                    _StatCard(title: 'Active Clinics', value: '${state.stats.activeClinics}', icon: Icons.business, color: AppColors.info),
                    _StatCard(title: 'Specializations', value: '${state.stats.specializationsCount}', icon: Icons.local_hospital, color: AppColors.warning),
                    _StatCard(title: 'Users', value: '${state.stats.totalUsers}', icon: Icons.people, color: AppColors.success),
                    _StatCard(title: 'Open Tickets', value: '${state.stats.openTickets}', icon: Icons.headset_mic, color: AppColors.errorColor),
                    _StatCard(title: 'Scheduled Ads', value: '${state.stats.scheduledAds}', icon: Icons.campaign, color: AppColors.spicalColor),
                    _StatCard(title: 'Expired Subs', value: '${state.stats.expiredSubscriptions}', icon: Icons.subscriptions, color: AppColors.grey5),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Urgent Tickets', style: AppStyles.s18Bold.withColor(AppColors.textPrimary)),
                const SizedBox(height: 8),
                ...state.tickets.map((t) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.warning_amber, color: AppColors.errorColor),
                    title: Text(t.subject, style: AppStyles.s14Medium),
                    subtitle: Text('${t.reporter} - ${t.date}', style: AppStyles.s12Medium.withColor(AppColors.textSecondary)),
                    trailing: Chip(label: Text(t.priority, style: const TextStyle(fontSize: 12)), backgroundColor: AppColors.errorColor.withAlpha(30)),
                  ),
                )),
                const SizedBox(height: 24),
                Text('Activity Log', style: AppStyles.s18Bold.withColor(AppColors.textPrimary)),
                const SizedBox(height: 8),
                ...state.activities.map((a) => Card(
                  margin: const EdgeInsets.only(bottom: 6),
                  child: ListTile(
                    dense: true,
                    leading: const Icon(Icons.circle, size: 8, color: AppColors.stitchPrimary),
                    title: Text(a.action, style: AppStyles.s14Medium),
                    subtitle: Text('${a.user} - ${a.detail}', style: AppStyles.s12Medium.withColor(AppColors.textSecondary)),
                    trailing: Text(a.date, style: AppStyles.s12Medium.withColor(AppColors.textHint)),
                  ),
                )),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, style: AppStyles.s24Bold.withColor(AppColors.textPrimary)),
          Text(title, style: AppStyles.s12Medium.withColor(AppColors.textSecondary)),
        ],
      ),
    );
  }
}
