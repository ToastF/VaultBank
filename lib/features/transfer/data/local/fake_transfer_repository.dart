// Nah untuk mendukung development
// Sambil menunggu pematangan UI saya izin inisiatif membuat beberapa data dummy
import 'package:vaultbank/features/transfer/domain/entities/bank_model.dart';
import 'package:vaultbank/features/transfer/domain/entities/recipient_model.dart';
import 'package:vaultbank/features/transfer/domain/entities/transaction_model.dart';
import 'package:vaultbank/features/transfer/domain/repositories/transfer_repository.dart';

class FakeTransferRepository implements TransferRepository{
  // TODO: Tambahkan logo bank
  final List<BankModel> _dummyBanks = [
    BankModel(name: "Bank Central Asia", code: "014"),
    BankModel(name: "Bank Rakyat Indonesia", code: "002"),
    BankModel(name: "Bank Negara Indonesia", code: "009"),
    BankModel(name: "Bank Mandiri", code: "008"),
  ];

  // List no rekening yang telah kita daftarkan
  final List<RecipientModel> _dummyRecipients = [
    RecipientModel(id: "1", name: 'Coach Mariano', accountNumber: '4133313331', bankName: "Bank Central Asia", bankCode: "014"),
    RecipientModel(id: "2", name: "Sulistyo Luis", accountNumber: '1313321020', bankName: 'Bank Mandiri', bankCode: "008"),
  ];

  final List<RecipientModel> _registeredAccounts = [
    RecipientModel(id: '3', name: 'Budi Hartono', accountNumber: '1122334455', bankName: 'Bank Rakyat Indonesia', bankCode: '002'),
    RecipientModel(id: '4', name: 'Siti Aminah', accountNumber: '6677889900', bankName: 'Bank Negara Indonesia', bankCode: '009'),
    RecipientModel(id: '5', name: 'Erick Thohir', accountNumber: '123123123', bankName: 'Bank Central Asia', bankCode: '014'),
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

  // Simpan penerima baru kita
  @override
  Future<void> saveRecipient(RecipientModel recipient) async {
    // Simulasi proses menyimpan ke database
    await Future.delayed(const Duration(seconds: 1));
    
    // Tambahkan penerima baru ke daftar dummy kita
    _dummyRecipients.add(recipient);
    print('Penerima baru disimpan: ${recipient.name}');
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

  // Digunakan untuk mengecek apakah nomor akun yang dimasukkan terdaftar dalam database
  @override
  Future<RecipientModel?> verifyRecipientAccount({
    required String accountNumber,
    required String bankCode,
  }) async {
    // Simulasi proses pengecekan ke server
    await Future.delayed(const Duration(seconds: 1));
    
    try {
      // Cari rekening di "database" kita
      final recipient = _registeredAccounts.firstWhere(
        (acc) => acc.accountNumber == accountNumber && acc.bankCode == bankCode
      );
      return recipient;
    } catch (e) {
      // Jika tidak ditemukan, kembalikan null
      return null;
    }
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