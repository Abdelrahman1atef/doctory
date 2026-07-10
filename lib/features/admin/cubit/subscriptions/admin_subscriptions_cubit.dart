import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/admin_repo.dart';
import 'admin_subscriptions_states.dart';

class AdminSubscriptionsCubit extends Cubit<AdminSubscriptionsState> {
  final AdminRepo _repo;

  AdminSubscriptionsCubit(this._repo) : super(AdminSubscriptionsInitial());

  void load() async {
    emit(AdminSubscriptionsLoading());
    final result = _repo.getPlans();
    result.fold(
      onSuccess: (items) => emit(AdminSubscriptionsLoaded(items)),
      onFailure: (f) => emit(AdminSubscriptionsError(f.message)),
    );
  }
}
