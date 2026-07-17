import 'package:doctory/core/error/failures.dart';
import 'package:doctory/features/clinic/cubit/reservation_requests_state.dart';
import 'package:doctory/features/clinic/data/repo/reservation_requests_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReservationRequestsCubit extends Cubit<ReservationRequestsState> {
  final ReservationRequestsRepo _repository;

  ReservationRequestsCubit(this._repository) : super(RequestsInitial());

  Future<void> load() async {
    emit(RequestsLoading());
    final result = await _repository.getPending(1, 50);
    result.fold(
      onSuccess: (requests) => emit(RequestsLoaded(requests)),
      onFailure: (failure) => emit(RequestsError(failure.userMessage)),
    );
  }

  Future<void> accept(int requestId) async {
    final current = state;
    if (current is! RequestsLoaded) return;
    final result = await _repository.accept(requestId);
    result.fold(
      onSuccess: (_) {
        emit(
          RequestsLoaded(
            current.requests.where((r) => r.id != requestId).toList(),
          ),
        );
      },
      onFailure: (_) {},
    );
  }

  Future<void> reject(int requestId) async {
    final current = state;
    if (current is! RequestsLoaded) return;
    final result = await _repository.reject(requestId);
    result.fold(
      onSuccess: (_) {
        emit(
          RequestsLoaded(
            current.requests.where((r) => r.id != requestId).toList(),
          ),
        );
      },
      onFailure: (_) {},
    );
  }
}
