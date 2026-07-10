import '../../data/model/pending_clinic_model.dart';

sealed class AdminPendingClinicsState {}

class AdminPendingClinicsInitial extends AdminPendingClinicsState {}

class AdminPendingClinicsLoading extends AdminPendingClinicsState {}

class AdminPendingClinicsLoaded extends AdminPendingClinicsState {
  final List<AdminPendingClinicModel> items;
  AdminPendingClinicsLoaded(this.items);
}

class AdminPendingClinicsError extends AdminPendingClinicsState {
  final String message;
  AdminPendingClinicsError(this.message);
}
