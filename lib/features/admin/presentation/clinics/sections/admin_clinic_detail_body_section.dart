import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';
import '../../../cubit/clinics/admin_clinics_cubit.dart';
import '../../../cubit/clinics/admin_clinics_states.dart';

class AdminClinicDetailBodySection extends StatelessWidget {
  const AdminClinicDetailBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminClinicsCubit, AdminClinicsState>(
      builder: (context, state) {
        if (state is AdminClinicsLoading) return const Center(child: CircularProgressIndicator());
        if (state is AdminClinicsError) return Center(child: Text(state.message));
        if (state is AdminClinicDetailLoaded) {
          final c = state.clinic;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
                    const SizedBox(width: 8),
                    Text(c.name, style: AppStyles.s20Bold),
                  ],
                ),
                const SizedBox(height: 16),
                _InfoRow('Specialty', c.specialty),
                _InfoRow('Location', c.location),
                _InfoRow('Phone', c.phone),
                _InfoRow('Manager', c.managerName),
                _InfoRow('Status', c.isActive ? 'Active' : 'Inactive'),
                _InfoRow('Rating', c.avgRating.toString()),
                _InfoRow('Doctors', c.doctorCount.toString()),
                _InfoRow('Staff', c.staffCount.toString()),
                const SizedBox(height: 16),
                Text('Description', style: AppStyles.s16Bold),
                const SizedBox(height: 4),
                Text(c.description, style: AppStyles.s14Medium.withColor(AppColors.textSecondary)),
                if (c.specializations.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text('Specializations', style: AppStyles.s16Bold),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: c.specializations.map((s) => Chip(label: Text(s, style: const TextStyle(fontSize: 12)))).toList(),
                  ),
                ],
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
