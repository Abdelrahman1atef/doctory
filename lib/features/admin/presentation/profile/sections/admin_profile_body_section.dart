import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import '../../../cubit/profile/admin_profile_cubit.dart';
import '../../../cubit/profile/admin_profile_states.dart';

class AdminProfileBodySection extends StatelessWidget {
  const AdminProfileBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminProfileCubit, AdminProfileState>(
      builder: (context, state) {
        if (state is AdminProfileLoading) return const Center(child: CircularProgressIndicator());
        if (state is AdminProfileError) return Center(child: Text(state.message));
        if (state is AdminProfileLoaded) {
          final p = state.profile;
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.stitchPrimary.withAlpha(30),
                  child: Text(p.initials, style: AppStyles.s32Bold.withColor(AppColors.stitchPrimary)),
                ),
                const SizedBox(height: 12),
                Text(p.name, style: AppStyles.s24Bold),
                Text(p.role, style: AppStyles.s14Medium.withColor(AppColors.textSecondary)),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _ProfileRow('Email', p.email),
                        const Divider(),
                        _ProfileRow('Phone', p.phone),
                        const Divider(),
                        _ProfileRow('Permission', p.permissionLevel),
                        const Divider(),
                        _ProfileRow('Registered', p.registeredAt),
                        const Divider(),
                        _ProfileRow('Last Login', p.lastLogin),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String label, value;
  const _ProfileRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: AppStyles.s14Bold.withColor(AppColors.textSecondary)), Text(value, style: AppStyles.s14Medium)],
      ),
    );
  }
}
