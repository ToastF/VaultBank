import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl(this._auth, this._firestore);

  @override
  Future<UserEntity> signUp(String email, String password, String pin, String notelp) async {
    // Create user with FirebaseAuth
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Store extra info in Firestore
    await _firestore.collection('users').doc(cred.user!.uid).set({
      'email': email,
      'pin': pin, // save transaction pin
      'notelp': notelp
    });

    return UserEntity(uid: cred.user!.uid, email: email, pin: pin, notelp: notelp);
  }
}
