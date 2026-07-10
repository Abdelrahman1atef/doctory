import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/theme/app_colors.dart';
import '../../../cubit/specializations/admin_specializations_cubit.dart';
import '../../../data/model/specialization_model.dart';

class AdminSpecializationFormModal extends StatefulWidget {
  final AdminSpecializationModel? editItem;

  const AdminSpecializationFormModal({super.key, this.editItem});

  @override
  State<AdminSpecializationFormModal> createState() => _AdminSpecializationFormModalState();
}

class _AdminSpecializationFormModalState extends State<AdminSpecializationFormModal> {
  late TextEditingController _nameCtl;
  late TextEditingController _nameArCtl;
  late TextEditingController _descCtl;
  late TextEditingController _iconCtl;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameCtl = TextEditingController(text: widget.editItem?.name ?? '');
    _nameArCtl = TextEditingController(text: widget.editItem?.nameAr ?? '');
    _descCtl = TextEditingController(text: widget.editItem?.description ?? '');
    _iconCtl = TextEditingController(text: widget.editItem?.icon ?? '🫀');
    _isActive = widget.editItem?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _nameArCtl.dispose();
    _descCtl.dispose();
    _iconCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editItem != null;
    final cubit = context.read<AdminSpecializationsCubit>();
    return AlertDialog(
      title: Text(isEdit ? 'Edit Specialization' : 'Add Specialization'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nameCtl, decoration: const InputDecoration(labelText: 'Name (EN)', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _nameArCtl, decoration: const InputDecoration(labelText: 'Name (AR)', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _descCtl, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()), maxLines: 2),
            const SizedBox(height: 12),
            TextField(controller: _iconCtl, decoration: const InputDecoration(labelText: 'Icon (emoji)', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Active'),
              value: _isActive,
              onChanged: (v) => setState(() => _isActive = v),
              activeThumbColor: AppColors.stitchPrimary,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final model = AdminSpecializationModel(
              id: widget.editItem?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
              name: _nameCtl.text,
              nameAr: _nameArCtl.text,
              description: _descCtl.text,
              icon: _iconCtl.text,
              isActive: _isActive,
            );
            if (isEdit) { cubit.update(model); } else { cubit.add(model); }
            Navigator.pop(context);
          },
          child: Text(isEdit ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}
