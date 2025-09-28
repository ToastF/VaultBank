import 'package:vaultbank/features/transfer/domain/entities/bank_model.dart';
import 'package:vaultbank/features/transfer/domain/entities/recipient_model.dart';
import 'package:vaultbank/features/transfer/domain/entities/transaction_model.dart';

abstract class TransferRepository {
  // List daftar bank yang tersedia
  Future<List<BankModel>> getBankList();

  // List daftar e-wallet yang tersedia
  Future<List<BankModel>> getEwalletList();

  // List daftar penerima yang disimpan
  Future<List<RecipientModel>> getSavedRecipients();

  // Riwayat transaksinya
  Future<List<TransactionModel>> getTransactionHistory();

  // Melakukan transfer
  Future<TransactionModel> performTransfer({
    required double amount,
    required RecipientModel recipient,
    String? notes,
  });
}