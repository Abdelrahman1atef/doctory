import '../../data/model/dashboard_stats_model.dart';

sealed class AdminDashboardState {}

class AdminDashboardInitial extends AdminDashboardState {}

class AdminDashboardLoading extends AdminDashboardState {}

class AdminDashboardLoaded extends AdminDashboardState {
  final AdminDashboardStats stats;
  final List<AdminTicketModel> tickets;
  final List<AdminSubscriberModel> subscribers;
  final List<AdminActivityModel> activities;

  AdminDashboardLoaded({
    required this.stats,
    required this.tickets,
    required this.subscribers,
    required this.activities,
  });
}

class AdminDashboardError extends AdminDashboardState {
  final String message;
  AdminDashboardError(this.message);
}
