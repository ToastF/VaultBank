import 'package:isar/isar.dart';
import '../../../../data/local_storage.dart';

part 'access_code_storage.g.dart';

// Isar storage for saving access code
// Access code is only saved locally
@collection
class AccessCodeModel {
  Id id = 0; // Isar always store only one access code
  late String code;
}

class AccessCodeStorage {
  // Check if access code exists
  Future<bool> hasAccessCode() async {
    final model = await LocalStorage.instance.accessCodeModels.get(0);
    return model != null;
  }

  // Save access code to local storage
  Future<void> saveAccessCode(String code) async {
    await LocalStorage.instance.writeTxn(() async {
      await LocalStorage.instance.accessCodeModels.put(
        AccessCodeModel()
          ..id = 0
          ..code = code,
      );
    });
  }

  // Getter function for access code
  Future<String?> getAccessCode() async {
    final model = await LocalStorage.instance.accessCodeModels.get(0);
    return model?.code;
  }

  // Clear access code from local storage (used for logout process)
  Future<void> clearAccessCode() async {
    await LocalStorage.instance.writeTxn(() async {
      await LocalStorage.instance.accessCodeModels.delete(0);
    });
  }
  
}
