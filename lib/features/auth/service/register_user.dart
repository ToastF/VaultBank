import '../data/repositories/auth_repository_impl.dart';
import '../../../features/user/data/repositories/user_repository_impl.dart';
import '../domain/entities/auth_entity.dart';

// Service class for signup scenario, calls auth and user repositories' implementations
class RegisterUser {
  final AuthRepositoryImpl _authRepository;
  final UserRepositoryImpl _userRepository;

  RegisterUser(this._authRepository, this._userRepository);

  Future<AuthEntity> call(
    String username,
    String email,
    String password,
    String pin,
    String notelp,
  ) async {
    // Create user in FirebaseAuth
    final authEntity = await _authRepository.signUp(email, password);

    // Store profile + PIN in Firestore
    await _userRepository.createUserProfile(
      username,
      authEntity.uid,
      email,
      notelp,
      pin,
    );

    // Return domain-level AuthEntity
    return AuthEntity(uid: authEntity.uid);
  }
}
