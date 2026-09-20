import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/common/widgets/layout/stitch_page_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClinicAvailabilityAppBarSection extends StatelessWidget {
  const ClinicAvailabilityAppBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return StitchPageHeader(
      title: LocaleKeys.availability_title.tr(),
      subtitle: LocaleKeys.availability_subtitle.tr(),
      onBack: context.canPop() ? context.pop : null,
    );
  }
}
