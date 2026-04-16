import 'package:doctory/core/cache/cache_helper.dart';
import 'package:doctory/core/session/user_session.dart';
import 'package:doctory/features/auth/cubit/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  void login({required String email, required String password}) async {
    emit(AuthLoadingState());

    // محاكاة تسجيل دخول ناجح للتجربة
    await Future.delayed(const Duration(seconds: 2));

    // في الحقيقة هنا بنادي على الـ Repository
    // final result = await _repository.login(email: email, password: password);
    // result.fold(...)

    const dummyToken = 'dummy_token';
    await CacheHelper.saveString('token', dummyToken);
    await UserSession.getUser();

    emit(AuthSuccessState(dummyToken));
  }
}
