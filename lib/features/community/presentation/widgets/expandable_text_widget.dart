import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle? style;

  const ExpandableTextWidget({
    super.key,
    required this.text,
    this.maxLines = 3,
    this.style,
  });

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textStyle =
        widget.style ?? AppStyles.s14Medium.withColor(AppColors.textPrimary);

    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(text: widget.text, style: textStyle);
        final tp = TextPainter(
          text: span,
          maxLines: widget.maxLines,
          textDirection: Directionality.of(context),
        );
        tp.layout(maxWidth: constraints.maxWidth);

        if (tp.didExceedMaxLines) {
          return InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.text,
                  maxLines: isExpanded ? null : widget.maxLines,
                  overflow: isExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: textStyle.copyWith(height: 1.5),
                ),
                if (!isExpanded)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'see_more'.tr(),
                      style: AppStyles.s14Bold.withColor(
                        AppColors.stitchPrimary,
                      ),
                    ),
                  ),
              ],
            ),
          );
        } else {
          return Text(
            widget.text,
            textAlign: TextAlign.start,
            style: textStyle.copyWith(height: 1.5),
          );
        }
      },
    );
  }
}
