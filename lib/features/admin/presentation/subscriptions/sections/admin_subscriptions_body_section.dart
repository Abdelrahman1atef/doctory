import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import '../../../cubit/subscriptions/admin_subscriptions_cubit.dart';
import '../../../cubit/subscriptions/admin_subscriptions_states.dart';

class AdminSubscriptionsBodySection extends StatelessWidget {
  const AdminSubscriptionsBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminSubscriptionsCubit, AdminSubscriptionsState>(
      builder: (context, state) {
        if (state is AdminSubscriptionsLoading) return const Center(child: CircularProgressIndicator());
        if (state is AdminSubscriptionsError) return Center(child: Text(state.message));
        if (state is AdminSubscriptionsLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.items.length,
            itemBuilder: (_, i) {
              final p = state.items[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(p.name, style: AppStyles.s16Bold),
                          Chip(label: Text(p.badge, style: const TextStyle(fontSize: 11)),
                            backgroundColor: p.cssClass == 'plan-premium' ? AppColors.spicalColor.withAlpha(30) : AppColors.stitchPrimary.withAlpha(30)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('${p.duration} - \$${p.price.toStringAsFixed(0)}', style: AppStyles.s14Medium.withColor(AppColors.stitchPrimary)),
                      const SizedBox(height: 8),
                      ...p.features.map((f) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, size: 16, color: p.isActive ? AppColors.success : AppColors.grey4),
                            const SizedBox(width: 8),
                            Text(f, style: AppStyles.s12Medium.withColor(AppColors.textSecondary)),
                          ],
                        ),
                      )),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Chip(label: Text(p.isActive ? 'Active' : 'Inactive', style: const TextStyle(fontSize: 11)),
                            backgroundColor: p.isActive ? AppColors.success.withAlpha(30) : AppColors.errorColor.withAlpha(30)),
                          const Spacer(),
                          Text('\$${p.price.toStringAsFixed(0)}/${p.duration}', style: AppStyles.s18Bold.withColor(AppColors.stitchPrimary)),
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
