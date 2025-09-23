// Model ini akan digunakan untuk transaksi kita
enum TransactionStatus { success, failed, pending }
enum TransactionType { antarBank, antarRekening, va }

class TransactionModel {
  // Berikut adalah data yang wajib data
  final String id;
  final double amount;
  final String recipientName;
  final String recipientAccount;
  final DateTime timestamp;
  final TransactionStatus status;
  final TransactionType type;

  // Adapun beberapa data yang bersifat opsional
  final String? notes; //Catatan transaksi
  final String? bankName; //Nama dari sebuah bank (tidak wajib untuk transfer antar-rekening)
  TransactionModel({
    required this.id,
    required this.amount,
    required this.recipientName,
    required this.recipientAccount,
    required this.timestamp,
    required this.status,
    required this.type,

    // Juga untuk data opsional
    this.notes,
    this.bankName,
  });
}