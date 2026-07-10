import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/admin_repo.dart';
import 'admin_dashboard_states.dart';

class AdminDashboardCubit extends Cubit<AdminDashboardState> {
  final AdminRepo _repo;

  AdminDashboardCubit(this._repo) : super(AdminDashboardInitial());

  void load() async {
    emit(AdminDashboardLoading());
    final statsResult = _repo.getDashboardStats();
    final ticketsResult = _repo.getUrgentTickets();
    final subsResult = _repo.getSubscribers();
    final activityResult = _repo.getActivityLog();

    statsResult.fold(
      onSuccess: (stats) {
        ticketsResult.fold(
          onSuccess: (tickets) {
            subsResult.fold(
              onSuccess: (subs) {
                activityResult.fold(
                  onSuccess: (activities) {
                    emit(AdminDashboardLoaded(
                      stats: stats,
                      tickets: tickets,
                      subscribers: subs,
                      activities: activities,
                    ));
                  },
                  onFailure: (f) => emit(AdminDashboardError(f.message)),
                );
              },
              onFailure: (f) => emit(AdminDashboardError(f.message)),
            );
          },
          onFailure: (f) => emit(AdminDashboardError(f.message)),
        );
      },
      onFailure: (f) => emit(AdminDashboardError(f.message)),
    );
  }
}
