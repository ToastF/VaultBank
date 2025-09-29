import 'package:isar/isar.dart';
import '../../domain/entities/recipient_entity.dart';

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
  final Isar _isar;
  RecipientStorage(this._isar);

  /// Return raw Isar models
  Future<List<RecipientModel>> getModels() async {
    return await _isar.recipientModels.where().findAll();
  }

  /// Return domain entities mapped from models
  Future<List<RecipientEntity>> getRecipients() async {
    final models = await getModels();
    return models.map((m) => m.toEntity()).toList();
  }

  /// Save all recipients with model
  Future<void> saveModels(List<RecipientModel> models) async {
    await _isar.writeTxn(() async {
      await _isar.recipientModels.clear();
      await _isar.recipientModels.putAll(models);
    });
  }

  /// Save recipients with entity
  Future<void> saveEntities(List<RecipientEntity> entities) async {
    final models = entities.map((e) => RecipientModel.fromEntity(e)).toList();
    await saveModels(models);
  }

  Future<void> addModel(RecipientModel model) async {
    await _isar.writeTxn(() async {
      await _isar.recipientModels.put(model);
    });
  }

  Future<void> deleteByRecipientId(String recipientId) async {
    await _isar.writeTxn(() async {
      await _isar.recipientModels
          .filter()
          .recipientIdEqualTo(recipientId)
          .deleteAll();
    });
  }

  Future<void> deleteByAccountNumber(String accountNumber) async {
    await _isar.writeTxn(() async {
      final list =
          await _isar.recipientModels
              .filter()
              .accountNumberEqualTo(accountNumber)
              .findAll();
      for (final m in list) {
        await _isar.recipientModels.delete(m.id);
      }
    });
  }
}
