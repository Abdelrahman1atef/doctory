import '../../data/model/doctor_model.dart';

sealed class AdminDoctorsState {}

class AdminDoctorsInitial extends AdminDoctorsState {}

class AdminDoctorsLoading extends AdminDoctorsState {}

class AdminDoctorsLoaded extends AdminDoctorsState {
  final List<AdminDoctorModel> items;
  AdminDoctorsLoaded(this.items);
}

class AdminDoctorDetailLoaded extends AdminDoctorsState {
  final AdminDoctorModel doctor;
  AdminDoctorDetailLoaded(this.doctor);
}

class AdminDoctorsError extends AdminDoctorsState {
  final String message;
  AdminDoctorsError(this.message);
}
