import 'package:firebase_auth/firebase_auth.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;

  AuthRepositoryImpl(this._auth);

  @override
  Future<UserEntity> signUp(String email, String password) async {

    // Create user with FirebaseAuth
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return UserEntity(uid: cred.user!.uid, email: email);
  }

  Future<UserEntity> logIn(String email, String password) async{
    final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password
    );

    return UserEntity(
      uid: cred.user!.uid,
      email: cred.user!.email!,
    );
  }

}
