import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vaultbank/features/recipient/data/local/recipient_list_storage.dart';
import 'package:vaultbank/features/transaction_history/data/local/transaction_data_storage.dart';

import '../features/auth/data/local/access_code_storage.dart';
import '../features/user/data/local/user_data_storage.dart';

// Isar local storage
class LocalStorage {
  static Isar? _isar;

  // Isar Initialization
  static Future<void> init() async {
    if (_isar == null) {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open([
        AccessCodeModelSchema,
        UserModelSchema,
        RecipientModelSchema,
        TransactionModelSchema,
      ], directory: dir.path);
    }
  }

  // Debug purposes to see if Isar is initialized
  static Isar get instance {
    if (_isar == null) {
      throw Exception(
        "LocalStorage not initialized. Call LocalStorage.init() first.",
      );
    }
    return _isar!;
  }
}
