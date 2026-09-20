import 'package:doctory/features/clinic/data/model/availability_dto.dart';

sealed class ClinicAvailabilityState {}

class ClinicAvailabilityInitial extends ClinicAvailabilityState {}

class ClinicAvailabilityLoading extends ClinicAvailabilityState {}

class ClinicAvailabilitySuccess extends ClinicAvailabilityState {
  final List<AvailabilityDto> availability;
  ClinicAvailabilitySuccess(this.availability);
}

class ClinicAvailabilityError extends ClinicAvailabilityState {
  final String message;
  ClinicAvailabilityError(this.message);
}

class ClinicAvailabilitySubmitLoading extends ClinicAvailabilityState {}

class ClinicAvailabilitySubmitSuccess extends ClinicAvailabilityState {}

class ClinicAvailabilitySubmitError extends ClinicAvailabilityState {
  final String message;
  ClinicAvailabilitySubmitError(this.message);
}
