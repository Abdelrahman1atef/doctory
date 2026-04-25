import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/booking/cubit/booking_cubit.dart';
import 'package:doctory/features/booking/cubit/booking_states.dart';
import 'package:doctory/features/booking/data/data_source/booking_mock_data.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SelectDateView extends StatelessWidget {
  const SelectDateView({super.key});

  @override
  Widget build(BuildContext context) {
    final availableDates = BookingMockData.getAvailableDates();

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
          'select_date'.tr(),
          style: AppStyles.s18Bold.withColor(AppColors.stitchPrimaryContainer),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<BookingCubit, BookingStates>(
        builder: (context, state) {
          if (state is! BookingStateUpdated) return const SizedBox.shrink();

          return Column(
            children: [
              // Calendar placeholder (using a simple list for dates)
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: availableDates.length,
                  itemBuilder: (context, index) {
                    final date = availableDates[index];
                    final isSelected =
                        state.selectedDate?.year == date.year &&
                        state.selectedDate?.month == date.month &&
                        state.selectedDate?.day == date.day;

                    return GestureDetector(
                      onTap: () {
                        context.read<BookingCubit>().selectDate(date);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.stitchPrimaryContainer
                              : AppColors.stitchSurfaceLowest,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.stitchPrimaryContainer
                                : AppColors.stitchSurfaceLow,
                          ),
                          boxShadow: [
                            if (!isSelected)
                              BoxShadow(
                                color: AppColors.black.withValues(alpha: 0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('EEEE, MMM d, yyyy').format(date),
                              style: AppStyles.s16Medium.withColor(
                                isSelected
                                    ? AppColors.stitchSurfaceLowest
                                    : AppColors.stitchPrimaryContainer,
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: AppColors.stitchSurfaceLowest,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
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
                    onPressed: state.selectedDate != null
                        ? () {
                            context.push(
                              AppRoutes.bookingSelectTime,
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
