import 'package:doctory/core/app_strings/locale_keys.dart';
import 'package:doctory/core/common/widgets/error/app_error_widget.dart';
import 'package:doctory/core/router/router_names.dart';
import 'package:doctory/core/services/alerts.dart';
import 'package:doctory/core/utils/digit_extensions.dart';
import 'package:doctory/features/clinic/cubit/clinic_booking_config_cubit.dart';
import 'package:doctory/features/clinic/cubit/clinic_booking_config_state.dart';
import 'package:doctory/features/clinic/data/model/booking_config_dto.dart';
import 'package:doctory/features/clinic/presentation/widgets/booking_config_form_widget.dart';
import 'package:doctory/features/clinic/presentation/widgets/booking_config_shimmer_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BookingConfigFormSection extends StatefulWidget {
  const BookingConfigFormSection({super.key});

  @override
  State<BookingConfigFormSection> createState() => _BookingConfigFormSectionState();
}

class _BookingConfigFormSectionState extends State<BookingConfigFormSection> {
  /// ISO code sent to the API; the form shows the localized label instead.
  static const _defaultCurrency = 'EGP';

  final _formKey = GlobalKey<FormState>();
  final _feeController = TextEditingController();
  final _maxAdvanceController = TextEditingController(text: '30');
  final _ttlController = TextEditingController(text: '30');
  final _cancellationController = TextEditingController(text: '480');
  String _currency = _defaultCurrency;
  bool _populated = false;

  /// Fills the form from the saved config exactly once, so user edits are not
  /// overwritten by later rebuilds.
  void _populate(BookingConfigDto config) {
    if (_populated) return;
    _populated = true;
    _feeController.text = _formatNumber(config.consultationFee);
    _maxAdvanceController.text = config.maxAdvanceBookingDays.toString();
    _ttlController.text = config.reservationTtlMinutes.toString();
    _cancellationController.text = config.cancellationWindowMinutes.toString();
    _currency = config.currency.isEmpty ? _defaultCurrency : config.currency;
  }

  /// Localized label for the currency code (EGP → "EGP" / "ج.م").
  String get _currencyLabel =>
      _currency == _defaultCurrency ? LocaleKeys.currency_egp.tr() : _currency;

  String _formatNumber(double value) =>
      value == value.roundToDouble() ? value.toInt().toString() : value.toString();

  // Spec: consultationFee >= 0, every other value > 0.
  String? _validateFee(String? value) {
    final number = double.tryParse((value ?? '').trim().toEnglishDigits);
    if (number == null) return LocaleKeys.required_field.tr();
    if (number < 0) return LocaleKeys.fee_cannot_be_negative.tr();
    return null;
  }

  String? _validatePositiveInt(String? value) {
    final number = int.tryParse((value ?? '').trim().toEnglishDigits);
    if (number == null) return LocaleKeys.required_field.tr();
    if (number <= 0) return LocaleKeys.must_be_positive.tr();
    return null;
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ClinicBookingConfigCubit>().submitConfig(
          BookingConfigDto(
            consultationFee: double.parse(_feeController.text.trim().toEnglishDigits),
            currency: _currency,
            maxAdvanceBookingDays: int.parse(_maxAdvanceController.text.trim().toEnglishDigits),
            reservationTtlMinutes: int.parse(_ttlController.text.trim().toEnglishDigits),
            cancellationWindowMinutes: int.parse(_cancellationController.text.trim().toEnglishDigits),
          ),
        );
  }

  void _onSubmitSuccess(BuildContext context, bool isFirstSetup) {
    Alerts.snack(text: LocaleKeys.success.tr(), state: SnackState.success);
    if (isFirstSetup) {
      // Onboarding continues with the working hours screen.
      context.push(AppRoutes.clinicAvailabilityOnboarding);
    } else if (context.canPop()) {
      context.pop();
    }
  }

  Widget _form({required bool isLoading}) {
    return BookingConfigFormWidget(
      formKey: _formKey,
      feeController: _feeController,
      currencyLabel: _currencyLabel,
      maxAdvanceController: _maxAdvanceController,
      ttlController: _ttlController,
      cancellationController: _cancellationController,
      feeValidator: _validateFee,
      positiveIntValidator: _validatePositiveInt,
      isLoading: isLoading,
      onSubmit: _submit,
    );
  }

  @override
  void dispose() {
    _feeController.dispose();
    _maxAdvanceController.dispose();
    _ttlController.dispose();
    _cancellationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClinicBookingConfigCubit, ClinicBookingConfigState>(
      listener: (context, state) {
        if (state is ClinicBookingConfigSubmitSuccess) {
          _onSubmitSuccess(context, state.isFirstSetup);
        } else if (state is ClinicBookingConfigSubmitError) {
          Alerts.snack(text: state.message, state: SnackState.failed);
        }
      },
      builder: (context, state) {
        switch (state) {
          case ClinicBookingConfigInitial():
          case ClinicBookingConfigLoading():
            return const BookingConfigShimmerWidget();
          case ClinicBookingConfigError(:final message):
            return AppErrorWidget(
              message: message,
              onRetry: context.read<ClinicBookingConfigCubit>().loadConfig,
            );
          case ClinicBookingConfigEmpty():
            return _form(isLoading: false);
          case ClinicBookingConfigSuccess(:final config):
          case ClinicBookingConfigSubmitSuccess(:final config):
            _populate(config);
            return _form(isLoading: false);
          case ClinicBookingConfigSubmitLoading():
            return _form(isLoading: true);
          case ClinicBookingConfigSubmitError():
            return _form(isLoading: false);
        }
      },
    );
  }
}
