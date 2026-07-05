import 'package:doctory/features/clinic/data/model/booking_request_model.dart';
import 'package:doctory/features/clinic/data/model/dashboard_stats_model.dart';
import 'package:doctory/features/clinic/data/model/quick_patient_model.dart';

sealed class ClinicDashboardState {}

class ClinicDashboardInitial extends ClinicDashboardState {}

class ClinicDashboardLoading extends ClinicDashboardState {}

class ClinicDashboardLoaded extends ClinicDashboardState {
  final DashboardStatsModel stats;
  final List<BookingRequestModel> bookings;
  final List<QuickPatientModel> searchResults;
  final int selectedTabIndex;
  final int unreadCount;

  ClinicDashboardLoaded({
    required this.stats,
    required this.bookings,
    required this.searchResults,
    this.selectedTabIndex = 0,
    this.unreadCount = 0,
  });

  ClinicDashboardLoaded copyWith({
    DashboardStatsModel? stats,
    List<BookingRequestModel>? bookings,
    List<QuickPatientModel>? searchResults,
    int? selectedTabIndex,
    int? unreadCount,
  }) {
    return ClinicDashboardLoaded(
      stats: stats ?? this.stats,
      bookings: bookings ?? this.bookings,
      searchResults: searchResults ?? this.searchResults,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class ClinicDashboardError extends ClinicDashboardState {
  final String message;

  ClinicDashboardError(this.message);
}
