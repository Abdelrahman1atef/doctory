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

  SharedSpecializationsCubit(this._apiConsumer)
      : super(SharedSpecializationsInitial());

  Future<void> getFamousSpecializations() async {
    if (state is SharedSpecializationsLoaded) return;
    emit(SharedSpecializationsLoading());

    final result = await _apiConsumer.get<PaginatedData<SpecialtyModel>>(
      path: 'specializations',
      queryParameters: {'IsFamous': true},
      parser: (json) => PaginatedData.fromJson(
        json['data'],
        (item) => SpecialtyModel.fromJson(item),
      ),
    );

    if (isClosed) return;

    result.fold(
      onSuccess: (data) =>
          emit(SharedSpecializationsLoaded(data.items)),
      onFailure: (failure) =>
          emit(SharedSpecializationsError(failure.message)),
    );
  }
}
