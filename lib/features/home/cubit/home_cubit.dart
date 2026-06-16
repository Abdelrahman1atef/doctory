import 'package:doctory/core/network/interfaces/api_result.dart';
import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/core/network/util/paginated_data.dart';
import 'package:doctory/features/home/cubit/home_states.dart';
import 'package:doctory/features/home/data/repo/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  final HomeRepo _homeRepo;

  HomeCubit(this._homeRepo) : super(HomeInitialState());

  void getHomeData() async {
    // If we already have success state, don't show loading again (for prefetch)
    if (state is! HomeSuccessState) {
      emit(HomeLoadingState());
    }

    final results = await Future.wait([
      _homeRepo.getSpecialties(isFamous: true),
      _homeRepo.getRecommendedDoctors(),
      _homeRepo.getFeaturedClinics(),
    ]);

    final specialtiesResult =
        results[0] as ApiResult<PaginatedData<SpecialtyModel>>;
    final doctorsResult = results[1] as ApiResult<List<DoctorModel>>;
    final clinicsResult = results[2] as ApiResult<List<ClinicModel>>;

    specialtiesResult.fold(
      onSuccess: (paginatedSpecialties) {
        final specialties = paginatedSpecialties.items;
        doctorsResult.fold(
          onSuccess: (doctors) {
            clinicsResult.fold(
              onSuccess: (clinics) {
                emit(
                  HomeSuccessState(
                    specialties: specialties,
                    recommendedDoctors: doctors,
                    featuredClinics: clinics,
                  ),
                );
              },
              onFailure: (failure) => emit(HomeErrorState(failure.message)),
            );
          },
          onFailure: (failure) => emit(HomeErrorState(failure.message)),
        );
      },
      onFailure: (failure) => emit(HomeErrorState(failure.message)),
    );
  }
}
