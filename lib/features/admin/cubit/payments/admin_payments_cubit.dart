import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/admin_repo.dart';
import 'admin_payments_states.dart';

class AdminPaymentsCubit extends Cubit<AdminPaymentsState> {
  final AdminRepo _repo;

  AdminPaymentsCubit(this._repo) : super(AdminPaymentsInitial());

  void load() async {
    emit(AdminPaymentsLoading());
    final result = _repo.getPayments();
    result.fold(
      onSuccess: (items) => emit(AdminPaymentsLoaded(items)),
      onFailure: (f) => emit(AdminPaymentsError(f.message)),
    );
  }
}
