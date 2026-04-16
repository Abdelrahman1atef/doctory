import 'package:flutter/material.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final ValueChanged<String>? onChanged;
  final List<BoxShadow>? boxShadow;
  final int? maxLines;
  final BoxConstraints? prefixIconConstraints;
  final TextDirection? textDirection;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.keyboardType,
    this.controller,
    this.validator,
    this.fillColor,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.boxShadow,
    this.maxLines,
    this.prefixIconConstraints,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      decoration: BoxDecoration(boxShadow: boxShadow),
      child: TextFormField(
        onChanged: onChanged,
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines ?? 1,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppStyles.s14Light.copyWith(color: AppColors.textHint),
          filled: true,
          fillColor: fillColor ?? AppColors.white,
          suffixIcon: suffixIcon,
          suffixIconConstraints: const BoxConstraints(
            minWidth: 44,
            minHeight: 24,
            maxWidth: 44,
            maxHeight: 24,
          ),
          prefixIcon: prefixIcon,
          prefixIconConstraints:
              prefixIconConstraints ??
              const BoxConstraints(
                minWidth: 44,
                minHeight: 24,
                maxWidth: 44,
                maxHeight: 24,
              ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xffC5C5C5), width: .5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xffC5C5C5), width: .5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xffC5C5C5), width: .5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red, width: .5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red, width: .5),
          ),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );

    if (textDirection != null) {
      return Directionality(textDirection: textDirection!, child: child);
    }

    return child;
  }
}
