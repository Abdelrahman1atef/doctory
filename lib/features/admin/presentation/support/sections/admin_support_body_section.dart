import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import '../../../cubit/support/admin_support_cubit.dart';
import '../../../cubit/support/admin_support_states.dart';

class AdminSupportBodySection extends StatelessWidget {
  const AdminSupportBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminSupportCubit, AdminSupportState>(
      builder: (context, state) {
        if (state is AdminSupportLoading) return const Center(child: CircularProgressIndicator());
        if (state is AdminSupportError) return Center(child: Text(state.message));
        if (state is AdminSupportLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.items.length,
            itemBuilder: (_, i) {
              final t = state.items[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: _PriorityIcon(t.priority),
                  title: Text(t.subject, style: AppStyles.s14Bold),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${t.code} - ${t.reporter}', style: AppStyles.s12Medium.withColor(AppColors.textSecondary)),
                      Row(
                        children: [
                          _StatusChip(t.status),
                          const SizedBox(width: 8),
                          _PriorityBadge(t.priority),
                          if (t.hasAttachments) ...[const SizedBox(width: 8), const Icon(Icons.attach_file, size: 14, color: AppColors.textHint)],
                        ],
                      ),
                    ],
                  ),
                  trailing: Text(t.date, style: AppStyles.s12Medium.withColor(AppColors.textHint)),
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

class _PriorityIcon extends StatelessWidget {
  final String priority;
  const _PriorityIcon(this.priority);

  @override
  Widget build(BuildContext context) {
    final color = priority == 'عالية' ? AppColors.errorColor : priority == 'متوسطة' ? AppColors.warning : AppColors.info;
    return Icon(Icons.circle, color: color, size: 12);
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip(this.status);

  @override
  Widget build(BuildContext context) {
    final color = status == 'مفتوح' ? AppColors.warning : status == 'قيد المعالجة' ? AppColors.info : AppColors.success;
    return Chip(label: Text(status, style: const TextStyle(fontSize: 10)), backgroundColor: color.withAlpha(30), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, visualDensity: VisualDensity.compact);
  }
}

class _PriorityBadge extends StatelessWidget {
  final String priority;
  const _PriorityBadge(this.priority);

  @override
  Widget build(BuildContext context) {
    final color = priority == 'عالية' ? AppColors.errorColor : priority == 'متوسطة' ? AppColors.warning : AppColors.info;
    return Chip(label: Text(priority, style: const TextStyle(fontSize: 10)), backgroundColor: color.withAlpha(30), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, visualDensity: VisualDensity.compact);
  }
}
