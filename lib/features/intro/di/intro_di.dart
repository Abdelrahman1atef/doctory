import 'package:doctory/features/intro/cubit/intro_cubit.dart';
import 'package:doctory/core/locator/service_locator.dart';

class IntroDI {
  static void setup() {
    sl.registerFactory<IntroCubit>(() => IntroCubit());
  }
}
