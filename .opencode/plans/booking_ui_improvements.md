# Booking UI Improvements Plan

## Changes Summary — 4 files

---

### 1. `booking_action_button.dart` — Add `outlined` variant

```dart
// Add outlined parameter
class BookingActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool outlined; // NEW

  const BookingActionButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.outlined = false, // NEW
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: outlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.stitchPrimary,
                side: const BorderSide(color: AppColors.stitchPrimary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Text(label, style: AppStyles.s16Bold.withColor(AppColors.stitchPrimary)),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.stitchPrimary,
                disabledBackgroundColor: AppColors.grey300,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 24, height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                    )
                  : Text(label, style: AppStyles.s16Bold.withColor(Colors.white)),
            ),
    );
  }
}
```

- Remove the outer `Container` with boxShadow (moved to the bottom bar container instead)
- Replace `SafeArea` (will be handled by the section wrapping the Row)

---

### 2. `booking_step_indicator.dart` — Add step labels

```dart
class BookingStepIndicator extends StatelessWidget {
  final BookingStep currentStep;

  const BookingStepIndicator({super.key, required this.currentStep});

  static const _stepGroups = [
    (_label: 'appointment', steps: {BookingStep.appointmentType, BookingStep.selectDate}),
    (_label: 'details', steps: {BookingStep.selectTime, BookingStep.patientInfo}),
    (_label: 'review_step', steps: {BookingStep.reviewBooking, BookingStep.payment}),
    (_label: 'confirmation', steps: {BookingStep.verification, BookingStep.success}),
  ];

  int get _currentGroupIndex {
    for (int i = 0; i < _stepGroups.length; i++) {
      if (_stepGroups[i].steps.contains(currentStep)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIdx = _currentGroupIndex;
    final totalSteps = _stepGroups.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.stitchSurface,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Step X of Y: Label"
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text.rich(
              TextSpan(
                text: 'booking_step_format'.tr(args: [
                  (currentIdx + 1).toString(),
                  totalSteps.toString(),
                ]),
                children: [
                  TextSpan(
                    text: ': ${_stepGroups[currentIdx]._label.tr()}',
                    style: AppStyles.s14Bold.withColor(AppColors.stitchPrimary),
                  ),
                ],
              ),
              style: AppStyles.s14Medium.withColor(AppColors.grey600),
            ),
          ),
          const SizedBox(height: 12),
          // Progress bars
          Row(
            children: List.generate(totalSteps, (index) {
              final isActive = index <= currentIdx;
              return Expanded(
                child: Container(
                  height: 6,
                  margin: EdgeInsetsDirectional.only(
                    end: index == totalSteps - 1 ? 0 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.stitchPrimary : AppColors.grey200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          // Step labels below bars
          Row(
            children: List.generate(totalSteps, (index) {
              final isActive = index == currentIdx;
              return Expanded(
                child: Text(
                  _stepGroups[index]._label.tr(),
                  textAlign: TextAlign.center,
                  style: AppStyles.s11Medium.withColor(
                    isActive ? AppColors.stitchPrimary : AppColors.grey400,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
```

Note: The `_label` syntax uses a `_StepGroup` record class. Alternative: define `_stepGroups` as a list of `(String, Set)` using `const` constructor with a helper class.

---

### 3. `booking_fab_section.dart` — Add Previous button + Row

```dart
class BookingFabSection extends StatelessWidget {
  const BookingFabSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        if (state is! BookingData) return const SizedBox.shrink();
        final cubit = context.read<BookingCubit>();
        final s = state;
        final step = s.currentStep;

        // Success: full-width Done button
        if (step == BookingStep.success) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.stitchSurfaceLowest,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: BookingActionButton(
                label: 'done'.tr(),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          );
        }

        final showPrevious = step != BookingStep.appointmentType;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.stitchSurfaceLowest,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                if (showPrevious)
                  SizedBox(
                    width: 130,
                    child: BookingActionButton(
                      label: 'previous'.tr(),
                      onPressed: () => cubit.previousStep(),
                      outlined: true,
                    ),
                  ),
                if (showPrevious) const SizedBox(width: 12),
                Expanded(
                  child: BookingActionButton(
                    label: _buttonLabel(step),
                    onPressed: _canProceed(step, s) && !s.isSubmitting
                        ? () => _onAction(context, cubit, step)
                        : null,
                    isLoading: s.isSubmitting,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  // ... _canProceed, _buttonLabel, _onAction methods unchanged
}
```

---

### 4. `booking_flow_view.dart` — Use `bottomNavigationBar` slot

```dart
class BookingFlowView extends StatelessWidget {
  const BookingFlowView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: const BookingBodySection(),
      ),
      bottomNavigationBar: const BookingFabSection(),
    );
  }
}
```

---

## Files affected
| File | Change |
|------|--------|
| `presentation/widgets/booking_action_button.dart` | Add `outlined` bool param, both button styles |
| `presentation/widgets/booking_step_indicator.dart` | Add step labels, show current step name |
| `presentation/sections/booking_fab_section.dart` | Previous + Next in Row, shadow container wraps both |
| `presentation/views/booking_flow_view.dart` | `floatingActionButton` → `bottomNavigationBar` |

## Verify
After implementation, run:
```
dart analyze lib\features\booking
```
Expect 0 errors, 0 warnings.
