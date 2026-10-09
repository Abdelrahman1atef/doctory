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

  /// Loads every home section independently. A failed, null or empty
  /// response for one section falls back to an empty list (the section hides
  /// itself) and never blocks the rest of the home screen.
  Future<void> getHomeData() async {
    emit(HomeLoadingState());

    final sharedCubit = sl<SharedSpecializationsCubit>();
    final results = await Future.wait([
      _homeRepo.getRecommendedDoctors(),
      _homeRepo.getFeaturedClinics(),
      _adsRepo.getActiveAds(),
      sl<NotificationsRepo>().getUnreadCount(),
      sharedCubit.getFamousSpecializations(forceRefresh: true),
    ]);

    if (isClosed) return;

    final doctorsResult = results[0] as ApiResult<List<DoctorModel>>;
    final clinicsResult = results[1] as ApiResult<List<ClinicModel>>;
    final adsResult = results[2] as ApiResult<List<PublicAdModel>>;
    final countResult = results[3] as ApiResult<int>;

    final specializationsState = sharedCubit.state;
    final specialties = specializationsState is SharedSpecializationsLoaded
        ? specializationsState.specializations
        : <SpecialtyModel>[];

    emit(
      HomeSuccessState(
        specialties: specialties,
        recommendedDoctors: doctorsResult.fold(
          onSuccess: (doctors) => doctors,
          onFailure: (_) => <DoctorModel>[],
        ),
        featuredClinics: clinicsResult.fold(
          onSuccess: (clinics) => clinics,
          onFailure: (_) => <ClinicModel>[],
        ),
        ads: adsResult.fold(
          onSuccess: (ads) => ads,
          onFailure: (_) => <PublicAdModel>[],
        ),
        unreadCount: countResult.fold(onSuccess: (c) => c, onFailure: (_) => 0),
      ),
    );
  }

  Future<void> refreshUnreadCount() async {
    final currentState = state;
    if (currentState is! HomeSuccessState) return;

    final count = await sl<NotificationsRepo>().getUnreadCount();
    final unreadCount = count.fold(onSuccess: (c) => c, onFailure: (_) => 0);

    emit(HomeSuccessState(
      specialties: currentState.specialties,
      recommendedDoctors: currentState.recommendedDoctors,
      featuredClinics: currentState.featuredClinics,
      ads: currentState.ads,
      unreadCount: unreadCount,
    ));
  }
}
