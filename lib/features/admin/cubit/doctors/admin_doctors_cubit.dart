import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/admin_repo.dart';
import 'admin_doctors_states.dart';

class AdminDoctorsCubit extends Cubit<AdminDoctorsState> {
  final AdminRepo _repo;

  AdminDoctorsCubit(this._repo) : super(AdminDoctorsInitial());

  void load() async {
    emit(AdminDoctorsLoading());
    final result = _repo.getDoctors();
    result.fold(
      onSuccess: (items) => emit(AdminDoctorsLoaded(items)),
      onFailure: (f) => emit(AdminDoctorsError(f.message)),
    );
  }

  void loadDetail(String id) async {
    emit(AdminDoctorsLoading());
    final result = _repo.getDoctorById(id);
    result.fold(
      onSuccess: (doctor) {
        if (doctor != null) {
          emit(AdminDoctorDetailLoaded(doctor));
        } else {
          emit(AdminDoctorsError('Doctor not found'));
        }
      },
      onFailure: (f) => emit(AdminDoctorsError(f.message)),
    );
  }
}
