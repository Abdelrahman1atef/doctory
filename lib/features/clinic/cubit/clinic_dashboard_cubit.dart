import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/error/failures.dart';
import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/network/interfaces/api_result.dart';
import 'package:doctory/features/clinic/cubit/clinic_dashboard_state.dart';
import 'package:doctory/features/clinic/data/model/dashboard_stats_model.dart';
import 'package:doctory/features/clinic/data/model/booking_request_model.dart';
import 'package:doctory/features/clinic/data/repo/clinic_dashboard_repo.dart';
import 'package:doctory/features/notifications/data/repo/notifications_repo.dart';

class ClinicDashboardCubit extends Cubit<ClinicDashboardState> {
  final ClinicDashboardRepo _repo;
  static const int _perPage = 10;

  ClinicDashboardCubit(this._repo) : super(ClinicDashboardInitial());

  Future<void> loadDashboard() async {
    emit(ClinicDashboardLoading());

    final results = await Future.wait([
      _repo.getStats(),
      _repo.getBookingsByStatus('pending', 1, _perPage),
      _repo.getBookingsByStatus('pending', 1, 1),
      _repo.getBookingsByStatus('accepted', 1, 1),
      _repo.getBookingsByStatus('rejected', 1, 1),
      sl<NotificationsRepo>().getUnreadCount(),
    ]);

    final statsResult = results[0] as ApiResult<DashboardStatsModel>;
    final bookingsResult = results[1] as ApiResult<PaginatedBookingsResponse>;
    final pendingCountResult = results[2] as ApiResult<PaginatedBookingsResponse>;
    final acceptedCountResult = results[3] as ApiResult<PaginatedBookingsResponse>;
    final rejectedCountResult = results[4] as ApiResult<PaginatedBookingsResponse>;
    final countResult = results[5] as ApiResult<int>;
    final unreadCount = countResult.fold(onSuccess: (c) => c, onFailure: (_) => 0);

    statsResult.fold(
      onSuccess: (stats) {
        bookingsResult.fold(
          onSuccess: (bookingsResponse) {
            final pending = pendingCountResult.fold(onSuccess: (r) => r.totalCount, onFailure: (_) => 0);
            final accepted = acceptedCountResult.fold(onSuccess: (r) => r.totalCount, onFailure: (_) => 0);
            final rejected = rejectedCountResult.fold(onSuccess: (r) => r.totalCount, onFailure: (_) => 0);
            emit(
              ClinicDashboardLoaded(
                stats: stats,
                bookings: bookingsResponse.items,
                currentStatus: BookingStatus.pending,
                page: 1,
                hasMore: bookingsResponse.items.length >= _perPage,
                pendingCount: pending,
                acceptedCount: accepted,
                rejectedCount: rejected,
                unreadCount: unreadCount,
              ),
            );
          },
          onFailure: (failure) {
            emit(ClinicDashboardError(failure.userMessage));
          },
        );
      },
      onFailure: (failure) {
        emit(ClinicDashboardError(failure.userMessage));
      },
    );
  }

  Future<void> loadMoreBookings() async {
    final current = state;
    if (current is! ClinicDashboardLoaded) return;
    if (current.isLoadingMore || !current.hasMore) return;

    emit(current.copyWith(isLoadingMore: true));

    final nextPage = current.page + 1;
    final result = await _repo.getBookingsByStatus(
      current.currentStatus.name,
      nextPage,
      _perPage,
    );

    result.fold(
      onSuccess: (newItemsResponse) {
        if (state is! ClinicDashboardLoaded) return;
        final loaded = state as ClinicDashboardLoaded;
        emit(loaded.copyWith(
          bookings: [...loaded.bookings, ...newItemsResponse.items],
          page: nextPage,
          hasMore: newItemsResponse.items.length >= _perPage,
          isLoadingMore: false,
        ));
      },
      onFailure: (_) {
        if (state is! ClinicDashboardLoaded) return;
        emit((state as ClinicDashboardLoaded).copyWith(isLoadingMore: false));
      },
    );
  }

  Future<void> switchStatus(BookingStatus status) async {
    final current = state;
    if (current is! ClinicDashboardLoaded) return;
    if (current.currentStatus == status) return;

    emit(current.copyWith(isLoadingMore: true));

    final result = await _repo.getBookingsByStatus(status.name, 1, _perPage);
    result.fold(
      onSuccess: (bookingsResponse) {
        if (state is! ClinicDashboardLoaded) return;
        emit((state as ClinicDashboardLoaded).copyWith(
          bookings: bookingsResponse.items,
          currentStatus: status,
          page: 1,
          hasMore: bookingsResponse.items.length >= _perPage,
          isLoadingMore: false,
        ));
      },
      onFailure: (_) {
        if (state is! ClinicDashboardLoaded) return;
        emit((state as ClinicDashboardLoaded).copyWith(isLoadingMore: false));
      },
    );
  }

  Future<void> acceptBooking(String id) async {
    final result = await _repo.acceptBooking(id);
    result.fold(
      onSuccess: (_) {
        final current = state;
        if (current is ClinicDashboardLoaded) {
          final updated = current.bookings.where((b) => b.id != id).toList();
          emit(current.copyWith(
            bookings: updated,
            pendingCount: current.pendingCount - 1,
            acceptedCount: current.acceptedCount + 1,
            stats: DashboardStatsModel(
              todayVisits: current.stats.todayVisits,
              todayIncome: current.stats.todayIncome,
              weeklyVisits: current.stats.weeklyVisits,
              weeklyIncome: current.stats.weeklyIncome,
              monthlyVisits: current.stats.monthlyVisits,
              monthlyIncome: current.stats.monthlyIncome,
              yearlyVisits: current.stats.yearlyVisits,
              yearlyIncome: current.stats.yearlyIncome,
              pendingActions: updated.length,
            ),
          ));
        }
      },
      onFailure: (_) {},
    );
  }

  Future<void> rejectBooking(String id) async {
    final result = await _repo.rejectBooking(id);
    result.fold(
      onSuccess: (_) {
        final current = state;
        if (current is ClinicDashboardLoaded) {
          final updated = current.bookings.where((b) => b.id != id).toList();
          emit(current.copyWith(
            bookings: updated,
            pendingCount: current.pendingCount - 1,
            rejectedCount: current.rejectedCount + 1,
            stats: DashboardStatsModel(
              todayVisits: current.stats.todayVisits,
              todayIncome: current.stats.todayIncome,
              weeklyVisits: current.stats.weeklyVisits,
              weeklyIncome: current.stats.weeklyIncome,
              monthlyVisits: current.stats.monthlyVisits,
              monthlyIncome: current.stats.monthlyIncome,
              yearlyVisits: current.stats.yearlyVisits,
              yearlyIncome: current.stats.yearlyIncome,
              pendingActions: updated.length,
            ),
          ));
        }
      },
      onFailure: (_) {},
    );
  }
}
