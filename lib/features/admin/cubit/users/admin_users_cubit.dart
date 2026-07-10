import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/admin_repo.dart';
import 'admin_users_states.dart';

class AdminUsersCubit extends Cubit<AdminUsersState> {
  final AdminRepo _repo;

  AdminUsersCubit(this._repo) : super(AdminUsersInitial());

  void load() async {
    emit(AdminUsersLoading());
    final result = _repo.getUsers();
    result.fold(
      onSuccess: (items) => emit(AdminUsersLoaded(items)),
      onFailure: (f) => emit(AdminUsersError(f.message)),
    );
  }
}
