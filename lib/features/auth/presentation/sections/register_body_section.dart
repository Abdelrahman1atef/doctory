import 'package:flutter/material.dart';
import '../widgets/register_body_widget.dart';
import '../widgets/register_header_widget.dart';
import '../widgets/role_selection_widget.dart';
import '../widgets/doctor_type_selection_widget.dart';
import 'register_form_section.dart';

class RegisterBodySection extends StatefulWidget {
  const RegisterBodySection({super.key});

  @override
  State<RegisterBodySection> createState() => _RegisterBodySectionState();
}

class _RegisterBodySectionState extends State<RegisterBodySection> {
  String? _selectedRole;
  String? _doctorType;

  void _onRoleSelected(String role) {
    setState(() {
      _selectedRole = role;
      _doctorType = null;
    });
  }

  void _onDoctorTypeSelected(String type) {
    setState(() => _doctorType = type);
  }

  void _onBack() {
    if (_doctorType != null && _selectedRole == 'doctor') {
      setState(() => _doctorType = null);
    } else {
      setState(() {
        _selectedRole = null;
        _doctorType = null;
      });
    }
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

    if (_selectedRole == 'doctor' && _doctorType == null) {
      return RegisterBodyWidget(
        header: const RegisterHeaderWidget(),
        form: DoctorTypeSelectionWidget(
          selectedType: _doctorType,
          onTypeSelected: _onDoctorTypeSelected,
        ),
        showBackButton: true,
        onBack: _onBack,
      );
    }

    return RegisterBodyWidget(
      header: const RegisterHeaderWidget(),
      form: RegisterFormSection(
        role: _selectedRole!,
        doctorType: _doctorType,
      ),
      showBackButton: true,
      onBack: _onBack,
    );
  }
}