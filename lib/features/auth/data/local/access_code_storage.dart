import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

part 'access_code_storage.g.dart'; // run build_runner after

@collection
class AccessCodeModel {
  Id id = 0; // single entry, always overwrite id=0
  late String code;
}

class AccessCodeStorage {
  static Isar? _isar;

  /// Initialize Isar once
  static Future<void> init() async {
    if (_isar == null) {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        [AccessCodeModelSchema],
        directory: dir.path,
      );
    }
  }
  
  Future<bool> hasAccessCode() async {
    if (_isar == null) return false;
    final model = await _isar!.accessCodeModels.get(0);
    return model != null;
  }

  /// Save new access code (overwrite if exists)
  Future<void> saveAccessCode(String code) async {
    await _isar!.writeTxn(() async {
      await _isar!.accessCodeModels.put(
        AccessCodeModel()..code = code,
      );
    });
  }

  /// Get the stored access code
  Future<String?> getAccessCode() async {
    final model = await _isar!.accessCodeModels.get(0);
    return model?.code;
  }

  /// Delete access code (if needed for reset)
  Future<void> clearAccessCode() async {
    await _isar!.writeTxn(() async {
      await _isar!.accessCodeModels.delete(0);
    });
  }
}
