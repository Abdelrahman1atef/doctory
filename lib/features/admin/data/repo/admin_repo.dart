import 'package:doctory/core/error/failures.dart';
import 'package:doctory/core/network/interfaces/api_result.dart';
import '../../data/data_source/admin_mock_data_source.dart';
import '../../data/model/specialization_model.dart';
import '../../data/model/clinic_model.dart';
import '../../data/model/doctor_model.dart';
import '../../data/model/user_model.dart';
import '../../data/model/payment_model.dart';
import '../../data/model/subscription_model.dart';
import '../../data/model/pending_clinic_model.dart';
import '../../data/model/verification_model.dart';
import '../../data/model/support_ticket_model.dart';
import '../../data/model/ad_model.dart';
import '../../data/model/dashboard_stats_model.dart';
import '../../data/model/admin_profile_model.dart';

class AdminRepo {
  final AdminMockDataSource _dataSource;

  AdminRepo(this._dataSource);

  ApiResult<List<AdminSpecializationModel>> getSpecializations() {
    try {
      return ApiResult.success(_dataSource.getSpecializations());
    } catch (e) {
      return ApiResult.failure(ServerFailure(message: e.toString()));
    }
  }

  ApiResult<List<AdminClinicModel>> getClinics() {
    try {
      return ApiResult.success(_dataSource.getClinics());
    } catch (e) {
      return ApiResult.failure(ServerFailure(message: e.toString()));
    }
  }

  ApiResult<AdminClinicModel?> getClinicById(String id) {
    try {
      final clinics = _dataSource.getClinics();
      final clinic = clinics.where((c) => c.id == id).firstOrNull;
      return ApiResult.success(clinic);
    } catch (e) {
      return ApiResult.failure(ServerFailure(message: e.toString()));
    }
  }

  ApiResult<List<AdminDoctorModel>> getDoctors() {
    try {
      return ApiResult.success(_dataSource.getDoctors());
    } catch (e) {
      return ApiResult.failure(ServerFailure(message: e.toString()));
    }
  }

  ApiResult<AdminDoctorModel?> getDoctorById(String id) {
    try {
      final doctors = _dataSource.getDoctors();
      final doctor = doctors.where((d) => d.id == id).firstOrNull;
      return ApiResult.success(doctor);
    } catch (e) {
      return ApiResult.failure(ServerFailure(message: e.toString()));
    }
  }

  ApiResult<List<AdminUserModel>> getUsers() {
    try {
      return ApiResult.success(_dataSource.getUsers());
    } catch (e) {
      return ApiResult.failure(ServerFailure(message: e.toString()));
    }
  }

  ApiResult<List<AdminPaymentModel>> getPayments() {
    try {
      return ApiResult.success(_dataSource.getPayments());
    } catch (e) {
      return ApiResult.failure(ServerFailure(message: e.toString()));
    }
  }

  ApiResult<List<AdminSubscriptionModel>> getPlans() {
    try {
      return ApiResult.success(_dataSource.getPlans());
    } catch (e) {
      return ApiResult.failure(ServerFailure(message: e.toString()));
    }
  }

  ApiResult<List<AdminPendingClinicModel>> getPendingClinics() {
    try {
      return ApiResult.success(_dataSource.getPendingClinics());
    } catch (e) {
      return ApiResult.failure(ServerFailure(message: e.toString()));
    }
  }

  ApiResult<List<AdminVerificationModel>> getVerifications() {
    try {
      return ApiResult.success(_dataSource.getVerifications());
    } catch (e) {
      return ApiResult.failure(ServerFailure(message: e.toString()));
    }
  }

  ApiResult<List<AdminSupportTicketModel>> getTickets() {
    try {
      return ApiResult.success(_dataSource.getTickets());
    } catch (e) {
      return ApiResult.failure(ServerFailure(message: e.toString()));
    }
  }

  ApiResult<List<AdminAdModel>> getAds() {
    try {
      return ApiResult.success(_dataSource.getAds());
    } catch (e) {
      return ApiResult.failure(ServerFailure(message: e.toString()));
    }
  }

  ApiResult<AdminDashboardStats> getDashboardStats() {
    try {
      return ApiResult.success(_dataSource.getDashboardStats());
    } catch (e) {
      return ApiResult.failure(ServerFailure(message: e.toString()));
    }
  }

  ApiResult<List<AdminTicketModel>> getUrgentTickets() {
    try {
      return ApiResult.success(_dataSource.getUrgentTickets());
    } catch (e) {
      return ApiResult.failure(ServerFailure(message: e.toString()));
    }
  }

  ApiResult<List<AdminSubscriberModel>> getSubscribers() {
    try {
      return ApiResult.success(_dataSource.getSubscribers());
    } catch (e) {
      return ApiResult.failure(ServerFailure(message: e.toString()));
    }
  }

  ApiResult<List<AdminActivityModel>> getActivityLog() {
    try {
      return ApiResult.success(_dataSource.getActivityLog());
    } catch (e) {
      return ApiResult.failure(ServerFailure(message: e.toString()));
    }
  }

  ApiResult<AdminProfileModel> getProfile() {
    try {
      return ApiResult.success(_dataSource.getProfile());
    } catch (e) {
      return ApiResult.failure(ServerFailure(message: e.toString()));
    }
  }
}
