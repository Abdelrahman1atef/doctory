import 'package:doctory/features/clinic/data/model/booking_config_dto.dart';

sealed class ClinicBookingConfigState {}

class ClinicBookingConfigInitial extends ClinicBookingConfigState {}

class ClinicBookingConfigLoading extends ClinicBookingConfigState {}

/// The clinic has no booking config yet — show the form in create mode.
class ClinicBookingConfigEmpty extends ClinicBookingConfigState {}

class ClinicBookingConfigSuccess extends ClinicBookingConfigState {
  final BookingConfigDto config;
  ClinicBookingConfigSuccess(this.config);
}

class ClinicBookingConfigError extends ClinicBookingConfigState {
  final String message;
  ClinicBookingConfigError(this.message);
}

class ClinicBookingConfigSubmitLoading extends ClinicBookingConfigState {}

class ClinicBookingConfigSubmitSuccess extends ClinicBookingConfigState {
  final BookingConfigDto config;

  /// True when this save created the config for the first time (onboarding).
  final bool isFirstSetup;
  ClinicBookingConfigSubmitSuccess(this.config, {required this.isFirstSetup});
}

class ClinicBookingConfigSubmitError extends ClinicBookingConfigState {
  final String message;
  ClinicBookingConfigSubmitError(this.message);
}
