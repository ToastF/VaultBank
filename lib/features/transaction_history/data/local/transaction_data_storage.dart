import 'package:isar/isar.dart';
import '../../../../data/local_storage.dart';
import 'package:flutter/foundation.dart';

part 'transaction_data_storage.g.dart';

@collection
class TransactionModel {
  Id id = Isar.autoIncrement;

  late String txnId;
  late double amount;
  late DateTime timestamp;
  late String status;
  late String type;

  late String senderName;
  late String senderAccount;
  late String recipientName;
  late String recipientAccount;
  late String recipientBankName;
  String? notes;
}

class TransactionStorage {
  Future<void> saveTransaction(TransactionModel tx) async {
    await LocalStorage.instance.writeTxn(() async {
      await LocalStorage.instance.transactionModels.put(tx);
    });
    debugPrint("Saved transaction ${tx.txnId} to cache");
  }

  Future<List<TransactionModel>> getTransactions() async {
    return await LocalStorage.instance.transactionModels.where().findAll();
  }

  Future<void> clearTransactions() async {
    await LocalStorage.instance.writeTxn(() async {
      await LocalStorage.instance.transactionModels.clear();
    });
  }
}
