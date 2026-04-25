import 'package:doctory/features/home/cubit/home_states.dart';
import 'package:doctory/features/home/data/repo/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  final HomeRepo _homeRepo;

  HomeCubit(this._homeRepo) : super(HomeInitialState());

  void getHomeData() async {
    emit(HomeLoadingState());

    final specialtiesResult = await _homeRepo.getSpecialties();
    final doctorsResult = await _homeRepo.getRecommendedDoctors();
    final clinicsResult = await _homeRepo.getFeaturedClinics();

    // If any fails, emit error
    if (specialtiesResult.isFailure) {
      emit(HomeErrorState(specialtiesResult.failure!.message));
      return;
    }
    if (doctorsResult.isFailure) {
      emit(HomeErrorState(doctorsResult.failure!.message));
      return;
    }
    if (clinicsResult.isFailure) {
      emit(HomeErrorState(clinicsResult.failure!.message));
      return;
    }

    emit(
      HomeSuccessState(
        specialties: specialtiesResult.data ?? [],
        recommendedDoctors: doctorsResult.data ?? [],
        featuredClinics: clinicsResult.data ?? [],
      ),
    );
  }
}
