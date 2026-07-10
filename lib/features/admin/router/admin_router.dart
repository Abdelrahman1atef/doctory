import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/features/admin/presentation/layout/views/admin_layout_view.dart';
import 'package:doctory/features/admin/router/admin_router_names.dart';
import 'package:doctory/features/admin/cubit/dashboard/admin_dashboard_cubit.dart';
import 'package:doctory/features/admin/cubit/specializations/admin_specializations_cubit.dart';
import 'package:doctory/features/admin/cubit/clinics/admin_clinics_cubit.dart';
import 'package:doctory/features/admin/cubit/doctors/admin_doctors_cubit.dart';
import 'package:doctory/features/admin/cubit/users/admin_users_cubit.dart';
import 'package:doctory/features/admin/cubit/payments/admin_payments_cubit.dart';
import 'package:doctory/features/admin/cubit/subscriptions/admin_subscriptions_cubit.dart';
import 'package:doctory/features/admin/cubit/pending_clinics/admin_pending_clinics_cubit.dart';
import 'package:doctory/features/admin/cubit/verification/admin_verification_cubit.dart';
import 'package:doctory/features/admin/cubit/support/admin_support_cubit.dart';
import 'package:doctory/features/admin/cubit/ads/admin_ads_cubit.dart';
import 'package:doctory/features/admin/cubit/profile/admin_profile_cubit.dart';
import 'package:doctory/features/admin/presentation/dashboard/views/admin_dashboard_view.dart';
import 'package:doctory/features/admin/presentation/specializations/views/admin_specializations_view.dart';
import 'package:doctory/features/admin/presentation/clinics/views/admin_clinics_view.dart';
import 'package:doctory/features/admin/presentation/clinics/views/admin_clinic_detail_view.dart';
import 'package:doctory/features/admin/presentation/doctors/views/admin_doctors_view.dart';
import 'package:doctory/features/admin/presentation/doctors/views/admin_doctor_detail_view.dart';
import 'package:doctory/features/admin/presentation/users/views/admin_users_view.dart';
import 'package:doctory/features/admin/presentation/payments/views/admin_payments_view.dart';
import 'package:doctory/features/admin/presentation/subscriptions/views/admin_subscriptions_view.dart';
import 'package:doctory/features/admin/presentation/pending_clinics/views/admin_pending_clinics_view.dart';
import 'package:doctory/features/admin/presentation/verification/views/admin_verification_view.dart';
import 'package:doctory/features/admin/presentation/support/views/admin_support_view.dart';
import 'package:doctory/features/admin/presentation/ads/views/admin_ads_view.dart';
import 'package:doctory/features/admin/presentation/profile/views/admin_profile_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

abstract class AdminRouter {
  static final routes = [
    ShellRoute(
      builder: (context, state, child) => AdminLayoutView(child: child),
      routes: [
        GoRoute(
          path: AdminRoutes.dashboard,
          builder: (context, state) => BlocProvider(
            create: (_) => sl<AdminDashboardCubit>()..load(),
            child: const AdminDashboardView(),
          ),
        ),
        GoRoute(
          path: AdminRoutes.specializations,
          builder: (context, state) => BlocProvider(
            create: (_) => sl<AdminSpecializationsCubit>()..load(),
            child: const AdminSpecializationsView(),
          ),
        ),
        GoRoute(
          path: AdminRoutes.clinicas,
          builder: (context, state) => BlocProvider(
            create: (_) => sl<AdminClinicsCubit>()..load(),
            child: const AdminClinicsView(),
          ),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) => BlocProvider(
                create: (_) => sl<AdminClinicsCubit>()..loadDetail(state.pathParameters['id']!),
                child: const AdminClinicDetailView(),
              ),
            ),
          ],
        ),
        GoRoute(
          path: AdminRoutes.doctors,
          builder: (context, state) => BlocProvider(
            create: (_) => sl<AdminDoctorsCubit>()..load(),
            child: const AdminDoctorsView(),
          ),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) => BlocProvider(
                create: (_) => sl<AdminDoctorsCubit>()..loadDetail(state.pathParameters['id']!),
                child: const AdminDoctorDetailView(),
              ),
            ),
          ],
        ),
        GoRoute(
          path: AdminRoutes.users,
          builder: (context, state) => BlocProvider(
            create: (_) => sl<AdminUsersCubit>()..load(),
            child: const AdminUsersView(),
          ),
        ),
        GoRoute(
          path: AdminRoutes.payments,
          builder: (context, state) => BlocProvider(
            create: (_) => sl<AdminPaymentsCubit>()..load(),
            child: const AdminPaymentsView(),
          ),
        ),
        GoRoute(
          path: AdminRoutes.subscriptions,
          builder: (context, state) => BlocProvider(
            create: (_) => sl<AdminSubscriptionsCubit>()..load(),
            child: const AdminSubscriptionsView(),
          ),
        ),
        GoRoute(
          path: AdminRoutes.pendingClinics,
          builder: (context, state) => BlocProvider(
            create: (_) => sl<AdminPendingClinicsCubit>()..load(),
            child: const AdminPendingClinicsView(),
          ),
        ),
        GoRoute(
          path: AdminRoutes.verification,
          builder: (context, state) => BlocProvider(
            create: (_) => sl<AdminVerificationCubit>()..load(),
            child: const AdminVerificationView(),
          ),
        ),
        GoRoute(
          path: AdminRoutes.support,
          builder: (context, state) => BlocProvider(
            create: (_) => sl<AdminSupportCubit>()..load(),
            child: const AdminSupportView(),
          ),
        ),
        GoRoute(
          path: AdminRoutes.ads,
          builder: (context, state) => BlocProvider(
            create: (_) => sl<AdminAdsCubit>()..load(),
            child: const AdminAdsView(),
          ),
        ),
        GoRoute(
          path: AdminRoutes.profile,
          builder: (context, state) => BlocProvider(
            create: (_) => sl<AdminProfileCubit>()..load(),
            child: const AdminProfileView(),
          ),
        ),
      ],
    ),
  ];
}
