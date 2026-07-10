import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import '../../../cubit/payments/admin_payments_cubit.dart';
import '../../../cubit/payments/admin_payments_states.dart';

class AdminPaymentsBodySection extends StatelessWidget {
  const AdminPaymentsBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminPaymentsCubit, AdminPaymentsState>(
      builder: (context, state) {
        if (state is AdminPaymentsLoading) return const Center(child: CircularProgressIndicator());
        if (state is AdminPaymentsError) return Center(child: Text(state.message));
        if (state is AdminPaymentsLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.items.length,
            itemBuilder: (_, i) {
              final p = state.items[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text('${p.code} - ${p.payerName}', style: AppStyles.s14Bold),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${p.type} - ${p.method}', style: AppStyles.s12Medium.withColor(AppColors.textSecondary)),
                      Row(
                        children: [
                          Text('\$${p.amount.toStringAsFixed(0)}', style: AppStyles.s16Bold.withColor(AppColors.stitchPrimary)),
                          const SizedBox(width: 8),
                          Chip(label: Text(p.status, style: const TextStyle(fontSize: 11)), backgroundColor: p.status == 'مكتملة' ? AppColors.success.withAlpha(30) : p.status == 'معلقة' ? AppColors.warning.withAlpha(30) : AppColors.errorColor.withAlpha(30)),
                        ],
                      ),
                    ],
                  ),
                  trailing: Text(p.date, style: AppStyles.s12Medium.withColor(AppColors.textHint)),
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
