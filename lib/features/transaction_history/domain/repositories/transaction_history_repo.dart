import '../entities/transaction_entity.dart';

abstract class TransactionHistoryRepository {
  /// Get cached transactions (offline-first)
  Future<List<TransactionEntity>> getTransactions(String uid);

  /// Save new transaction (Firestore + Isar cache)
  Future<void> addTransaction(String uid, TransactionEntity tx);

  /// Listen for Firestore changes and keep local Isar updated
  Stream<List<TransactionEntity>> listenToTransactions(String uid);

  /// Save a transaction only to local Isar (used internally)
  Future<void> saveToCache(TransactionEntity tx);
}
