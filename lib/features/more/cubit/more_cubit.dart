import 'package:doctory/core/services/social_auth_service.dart';
import 'package:doctory/core/session/user_session.dart';
import 'package:doctory/features/auth/data/repo/auth_repo.dart';
import 'package:doctory/features/more/cubit/more_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoreCubit extends Cubit<MoreStates> {
  final AuthRepo _authRepo;
  final SocialAuthService _socialAuthService;

  MoreCubit(this._authRepo, this._socialAuthService)
    : super(MoreInitialState());

  Future<void> logout() async {
    emit(LogoutLoadingState());

    if (UserSession.refreshToken.isNotEmpty) {
      await _authRepo.logout(UserSession.refreshToken);
    }

    await UserSession.logout();
    await _socialAuthService.signOut();
    emit(LogoutSuccessState());
  }

  Future<void> deleteAccount() async {
    emit(DeleteAccountLoadingState());

    final userId = UserSession.userId;
    if (userId == null) {
      emit(const DeleteAccountErrorState('User not found'));
      return;
    }

    final result = await _authRepo.deleteAccount(userId);
    result.fold(
      onSuccess: (_) async {
        await UserSession.logout();
        await _socialAuthService.signOut();
        emit(DeleteAccountSuccessState());
      },
      onFailure: (failure) {
        emit(DeleteAccountErrorState(failure.message));
      },
    );
  }
}
