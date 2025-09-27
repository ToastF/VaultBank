import 'package:vaultbank/features/transfer/data/models/bank_model.dart';
import 'package:vaultbank/features/transfer/data/models/recipient_model.dart';
import 'package:vaultbank/features/transfer/data/models/transaction_model.dart';

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

// Nah untuk mendukung development
// Sambil menunggu pematangan UI saya izin inisiatif membuat beberapa data dummy
class FakeTransferRepository implements TransferRepository{
  // Bagian ini jadi list untuk nama bank palsunya  
  // Saya gunakan nama anggota saya sendiri sebagai easter egg
  final List<BankModel> _dummyBanks = [
    BankModel(name: "Erick National Bank", code: "010"),
    BankModel(name: "Gerald's Priority", code: "030"),
    BankModel(name: "Anstendyk", code: "130"),
    BankModel(name: "New Ferdinand Central", code: "135"),
    BankModel(name: "The NG", code: "153"),
  ];

  final List<RecipientModel> _dummyRecipients = [
    RecipientModel(id: "1", name: 'Coach Mariano', accountNumber: '4133313331', bankName: "New Ferdinand Central", bankCode: "135"),
    RecipientModel(id: "2", name: "Sulistyo Luis", accountNumber: '1313321020', bankName: 'The NG', bankCode: "153"),
  ];

  List<TransactionModel> _dummyTransactions = [
    TransactionModel(
      id: 'tx1', amount: 50000, timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: TransactionType.antarBank, status: TransactionStatus.success,
      senderName: 'Filbert Ferdinand', senderAccount: '123456789',
      recipientName: 'Budi Hartono', recipientAccount: '1122334455', recipientBankName: 'Gerald\'s Priority',
    ),
    TransactionModel(
      id: 'tx2', amount: 125000, timestamp: DateTime.now().subtract(const Duration(days: 3)),
      type: TransactionType.virtualAccount, status: TransactionStatus.success,
      senderName: 'Filbert Ferdinand', senderAccount: '123456789',
      recipientName: 'Toko Online', recipientAccount: '88001122334455', recipientBankName: 'Anstendyk'
    ),
    TransactionModel(id: 'tx3', amount: 200000, timestamp: DateTime.now().subtract(const Duration(days: 5)), 
    status: TransactionStatus.failed, type: TransactionType.antarBank, 
    senderName: 'Filbert Ferdinand', senderAccount: '123456789', 
    recipientName: 'Orang Asing', recipientAccount: '987654321', recipientBankName: 'New Ferdinand Central')
  ];

  // Tambahan dummy e wallets
  final List<BankModel> _dummyEwallets = [
    BankModel(name: "GoPay", code: "70001", logoUrl: "assets/images/gopay.png"),
    BankModel(name: "OVO", code: "90000", logoUrl: "assets/images/ovo.png"),
    BankModel(name: "DANA", code: "8059", logoUrl: "assets/images/dana.png"),
    BankModel(name: "ShopeePay", code: "122", logoUrl: "assets/images/shopeepay.png"),
  ];

  // Terapkan fungsi-fungsi yang sudah di set di dalam abstract class TransferRepository
  // Ambil list bank
  @override
  Future<List<BankModel>> getBankList() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _dummyBanks;
  }
  // Ambil list e-wallet
  @override
  Future<List<BankModel>> getEwalletList() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _dummyEwallets;
  }
  // Ambil list penerima yang sudah kita simpan
  @override
  Future<List<RecipientModel>> getSavedRecipients() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _dummyRecipients;
  }

  // Ambil transaction history kita
  @override
  Future<List<TransactionModel>> getTransactionHistory() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    // Urutkan agar transaksi ditampilkan mulai dari yang terbaru ke yang terlama
    _dummyTransactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return _dummyTransactions;
  }

  // Lakukan transfer
  @override
  Future<TransactionModel> performTransfer({
    required double amount,
    required RecipientModel recipient,
    String? notes,
  }) async {
    // Simulasi jika ada delay transfer selama 2 detik
    await Future.delayed(const Duration(seconds: 2));

    // Simulasi bila ada kegagalan untuk melakukan transfer
    if (recipient.accountNumber == '0000000000') {
      throw Exception("Rekening tujuan diblokir.");
    }

    // Buat objek baru, jika berhasil melakukan transaksi
    final newTransaction = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      timestamp: DateTime.now(),
      type: TransactionType.antarBank,
      status: TransactionStatus.success,
      senderName: 'Filbert Ferdinand', // JANGAN LUPA DI GANTI DENGAN NAMA USER ASLI
      senderAccount: '123456789',      // JANGAN LUPA DI GANTI DENGAN NO AKUN USER ASLI
      recipientName: recipient.name,
      recipientAccount: recipient.accountNumber,
      recipientBankName: recipient.bankName,
      notes: notes,
    );

    // Terakhir simpan hasil transaksi baru tersebut ke dalam daftar riwayat
    _dummyTransactions.add(newTransaction);
    
    return newTransaction;
  }
}