import 'package:flutter/material.dart';
import '../widgets/otp_body_widget.dart';
import '../widgets/otp_header_widget.dart';
import 'otp_input_section.dart';

class OtpBodySection extends StatelessWidget {
  final String? email;
  final bool isForgotPassword;

  const OtpBodySection({super.key, this.email, this.isForgotPassword = false});

  @override
  Widget build(BuildContext context) {
    return OtpBodyWidget(
      header: OtpHeaderWidget(email: email),
      form: OtpInputSection(email: email, isForgotPassword: isForgotPassword),
    );
  }
}
