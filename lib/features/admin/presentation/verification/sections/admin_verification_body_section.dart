import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import '../../../cubit/verification/admin_verification_cubit.dart';
import '../../../cubit/verification/admin_verification_states.dart';

class AdminVerificationBodySection extends StatelessWidget {
  const AdminVerificationBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminVerificationCubit, AdminVerificationState>(
      builder: (context, state) {
        if (state is AdminVerificationLoading) return const Center(child: CircularProgressIndicator());
        if (state is AdminVerificationError) return Center(child: Text(state.message));
        if (state is AdminVerificationLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.items.length,
            itemBuilder: (_, i) {
              final v = state.items[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.stitchPrimary.withAlpha(30),
                            child: Text(v.doctorName[0], style: AppStyles.s18Bold.withColor(AppColors.stitchPrimary)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(v.doctorName, style: AppStyles.s16Bold),
                              Text('${v.specialty} - ${v.degree}', style: AppStyles.s12Medium.withColor(AppColors.textSecondary)),
                            ],
                          )),
                          Chip(label: Text(v.status, style: const TextStyle(fontSize: 11)), backgroundColor: AppColors.warning.withAlpha(30)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _InfoRow('Syndicate', v.syndicateId),
                      _InfoRow('Tax Registry', v.taxRegistry),
                      _InfoRow('Phone', v.phone),
                      _InfoRow('Email', v.email),
                      _InfoRow('Requested', v.requestDate),
                      if (v.documents.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text('Documents (${v.documents.length})', style: AppStyles.s14Bold),
                        const SizedBox(height: 4),
                        ...v.documents.map((d) => Row(
                          children: [const Icon(Icons.description, size: 16, color: AppColors.info), const SizedBox(width: 4), Text(d, style: AppStyles.s12Medium.withColor(AppColors.textSecondary))],
                        )),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton.icon(
                            icon: const Icon(Icons.check, size: 18),
                            label: const Text('Accept'),
                            style: OutlinedButton.styleFrom(foregroundColor: AppColors.success),
                            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Doctor verified'))),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.close, size: 18),
                            label: const Text('Reject'),
                            style: OutlinedButton.styleFrom(foregroundColor: AppColors.errorColor),
                            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verification rejected'))),
                          ),
                        ],
                      ),
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

class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(children: [SizedBox(width: 100, child: Text(label, style: AppStyles.s12Bold.withColor(AppColors.textSecondary))), Text(value, style: AppStyles.s12Medium)]),
    );
  }
}
