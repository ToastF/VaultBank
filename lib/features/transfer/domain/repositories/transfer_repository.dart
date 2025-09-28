import 'package:vaultbank/features/transfer/domain/entities/bank_model.dart';
import 'package:vaultbank/features/transfer/domain/entities/recipient_model.dart';
import 'package:vaultbank/features/transfer/domain/entities/transaction_model.dart';

abstract class TransferRepository {
  // List daftar bank yang tersedia
  Future<List<BankModel>> getBankList();

  // List daftar e-wallet yang tersedia
  Future<List<BankModel>> getEwalletList();

  // Simpan data penerima baru
  Future<void> saveRecipient(RecipientModel recipient);

  // List daftar penerima yang disimpan
  Future<List<RecipientModel>> getSavedRecipients();

  // Riwayat transaksinya
  Future<List<TransactionModel>> getTransactionHistory();

  // Memverifikasi adanya nomor rekening, (digunakan untuk bagian daftar)
  Future<RecipientModel?> verifyRecipientAccount({
    required String accountNumber,
    required String bankCode,
  });

  // Melakukan transfer
  Future<TransactionModel> performTransfer({
    required double amount,
    required RecipientModel recipient,
    String? notes,
  });
}