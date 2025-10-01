import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vaultbank/features/transaction_history/domain/entities/transaction_entity.dart';
import '../../domain/repositories/transfer_repository.dart';
import 'package:flutter/foundation.dart';

class TransferRepositoryImpl implements TransferRepository {
  final FirebaseFirestore _firestore;

  TransferRepositoryImpl(this._firestore);

  @override
  Future<TransactionEntity> makeTransfer({
    required String uid,
    required String senderAccount,
    required String senderName,
    required String recipientAccount,
    required String recipientName,
    required double amount,
    required TransactionType type,
    String? notes,
  }) async {
    if (amount <= 0) {
      throw Exception("Invalid transfer amount");
    }

    try {
      final senderRef = _firestore.collection('users').doc(uid);

      // Lookup recipient by accountNumber
      final recipientQuery =
          await _firestore
              .collection('users')
              .where('accountNumber', isEqualTo: recipientAccount)
              .limit(1)
              .get();

      if (recipientQuery.docs.isEmpty) {
        throw Exception("Recipient account not found");
      }

      final recipientDoc = recipientQuery.docs.first;
      final recipientRef = _firestore.collection('users').doc(recipientDoc.id);

      final txId = senderRef.collection('transactions').doc().id;

      late TransactionEntity createdTx;

      await _firestore.runTransaction((transaction) async {
        final senderSnap = await transaction.get(senderRef);
        final recipientSnap = await transaction.get(recipientRef);

        if (!senderSnap.exists) throw Exception("Sender not found");
        if (!recipientSnap.exists) throw Exception("Recipient not found");

        final senderBalance = (senderSnap['balance'] as num).toDouble();
        final recipientBalance = (recipientSnap['balance'] as num).toDouble();

        // 💰 Balance check
        if (senderBalance < amount) {
          throw Exception("Insufficient balance");
        }

        // Update balances
        transaction.update(senderRef, {'balance': senderBalance - amount});
        transaction.update(recipientRef, {
          'balance': recipientBalance + amount,
        });

        // Transaction payload
        final txMap = {
          'id': txId,
          'amount': amount,
          'timestamp': DateTime.now().toIso8601String(),
          'status': TransactionStatus.success.name,
          'type': type.name,
          'senderName': senderName,
          'senderAccount': senderAccount,
          'recipientName': recipientName,
          'recipientAccount': recipientAccount,
          'recipientBankName':
              type == TransactionType.antarRekening ? "VaultBank" : null,
          'notes': notes,
        };

        // Save to both sender & recipient transaction histories
        transaction.set(senderRef.collection('transactions').doc(txId), txMap);
        transaction.set(
          recipientRef.collection('transactions').doc(txId),
          txMap,
        );

        // Construct entity to return
        createdTx = TransactionEntity(
          id: txId,
          amount: amount,
          timestamp: DateTime.now(),
          status: TransactionStatus.success,
          type: type,
          senderName: senderName,
          senderAccount: senderAccount,
          recipientName: recipientName,
          recipientAccount: recipientAccount,
          recipientBankName:
              type == TransactionType.antarRekening ? "VaultBank" : null,
          notes: notes,
        );
      });

      debugPrint("Transfer successful");
      return createdTx;
    } catch (e) {
      throw Exception("Transfer failed: $e");
    }
  }
}
