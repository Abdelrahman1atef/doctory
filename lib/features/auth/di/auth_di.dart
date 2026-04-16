import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/features/auth/cubit/auth_cubit.dart';

class AuthDI {
  static void setup() {
    sl.registerFactory<AuthCubit>(() => AuthCubit());
  }
}
