import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/admin_repo.dart';
import '../../data/model/pending_clinic_model.dart';
import 'admin_pending_clinics_states.dart';

class AdminPendingClinicsCubit extends Cubit<AdminPendingClinicsState> {
  final AdminRepo _repo;
  List<AdminPendingClinicModel> _all = [];

  AdminPendingClinicsCubit(this._repo) : super(AdminPendingClinicsInitial());

  void load() async {
    emit(AdminPendingClinicsLoading());
    final result = _repo.getPendingClinics();
    result.fold(
      onSuccess: (items) {
        _all = items;
        emit(AdminPendingClinicsLoaded(items));
      },
      onFailure: (f) => emit(AdminPendingClinicsError(f.message)),
    );
  }

  void updateStatus(String id, PendingClinicStatus status, {String? notes}) {
    _all = _all.map((e) {
      if (e.id == id) return e.copyWith(status: status, notes: notes);
      return e;
    }).toList();
    emit(AdminPendingClinicsLoaded(_all));
  }
}
