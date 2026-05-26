import 'dart:io';
import 'package:doctory/core/locator/service_locator.dart';
import 'package:doctory/features/auth/data/model/update_profile_request.dart';
import 'package:doctory/features/auth/data/repo/auth_repo.dart';
import 'package:doctory/features/create_post/data/data_source/create_post_remote_data_source.dart';
import 'package:doctory/features/more/profile/cubit/profile_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final AuthRepo _authRepo;
  final CreatePostRemoteDataSource _mediaDataSource;

  ProfileCubit(this._authRepo, this._mediaDataSource) : super(ProfileInitial());

  Future<void> getProfile() async {
    emit(ProfileLoading());
    final result = await _authRepo.getProfile();
    result.fold(
      onSuccess: (user) => emit(ProfileLoadSuccess(user)),
      onFailure: (failure) => emit(ProfileLoadError(failure.message)),
    );
  }

  Future<void> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? birthDate,
    int? gender,
    File? profileImage,
  }) async {
    emit(ProfileUpdateLoading());

    String? profileImageUrl;

    // 1. Upload image if provided
    if (profileImage != null) {
      final uploadResult = await _mediaDataSource.uploadImage(profileImage, place: 1); // Place 1 for profiles maybe?
      uploadResult.fold(
        onSuccess: (imageUrl) => profileImageUrl = imageUrl,
        onFailure: (failure) {
          emit(ProfileUpdateError(failure.message));
          return;
        },
      );
      
      // If upload failed and we emitted error, stop here
      if (state is ProfileUpdateError) return;
    }

    // 2. Update profile data
    final request = UpdateProfileRequest(
      fullName: fullName,
      phoneNumber: phoneNumber,
      birthDate: birthDate,
      gender: gender,
      profileImageUrl: profileImageUrl,
    );

    final result = await _authRepo.updateProfile(request);
    result.fold(
      onSuccess: (_) {
        emit(ProfileUpdateSuccess('profile_update_success'));
        getProfile(); // Refresh profile data
      },
      onFailure: (failure) => emit(ProfileUpdateError(failure.message)),
    );
  }
}
