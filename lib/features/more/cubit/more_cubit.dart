import 'package:doctory/core/services/social_auth_service.dart';
import 'package:doctory/core/session/user_session.dart';
import 'package:doctory/features/auth/data/repo/auth_repo.dart';
import 'package:doctory/features/more/cubit/more_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoreCubit extends Cubit<MoreStates> {
  final AuthRepo _authRepo;
  final SocialAuthService _socialAuthService;

  MoreCubit(this._authRepo, this._socialAuthService) : super(MoreInitialState());

  Future<void> logout() async {
    emit(LogoutLoadingState());

    // Call backend logout if we have a refresh token
    if (UserSession.refreshToken.isNotEmpty) {
      await _authRepo.logout(UserSession.refreshToken);
    }

    await UserSession.logout();
    await _socialAuthService.signOut();
    emit(LogoutSuccessState());
  }
}
