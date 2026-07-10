import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';
import '../../../cubit/clinics/admin_clinics_cubit.dart';
import '../../../cubit/clinics/admin_clinics_states.dart';
import '../../../router/admin_router_names.dart';

class AdminClinicsBodySection extends StatelessWidget {
  const AdminClinicsBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminClinicsCubit, AdminClinicsState>(
      builder: (context, state) {
        if (state is AdminClinicsLoading) return const Center(child: CircularProgressIndicator());
        if (state is AdminClinicsError) return Center(child: Text(state.message));
        if (state is AdminClinicsLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.items.length,
            itemBuilder: (_, i) {
              final item = state.items[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.stitchPrimary.withAlpha(30),
                    child: Text(item.name[0], style: AppStyles.s18Bold.withColor(AppColors.stitchPrimary)),
                  ),
                  title: Text(item.name, style: AppStyles.s16Bold),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${item.specialty} - ${item.location}', style: AppStyles.s12Medium.withColor(AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Chip(label: Text(item.isActive ? 'Active' : 'Inactive', style: const TextStyle(fontSize: 11)),
                            backgroundColor: item.isActive ? AppColors.success.withAlpha(30) : AppColors.errorColor.withAlpha(30)),
                          const SizedBox(width: 8),
                          Text('${item.doctorCount} doctors', style: AppStyles.s12Medium.withColor(AppColors.textHint)),
                          const SizedBox(width: 8),
                          Text('${item.avgRating} ★', style: AppStyles.s12Medium.withColor(AppColors.rate)),
                        ],
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('${AdminRoutes.clinicas}/${item.id}'),
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
