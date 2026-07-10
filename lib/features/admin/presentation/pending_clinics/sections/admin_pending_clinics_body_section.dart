import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import '../../../cubit/pending_clinics/admin_pending_clinics_cubit.dart';
import '../../../cubit/pending_clinics/admin_pending_clinics_states.dart';
import '../../../data/model/pending_clinic_model.dart';

class AdminPendingClinicsBodySection extends StatelessWidget {
  const AdminPendingClinicsBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminPendingClinicsCubit, AdminPendingClinicsState>(
      builder: (context, state) {
        if (state is AdminPendingClinicsLoading) return const Center(child: CircularProgressIndicator());
        if (state is AdminPendingClinicsError) return Center(child: Text(state.message));
        if (state is AdminPendingClinicsLoaded) {
          final items = state.items;
          final total = items.length;
          final pending = items.where((e) => e.status == PendingClinicStatus.pending).length;
          final approved = items.where((e) => e.status == PendingClinicStatus.approved).length;
          final rejected = items.where((e) => e.status == PendingClinicStatus.rejected).length;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Wrap(
                spacing: 12, runSpacing: 12,
                children: [
                  _MiniStat('Total', '$total', AppColors.stitchPrimary),
                  _MiniStat('Pending', '$pending', AppColors.warning),
                  _MiniStat('Approved', '$approved', AppColors.success),
                  _MiniStat('Rejected', '$rejected', AppColors.errorColor),
                ],
              ),
              const SizedBox(height: 16),
              ...items.map((item) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(item.clinicName, style: AppStyles.s14Bold),
                  subtitle: Text('${item.doctorName} - ${item.package}', style: AppStyles.s12Medium.withColor(AppColors.textSecondary)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _StatusChip(item.status),
                      if (item.status == PendingClinicStatus.pending) ...[
                        IconButton(
                          icon: const Icon(Icons.check_circle, color: AppColors.success),
                          onPressed: () => context.read<AdminPendingClinicsCubit>().updateStatus(item.id, PendingClinicStatus.approved),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel, color: AppColors.errorColor),
                          onPressed: () => context.read<AdminPendingClinicsCubit>().updateStatus(item.id, PendingClinicStatus.rejected),
                        ),
                      ],
                    ],
                  ),
                ),
              )),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _MiniStat(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withAlpha(60))),
      child: Column(children: [Text(value, style: AppStyles.s20Bold.withColor(color)), Text(label, style: AppStyles.s12Medium.withColor(AppColors.textSecondary))]),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final PendingClinicStatus status;
  const _StatusChip(this.status);

  @override
  Widget build(BuildContext context) {
    final map = {PendingClinicStatus.pending: 'Pending', PendingClinicStatus.approved: 'Approved', PendingClinicStatus.rejected: 'Rejected', PendingClinicStatus.paid: 'Paid'};
    final colorMap = {PendingClinicStatus.pending: AppColors.warning, PendingClinicStatus.approved: AppColors.success, PendingClinicStatus.rejected: AppColors.errorColor, PendingClinicStatus.paid: AppColors.stitchPrimary};
    return Chip(label: Text(map[status]!, style: const TextStyle(fontSize: 10)), backgroundColor: colorMap[status]!.withAlpha(30), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, visualDensity: VisualDensity.compact);
  }
}
