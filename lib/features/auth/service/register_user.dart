import '../data/repositories/auth_repository_impl.dart';
import '../../../features/user/data/repositories/user_repository_impl.dart';
import '../../../features/user/domain/entities/user_entity.dart';

class RegisterUser {
  final AuthRepositoryImpl _authRepository;
  final UserRepositoryImpl _userRepository;

  RegisterUser(this._authRepository, this._userRepository);

  Future<UserEntity> call(
    String email,
    String password,
    String pin,
    String notelp,
  ) async {
    // 1. Create user in FirebaseAuth
    final authEntity = await _authRepository.signUp(email, password);

    // 2. Store profile + PIN in Firestore
    await _userRepository.createUserProfile(
      authEntity.uid,
      email,
      notelp,
      pin,
    );

    // 3. Return domain-level UserEntity
    return UserEntity(
      uid: authEntity.uid,
      email: email,
      notelp: notelp,
    );
  }
}
