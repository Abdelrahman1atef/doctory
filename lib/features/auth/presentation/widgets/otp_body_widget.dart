import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:doctory/core/utils/extensions.dart';

/// Pure widget — displays the OTP screen layout with animations.
class OtpBodyWidget extends StatelessWidget {
  final Widget header;
  final Widget form;

  const OtpBodyWidget({super.key, required this.header, required this.form});

  @override
  Widget build(BuildContext context) {
    // The back header above already owns the status-bar inset.
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: context.bottomPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          20.ph,
          FadeInDown(duration: const Duration(milliseconds: 600), child: header),
          60.ph,
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 200),
            child: form,
          ),
        ],
      ),
    );
  }
}
