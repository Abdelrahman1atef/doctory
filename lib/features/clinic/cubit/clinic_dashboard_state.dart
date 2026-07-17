import 'package:doctory/features/clinic/data/model/booking_request_model.dart';
import 'package:doctory/features/clinic/data/model/dashboard_stats_model.dart';

sealed class ClinicDashboardState {}

class ClinicDashboardInitial extends ClinicDashboardState {}

class ClinicDashboardLoading extends ClinicDashboardState {}

class ClinicDashboardLoaded extends ClinicDashboardState {
  final DashboardStatsModel stats;
  final List<BookingRequestModel> bookings;
  final BookingStatus currentStatus;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;
  final int pendingCount;
  final int acceptedCount;
  final int rejectedCount;
  final int unreadCount;

  ClinicDashboardLoaded({
    required this.stats,
    required this.bookings,
    this.currentStatus = BookingStatus.pending,
    this.page = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.pendingCount = 0,
    this.acceptedCount = 0,
    this.rejectedCount = 0,
    this.unreadCount = 0,
  });

  ClinicDashboardLoaded copyWith({
    DashboardStatsModel? stats,
    List<BookingRequestModel>? bookings,
    BookingStatus? currentStatus,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    int? pendingCount,
    int? acceptedCount,
    int? rejectedCount,
    int? unreadCount,
  }) {
    return ClinicDashboardLoaded(
      stats: stats ?? this.stats,
      bookings: bookings ?? this.bookings,
      currentStatus: currentStatus ?? this.currentStatus,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      pendingCount: pendingCount ?? this.pendingCount,
      acceptedCount: acceptedCount ?? this.acceptedCount,
      rejectedCount: rejectedCount ?? this.rejectedCount,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class ClinicDashboardError extends ClinicDashboardState {
  final String message;

  ClinicDashboardError(this.message);
}
