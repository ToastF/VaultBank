import 'package:isar/isar.dart';
import '../../domain/entities/recipient_entity.dart';
import '../../../../data/local_storage.dart';

part 'recipient_list_storage.g.dart';

@collection
class RecipientModel {
  Id id = Isar.autoIncrement;

  /// Firestore recipient id
  late String recipientId;

  late String name;
  late String accountNumber;
  String? alias;

  // Helper function between models
  RecipientEntity toEntity() {
    return RecipientEntity(
      name: name,
      accountNumber: accountNumber,
      alias: alias,
    );
  }

  static RecipientModel fromEntity(
    RecipientEntity e, {
    String recipientId = '',
  }) {
    return RecipientModel()
      ..recipientId = recipientId
      ..name = e.name
      ..accountNumber = e.accountNumber
      ..alias = e.alias;
  }
}

class RecipientStorage {
  Future<List<RecipientModel>> getModels() async {
    return await LocalStorage.instance.recipientModels.where().findAll();
  }

  Future<List<RecipientEntity>> getRecipients() async {
    final models = await getModels();
    return models.map((m) => m.toEntity()).toList();
  }

  Future<void> saveModels(List<RecipientModel> models) async {
    await LocalStorage.instance.writeTxn(() async {
      await LocalStorage.instance.recipientModels.clear();
      await LocalStorage.instance.recipientModels.putAll(models);
    });
  }

  Future<void> saveEntities(List<RecipientEntity> entities) async {
    final models = entities.map((e) => RecipientModel.fromEntity(e)).toList();
    await saveModels(models);
  }

  Future<void> addModel(RecipientModel model) async {
    await LocalStorage.instance.writeTxn(() async {
      await LocalStorage.instance.recipientModels.put(model);
    });
  }

  Future<void> deleteByRecipientId(String recipientId) async {
    await LocalStorage.instance.writeTxn(() async {
      await LocalStorage.instance.recipientModels
          .filter()
          .recipientIdEqualTo(recipientId)
          .deleteAll();
    });
  }

  Future<void> deleteByAccountNumber(String accountNumber) async {
    await LocalStorage.instance.writeTxn(() async {
      final list =
          await LocalStorage.instance.recipientModels
              .filter()
              .accountNumberEqualTo(accountNumber)
              .findAll();
      for (final m in list) {
        await LocalStorage.instance.recipientModels.delete(m.id);
      }
    });
  }

  /// Clear all recipients
  Future<void> clearRecipients() async {
    await LocalStorage.instance.writeTxn(() async {
      await LocalStorage.instance.recipientModels.clear();
    });
  }
}
