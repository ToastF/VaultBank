import '../entities/recipient_entity.dart';

abstract class RecipientRepository {
  // Get recipients (reads cache first, triggers background sync)
  Future<List<RecipientEntity>> getRecipients(String userUid);

  // Add recipient (persist to Firestore and cache)
  Future<void> addRecipient(String userUid, RecipientEntity recipient);

  // Delete recipient by firestore doc id
  Future<void> deleteRecipient(String userUid, String recipientDocId);

  // Start listening to remote changes for this user and update local cache
  Stream<List<RecipientEntity>> listenToRecipients(String userUid);

  // Save list of recipients to local cache (Isar)
  Future<void> saveRecipientsToCache(List<RecipientEntity> recipients);
}
