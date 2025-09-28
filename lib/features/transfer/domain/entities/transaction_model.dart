import 'package:equatable/equatable.dart';

// Model ini akan digunakan untuk transaksi kita
enum TransactionStatus { success, failed, pending }
enum TransactionType { antarBank, antarRekening, virtualAccount }

class TransactionModel extends Equatable {
  // Berikut adalah data yang wajib data
  final String id;
  final double amount;
  final DateTime timestamp;
  final TransactionStatus status; //success/failed/pending
  final TransactionType type; //Simpan informasi apakah transaksi ini termasuk transaksi
                              // antar-rekening, antar-bank, atau lewat virtual account
  
  // Sisi pengirim
  final String senderName;
  final String senderAccount;

  // Sisa penerima
  final String recipientName;
  final String recipientAccount;
  final String? recipientBankName; //Untuk simpan nama bank (semisalnya menggunakan transfer antar-bank/VA)

  // Adapun data lain yang sifatnya opsional, sebagai berikut:
  final String? notes; //Catatan transaksi
  
  const TransactionModel({
  required this.id,
  required this.amount,
  required this.timestamp,
  required this.status,
  required this.type,
  // Pengirim
  required this.senderName,
  required this.senderAccount,
  // Penerima
  required this.recipientName,
  required this.recipientAccount,
  // Data opsional
  this.recipientBankName,
  this.notes,
  });

  // Penambahan override dan equatable agar perbandingannya langsung berdasarkan properti dan 
  // bukan pada persamaan letak lokasi memori saja saja. Alias perbandingan hanya pada nilai :);
  @override
  List<Object?> get props => [
    id, 
    amount, 
    timestamp, 
    status, 
    type, 
    senderName, 
    senderAccount,
    recipientName,
    recipientAccount,
    recipientBankName,
    notes
  ];
}