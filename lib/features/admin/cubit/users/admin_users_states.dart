import '../../data/model/user_model.dart';

sealed class AdminUsersState {}

class AdminUsersInitial extends AdminUsersState {}

class AdminUsersLoading extends AdminUsersState {}

class AdminUsersLoaded extends AdminUsersState {
  final List<AdminUserModel> items;
  AdminUsersLoaded(this.items);
}

class AdminUserDetailLoaded extends AdminUsersState {
  final AdminUserModel user;
  AdminUserDetailLoaded(this.user);
}

class AdminUsersError extends AdminUsersState {
  final String message;
  AdminUsersError(this.message);
}
