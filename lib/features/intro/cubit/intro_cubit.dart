import 'package:doctory/core/cache/cache_helper.dart';
import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/core/session/user_session.dart';
import 'package:doctory/features/auth/data/repo/auth_repo.dart';
import 'package:doctory/features/intro/data/model/intro_model.dart';
import 'package:doctory/features/intro/cubit/intro_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IntroCubit extends Cubit<IntroStates> {
  IntroCubit() : super(IntroInitialState());

  List<IntroModel> getIntros() {
    return [
      IntroModel(
        id: 1,
        title: 'discover',
        content: 'discover_subtitle',
        imagePath: '',
      ),
      IntroModel(id: 2, title: 'book', content: 'book_subtitle', imagePath: ''),
      IntroModel(
        id: 3,
        title: 'compare',
        content: 'compare_subtitle',
        imagePath: '',
      ),
    ];
  }

  /// منطق التحقق من حالة المستخدم (Splash Screen Logic)
  void checkUserStatus() async {
    // Populate UserSession from cache
    await UserSession.getUser();

    final bool isLoggedIn = UserSession.token.isNotEmpty;

    // Refresh profile from server to get fresh role/permissions
    // with a 5-second timeout so splash never hangs indefinitely
    if (isLoggedIn) {
      final authRepo = sl<AuthRepo>();
      try {
        final result = await authRepo.getProfile().timeout(
          const Duration(seconds: 5),
        );
        result.fold(
          onSuccess: (user) {
            if (user.userRole != null) {
              UserSession.currentRole = user.userRole;
            }
            if (user.permissions != null) {
              UserSession.currentPermissions = user.permissions!.toSet();
            }
            UserSession.currentDoctorType = user.doctorType;
          },
          onFailure: (_) {},
        );
      } catch (_) {
        // Timeout or network error — proceed with cached session
      }
    }

    // Compatibility logic for old flags
    bool isLanguageSelected =
        CacheHelper.getBool('isLanguageSelected') ?? false;
    bool isIntroSeen = CacheHelper.getBool('isIntroSeen') ?? false;

    // If they already finished onboarding the old way (isFirstTime was false)
    final bool isFirstTimeOld = CacheHelper.getBool('isFirstTime') ?? true;
    if (!isFirstTimeOld) {
      isLanguageSelected = true;
      isIntroSeen = true;
      await CacheHelper.saveBool('isLanguageSelected', true);
      await CacheHelper.saveBool('isIntroSeen', true);
    }

    if (!isLanguageSelected) {
      // 1. Language Selection (First time ever)
      emit(ShowLanguageBottomSheetState());
    } else if (!isIntroSeen) {
      // 2. Onboarding (First time after language)
      emit(NavigateToIntroState());
    } else if (isLoggedIn) {
      // 3. Main Layout (If already logged in)
      emit(NavigateToMainState());
    } else {
      // 4. Login (If not logged in and seen intro)
      emit(NavigateToLoginState());
    }
  }

  /// دالة تعيين مشاهدة الإنترو والانتقال
  void setIntroSeen() async {
    await CacheHelper.saveBool('isIntroSeen', true);
    // After intro, we go to login (since they wouldn't be logged in yet if it's the first time)
    emit(NavigateToLoginState());
  }
}
