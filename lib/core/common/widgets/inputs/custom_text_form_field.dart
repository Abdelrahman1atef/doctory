import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // New params (all optional – existing callers unaffected)
  final String? labelText;
  final TextStyle? labelStyle;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final double borderRadius;
  final Color? borderColor;
  final Color? errorBorderColor;
  final TextStyle? errorStyle;
  final AutovalidateMode? autovalidateMode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final EdgeInsetsGeometry? contentPadding;
  final Color? backgroundColor;
  final Widget? label;
  final String? counterText;
  final bool expands;
  final double? cursorHeight;
  final Color? cursorColor;
  final StrutStyle? strutStyle;

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
    this.labelText,
    this.labelStyle,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.inputFormatters,
    this.borderRadius = 10,
    this.borderColor,
    this.errorBorderColor,
    this.errorStyle,
    this.autovalidateMode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.focusNode,
    this.textAlign = TextAlign.start,
    this.contentPadding,
    this.backgroundColor,
    this.label,
    this.counterText,
    this.expands = false,
    this.cursorHeight,
    this.cursorColor,
    this.strutStyle,
  });

  OutlineInputBorder _border(Color color, double radius) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: color, width: .5),
    );
  }

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius;
    final bColor = borderColor ?? const Color(0xffC5C5C5);
    final errColor = errorBorderColor ?? Colors.red;

    Widget child = Container(
      decoration: BoxDecoration(boxShadow: boxShadow),
      child: TextFormField(
        onChanged: onChanged,
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        validator: validator,
        maxLines: expands ? null : (maxLines ?? 1),
        minLines: expands ? null : 1,
        maxLength: maxLength,
        enabled: enabled,
        readOnly: readOnly,
        onTap: onTap,
        inputFormatters: inputFormatters,
        autovalidateMode: autovalidateMode,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        focusNode: focusNode,
        textAlign: textAlign,
        expands: expands,
        cursorHeight: cursorHeight,
        cursorColor: cursorColor,
        strutStyle: strutStyle,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppStyles.s14Light.copyWith(color: AppColors.textHint),
          labelText: labelText,
          labelStyle: labelStyle ?? AppStyles.s14Medium,
          filled: true,
          fillColor: backgroundColor ?? fillColor ?? AppColors.white,
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
          border: _border(bColor, radius),
          enabledBorder: _border(bColor, radius),
          focusedBorder: _border(bColor, radius),
          errorBorder: _border(errColor, radius),
          focusedErrorBorder: _border(errColor, radius),
          errorStyle: errorStyle,
          isDense: true,
          contentPadding:
              contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          label: label,
          counterText: counterText,
        ),
      ),
    );

    if (textDirection != null) {
      return Directionality(textDirection: textDirection!, child: child);
    }

    return child;
  }
}
