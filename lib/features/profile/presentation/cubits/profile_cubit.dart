import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_flutter/features/profile/domain/repos/profile_repo.dart';
import 'package:social_media_flutter/features/storage/domain/storage_repo.dart';
import 'profile_states.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  ProfileCubit({required this.profileRepo, required this.storageRepo})
    : super(ProfileInitial());

  //fetch user rofile using repo
  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchUserProfile(uid);

      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError("User not found."));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  //update bio and or profile picture
  Future<void> updateProfile({
    required String uid,
    String? newBio,
    Uint8List? imageWebBytes,
    String? imageMobilePath,
  }) async {
    emit(ProfileLoading());
    try {
      // fetch current profile first
      final currentUser = await profileRepo.fetchUserProfile(uid);

      if (currentUser == null) {
        emit(ProfileError("Failed to fetch user for profile update"));
        return;
      }

      //profile picture update
      String? imageDownloadUrl;

      //ensure there is an image
      if (imageWebBytes != null || imageMobilePath != null) {
        //for mobile
        if (imageWebBytes != null) {
          //upload
          imageDownloadUrl = await storageRepo.uploadProfileImageMobile(
            imageMobilePath!,
            uid,
          );
        }
        //for web
        else if (imageWebBytes != null) {
          //upload
          imageDownloadUrl = await storageRepo.uploadProfileImageWeb(
            imageWebBytes,
            uid,
          );
        }

        if (imageDownloadUrl == null) {
          emit(ProfileError("Failed to upload image"));
          return;
        }
      }

      //update new profile
      final updatedProfile = currentUser.copyWith(
        newBio: newBio ?? currentUser.bio,
        newProfileImageUrl: imageDownloadUrl ?? currentUser.profileImageUrl,
      );

      //update in repo
      await profileRepo.updateProfile(updatedProfile);

      //re-fetch profile
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileError("Error updating profile: $e"));
    }
  }
}
