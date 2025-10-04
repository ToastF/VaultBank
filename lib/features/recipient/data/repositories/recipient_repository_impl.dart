import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/recipient_entity.dart';
import '../../domain/repositories/recipient_repository.dart';
import '../local/recipient_list_storage.dart';

class RecipientRepositoryImpl implements RecipientRepository {
  final FirebaseFirestore _firestore;

  RecipientRepositoryImpl(this._firestore);

  @override
  Future<List<RecipientEntity>> getRecipients(String userUid) async {
    debugPrint("Getting recipients (cache-first) for user $userUid");

    final cached = await RecipientStorage().getModels();
    if (cached.isNotEmpty) {
      _syncRecipientsFromFirestore(userUid);
      return cached.map((m) => m.toEntity()).toList();
    }

    final snapshot =
        await _firestore
            .collection('users')
            .doc(userUid)
            .collection('recipients')
            .get();

    final recipients =
        snapshot.docs.map((doc) {
          final data = doc.data();
          return RecipientEntity(
            name: data['name'] as String? ?? '',
            accountNumber: data['accountNumber'] as String? ?? '',
            alias:
                (data['alias'] as String?)?.isEmpty ?? true
                    ? null
                    : data['alias'] as String?,
          );
        }).toList();

    await saveRecipientsToCache(recipients);
    return recipients;
  }

  Future<void> _syncRecipientsFromFirestore(String userUid) async {
    try {
      final snapshot =
          await _firestore
              .collection('users')
              .doc(userUid)
              .collection('recipients')
              .get();

      final recipients =
          snapshot.docs.map((doc) {
            final data = doc.data();
            return RecipientEntity(
              name: data['name'] as String? ?? '',
              accountNumber: data['accountNumber'] as String? ?? '',
              alias:
                  (data['alias'] as String?)?.isEmpty ?? true
                      ? null
                      : data['alias'] as String?,
            );
          }).toList();

      await saveRecipientsToCache(recipients);
      debugPrint("Recipients synced from Firestore -> local cache");
    } catch (e) {
      debugPrint("Background recipients sync failed: $e");
    }
  }

  @override
  Future<void> saveRecipientsToCache(List<RecipientEntity> recipients) async {
    debugPrint("Updating cache with Firebase");
    final models =
        recipients
            .map((e) => RecipientModel.fromEntity(e, recipientId: ''))
            .toList();
    await RecipientStorage().saveModels(models);
  }

  @override
  Stream<List<RecipientEntity>> listenToRecipients(String userUid) {
    debugPrint("Listening to recipients for user $userUid");

    return _firestore
        .collection('users')
        .doc(userUid)
        .collection('recipients')
        .snapshots()
        .asyncMap((snapshot) async {
          final recipients =
              snapshot.docs.map((doc) {
                final d = doc.data();
                return RecipientEntity(
                  name: d['name'] as String? ?? '',
                  accountNumber: d['accountNumber'] as String? ?? '',
                  alias:
                      (d['alias'] as String?)?.isEmpty ?? true
                          ? null
                          : d['alias'] as String?,
                );
              }).toList();

          await saveRecipientsToCache(recipients);
          return recipients;
        });
  }

  @override
  Future<void> addRecipient(String userUid, RecipientEntity recipient) async {
    // Get current user data
    final currentUserDoc =
        await _firestore.collection('users').doc(userUid).get();

    final currentUserData = currentUserDoc.data();
    final currentAccountNumber = currentUserData?['accountNumber'] as String?;

    if (currentAccountNumber != null &&
        currentAccountNumber == recipient.accountNumber) {
      throw Exception("You cannot add your own account as a recipient");
    }

    // Verify account exists
    final query =
        await _firestore
            .collection('users')
            .where('accountNumber', isEqualTo: recipient.accountNumber)
            .limit(1)
            .get();

    if (query.docs.isEmpty) {
      throw Exception("Account number not found in VaultBank records");
    }

    // Use actual name from target user
    final userData = query.docs.first.data();
    final verifiedName = userData['username'] as String? ?? recipient.name;

    // Prevent duplicates
    final existing =
        await _firestore
            .collection('users')
            .doc(userUid)
            .collection('recipients')
            .where('accountNumber', isEqualTo: recipient.accountNumber)
            .limit(1)
            .get();

    if (existing.docs.isNotEmpty) {
      throw Exception("Recipient with this account already saved");
    }

    // Save
    final col = _firestore
        .collection('users')
        .doc(userUid)
        .collection('recipients');
    final docRef = col.doc();

    final payload = {
      'name': verifiedName,
      'accountNumber': recipient.accountNumber,
      'alias': recipient.alias ?? '',
    };

    await docRef.set(payload);

    final model = RecipientModel.fromEntity(
      RecipientEntity(
        name: verifiedName,
        accountNumber: recipient.accountNumber,
        alias: recipient.alias,
      ),
      recipientId: docRef.id,
    );
    await RecipientStorage().addModel(model);
    await _syncRecipientsFromFirestore(userUid);

    debugPrint('Added recipient $verifiedName (${recipient.accountNumber})');
  }

  @override
  Future<void> deleteRecipient(String userUid, String recipientDocId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userUid)
          .collection('recipients')
          .doc(recipientDocId)
          .delete();
    } catch (e) {
      debugPrint("Warning: failed to delete remote recipient: $e");
    }

    await RecipientStorage().deleteByRecipientId(recipientDocId);
    debugPrint(
      'Deleted recipient $recipientDocId locally and remote (if existed)',
    );
  }
}
