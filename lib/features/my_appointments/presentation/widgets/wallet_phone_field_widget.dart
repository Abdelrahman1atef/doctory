import 'package:doctory/core/common/widgets/inputs/stitch_text_field.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/core/validation/form_validator.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Phone number of the e-wallet the gateway should charge.
class WalletPhoneFieldWidget extends StatelessWidget {
  static const int _phoneLength = 11;

  final TextEditingController controller;

  const WalletPhoneFieldWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StitchTextField(
          controller: controller,
          label: 'wallet_phone_number'.tr(),
          hintText: '01XXXXXXXXX',
          keyboardType: TextInputType.phone,
          maxLength: _phoneLength,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textDirection: TextDirection.ltr,
          prefixIcon: const Icon(
            Icons.phone_android_rounded,
            color: AppColors.textSecondary,
          ),
          validator: FormValidator.validateWalletPhone,
        ),
        8.ph,
        Text(
          'wallet_phone_note'.tr(),
          style: AppStyles.s12Medium.withColor(AppColors.textSecondary),
        ),
      ],
    );
  }
}
