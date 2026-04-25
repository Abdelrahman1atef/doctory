import 'package:doctory/core/common/models/shared_models.dart';

abstract class DoctorDetailsStates {}

class DoctorDetailsInitial extends DoctorDetailsStates {}

class DoctorDetailsLoading extends DoctorDetailsStates {}

class DoctorDetailsLoaded extends DoctorDetailsStates {
  final DoctorModel doctor;
  DoctorDetailsLoaded(this.doctor);
}

class DoctorDetailsError extends DoctorDetailsStates {
  final String message;
  DoctorDetailsError(this.message);
}
