import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/admin_repo.dart';
import 'admin_profile_states.dart';

class AdminProfileCubit extends Cubit<AdminProfileState> {
  final AdminRepo _repo;

  AdminProfileCubit(this._repo) : super(AdminProfileInitial());

  void load() async {
    emit(AdminProfileLoading());
    final result = _repo.getProfile();
    result.fold(
      onSuccess: (profile) => emit(AdminProfileLoaded(profile)),
      onFailure: (f) => emit(AdminProfileError(f.message)),
    );
  }
}
