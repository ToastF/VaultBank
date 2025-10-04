import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:vaultbank/features/user/service/AccountNumberGenerator.dart';
import '../../../../core/util/hash_util.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../local/user_data_storage.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;

  UserRepositoryImpl(this._firestore);

  @override
  Future<UserEntity?> getCurrentUser(String uid) async {
    debugPrint("Getting Current user Data");
    // UI reads from cache first then sync with firebase in the background
    final cached = await UserStorage().getUser();
    if (cached != null && cached.uid == uid) {
      // background sync
      _syncUserFromFirestore(uid);
      return UserEntity(
        username: cached.username,
        uid: cached.uid,
        email: cached.email,
        notelp: cached.notelp,
        balance: cached.balance.toDouble(),
        accountNumber: cached.accountNumber,
      );
    }

    // If no cache, fetch directly from Firestore (first-time login)
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;

    final data = doc.data()!;
    final user = UserEntity(
      uid: uid,
      email: data['email'],
      notelp: data['notelp'],
      username: data['username'],
      balance: (data['balance'] as num? ?? 0).toDouble(),
      accountNumber: data['accountNumber'] ?? '',
    );

    await saveUserToCache(uid, data);

    return user;
  }

  // Background sync
  Future<void> _syncUserFromFirestore(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return;

      final data = doc.data()!;
      await saveUserToCache(uid, data);
    } catch (e) {
      debugPrint("Background sync failed: $e");
    }
  }

  // saves to cache
  @override
  Future<void> saveUserToCache(String uid, Map<String, dynamic> data) async {
    await UserStorage().saveUser(
      UserModel()
        ..uid = uid
        ..email = data['email']
        ..notelp = data['notelp'] ?? ''
        ..pinHash = data['pinHash'] ?? ''
        ..pinSalt = data['pinSalt'] ?? ''
        ..username = data['username'] ?? 'User'
        ..balance = (data['balance'] as num? ?? 0).toDouble()
        ..accountNumber = data['accountNumber'] ?? '',
    );
    debugPrint("Saved user data to Cache");
  }

  // Listen to Firestore changes and keep cache in sync
  @override
  Stream<UserEntity?> listenToUser(String uid) {
    debugPrint("listening to user changes");
    return _firestore.collection('users').doc(uid).snapshots().asyncMap((
      doc,
    ) async {
      if (!doc.exists) return null;

      final data = doc.data()!;
      await saveUserToCache(uid, data); // update cache every change

      return UserEntity(
        uid: uid,
        email: data['email'],
        notelp: data['notelp'],
        username: data['username'],
        balance: (data['balance'] as num? ?? 0).toDouble(),
        accountNumber: data['accountNumber'] ?? '',
      );
    });
  }

  // create firestore user profile (complete credentials)
  @override
  Future<void> createUserProfile(
    String username,
    String uid,
    String email,
    String notelp,
    String pin,
  ) async {
    // hashes pin before saving
    final salt = HashUtil.generateSalt();
    final pinHash = HashUtil.hashWithSalt(pin, salt);
    final accountNumber =
        await AccountNumberGenerator.generateUniqueAccountNumber();

    // save profile data to firestore
    await _firestore.collection('users').doc(uid).set({
      'username': username,
      'email': email,
      'pinHash': pinHash,
      'pinSalt': salt,
      'notelp': notelp,
      'balance': 0.0,
      'accountNumber': accountNumber,
    });

    // cache profile data
    await UserStorage().saveUser(
      UserModel()
        ..username = username
        ..uid = uid
        ..email = email
        ..pinHash = pinHash
        ..pinSalt = salt
        ..notelp = notelp
        ..balance = 0.0
        ..accountNumber = accountNumber,
    );
  }

  // verify pin
  @override
  Future<bool> verifyPin(String uid, String enteredPin) async {
    // check local pin first
    final localUser = await UserStorage().getUser();
    if (localUser != null && localUser.uid == uid) {
      // check with salt
      return HashUtil.verify(enteredPin, localUser.pinHash, localUser.pinSalt);
    }

    // fallback to Firestore (source of truth)
    final snapshot = await _firestore.collection('users').doc(uid).get();
    if (!snapshot.exists) return false;

    final data = snapshot.data()!;
    final storedHash = data['pinHash'] as String;
    final storedSalt = data['pinSalt'] as String;

    return HashUtil.verify(enteredPin, storedHash, storedSalt);
  }
}
