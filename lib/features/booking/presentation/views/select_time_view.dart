import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/booking/cubit/booking_cubit.dart';
import 'package:doctory/features/booking/cubit/booking_states.dart';
import 'package:doctory/features/booking/data/data_source/booking_mock_data.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SelectTimeView extends StatelessWidget {
  const SelectTimeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.stitchSurface,
      appBar: AppBar(
        backgroundColor: AppColors.stitchSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.stitchPrimaryContainer,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'select_time'.tr(),
          style: AppStyles.s18Bold.withColor(AppColors.stitchPrimaryContainer),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<BookingCubit, BookingStates>(
        builder: (context, state) {
          if (state is! BookingStateUpdated || state.selectedDate == null) {
            return const SizedBox.shrink();
          }

          final slots = BookingMockData.getTimeSlotsForDate(
            state.selectedDate!,
          );

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat(
                          'EEEE, MMM d, yyyy',
                        ).format(state.selectedDate!),
                        style: AppStyles.s16Bold.withColor(
                          AppColors.stitchPrimaryContainer,
                        ),
                      ),
                      24.ph,
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: slots.map((slot) {
                          final isSelected = state.selectedTime?.id == slot.id;

                          return GestureDetector(
                            onTap: slot.isAvailable
                                ? () {
                                    context.read<BookingCubit>().selectTime(
                                      slot,
                                    );
                                  }
                                : null,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.stitchPrimaryContainer
                                    : (slot.isAvailable
                                          ? AppColors.stitchSurfaceLowest
                                          : AppColors.stitchSurfaceLow),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.stitchPrimaryContainer
                                      : (slot.isAvailable
                                            ? AppColors.stitchSurfaceLow
                                            : AppColors.stitchSurfaceLow),
                                ),
                              ),
                              child: Text(
                                DateFormat('hh:mm a').format(slot.startTime),
                                style: AppStyles.s14Medium.withColor(
                                  isSelected
                                      ? AppColors.stitchSurfaceLowest
                                      : (slot.isAvailable
                                            ? AppColors.stitchPrimaryContainer
                                            : AppColors.stitchSecondary
                                                  .withValues(alpha: 0.5)),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              // Next Button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.stitchSurfaceLowest,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.selectedTime != null
                        ? () {
                            context.push(
                              AppRoutes.bookingConfirm,
                              extra: context.read<BookingCubit>(),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.stitchPrimaryContainer,
                      disabledBackgroundColor: AppColors.stitchSurfaceLow,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'next'.tr(),
                      style: AppStyles.s16Bold.withColor(
                        AppColors.stitchSurfaceLowest,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
