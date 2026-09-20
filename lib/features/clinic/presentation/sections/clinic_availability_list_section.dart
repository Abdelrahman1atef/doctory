import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/common/widgets/error/app_error_widget.dart';
import 'package:doctory/core/common/widgets/layout/empty_widget.dart';
import 'package:doctory/core/services/alerts.dart';
import 'package:doctory/features/clinic/cubit/clinic_availability_cubit.dart';
import 'package:doctory/features/clinic/cubit/clinic_availability_state.dart';
import 'package:doctory/features/clinic/data/model/availability_dto.dart';
import 'package:doctory/features/clinic/presentation/widgets/availability_list_widget.dart';
import 'package:doctory/features/clinic/presentation/widgets/availability_shimmer_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClinicAvailabilityListSection extends StatelessWidget {
  const ClinicAvailabilityListSection({super.key});

  Widget _list(BuildContext context, List<AvailabilityDto> windows, {bool isSubmitting = false}) {
    if (windows.isEmpty) {
      return EmptyWidget(
        title: LocaleKeys.no_availability.tr(),
        subtitle: LocaleKeys.no_availability_hint.tr(),
      );
    }
    return AvailabilityListWidget(
      windows: windows,
      isSubmitting: isSubmitting,
      onDelete: (window) => context.read<ClinicAvailabilityCubit>().deleteAvailability(window.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClinicAvailabilityCubit, ClinicAvailabilityState>(
      listener: (context, state) {
        if (state is ClinicAvailabilitySubmitSuccess) {
          Alerts.snack(text: LocaleKeys.success.tr(), state: SnackState.success);
        } else if (state is ClinicAvailabilitySubmitError) {
          Alerts.snack(text: state.message, state: SnackState.failed);
        }
      },
      builder: (context, state) {
        final cubit = context.read<ClinicAvailabilityCubit>();
        switch (state) {
          case ClinicAvailabilityInitial():
            return const AvailabilityShimmerWidget();
          case ClinicAvailabilityLoading():
            // Keep the list on screen while it refreshes after a write.
            return cubit.currentAvailability.isEmpty
                ? const AvailabilityShimmerWidget()
                : _list(context, cubit.currentAvailability, isSubmitting: true);
          case ClinicAvailabilityError(:final message):
            return AppErrorWidget(message: message, onRetry: cubit.reload);
          case ClinicAvailabilitySuccess(:final availability):
            return _list(context, availability);
          case ClinicAvailabilitySubmitLoading():
            return _list(context, cubit.currentAvailability, isSubmitting: true);
          case ClinicAvailabilitySubmitSuccess():
          case ClinicAvailabilitySubmitError():
            return _list(context, cubit.currentAvailability);
        }
      },
    );
  }
}
