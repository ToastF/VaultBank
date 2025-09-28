import 'package:isar/isar.dart';
import '../../../../data/local_storage.dart';
import 'package:flutter/foundation.dart';

part 'user_data_storage.g.dart';

@collection
class UserModel {
  Id id = 0; // always store only one user locally
  late String username;
  late String uid;
  late String email;
  late String notelp;
  late String pinHash;
  late String pinSalt;
  late double balance;
}

class UserStorage {
  Future<void> saveUser(UserModel user) async {
    await LocalStorage.instance.writeTxn(() async {
      await LocalStorage.instance.userModels.put(user..id = 0);
    });
  }

  Future<UserModel?> getUser() async {
    debugPrint("getting data from local storage");
    return await LocalStorage.instance.userModels.get(0);
  }

  Future<void> clearUser() async {
    await LocalStorage.instance.writeTxn(() async {
      await LocalStorage.instance.userModels.delete(0);
    });
  }
}
