import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/admin_repo.dart';
import 'admin_ads_states.dart';

class AdminAdsCubit extends Cubit<AdminAdsState> {
  final AdminRepo _repo;

  AdminAdsCubit(this._repo) : super(AdminAdsInitial());

  void load() async {
    emit(AdminAdsLoading());
    final result = _repo.getAds();
    result.fold(
      onSuccess: (items) => emit(AdminAdsLoaded(items)),
      onFailure: (f) => emit(AdminAdsError(f.message)),
    );
  }
}
