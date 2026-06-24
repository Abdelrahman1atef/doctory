import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// A real calendar grid with month navigation for date selection.
class BookingCalendarGrid extends StatefulWidget {
  final List<DateTime> availableDates;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const BookingCalendarGrid({
    super.key,
    required this.availableDates,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<BookingCalendarGrid> createState() => _BookingCalendarGridState();
}

class _BookingCalendarGridState extends State<BookingCalendarGrid> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  }

  void _previousMonth() {
    final now = DateTime(DateTime.now().year, DateTime.now().month);
    if (_currentMonth.isAfter(now)) {
      setState(() {
        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
      });
    }
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  bool _isAvailable(DateTime day) {
    return widget.availableDates.any(
      (d) => d.year == day.year && d.month == day.month && d.day == day.day,
    );
  }

  bool _isSelected(DateTime day) {
    final sel = widget.selectedDate;
    if (sel == null) return false;
    return sel.year == day.year && sel.month == day.month && sel.day == day.day;
  }

  bool _isPast(DateTime day) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final dayDate = DateTime(day.year, day.month, day.day);
    return dayDate.isBefore(todayDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.stitchSurfaceLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Month Navigation
          _buildMonthHeader(),
          const SizedBox(height: 16),
          // Weekday Headers
          _buildWeekdayHeaders(),
          const SizedBox(height: 8),
          // Calendar Days Grid
          _buildDaysGrid(),
        ],
      ),
    );
  }

  Widget _buildMonthHeader() {
    final locale = context.locale.toLanguageTag();
    final monthName = DateFormat('MMMM yyyy', locale).format(_currentMonth);
    final now = DateTime(DateTime.now().year, DateTime.now().month);
    final canGoBack = _currentMonth.isAfter(now);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: canGoBack ? _previousMonth : null,
          icon: Icon(
            Icons.chevron_left,
            color: canGoBack
                ? AppColors.stitchPrimaryContainer
                : AppColors.grey300,
          ),
        ),
        Text(
          monthName,
          style: AppStyles.s16Bold.withColor(AppColors.stitchPrimaryContainer),
        ),
        IconButton(
          onPressed: _nextMonth,
          icon: const Icon(
            Icons.chevron_right,
            color: AppColors.stitchPrimaryContainer,
          ),
        ),
      ],
    );
  }

  Widget _buildWeekdayHeaders() {
    final locale = context.locale.toLanguageTag();
    final weekdays = List.generate(7, (i) {
      final date = DateTime(2024, 1, 7 + i);
      return DateFormat('E', locale).format(date);
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays
          .map(
            (d) => SizedBox(
              width: 40,
              child: Center(
                child: Text(
                  d,
                  style: AppStyles.s12Bold.withColor(AppColors.grey500),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildDaysGrid() {
    final firstDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    );
    final startWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0

    final cells = <Widget>[];

    // Empty cells before first day
    for (int i = 0; i < startWeekday; i++) {
      cells.add(const SizedBox(width: 40, height: 40));
    }

    // Day cells
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final isAvailable = _isAvailable(date);
      final isSelected = _isSelected(date);
      final isPast = _isPast(date);

      cells.add(
        GestureDetector(
          onTap: isAvailable && !isPast
              ? () => widget.onDateSelected(date)
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? AppColors.stitchPrimary
                  : isAvailable && !isPast
                  ? AppColors.stitchPrimaryFixed.withValues(alpha: 0.3)
                  : Colors.transparent,
            ),
            child: Center(
              child: Text(
                '$day',
                style: AppStyles.s14Medium.withColor(
                  isSelected
                      ? Colors.white
                      : isPast || !isAvailable
                      ? AppColors.grey400
                      : AppColors.stitchPrimaryContainer,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Wrap(
      children: cells.map((cell) {
        return SizedBox(
          width: (MediaQuery.of(context).size.width - 64) / 7,
          height: 44,
          child: Center(child: cell),
        );
      }).toList(),
    );
  }
}
