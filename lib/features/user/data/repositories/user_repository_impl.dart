import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/util/hash_util.dart';

class UserRepositoryImpl {
  final FirebaseFirestore _firestore;

  UserRepositoryImpl(this._firestore);

  // @override
  Future<void> createUserProfile(String uid, String email, String notelp, String pin) async {
    final salt = HashUtil.generateSalt();
    final pinHash = HashUtil.hashWithSalt(pin, salt);

    await _firestore.collection('users').doc(uid).set({
      'email': email,
      'pinHash': pinHash,
      'pinSalt': salt,
      'notelp': notelp,
    });
  }

  Future<bool> verifyPin(String uid, String enteredPin) async {
    final snapshot =
        await _firestore.collection('users').doc(uid).get();

    if (!snapshot.exists) return false;

    final data = snapshot.data()!;
    final storedHash = data['pin'] as String;
    final storedSalt = data['pinSalt'] as String;

    return HashUtil.verify(enteredPin, storedHash, storedSalt);
  }

}