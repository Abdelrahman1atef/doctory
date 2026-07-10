import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/admin_repo.dart';
import 'admin_support_states.dart';

class AdminSupportCubit extends Cubit<AdminSupportState> {
  final AdminRepo _repo;

  AdminSupportCubit(this._repo) : super(AdminSupportInitial());

  void load() async {
    emit(AdminSupportLoading());
    final result = _repo.getTickets();
    result.fold(
      onSuccess: (items) => emit(AdminSupportLoaded(items)),
      onFailure: (f) => emit(AdminSupportError(f.message)),
    );
  }
}
