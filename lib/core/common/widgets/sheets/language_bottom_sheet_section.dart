import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/common/widgets/buttons/custom_button.dart';
import 'package:doctory/core/common/widgets/sheets/custom_bottom_sheet.dart';
import 'package:doctory/core/app_strings/app_strings.dart';
import 'package:doctory/features/intro/presentation/widgets/language_list_widget.dart';
import 'package:doctory/core/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageBottomSheetSection extends StatefulWidget {
  final VoidCallback onContinue;

  const LanguageBottomSheetSection({super.key, required this.onContinue});

  @override
  State<LanguageBottomSheetSection> createState() =>
      _LanguageBottomSheetSectionState();
}

class _LanguageBottomSheetSectionState
    extends State<LanguageBottomSheetSection> {
  late String _selectedLang;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedLang = context.locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: AppStrings.appLanguage.tr(),
      subtitle: AppStrings.chooseLanguageSubtitle.tr(),
      content: LanguageListWidget(
        selectedLang: _selectedLang,
        onLangSelected: (lang) => setState(() => _selectedLang = lang),
      ),
      actionButton: CustomButton(
        onPressed: () {
          Utils.lang = _selectedLang;
          context.setLocale(Locale(_selectedLang));
          widget.onContinue();
        },
        text: AppStrings.continueBtn.tr(),
        backgroundColor: AppColors.primaryTeal,
        textColor: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        padding: const EdgeInsets.symmetric(vertical: 18),
        textStyle: AppStyles.s16Bold.copyWith(color: AppColors.white),
      ),
    );
  }
}
