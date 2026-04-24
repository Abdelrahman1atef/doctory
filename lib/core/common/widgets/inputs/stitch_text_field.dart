import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
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

  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

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
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppStyles.s14Bold.copyWith(color: AppColors.onSurface),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          obscureText: obscureText,
          readOnly: readOnly,
          onTap: onTap,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          decoration: InputDecoration(
            counterText: '',
            hintText: hintText,
            hintStyle: AppStyles.s14Medium.copyWith(color: AppColors.textHint),
            filled: true,
            fillColor: AppColors.stitchSurfaceLow,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 18,
            ),
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
              borderSide: const BorderSide(
                color: AppColors.stitchPrimary,
                width: 2,
              ),
            ),
            prefixIcon: prefix ?? prefixIcon,
            prefixIconConstraints: const BoxConstraints(minWidth: 56),
            suffixIcon: suffixIcon,
          ),
          style: AppStyles.s16Medium.copyWith(color: AppColors.onSurface),
        ),
      ],
    );
  }
}
