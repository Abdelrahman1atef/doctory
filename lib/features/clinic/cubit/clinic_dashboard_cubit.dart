import 'dart:async';
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
  Timer? _debounceTimer;

  ClinicDashboardCubit(this._repo) : super(ClinicDashboardInitial());

  Future<void> loadDashboard() async {
    emit(ClinicDashboardLoading());

    final results = await Future.wait([
      _repo.getStats(),
      _repo.getPendingBookings(),
      sl<NotificationsRepo>().getUnreadCount(),
    ]);

    final statsResult = results[0] as ApiResult<DashboardStatsModel>;
    final bookingsResult = results[1] as ApiResult<List<BookingRequestModel>>;
    final countResult = results[2] as ApiResult<int>;
    final unreadCount = countResult.fold(onSuccess: (c) => c, onFailure: (_) => 0);

    statsResult.fold(
      onSuccess: (stats) {
        bookingsResult.fold(
          onSuccess: (bookings) {
            emit(
              ClinicDashboardLoaded(
                stats: stats,
                bookings: bookings,
                searchResults: [],
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

  Future<void> acceptBooking(int id) async {
    final result = await _repo.acceptBooking(id);
    result.fold(
      onSuccess: (_) {
        final current = state;
        if (current is ClinicDashboardLoaded) {
          final updated = current.bookings.where((b) => b.id != id).toList();
          emit(
            current.copyWith(
              bookings: updated,
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
            ),
          );
        }
      },
      onFailure: (_) {},
    );
  }

  Future<void> rejectBooking(int id) async {
    final result = await _repo.rejectBooking(id);
    result.fold(
      onSuccess: (_) {
        final current = state;
        if (current is ClinicDashboardLoaded) {
          final updated = current.bookings.where((b) => b.id != id).toList();
          emit(
            current.copyWith(
              bookings: updated,
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
            ),
          );
        }
      },
      onFailure: (_) {},
    );
  }

  void searchPatients(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      final current = state;
      if (current is! ClinicDashboardLoaded) return;

      final result = await _repo.searchPatients(query);
      result.fold(
        onSuccess: (results) {
          emit(
            current.copyWith(searchResults: results),
          );
        },
        onFailure: (_) {},
      );
    });
  }

  void switchTab(int index) {
    final current = state;
    if (current is ClinicDashboardLoaded) {
      emit(current.copyWith(selectedTabIndex: index));
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
