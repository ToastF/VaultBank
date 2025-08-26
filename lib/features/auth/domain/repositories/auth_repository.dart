import '../entities/auth_entity.dart';

//Repository rules
abstract class AuthRepository {
  Future<AuthEntity> signUp(String email, String password);
  Future<AuthEntity> logIn(String email, String password);
  Future<AuthEntity?> getCurrentAuth();
}
