import 'package:doctory/features/clinic/data/model/booking_config_dto.dart';

sealed class ClinicBookingConfigState {}

class ClinicBookingConfigInitial extends ClinicBookingConfigState {}

class ClinicBookingConfigLoading extends ClinicBookingConfigState {}

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
  ClinicBookingConfigSubmitSuccess(this.config);
}

class ClinicBookingConfigSubmitError extends ClinicBookingConfigState {
  final String message;
  ClinicBookingConfigSubmitError(this.message);
}
