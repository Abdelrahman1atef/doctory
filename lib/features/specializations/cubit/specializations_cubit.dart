import 'package:doctory/features/home/data/repo/home_repo.dart';
import 'package:doctory/features/specializations/cubit/specializations_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doctory/core/common/models/shared_models.dart';

class SpecializationsCubit extends Cubit<SpecializationsStates> {
  final HomeRepo _homeRepo;
  int _pageNumber = 1;
  final int _pageSize = 20;
  bool _isLoading = false;
  final List<SpecialtyModel> _allItems = [];

  SpecializationsCubit(this._homeRepo) : super(SpecializationsInitialState());

  void getSpecializations() async {
    if (_isLoading) return;
    _isLoading = true;

    final currentState = state;
    if (currentState is SpecializationsInitialState) {
      emit(SpecializationsLoadingState([], isFirstFetch: true));
    } else if (currentState is SpecializationsSuccessState) {
      emit(SpecializationsLoadingState(_allItems));
    }

    final result = await _homeRepo.getSpecialties(
      pageNumber: _pageNumber,
      pageSize: _pageSize,
        isFamous: false
    );

    result.fold(
      onSuccess: (paginatedData) {
        _pageNumber++;
        _allItems.addAll(paginatedData.items);
        emit(
          SpecializationsSuccessState(
            items: List.from(_allItems),
            hasNextPage: paginatedData.hasNextPage,
          ),
        );
        _isLoading = false;
      },
      onFailure: (failure) {
        emit(SpecializationsErrorState(failure.message));
        _isLoading = false;
      },
    );
  }
}
