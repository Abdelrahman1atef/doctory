import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:doctory/core/services/alerts.dart';
import 'package:doctory/core/common/widgets/buttons/custom_button.dart';
import 'package:doctory/core/common/widgets/loading/app_shimmer.dart';
import 'package:doctory/core/common/widgets/error/app_error_widget.dart';
import 'package:doctory/core/common/widgets/layout/empty_widget.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/session/user_session.dart';
import 'package:doctory/core/theme/app_colors.dart';
import 'package:doctory/core/theme/app_typography.dart';
import 'package:doctory/features/clinic/cubit/clinic_availability_cubit.dart';
import 'package:doctory/features/clinic/cubit/clinic_availability_state.dart';
import 'package:doctory/features/clinic/data/model/availability_dto.dart';
import 'package:doctory/features/clinic/presentation/widgets/availability_window_dialog.dart';

class ClinicAvailabilitySection extends StatefulWidget {
  const ClinicAvailabilitySection({super.key});

  @override
  State<ClinicAvailabilitySection> createState() => _ClinicAvailabilitySectionState();
}

class _ClinicAvailabilitySectionState extends State<ClinicAvailabilitySection> {
  late String _doctorId;

  @override
  void initState() {
    super.initState();
    _doctorId = UserSession.userModel?['doctorId']?.toString() ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClinicAvailabilityCubit>().loadAvailability(_doctorId);
    });
  }

  void _showAddDialog() {
    Alerts.dialog(
      context,
      child: AvailabilityWindowDialog(
        onSave: (availability) {
          context.read<ClinicAvailabilityCubit>().addAvailability(availability);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClinicAvailabilityCubit, ClinicAvailabilityState>(
      listener: (context, state) {
        if (state is ClinicAvailabilitySubmitSuccess) {
          Alerts.snack(
            text: 'common.success'.tr(),
            state: SnackState.success,
          );
        } else if (state is ClinicAvailabilitySubmitError) {
          Alerts.snack(
            text: state.message,
            state: SnackState.failed,
          );
        }
      },
      builder: (context, state) => switch (state) {
        ClinicAvailabilityInitial() || ClinicAvailabilityLoading() => AppShimmer(
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            children: List.generate(
              3,
              (index) => const ShimmerContainer(
                height: 80,
                margin: EdgeInsets.only(bottom: 16),
              ),
            ),
          ),
        ),
        ClinicAvailabilityError(:final message) => AppErrorWidget(
            message: message,
            onRetry: () => context.read<ClinicAvailabilityCubit>().loadAvailability(_doctorId),
          ),
        ClinicAvailabilitySuccess(:final availability) when availability.isEmpty => _buildList(availability, true),
        ClinicAvailabilitySuccess(:final availability) => _buildList(availability, false),
        ClinicAvailabilitySubmitLoading() ||
        ClinicAvailabilitySubmitSuccess() ||
        ClinicAvailabilitySubmitError() => _buildList(context.read<ClinicAvailabilityCubit>().currentAvailability, false, isLoading: state is ClinicAvailabilitySubmitLoading),
      },
    );
  }

  Widget _buildList(List<AvailabilityDto> availability, bool isEmpty, {bool isLoading = false}) {
    return Column(
      children: [
        Expanded(
          child: isEmpty
              ? EmptyWidget(title: 'clinic.no_availability'.tr())
              : ListView.separated(
                  padding: const EdgeInsets.all(24.0),
                  itemCount: availability.length,
                  separatorBuilder: (context, index) => 16.ph,
                  itemBuilder: (context, index) {
                    final item = availability[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                item.dayOfWeek.toString(),
                                style: AppStyles.s16Bold.withColor(AppColors.textPrimary),
                              ),
                              CustomButton(
                                onPressed: () {
                                  context.read<ClinicAvailabilityCubit>().deleteAvailability(item.id);
                                },
                                backgroundColor: AppColors.white,
                                borderColor: AppColors.error,
                                textColor: AppColors.error,
                                height: 36,
                                width: 100,
                                text: 'common.delete'.tr(),
                              ),
                            ],
                          ),
                          8.ph,
                          Text(
                            '${item.startTime} - ${item.endTime} (${item.slotDurationMinutes} mins)',
                            style: AppStyles.s14Medium.withColor(AppColors.textSecondary),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        if (isLoading) const LinearProgressIndicator(),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                text: 'clinic.add_availability'.tr(),
                onPressed: _showAddDialog,
              ),
              16.ph,
              CustomButton(
                text: 'clinic.finish_setup'.tr(),
                backgroundColor: AppColors.white,
                textColor: AppColors.primary,
                borderColor: AppColors.primary,
                onPressed: () {
                  context.go(AppRoutes.clinicDashboard);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}


