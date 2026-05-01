import 'package:flutter/material.dart';
import '../widgets/profile_body_widget.dart';
import '../widgets/profile_header_widget.dart';
import 'profile_form_section.dart';

class ProfileBodySection extends StatelessWidget {
  const ProfileBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileBodyWidget(
      header: ProfileHeaderWidget(),
      form: ProfileFormSection(),
    );
  }
}
