import 'package:doctory/features/clinic_requests/cubit/reservation_requests_state.dart';
import 'package:doctory/features/clinic_requests/data/repo/reservation_requests_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReservationRequestsCubit extends Cubit<ReservationRequestsState> {
  final ReservationRequestsRepo _repository;

  ReservationRequestsCubit(this._repository) : super(RequestsLoading()) {
    load();
  }

  Future<void> load() async {
    emit(RequestsLoading());
    try {
      final requests = await _repository.getPending();
      emit(RequestsLoaded(requests));
    } catch (e) {
      emit(RequestsError(e.toString()));
    }
  }

  Future<void> accept(int requestId) async {
    final current = state;
    if (current is! RequestsLoaded) return;
    await _repository.accept(requestId);
    emit(
      RequestsLoaded(
        current.requests.where((r) => r.id != requestId).toList(),
      ),
    );
  }

  Future<void> reject(int requestId) async {
    final current = state;
    if (current is! RequestsLoaded) return;
    await _repository.reject(requestId);
    emit(
      RequestsLoaded(
        current.requests.where((r) => r.id != requestId).toList(),
      ),
    );
  }
}
