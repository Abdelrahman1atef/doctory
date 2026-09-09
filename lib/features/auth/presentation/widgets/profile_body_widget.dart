import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:doctory/core/utils/extensions.dart';

/// Pure widget — displays the Complete Profile screen layout with animations.
class ProfileBodyWidget extends StatelessWidget {
  final Widget header;
  final Widget form;

  const ProfileBodyWidget({
    super.key,
    required this.header,
    required this.form,
  });

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.paddingOf(context).top;
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20 + topInset,
        bottom: context.bottomPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          20.ph,
          FadeInDown(duration: const Duration(milliseconds: 600), child: header),
          48.ph,
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
