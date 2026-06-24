import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BookingTextField extends StatefulWidget {
  final String label;
  final IconData icon;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final List<TextInputFormatter>? inputFormatters;

  const BookingTextField({
    super.key,
    required this.label,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType,
    this.initialValue,
    required this.onChanged,
    this.inputFormatters,
  });

  @override
  State<BookingTextField> createState() => _BookingTextFieldState();
}

class _BookingTextFieldState extends State<BookingTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void didUpdateWidget(BookingTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      style: AppStyles.s14Medium.withColor(AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: AppStyles.s14Medium.withColor(AppColors.grey500),
        prefixIcon: Icon(widget.icon, color: AppColors.stitchSecondary, size: 20),
        filled: true,
        fillColor: AppColors.stitchSurfaceLowest,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.stitchPrimary, width: 1.5),
        ),
      ),
    );
  }
}
