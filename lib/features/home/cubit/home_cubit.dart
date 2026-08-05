import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/network/interfaces/api_result.dart';
import 'package:doctory/core/common/models/shared_models.dart';
import 'package:doctory/features/ads/data/model/public_ad_model.dart';
import 'package:doctory/features/ads/data/repo/ads_repo.dart';
import 'package:doctory/features/home/cubit/home_states.dart';
import 'package:doctory/features/home/data/repo/home_repo.dart';
import 'package:doctory/features/notifications/data/repo/notifications_repo.dart';
import 'package:doctory/shared/cubit/specializations_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  final HomeRepo _homeRepo;
  final AdsRepo _adsRepo;

  HomeCubit(this._homeRepo, this._adsRepo) : super(HomeInitialState());

  void getHomeData() async {
    emit(HomeSuccessState(
      specialties: const [],
      recommendedDoctors: const [],
      featuredClinics: const [],
      ads: const [],
      unreadCount: 0,
    ));

    final sharedCubit = sl<SharedSpecializationsCubit>();
    await sharedCubit.getFamousSpecializations(forceRefresh: true);

    if (sharedCubit.state is SharedSpecializationsError) {
      emit(HomeErrorState((sharedCubit.state as SharedSpecializationsError).message));
      return;
    }

    final specialties = (sharedCubit.state is SharedSpecializationsLoaded)
        ? (sharedCubit.state as SharedSpecializationsLoaded).specializations
        : <SpecialtyModel>[];

    final results = await Future.wait([
      _homeRepo.getRecommendedDoctors(),
      _homeRepo.getFeaturedClinics(),
      _adsRepo.getActiveAds(),
      sl<NotificationsRepo>().getUnreadCount(),
    ]);

    final doctorsResult = results[0] as ApiResult<List<DoctorModel>>;
    final clinicsResult = results[1] as ApiResult<List<ClinicModel>>;
    final adsResult = results[2] as ApiResult<List<PublicAdModel>>;
    final countResult = results[3] as ApiResult<int>;
    final unreadCount = countResult.fold(onSuccess: (c) => c, onFailure: (_) => 0);
    final ads = adsResult.fold(onSuccess: (a) => a, onFailure: (_) => <PublicAdModel>[]);

    doctorsResult.fold(
      onSuccess: (doctors) {
        clinicsResult.fold(
          onSuccess: (clinics) {
            emit(
              HomeSuccessState(
                specialties: specialties,
                recommendedDoctors: doctors,
                featuredClinics: clinics,
                ads: ads,
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
