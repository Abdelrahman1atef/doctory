import '../../data/model/verification_model.dart';

sealed class AdminVerificationState {}

class AdminVerificationInitial extends AdminVerificationState {}

class AdminVerificationLoading extends AdminVerificationState {}

class AdminVerificationLoaded extends AdminVerificationState {
  final List<AdminVerificationModel> items;
  AdminVerificationLoaded(this.items);
}

class AdminVerificationError extends AdminVerificationState {
  final String message;
  AdminVerificationError(this.message);
}
