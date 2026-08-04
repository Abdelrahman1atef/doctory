import 'package:doctory/core/common/models/specialty_model.dart';
import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/core/network/util/paginated_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class SharedSpecializationsState {}

class SharedSpecializationsInitial extends SharedSpecializationsState {}

class SharedSpecializationsLoading extends SharedSpecializationsState {}

class SharedSpecializationsLoaded extends SharedSpecializationsState {
  final List<SpecialtyModel> specializations;
  SharedSpecializationsLoaded(this.specializations);
}

class SharedSpecializationsError extends SharedSpecializationsState {
  final String message;
  SharedSpecializationsError(this.message);
}

class SharedSpecializationsCubit extends Cubit<SharedSpecializationsState> {
  final ApiConsumer _apiConsumer;
  Future<ApiResult<PaginatedData<SpecialtyModel>>>? _pendingRequest;
  bool _isLoadingAll = false;

  SharedSpecializationsCubit(this._apiConsumer)
      : super(SharedSpecializationsInitial());

  Future<void> getFamousSpecializations({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      if (state is SharedSpecializationsLoaded) return;
      if (_pendingRequest != null) {
        await _pendingRequest;
        return;
      }
    }

    emit(SharedSpecializationsLoading());

    final future = _apiConsumer.get<PaginatedData<SpecialtyModel>>(
      path: 'specializations',
      queryParameters: {'IsFamous': true},
      parser: (json) => PaginatedData.fromJson(
        json['data'],
        (item) => SpecialtyModel.fromJson(item),
      ),
    );

    _pendingRequest = future;

    final result = await future;
    _pendingRequest = null;

    if (isClosed) return;

    result.fold(
      onSuccess: (data) =>
          emit(SharedSpecializationsLoaded(data.items)),
      onFailure: (failure) =>
          emit(SharedSpecializationsError(failure.message)),
    );
  }

  Future<void> getAllSpecializations({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      if (state is SharedSpecializationsLoaded) return;
      if (_isLoadingAll) return;
    }

    _isLoadingAll = true;
    emit(SharedSpecializationsLoading());

    final result = await _apiConsumer.get<List<SpecialtyModel>>(
      path: 'specializations/active',
      parser: (json) {
        final data = json['data'] as List;
        return data.map((e) => SpecialtyModel.fromJson(e)).toList();
      },
    );

    if (isClosed) return;

    _isLoadingAll = false;

    result.fold(
      onSuccess: (data) => emit(SharedSpecializationsLoaded(data)),
      onFailure: (failure) => emit(SharedSpecializationsError(failure.message)),
    );
  }

  void setSpecializations(List<SpecialtyModel> specializations) {
    if (state is SharedSpecializationsLoaded) return;
    emit(SharedSpecializationsLoaded(specializations));
  }
}
