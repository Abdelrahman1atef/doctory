import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import '../../../cubit/specializations/admin_specializations_cubit.dart';
import '../../../cubit/specializations/admin_specializations_states.dart';
import '../widgets/admin_specialization_form_modal.dart';

class AdminSpecializationsBodySection extends StatelessWidget {
  const AdminSpecializationsBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AdminSpecializationsCubit>();
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search specializations...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onChanged: (v) => cubit.filter(v, ''),
                ),
              ),
              const SizedBox(width: 12),
              DropdownButton<String>(
                hint: const Text('All'),
                items: const [
                  DropdownMenuItem(value: '', child: Text('All')),
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                ],
                onChanged: (v) => cubit.filter('', v ?? ''),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => showDialog(context: context, builder: (_) => BlocProvider.value(value: cubit, child: const AdminSpecializationFormModal())),
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<AdminSpecializationsCubit, AdminSpecializationsState>(
            builder: (context, state) {
              if (state is AdminSpecializationsLoading) return const Center(child: CircularProgressIndicator());
              if (state is AdminSpecializationsError) return Center(child: Text(state.message));
              if (state is AdminSpecializationsLoaded) {
                if (state.items.isEmpty) return const Center(child: Text('No specializations found'));
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.items.length,
                  itemBuilder: (_, i) {
                    final item = state.items[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Text(item.icon, style: const TextStyle(fontSize: 32)),
                        title: Text(item.nameAr.isNotEmpty ? item.nameAr : item.name, style: AppStyles.s14Bold),
                        subtitle: Text(item.description, style: AppStyles.s12Medium.withColor(AppColors.textSecondary)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Switch(
                              value: item.isActive,
                              onChanged: (_) => cubit.toggleStatus(item.id),
                              activeThumbColor: AppColors.stitchPrimary,
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18),
                              onPressed: () => showDialog(context: context, builder: (_) => BlocProvider.value(value: cubit, child: AdminSpecializationFormModal(editItem: item))),
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
          ),
        ),
      ],
    );
  }
}
