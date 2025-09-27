import '../entities/user_entity.dart';

//Repository rules
abstract class UserRepository {
  Future<UserEntity?> getCurrentUser(String uid);
  Future<void> saveUserToCache(String uid, Map<String, dynamic> data);
  Stream<UserEntity?> listenToUser(String uid);
  Future<void> createUserProfile(
    String username,
    String uid,
    String email,
    String notelp,
    String pin,
  );
  Future<bool> verifyPin(String uid, String enteredPin);
}
