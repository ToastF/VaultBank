import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';

// Implementation of AuthRepository

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;

  AuthRepositoryImpl(this._auth);

  // Signup using firebase authentication
  @override
  Future<AuthEntity> signUp(String email, String password) async {

    // Create user with FirebaseAuth
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return AuthEntity(uid: cred.user!.uid);
  }

  // Login a user using firebase authentication
  @override
  Future<AuthEntity> logIn(String email, String password) async{

    // Login user with FirebaseAuth
    final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password
    );

    return AuthEntity(
      uid: cred.user!.uid,
    );
  }

  // Getter function for firebase login status
  @override
  Future<AuthEntity?> getCurrentAuth() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;
    return AuthEntity(uid: firebaseUser.uid);
  }

}
