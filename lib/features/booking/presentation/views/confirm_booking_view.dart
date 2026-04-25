import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/features/booking/cubit/booking_cubit.dart';
import 'package:doctory/features/booking/cubit/booking_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ConfirmBookingView extends StatelessWidget {
  const ConfirmBookingView({super.key});

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
          'confirm_booking'.tr(),
          style: AppStyles.s18Bold.withColor(AppColors.stitchPrimaryContainer),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<BookingCubit, BookingStates>(
        listener: (context, state) {
          if (state is BookingSuccessState) {
            context.go(AppRoutes.bookingSuccess);
          } else if (state is BookingErrorState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final cubit = context.read<BookingCubit>();
          final currentState = state is BookingStateUpdated ? state : null;
          final doctor = currentState?.doctor ?? cubit.doctor;
          final date = currentState?.selectedDate;
          final time = currentState?.selectedTime;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Summary Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.stitchSurfaceLowest,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.stitchSurfaceLow),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                    doctor.imageUrl ?? '',
                                  ),
                                  backgroundColor: AppColors.stitchSurfaceLow,
                                ),
                                16.pw,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        doctor.displayName,
                                        style: AppStyles.s16Bold.withColor(
                                          AppColors.stitchPrimaryContainer,
                                        ),
                                      ),
                                      4.ph,
                                      Text(
                                        doctor.displaySpecialty,
                                        style: AppStyles.s14Medium.withColor(
                                          AppColors.stitchSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            16.ph,
                            const Divider(color: AppColors.stitchSurfaceLow),
                            16.ph,
                            _buildSummaryRow(
                              Icons.calendar_today,
                              DateFormat(
                                'EEEE, MMM d, yyyy',
                              ).format(date ?? DateTime.now()),
                            ),
                            12.ph,
                            _buildSummaryRow(
                              Icons.access_time,
                              DateFormat(
                                'hh:mm a',
                              ).format(time?.startTime ?? DateTime.now()),
                            ),
                          ],
                        ),
                      ),
                      24.ph,
                      // Patient Info Form
                      Text(
                        'patient_details'.tr(),
                        style: AppStyles.s18Bold.withColor(
                          AppColors.stitchPrimaryContainer,
                        ),
                      ),
                      16.ph,
                      _buildTextField(
                        label: 'full_name'.tr(),
                        icon: Icons.person_outline,
                        onChanged: (val) => cubit.updatePatientInfo(name: val),
                      ),
                      16.ph,
                      _buildTextField(
                        label: 'phone_number'.tr(),
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        onChanged: (val) => cubit.updatePatientInfo(phone: val),
                      ),
                      16.ph,
                      _buildTextField(
                        label: 'additional_notes'.tr(),
                        icon: Icons.notes,
                        maxLines: 3,
                        onChanged: (val) => cubit.updatePatientInfo(notes: val),
                      ),
                    ],
                  ),
                ),
              ),
              // Confirm Button
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
                    onPressed: state is BookingSubmitting
                        ? null
                        : () => cubit.confirmBooking(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.stitchPrimaryContainer,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: state is BookingSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: AppColors.stitchSurfaceLowest,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'confirm_booking'.tr(),
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

  Widget _buildSummaryRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.stitchPrimaryContainer),
        12.pw,
        Text(text, style: AppStyles.s14Medium.withColor(AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    required Function(String) onChanged,
  }) {
    return TextField(
      onChanged: onChanged,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: maxLines > 1 ? 40 : 0),
          child: Icon(icon, color: AppColors.stitchSecondary),
        ),
        filled: true,
        fillColor: AppColors.stitchSurfaceLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.stitchSurfaceLow),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.stitchSurfaceLow),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.stitchPrimaryContainer),
        ),
      ),
    );
  }
}
