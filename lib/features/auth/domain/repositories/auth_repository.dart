import 'package:vaultbank/features/user/domain/entities/user_entity.dart';

//Repository rules
abstract class AuthRepository {
  Future<UserEntity> signUp(String email, String password);
  Future<UserEntity> logIn(String email, String password);
}
