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
    final cached = await UserStorage().getUser();
    if (cached != null && cached.uid == uid) {
      _syncUserFromFirestore(uid);
      // PERBAIKAN 1: Sertakan profileImagePath dari cache saat membuat UserEntity
      return UserEntity(
        username: cached.username,
        uid: cached.uid,
        email: cached.email,
        notelp: cached.notelp,
        accountNumber: cached.accountNumber,
        balance: cached.balance, // Tipe sudah double dari UserModel
        profileImagePath: cached.profileImagePath,
      );
    }

    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;

    final data = doc.data()!;
    // Simpan dulu ke cache agar path gambar (jika ada) ikut tergabung
    await saveUserToCache(uid, data);

    // Baca lagi dari cache yang sudah ter-update
    final updatedCachedUser = await UserStorage().getUser();

    return UserEntity(
      uid: uid,
      email: data['email'],
      notelp: data['notelp'],
      username: data['username'],
      balance: (data['balance'] as num? ?? 0).toDouble(),
      accountNumber: data['accountNumber'] ?? '',
      // PERBAIKAN 2: Ambil profileImagePath dari cache yang baru disimpan
      profileImagePath: updatedCachedUser?.profileImagePath,
    );
  }

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

  @override
  Future<void> saveUserToCache(String uid, Map<String, dynamic> data) async {
    // PERBAIKAN 3: Buat saveUserToCache menjadi lebih "pintar"
    // Baca dulu data cache yang ada untuk mempertahankan profileImagePath
    final existingCache = await UserStorage().getUser();

    await UserStorage().saveUser(
      UserModel()
        ..uid = uid
        ..email = data['email']
        ..notelp = data['notelp'] ?? ''
        ..pinHash = data['pinHash'] ?? ''
        ..pinSalt = data['pinSalt'] ?? ''
        ..username = data['username'] ?? 'User'
        ..balance = (data['balance'] as num? ?? 0).toDouble()
        ..accountNumber = data['accountNumber'] ?? ''
        // Pertahankan path gambar lama jika ada, karena data dari firestore tidak memilikinya
        ..profileImagePath = existingCache?.profileImagePath,
    );
    debugPrint("Saved user data to Cache");
  }

  @override
  Stream<UserEntity?> listenToUser(String uid) {
    debugPrint("listening to user changes");
    return _firestore.collection('users').doc(uid).snapshots().asyncMap((
      doc,
    ) async {
      if (!doc.exists) return null;

      final data = doc.data()!;
      await saveUserToCache(uid, data);

      // Baca lagi dari cache setelah update
      final updatedCache = await UserStorage().getUser();

      // PERBAIKAN 4: Sertakan profileImagePath dari cache
      return UserEntity(
        uid: uid,
        email: data['email'],
        notelp: data['notelp'],
        username: data['username'],
        balance: (data['balance'] as num? ?? 0).toDouble(),
        accountNumber: data['accountNumber'] ?? '',
        profileImagePath: updatedCache?.profileImagePath,
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

  // New method to update profileImagePath in cache
  Future<void> updateProfileImagePath(String uid, String imagePath) async {
    final existingCache = await UserStorage().getUser();
    if (existingCache == null) return;

    final updatedUser =
        UserModel()
          ..uid = existingCache.uid
          ..email = existingCache.email
          ..notelp = existingCache.notelp
          ..pinHash = existingCache.pinHash
          ..pinSalt = existingCache.pinSalt
          ..username = existingCache.username
          ..balance = existingCache.balance
          ..accountNumber = existingCache.accountNumber
          ..profileImagePath = imagePath;

    await UserStorage().saveUser(updatedUser);
    debugPrint("Updated profileImagePath in cache");
  }
}
