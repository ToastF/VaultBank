// File ini akan digunakan untuk state management dari transfer ke depannya

import 'package:equatable/equatable.dart';
import 'package:vaultbank/features/home/ui/page/transfer/domain/entities/bank_model.dart';
import 'package:vaultbank/features/home/ui/page/transfer/domain/entities/transaction_model.dart';

// Di sini saya memanfaatkan Equatable, hal ini agar mempermudah overriding == dan hashCode
// Dokumentasi dari Equatable, yakni: https://pub.dev/packages/equatable
abstract class TransferState extends Equatable{
  const TransferState();
  
  @override
  List<Object?> get props => [];
}

// State ketika halaman transfer dibuka
class TransferInitial extends TransferState{}

// State saat terjadi loading
class TransferLoading extends TransferState{}

// State ketika data berhasil di load
// Sehingga muncul daftar bank yang bisa kita pilih
class TransferDataLoaded extends TransferState{
  final List<BankModel> banks;
  const TransferDataLoaded(this.banks);

  @override
  List<Object?> get props => [banks];
}

// State ketika proses transaksi berhasil
// Nantinya akan muncul detail dari transaksi kita yang berhasil barusan
class TransferSuccess extends TransferState{
  final TransactionModel transaction;
  const TransferSuccess(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

// Terakhir semisalnya terjadi error/failed untuk segala jenis proses
// Entah menampilkan nama bank, halaman tidak terload, maka disediakan class berikut ini
class TransferFailed extends TransferState{
  final String errorMessage;
  const TransferFailed(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}




