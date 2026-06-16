import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/features/specializations/cubit/specializations_cubit.dart';

void setupSpecializationsLocator() {
  sl.registerFactory(() => SpecializationsCubit(sl()));
}
