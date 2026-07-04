import 'package:flutter/material.dart';
import '../widgets/register_body_widget.dart';
import '../widgets/register_header_widget.dart';
import '../widgets/role_selection_widget.dart';
import 'register_form_section.dart';

class RegisterBodySection extends StatefulWidget {
  const RegisterBodySection({super.key});

  @override
  State<RegisterBodySection> createState() => _RegisterBodySectionState();
}

class _RegisterBodySectionState extends State<RegisterBodySection> {
  String? _selectedRole;

  void _onRoleSelected(String role) {
    setState(() => _selectedRole = role);
  }

  void _onBack() {
    setState(() => _selectedRole = null);
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedRole == null) {
      return RegisterBodyWidget(
        header: const RegisterHeaderWidget(),
        form: RoleSelectionWidget(
          selectedRole: _selectedRole,
          onRoleSelected: _onRoleSelected,
        ),
      );
    }

    return RegisterBodyWidget(
      header: const RegisterHeaderWidget(),
      form: RegisterFormSection(
        role: _selectedRole!,
      ),
      showBackButton: true,
      onBack: _onBack,
    );
  }
}