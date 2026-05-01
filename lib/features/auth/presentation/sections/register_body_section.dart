import 'package:flutter/material.dart';
import '../widgets/register_body_widget.dart';
import '../widgets/register_header_widget.dart';
import 'register_form_section.dart';

class RegisterBodySection extends StatelessWidget {
  const RegisterBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegisterBodyWidget(
      header: RegisterHeaderWidget(),
      form: RegisterFormSection(),
    );
  }
}
