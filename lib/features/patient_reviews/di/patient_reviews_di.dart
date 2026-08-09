import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/network/interfaces/api_consumer.dart';
import 'package:doctory/features/patient_reviews/cubit/patient_reviews_cubit.dart';
import 'package:doctory/features/patient_reviews/data/data_source/patient_reviews_remote_data_source.dart';
import 'package:doctory/features/patient_reviews/data/repo/patient_reviews_repo.dart';

void setupPatientReviewsDI() {
  sl.registerLazySingleton<PatientReviewsRemoteDataSource>(
    () => PatientReviewsRemoteDataSourceImpl(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<PatientReviewsRepo>(
    () => PatientReviewsRepoImpl(sl<PatientReviewsRemoteDataSource>()),
  );

  sl.registerFactory<PatientReviewsCubit>(
    () => PatientReviewsCubit(sl<PatientReviewsRepo>()),
  );
}