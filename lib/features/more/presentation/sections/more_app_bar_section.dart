import 'package:doctory/core/common/widgets/layout/custom_appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MoreAppBarSection extends StatelessWidget {
  const MoreAppBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(title: 'more'.tr(), canNavigateUp: false);
  }
}
