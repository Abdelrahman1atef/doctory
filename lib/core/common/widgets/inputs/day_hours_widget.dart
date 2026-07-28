import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../utils/extensions.dart';

class DayHours {
  final int dayIndex;
  final String dayName;
  final TimeOfDay from;
  final TimeOfDay to;
  final bool isClosed;

  const DayHours({
    required this.dayIndex,
    required this.dayName,
    required this.from,
    required this.to,
    required this.isClosed,
  });

  DayHours copyWith({
    int? dayIndex,
    String? dayName,
    TimeOfDay? from,
    TimeOfDay? to,
    bool? isClosed,
  }) {
    return DayHours(
      dayIndex: dayIndex ?? this.dayIndex,
      dayName: dayName ?? this.dayName,
      from: from ?? this.from,
      to: to ?? this.to,
      isClosed: isClosed ?? this.isClosed,
    );
  }

  String get fromDisplay {
    final hour = from.hourOfPeriod == 0 ? 12 : from.hourOfPeriod;
    final m = from.minute.toString().padLeft(2, '0');
    final period = from.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$m $period';
  }

  String get toDisplay {
    final hour = to.hourOfPeriod == 0 ? 12 : to.hourOfPeriod;
    final m = to.minute.toString().padLeft(2, '0');
    final period = to.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$m $period';
  }
}

class DayHoursRow extends StatelessWidget {
  final String dayName;
  final String fromDisplay;
  final String toDisplay;
  final bool isClosed;
  final VoidCallback onPickFrom;
  final VoidCallback onPickTo;
  final VoidCallback onToggleClosed;

  const DayHoursRow({
    super.key,
    required this.dayName,
    required this.fromDisplay,
    required this.toDisplay,
    required this.isClosed,
    required this.onPickFrom,
    required this.onPickTo,
    required this.onToggleClosed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            context.l10n(dayName.toLowerCase()),
            style: AppStyles.s14Medium.copyWith(
              color: isClosed ? AppColors.textHint : AppColors.onSurface,
            ),
          ),
        ),
        const SizedBox(width: 8),
        if (isClosed)
          Expanded(
            child: Text(
              context.l10n('closed'),
              style: AppStyles.s14Medium.copyWith(color: AppColors.textHint),
            ),
          )
        else ...[
          _TimeButton(label: fromDisplay, onTap: onPickFrom),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text('-', style: AppStyles.s14Medium.copyWith(color: AppColors.textSecondary)),
          ),
          _TimeButton(label: toDisplay, onTap: onPickTo),
        ],
        const Spacer(),
        GestureDetector(
          onTap: onToggleClosed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isClosed
                  ? AppColors.stitchPrimary.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isClosed ? AppColors.stitchPrimary : AppColors.cardBorder,
              ),
            ),
            child: Text(
              context.l10n('closed'),
              style: AppStyles.s12Medium.copyWith(
                color: isClosed ? AppColors.stitchPrimary : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TimeButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _TimeButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.stitchSurfaceLow,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Text(
          label,
          style: AppStyles.s14Medium.copyWith(color: AppColors.onSurface),
        ),
      ),
    );
  }
}
