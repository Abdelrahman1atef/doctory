import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';
import '../../../cubit/doctors/admin_doctors_cubit.dart';
import '../../../cubit/doctors/admin_doctors_states.dart';

class AdminDoctorDetailBodySection extends StatelessWidget {
  const AdminDoctorDetailBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminDoctorsCubit, AdminDoctorsState>(
      builder: (context, state) {
        if (state is AdminDoctorsLoading) return const Center(child: CircularProgressIndicator());
        if (state is AdminDoctorsError) return Center(child: Text(state.message));
        if (state is AdminDoctorDetailLoaded) {
          final d = state.doctor;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
                    const SizedBox(width: 8),
                    Text(d.name, style: AppStyles.s20Bold),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.stitchPrimary.withAlpha(30),
                    child: Text(d.name[0], style: AppStyles.s28Bold.withColor(AppColors.stitchPrimary)),
                  ),
                ),
                const SizedBox(height: 16),
                _InfoRow('Specialty', d.specialty),
                _InfoRow('Degree', d.degree),
                _InfoRow('Phone', d.phone),
                _InfoRow('Email', d.email),
                _InfoRow('Type', d.employmentType.name),
                _InfoRow('Status', d.isActive ? 'Active' : 'Inactive'),
                if (d.clinicName != null) _InfoRow('Clinic', d.clinicName!),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label, style: AppStyles.s14Bold.withColor(AppColors.textSecondary))),
          Expanded(child: Text(value, style: AppStyles.s14Medium)),
        ],
      ),
    );
  }
}
