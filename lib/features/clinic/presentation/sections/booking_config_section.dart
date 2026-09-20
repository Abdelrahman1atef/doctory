import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:doctory/core/services/alerts.dart';
import 'package:doctory/core/common/widgets/buttons/custom_button.dart';
import 'package:doctory/core/common/widgets/inputs/custom_text_form_field.dart';
import 'package:doctory/core/common/widgets/loading/app_shimmer.dart';
import 'package:doctory/core/common/widgets/error/app_error_widget.dart';
import 'package:doctory/core/utils/extensions.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/features/clinic/cubit/clinic_booking_config_cubit.dart';
import 'package:doctory/features/clinic/cubit/clinic_booking_config_state.dart';
import 'package:doctory/features/clinic/data/model/booking_config_dto.dart';
import 'package:doctory/core/utils/digit_extensions.dart';

class BookingConfigSection extends StatefulWidget {
  const BookingConfigSection({super.key});

  @override
  State<BookingConfigSection> createState() => _BookingConfigSectionState();
}

class _BookingConfigSectionState extends State<BookingConfigSection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController(text: 'EGP');
  final TextEditingController _maxAdvanceController = TextEditingController(text: '30');
  final TextEditingController _ttlController = TextEditingController(text: '15');
  final TextEditingController _cancelWindowController = TextEditingController(text: '60');

  void _populateForm(BookingConfigDto config) {
    if (_feeController.text.isEmpty) {
      _feeController.text = config.consultationFee.toString();
      _currencyController.text = config.currency;
      _maxAdvanceController.text = config.maxAdvanceBookingDays.toString();
      _ttlController.text = config.reservationTtlMinutes.toString();
      _cancelWindowController.text = config.cancellationWindowMinutes.toString();
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final cubit = context.read<ClinicBookingConfigCubit>();
    final config = BookingConfigDto(
      consultationFee: _feeController.text.toEnglishDigits.toDouble(),
      currency: _currencyController.text.trim(),
      maxAdvanceBookingDays: int.parse(_maxAdvanceController.text.toEnglishDigits),
      reservationTtlMinutes: int.parse(_ttlController.text.toEnglishDigits),
      cancellationWindowMinutes: int.parse(_cancelWindowController.text.toEnglishDigits),
    );
    cubit.submitConfig(config);
  }

  @override
  void dispose() {
    _feeController.dispose();
    _currencyController.dispose();
    _maxAdvanceController.dispose();
    _ttlController.dispose();
    _cancelWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClinicBookingConfigCubit, ClinicBookingConfigState>(
      listener: (context, state) {
        if (state is ClinicBookingConfigSubmitSuccess) {
          Alerts.snack(
            text: 'common.success'.tr(),
            state: SnackState.success,
          );
          // Navigate to availability after setting up config if it's the first time
          context.push(AppRoutes.clinicAvailability);
        } else if (state is ClinicBookingConfigSubmitError) {
          Alerts.snack(
            text: state.message,
            state: SnackState.failed,
          );
        }
      },
      builder: (context, state) => switch (state) {
        ClinicBookingConfigInitial() || ClinicBookingConfigLoading() => AppShimmer(
  child: ListView(
    padding: const EdgeInsets.all(24.0),
    children: List.generate(
      5,
      (index) => ShimmerContainer(
        height: 50,
        margin: const EdgeInsets.only(bottom: 16),
      ),
    ),
  ),
),
        ClinicBookingConfigError(:final message) => AppErrorWidget(
            message: message,
            onRetry: context.read<ClinicBookingConfigCubit>().loadConfig,
          ),
        ClinicBookingConfigSuccess(:final config) => _buildForm(config, false),
        ClinicBookingConfigSubmitLoading() => _buildForm(context.read<ClinicBookingConfigCubit>().currentConfig ?? BookingConfigDto.mock, true),
        ClinicBookingConfigSubmitError() => _buildForm(context.read<ClinicBookingConfigCubit>().currentConfig ?? BookingConfigDto.mock, false),
        ClinicBookingConfigSubmitSuccess(:final config) => _buildForm(config, false),
      },
    );
  }

  Widget _buildForm(BookingConfigDto config, bool isLoading) {
    final isMock = config.consultationFee == BookingConfigDto.mock.consultationFee && context.read<ClinicBookingConfigCubit>().currentConfig == null;
    if (!isMock) {
      _populateForm(config);
    }
    
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          CustomTextFormField(
            controller: _feeController,
            labelText: 'clinic.consultation_fee'.tr(),
            hintText: '500',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (val) => val == null || val.isEmpty ? 'validation.required'.tr() : null,
          ),
          16.ph,
          CustomTextFormField(
            controller: _currencyController,
            labelText: 'clinic.currency'.tr(),
            hintText: 'EGP',
            validator: (val) => val == null || val.isEmpty ? 'validation.required'.tr() : null,
          ),
          16.ph,
          CustomTextFormField(
            controller: _maxAdvanceController,
            labelText: 'clinic.max_advance_days'.tr(),
            hintText: '30',
            keyboardType: TextInputType.number,
            validator: (val) => val == null || val.isEmpty ? 'validation.required'.tr() : null,
          ),
          16.ph,
          CustomTextFormField(
            controller: _ttlController,
            labelText: 'clinic.reservation_ttl'.tr(),
            hintText: '15',
            keyboardType: TextInputType.number,
            validator: (val) => val == null || val.isEmpty ? 'validation.required'.tr() : null,
          ),
          16.ph,
          CustomTextFormField(
            controller: _cancelWindowController,
            labelText: 'clinic.cancellation_window'.tr(),
            hintText: '60',
            keyboardType: TextInputType.number,
            validator: (val) => val == null || val.isEmpty ? 'validation.required'.tr() : null,
          ),
          32.ph,
          CustomButton(
            text: 'common.save'.tr(),
            onPressed: _submit,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
