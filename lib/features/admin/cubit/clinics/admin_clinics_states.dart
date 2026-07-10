import '../../data/model/clinic_model.dart';

sealed class AdminClinicsState {}

class AdminClinicsInitial extends AdminClinicsState {}

class AdminClinicsLoading extends AdminClinicsState {}

class AdminClinicsLoaded extends AdminClinicsState {
  final List<AdminClinicModel> items;
  AdminClinicsLoaded(this.items);
}

class AdminClinicDetailLoaded extends AdminClinicsState {
  final AdminClinicModel clinic;
  AdminClinicDetailLoaded(this.clinic);
}

class AdminClinicsError extends AdminClinicsState {
  final String message;
  AdminClinicsError(this.message);
}
