import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';
import '../../../cubit/doctors/admin_doctors_cubit.dart';
import '../../../cubit/doctors/admin_doctors_states.dart';
import '../../../data/model/doctor_model.dart';
import '../../../router/admin_router_names.dart';

class AdminDoctorsBodySection extends StatelessWidget {
  const AdminDoctorsBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminDoctorsCubit, AdminDoctorsState>(
      builder: (context, state) {
        if (state is AdminDoctorsLoading) return const Center(child: CircularProgressIndicator());
        if (state is AdminDoctorsError) return Center(child: Text(state.message));
        if (state is AdminDoctorsLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.items.length,
            itemBuilder: (_, i) {
              final d = state.items[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.stitchPrimary.withAlpha(30),
                    child: Text(d.name[0], style: AppStyles.s16Bold.withColor(AppColors.stitchPrimary)),
                  ),
                  title: Text(d.name, style: AppStyles.s14Bold),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${d.specialty} - ${d.degree}', style: AppStyles.s12Medium.withColor(AppColors.textSecondary)),
                      Row(
                        children: [
                          _TypeBadge(d.employmentType),
                          const SizedBox(width: 8),
                          if (d.clinicName != null) Text(d.clinicName!, style: AppStyles.s12Medium.withColor(AppColors.textHint)),
                        ],
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(value: d.isActive, onChanged: null, activeThumbColor: AppColors.stitchPrimary),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () => context.push('${AdminRoutes.doctors}/${d.id}'),
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

class _TypeBadge extends StatelessWidget {
  final DoctorEmploymentType type;
  const _TypeBadge(this.type);

  @override
  Widget build(BuildContext context) {
    final map = {DoctorEmploymentType.freelance: 'Freelance', DoctorEmploymentType.ownClinic: 'Own Clinic', DoctorEmploymentType.inCenter: 'In Center'};
    return Chip(label: Text(map[type]!, style: const TextStyle(fontSize: 11)), backgroundColor: AppColors.info.withAlpha(30), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, visualDensity: VisualDensity.compact);
  }
}
