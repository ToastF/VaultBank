import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/recipient_entity.dart';
import '../../domain/repositories/recipient_repository.dart';
import '../local/recipient_list_storage.dart';

class RecipientRepositoryImpl implements RecipientRepository {
  final FirebaseFirestore _firestore;
  final RecipientStorage _storage;

  RecipientRepositoryImpl(this._firestore, this._storage);

  /// check local cache first, then background sync with Firestore
  @override
  Future<List<RecipientEntity>> getRecipients(String userUid) async {
    debugPrint("Getting recipients (cache-first) for user $userUid");

    final cached = await _storage.getModels();
    if (cached.isNotEmpty) {
      // background sync
      _syncRecipientsFromFirestore(userUid);
      // return domain entities mapped from local cache
      return cached.map((m) => m.toEntity()).toList();
    }

    // no cache? fetch from Firestore
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

    // cache
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
    // convert to models (without recipientId)
    final models =
        recipients
            .map((e) => RecipientModel.fromEntity(e, recipientId: ''))
            .toList();
    await _storage.saveModels(models);
  }

  /// Real-time listening: updates cache whenever Firestore changes
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

  /// Add recipient: write to Firestore then add to local cache (Isar)
  @override
  Future<void> addRecipient(String userUid, RecipientEntity recipient) async {
    final col = _firestore
        .collection('users')
        .doc(userUid)
        .collection('recipients');
    final docRef = col.doc(); // generate new doc id

    final payload = {
      'name': recipient.name,
      'accountNumber': recipient.accountNumber,
      'alias': recipient.alias ?? '',
    };

    await docRef.set(payload);

    // Also persist to local cache with recipientId set so delete/sync work
    final model = RecipientModel.fromEntity(recipient, recipientId: docRef.id);
    await _storage.addModel(model);

    debugPrint(
      'Added recipient ${recipient.name} (${recipient.accountNumber})',
    );
  }

  /// Delete recipient from Firestore and local cache
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
      // continue to delete local cache anyway
    }

    await _storage.deleteByRecipientId(recipientDocId);
    debugPrint(
      'Deleted recipient $recipientDocId locally and remote (if existed)',
    );
  }
}
