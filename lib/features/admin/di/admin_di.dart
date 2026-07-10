import 'package:doctory/core/locator/service_locator.dart';
import '../data/data_source/admin_mock_data_source.dart';
import '../data/repo/admin_repo.dart';
import '../cubit/dashboard/admin_dashboard_cubit.dart';
import '../cubit/specializations/admin_specializations_cubit.dart';
import '../cubit/clinics/admin_clinics_cubit.dart';
import '../cubit/doctors/admin_doctors_cubit.dart';
import '../cubit/users/admin_users_cubit.dart';
import '../cubit/payments/admin_payments_cubit.dart';
import '../cubit/subscriptions/admin_subscriptions_cubit.dart';
import '../cubit/pending_clinics/admin_pending_clinics_cubit.dart';
import '../cubit/verification/admin_verification_cubit.dart';
import '../cubit/support/admin_support_cubit.dart';
import '../cubit/ads/admin_ads_cubit.dart';
import '../cubit/profile/admin_profile_cubit.dart';

void setupAdminLocator() {
  sl.registerLazySingleton<AdminMockDataSource>(() => AdminMockDataSource());
  sl.registerLazySingleton<AdminRepo>(() => AdminRepo(sl()));

  sl.registerFactory(() => AdminDashboardCubit(sl()));
  sl.registerFactory(() => AdminSpecializationsCubit(sl()));
  sl.registerFactory(() => AdminClinicsCubit(sl()));
  sl.registerFactory(() => AdminDoctorsCubit(sl()));
  sl.registerFactory(() => AdminUsersCubit(sl()));
  sl.registerFactory(() => AdminPaymentsCubit(sl()));
  sl.registerFactory(() => AdminSubscriptionsCubit(sl()));
  sl.registerFactory(() => AdminPendingClinicsCubit(sl()));
  sl.registerFactory(() => AdminVerificationCubit(sl()));
  sl.registerFactory(() => AdminSupportCubit(sl()));
  sl.registerFactory(() => AdminAdsCubit(sl()));
  sl.registerFactory(() => AdminProfileCubit(sl()));
}
