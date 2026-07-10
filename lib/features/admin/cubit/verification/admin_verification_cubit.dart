import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/admin_repo.dart';
import 'admin_verification_states.dart';

class AdminVerificationCubit extends Cubit<AdminVerificationState> {
  final AdminRepo _repo;

  AdminVerificationCubit(this._repo) : super(AdminVerificationInitial());

  void load() async {
    emit(AdminVerificationLoading());
    final result = _repo.getVerifications();
    result.fold(
      onSuccess: (items) => emit(AdminVerificationLoaded(items)),
      onFailure: (f) => emit(AdminVerificationError(f.message)),
    );
  }
}
