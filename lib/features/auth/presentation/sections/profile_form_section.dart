import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/common/functions/location_helper.dart';
import '../../../../core/router/router_names.dart';
import '../widgets/profile_form_widget.dart';

class ProfileFormSection extends StatefulWidget {
  const ProfileFormSection({super.key});

  @override
  State<ProfileFormSection> createState() => _ProfileFormSectionState();
}

class _ProfileFormSectionState extends State<ProfileFormSection> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = 'male';
  }

  void _onSubmit() {
    LocationHelper.isPermissionGranted().then((isGranted) {
      if (isGranted && context.mounted) {
        context.go(AppRoutes.home);
      } else if (context.mounted) {
        context.push(AppRoutes.locationPermission);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProfileFormWidget(
      formKey: _formKey,
      selectedGender: _selectedGender,
      onGenderChanged: (gender) => setState(() => _selectedGender = gender),
      onSubmit: _onSubmit,
    );
  }
}
