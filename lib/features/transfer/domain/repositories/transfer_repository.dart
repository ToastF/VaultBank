import 'package:vaultbank/features/transaction_history/domain/entities/transaction_entity.dart';

abstract class TransferRepository {
  Future<void> makeTransfer({
    required String uid, // uid pengirim
    required String senderAccount,
    required String senderName,
    required String recipientAccount,
    required String recipientName,
    required double amount,
    required TransactionType type,
    String? notes,
  });
}
