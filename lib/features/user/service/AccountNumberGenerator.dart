import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountNumberGenerator {
  static Future<String> generateUniqueAccountNumber() async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    String accountNumber;
    bool exists = true;
    final rand = Random();

    do {
      // Generate 10-digit number using padding
      accountNumber = rand.nextInt(999999999).toString().padLeft(10, '0');

      final snapshot =
          await usersRef.where('accountNumber', isEqualTo: accountNumber).get();

      exists = snapshot.docs.isNotEmpty;
    } while (exists);

    return accountNumber;
  }
}
