import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:vaultbank/features/transaction_history/domain/repositories/transaction_history_repo.dart';
import '../../domain/entities/transaction_entity.dart';
import '../local/transaction_data_storage.dart';

class TransactionHistoryRepositoryImpl implements TransactionHistoryRepository {
  final FirebaseFirestore _firestore;

  TransactionHistoryRepositoryImpl(this._firestore);

  TransactionEntity _toEntity(TransactionModel model) {
    return TransactionEntity(
      id: model.txnId,
      amount: model.amount,
      timestamp: model.timestamp,
      status: TransactionStatus.values.firstWhere(
        (e) => e.name == model.status,
        orElse: () => TransactionStatus.failed,
      ),
      type: TransactionType.values.firstWhere(
        (e) => e.name == model.type,
        orElse: () => TransactionType.antarRekening,
      ),
      senderName: model.senderName,
      senderAccount: model.senderAccount,
      recipientName: model.recipientName,
      recipientAccount: model.recipientAccount,
      recipientBankName: model.recipientBankName,
      notes: model.notes,
    );
  }

  TransactionModel _toModel(TransactionEntity entity) {
    return TransactionModel()
      ..txnId = entity.id
      ..amount = entity.amount
      ..timestamp = entity.timestamp
      ..status = entity.status.name
      ..type = entity.type.name
      ..senderName = entity.senderName
      ..senderAccount = entity.senderAccount
      ..recipientName = entity.recipientName
      ..recipientAccount = entity.recipientAccount
      ..recipientBankName = entity.recipientBankName ?? "VaultBank"
      ..notes = entity.notes;
  }

  @override
  Future<void> addTransaction(String uid, TransactionEntity tx) async {
    final docRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .doc(tx.id);

    await docRef.set({
      'amount': tx.amount,
      'timestamp': tx.timestamp.toIso8601String(),
      'status': tx.status.name,
      'type': tx.type.name,
      'senderName': tx.senderName,
      'senderAccount': tx.senderAccount,
      'recipientName': tx.recipientName,
      'recipientAccount': tx.recipientAccount,
      'recipientBankName': tx.recipientBankName ?? "VaultBank",
      'notes': tx.notes,
    });

    // Save to cache
    await TransactionStorage().saveTransaction(_toModel(tx));

    debugPrint("Transaction saved to Firestore + Cache");
  }

  @override
  Future<List<TransactionEntity>> getTransactions(String uid) async {
    // get local first
    final cached = await TransactionStorage().getTransactions();
    if (cached.isNotEmpty) {
      _syncFromFirestore(uid);
      return cached.map(_toEntity).toList();
    }

    // fallback to firestore
    final snapshot =
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('transactions')
            .get();

    final list =
        snapshot.docs.map((doc) {
          final data = doc.data();
          return TransactionEntity(
            id: doc.id,
            amount: (data['amount'] as num).toDouble(),
            timestamp: DateTime.parse(data['timestamp']),
            status: TransactionStatus.values.firstWhere(
              (e) => e.name == data['status'],
              orElse: () => TransactionStatus.failed,
            ),
            type: TransactionType.values.firstWhere(
              (e) => e.name == data['type'],
              orElse: () => TransactionType.antarRekening,
            ),
            senderName: data['senderName'],
            senderAccount: data['senderAccount'],
            recipientName: data['recipientName'],
            recipientAccount: data['recipientAccount'],
            recipientBankName: data['recipientBankName'] ?? "VaultBank",
            notes: data['notes'],
          );
        }).toList();

    // cache them
    for (final tx in list) {
      await TransactionStorage().saveTransaction(_toModel(tx));
    }

    return list;
  }

  @override
  Stream<List<TransactionEntity>> listenToTransactions(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .snapshots()
        .asyncMap((snapshot) async {
          final entities =
              snapshot.docs.map((doc) {
                final data = doc.data();
                return TransactionEntity(
                  id: doc.id,
                  amount: (data['amount'] as num).toDouble(),
                  timestamp: DateTime.parse(data['timestamp']),
                  status: TransactionStatus.values.firstWhere(
                    (e) => e.name == data['status'],
                    orElse: () => TransactionStatus.failed,
                  ),
                  type: TransactionType.values.firstWhere(
                    (e) => e.name == data['type'],
                    orElse: () => TransactionType.antarRekening,
                  ),
                  senderName: data['senderName'],
                  senderAccount: data['senderAccount'],
                  recipientName: data['recipientName'],
                  recipientAccount: data['recipientAccount'],
                  recipientBankName: data['recipientBankName'] ?? "VaultBank",
                  notes: data['notes'],
                );
              }).toList();

          // keep cache synced
          for (final tx in entities) {
            await TransactionStorage().saveTransaction(_toModel(tx));
          }

          return entities;
        });
  }

  @override
  Future<void> saveToCache(TransactionEntity tx) async {
    await TransactionStorage().saveTransaction(_toModel(tx));
  }

  Future<void> _syncFromFirestore(String uid) async {
    try {
      final snapshot =
          await _firestore
              .collection('users')
              .doc(uid)
              .collection('transactions')
              .get();

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final tx = TransactionEntity(
          id: doc.id,
          amount: (data['amount'] as num).toDouble(),
          timestamp: DateTime.parse(data['timestamp']),
          status: TransactionStatus.values.firstWhere(
            (e) => e.name == data['status'],
            orElse: () => TransactionStatus.failed,
          ),
          type: TransactionType.values.firstWhere(
            (e) => e.name == data['type'],
            orElse: () => TransactionType.antarRekening,
          ),
          senderName: data['senderName'],
          senderAccount: data['senderAccount'],
          recipientName: data['recipientName'],
          recipientAccount: data['recipientAccount'],
          recipientBankName: data['recipientBankName'] ?? "VaultBank",
          notes: data['notes'],
        );

        await TransactionStorage().saveTransaction(_toModel(tx));
      }
    } catch (e) {
      debugPrint("Background sync failed: $e");
    }
  }
}
