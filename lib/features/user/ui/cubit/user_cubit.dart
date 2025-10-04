import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:vaultbank/features/user/data/repositories/user_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import 'package:flutter/foundation.dart';
import '../../../home/ui/page/profile/data/profile_picture_storage.dart';
import 'package:image_picker/image_picker.dart';
part 'user_state.dart';

// Cubit for managing User Data state
class UserCubit extends Cubit<UserState> {
  final UserRepositoryImpl userRepo;
  StreamSubscription? _userSub;

  UserCubit(this.userRepo) : super(UserInitial());

  // Load user on app start
  Future<void> loadUser(String uid) async {
    debugPrint("loading User");
    emit(UserLoading());
    try {
      final user = await userRepo.getCurrentUser(uid);
      if (user != null) {
        emit(UserLoaded(user));
      } else {
        emit(UserError("User not found"));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  // Sync user data during app runtime
  void startUserListener(String uid) {
    debugPrint("Starting User Data Listener");
    _userSub?.cancel();
    _userSub = userRepo
        .listenToUser(uid)
        .listen(
          (user) {
            if (user != null) {
              emit(UserLoaded(user));
            }
          },
          onError: (e) {
            emit(UserError(e.toString()));
          },
        );
  }

  // untuk update profile picture
  Future<void> updateProfilePicture() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      final path = pickedFile.path;

      // Simpan ke SharedPreferences
      await ProfilePictureStorage.saveProfileImagePath(path);

      if (state is UserLoaded) {
        final currentUser = (state as UserLoaded).user;
        final updatedUser = currentUser.copyWith(profileImagePath: path);
        emit(UserLoaded(updatedUser));
      }
    } catch (e) {
      debugPrint("Failed to update profile picture: $e");
    }
  }
}
