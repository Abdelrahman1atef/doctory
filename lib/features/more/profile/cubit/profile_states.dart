
import '../../../auth/data/model/user_model.dart';

sealed class ProfileStates {}

class ProfileInitial extends ProfileStates {}

class ProfileLoading extends ProfileStates {}

class ProfileLoadSuccess extends ProfileStates {
  final UserModel user;
  ProfileLoadSuccess(this.user);
}

class ProfileLoadError extends ProfileStates {
  final String message;
  ProfileLoadError(this.message);
}

class ProfileUpdateLoading extends ProfileStates {}

class ProfileUpdateSuccess extends ProfileStates {
  final String message;
  ProfileUpdateSuccess(this.message);
}

class ProfileUpdateError extends ProfileStates {
  final String message;
  ProfileUpdateError(this.message);
}
