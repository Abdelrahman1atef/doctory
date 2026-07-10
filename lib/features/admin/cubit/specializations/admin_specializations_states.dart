import '../../data/model/specialization_model.dart';

sealed class AdminSpecializationsState {}

class AdminSpecializationsInitial extends AdminSpecializationsState {}

class AdminSpecializationsLoading extends AdminSpecializationsState {}

class AdminSpecializationsLoaded extends AdminSpecializationsState {
  final List<AdminSpecializationModel> items;
  AdminSpecializationsLoaded(this.items);
}

class AdminSpecializationsError extends AdminSpecializationsState {
  final String message;
  AdminSpecializationsError(this.message);
}
