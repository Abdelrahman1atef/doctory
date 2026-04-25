import 'package:doctory/core/common/models/shared_models.dart';

abstract class ClinicDetailsStates {}

class ClinicDetailsInitial extends ClinicDetailsStates {}

class ClinicDetailsLoading extends ClinicDetailsStates {}

class ClinicDetailsLoaded extends ClinicDetailsStates {
  final ClinicModel clinic;
  ClinicDetailsLoaded(this.clinic);
}

class ClinicDetailsError extends ClinicDetailsStates {
  final String message;
  ClinicDetailsError(this.message);
}
