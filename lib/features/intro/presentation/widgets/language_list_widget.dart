import 'package:doctory/core/app_strings/app_strings.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/intro/presentation/widgets/language_option_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageListWidget extends StatelessWidget {
  const LanguageListWidget({
    super.key,
    required this.selectedLang,
    required this.onLangSelected,
  });

  final String selectedLang;
  final ValueChanged<String> onLangSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LanguageOptionWidget(
          title: AppStrings.arabicAr.tr(),
          isSelected: selectedLang == 'ar',
          onTap: () => onLangSelected('ar'),
        ),
        16.ph,
        LanguageOptionWidget(
          title: AppStrings.englishEn.tr(),
          isSelected: selectedLang == 'en',
          onTap: () => onLangSelected('en'),
        ),
      ],
    );
  }
}
