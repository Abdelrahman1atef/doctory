import 'package:flutter/material.dart';
import 'package:doctory/core/theme/app_typography.dart';

import '../../../theme/app_colors.dart';

class DropDownItem<T> extends StatefulWidget {
  const DropDownItem({
    super.key,
    required this.options,
    required this.onChanged,
    this.initialValue,
    this.title,
    this.validator,
    this.radius,
    this.hint,
    this.color,
    this.hintColor,
    this.hintStyle,
    this.itemAsString,
    this.prefixIcon,
  });

  final List<T> options;
  final T? initialValue;
  final String Function(T)? itemAsString;
  final String? hint;
  final String? Function(T?)? validator;
  final String? title;
  final double? radius;
  final Color? hintColor;
  final Color? color;
  final TextStyle? hintStyle;
  final ValueChanged<T> onChanged;
  final Widget? prefixIcon;

  @override
  State<DropDownItem<T>> createState() => _DropDownItemState<T>();
}

class _DropDownItemState<T> extends State<DropDownItem<T>>
    with AutomaticKeepAliveClientMixin {
  T? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(DropDownItem<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _selectedValue = widget.initialValue;
    }
    // Safety check: if current selected value is not in the new options, reset it
    if (_selectedValue != null && !widget.options.contains(_selectedValue)) {
      _selectedValue = null;
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final radius = widget.radius ?? 28.0;

    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.title?.isNotEmpty ?? false)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  widget.title!,
                  style: AppStyles.s14Medium.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            DropdownButtonFormField<T>(
              initialValue: _selectedValue,
              validator: widget.validator,
              borderRadius: BorderRadius.circular(16),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              hint: Text(
                widget.hint ?? '',
                style:
                    widget.hintStyle ??
                    AppStyles.s14Light.copyWith(
                      color:
                          widget.hintColor ??
                          theme.colorScheme.onSurfaceVariant,
                    ),
              ),
              selectedItemBuilder: (_selectedValue == null)
                  ? null
                  : (context) => widget.options.map((e) {
                      return Row(
                        children: [
                          Text(
                            widget.itemAsString?.call(e) ?? e.toString(),
                            style: AppStyles.s14Light.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              decoration: InputDecoration(
                fillColor: widget.color ?? theme.colorScheme.surface,
                filled: true,
                prefixIcon: UnconstrainedBox(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                      color: AppColors.grey100,
                      shape: BoxShape.circle,
                    ),
                    child: widget.prefixIcon,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outline,
                    width: .5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outline,
                    width: .5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius),
                  borderSide: BorderSide(
                    color: theme.colorScheme.error,
                    width: .5,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius),
                  borderSide: BorderSide(
                    color: theme.colorScheme.error,
                    width: 1.5,
                  ),
                ),
              ),
              items: widget.options
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        widget.itemAsString?.call(e) ?? e.toString(),
                        style: AppStyles.s14Light.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedValue = value);
                  widget.onChanged(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
