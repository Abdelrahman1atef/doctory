import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/common/widgets/layout/stitch_page_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookingConfigAppBarSection extends StatelessWidget {
  const BookingConfigAppBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return StitchPageHeader(
      title: LocaleKeys.booking_config_title.tr(),
      subtitle: LocaleKeys.booking_config_subtitle.tr(),
      // During first-time onboarding there is nothing to go back to.
      onBack: context.canPop() ? context.pop : null,
    );
  }
}
