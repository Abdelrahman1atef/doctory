import '../../data/model/admin_profile_model.dart';

sealed class AdminProfileState {}

class AdminProfileInitial extends AdminProfileState {}

class AdminProfileLoading extends AdminProfileState {}

class AdminProfileLoaded extends AdminProfileState {
  final AdminProfileModel profile;
  AdminProfileLoaded(this.profile);
}

class AdminProfileError extends AdminProfileState {
  final String message;
  AdminProfileError(this.message);
}
