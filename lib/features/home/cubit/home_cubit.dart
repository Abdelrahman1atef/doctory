import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/network/interfaces/api_result.dart';
import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/features/home/cubit/home_states.dart';
import 'package:doctory/features/home/data/repo/home_repo.dart';
import 'package:doctory/features/notifications/data/repo/notifications_repo.dart';
import 'package:doctory/shared/cubit/specializations_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  final HomeRepo _homeRepo;

  HomeCubit(this._homeRepo) : super(HomeInitialState());

  void getHomeData() async {
    if (state is! HomeSuccessState) {
      emit(HomeLoadingState());
    }

    final sharedCubit = sl<SharedSpecializationsCubit>();
    if (sharedCubit.state is! SharedSpecializationsLoaded) {
      await sharedCubit.getFamousSpecializations();
    }

    final specialties = (sharedCubit.state is SharedSpecializationsLoaded)
        ? (sharedCubit.state as SharedSpecializationsLoaded).specializations
        : <SpecialtyModel>[];

    final results = await Future.wait([
      _homeRepo.getRecommendedDoctors(),
      _homeRepo.getFeaturedClinics(),
      sl<NotificationsRepo>().getUnreadCount(),
    ]);

    final doctorsResult = results[0] as ApiResult<List<DoctorModel>>;
    final clinicsResult = results[1] as ApiResult<List<ClinicModel>>;
    final countResult = results[2] as ApiResult<int>;
    final unreadCount = countResult.fold(onSuccess: (c) => c, onFailure: (_) => 0);

    doctorsResult.fold(
      onSuccess: (doctors) {
        clinicsResult.fold(
          onSuccess: (clinics) {
            emit(
              HomeSuccessState(
                specialties: specialties,
                recommendedDoctors: doctors,
                featuredClinics: clinics,
                unreadCount: unreadCount,
              ),
            );
          },
          onFailure: (failure) => emit(HomeErrorState(failure.message)),
        );
      },
      onFailure: (failure) => emit(HomeErrorState(failure.message)),
    );
  }
}
