import 'package:vaultbank/features/auth/domain/entities/user_entity.dart';

//Repository rules
abstract class AuthRepository {
  Future<UserEntity> signUp(String email, String password, String pin, String notelp);
}
