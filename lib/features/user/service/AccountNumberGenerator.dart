import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountNumberGenerator {
  static Future<String> generateUniqueAccountNumber() async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    String accountNumber;
    bool exists = true;

    do {
      // Generate random 10-digit number for account number
      accountNumber = (Random().nextInt(9000000000) + 1000000000).toString();

      final snapshot =
          await usersRef.where('accountNumber', isEqualTo: accountNumber).get();

      exists = snapshot.docs.isNotEmpty;
    } while (exists);

    return accountNumber;
  }
}
