import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart' as easy_localization;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StitchTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? label;
  final Widget? prefixIcon;
  final Widget? prefix;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool isPassword;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextDirection? textDirection;

  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool isRequired;

  const StitchTextField({
    super.key,
    this.controller,
    this.hintText,
    this.label,
    this.prefixIcon,
    this.prefix,
    this.suffixIcon,
    this.obscureText = false,
    this.isPassword = false,
    this.keyboardType,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.inputFormatters,
    this.maxLength,
    this.textDirection,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label!,
                  style:
                      AppStyles.s14Bold.copyWith(color: AppColors.onSurface),
                ),
                if (isRequired)
                  TextSpan(
                    text: ' *',
                    style: AppStyles.s14Bold.copyWith(color: Colors.red),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        Directionality(
          textDirection: textDirection ?? (context.locale == const Locale('ar')
              ? TextDirection.rtl
              : TextDirection.ltr),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            obscureText: obscureText,
            readOnly: readOnly,
            onTap: onTap,
            inputFormatters: inputFormatters,
            maxLength: maxLength,
            textDirection: textDirection,
            decoration: InputDecoration(
              counterText: '',
              hintText: hintText,
              hintStyle: AppStyles.s14Medium.copyWith(color: AppColors.textHint),
              filled: true,
              fillColor: AppColors.stitchSurfaceLow,
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.stitchPrimary, width: 2),
              ),
              prefixIcon: prefix ?? prefixIcon,
              prefixIconConstraints: const BoxConstraints(minWidth: 56),
              suffixIcon: suffixIcon,
            ),
            style: AppStyles.s16Medium.copyWith(color: AppColors.onSurface),
          ),
        ),
      ],
    );
  }
}
