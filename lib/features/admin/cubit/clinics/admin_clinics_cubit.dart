import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/admin_repo.dart';
import 'admin_clinics_states.dart';

class AdminClinicsCubit extends Cubit<AdminClinicsState> {
  final AdminRepo _repo;

  AdminClinicsCubit(this._repo) : super(AdminClinicsInitial());

  void load() async {
    emit(AdminClinicsLoading());
    final result = _repo.getClinics();
    result.fold(
      onSuccess: (items) => emit(AdminClinicsLoaded(items)),
      onFailure: (f) => emit(AdminClinicsError(f.message)),
    );
  }

  void loadDetail(String id) async {
    emit(AdminClinicsLoading());
    final result = _repo.getClinicById(id);
    result.fold(
      onSuccess: (clinic) {
        if (clinic != null) {
          emit(AdminClinicDetailLoaded(clinic));
        } else {
          emit(AdminClinicsError('Clinic not found'));
        }
      },
      onFailure: (f) => emit(AdminClinicsError(f.message)),
    );
  }
}
