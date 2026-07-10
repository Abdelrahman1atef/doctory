import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import '../../../cubit/users/admin_users_cubit.dart';
import '../../../cubit/users/admin_users_states.dart';

class AdminUsersBodySection extends StatelessWidget {
  const AdminUsersBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminUsersCubit, AdminUsersState>(
      builder: (context, state) {
        if (state is AdminUsersLoading) return const Center(child: CircularProgressIndicator());
        if (state is AdminUsersError) return Center(child: Text(state.message));
        if (state is AdminUsersLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.items.length,
            itemBuilder: (_, i) {
              final u = state.items[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: u.role == 'clinic_owner' ? AppColors.warning.withAlpha(30) : AppColors.stitchPrimary.withAlpha(30),
                    child: Text(u.name[0], style: AppStyles.s16Bold.withColor(u.role == 'clinic_owner' ? AppColors.warning : AppColors.stitchPrimary)),
                  ),
                  title: Text(u.name, style: AppStyles.s14Bold),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(u.email, style: AppStyles.s12Medium.withColor(AppColors.textSecondary)),
                      Row(
                        children: [
                          Chip(label: Text(u.role, style: const TextStyle(fontSize: 11)), backgroundColor: AppColors.info.withAlpha(20), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, visualDensity: VisualDensity.compact),
                          const SizedBox(width: 8),
                          Text('${u.totalVisits} visits', style: AppStyles.s12Medium.withColor(AppColors.textHint)),
                          if (u.avgRating > 0) ...[const SizedBox(width: 8), Text('${u.avgRating} ★', style: AppStyles.s12Medium.withColor(AppColors.rate))],
                        ],
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(value: u.isActive, onChanged: null, activeThumbColor: AppColors.stitchPrimary),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
