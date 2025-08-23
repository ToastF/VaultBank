import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class HashUtil {
  // Generates random salt
  static String generateSalt([int length = 16]) {
    final rand = Random.secure();
    final values = List<int>.generate(length, (_) => rand.nextInt(256));
    return base64Url.encode(values);
  }

  // Hash input
  static String hashWithSalt(String input, String salt) {
    final bytes = utf8.encode(input + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Matches input with hash
  static bool verify(String input, String hash, String salt) {
    final inputHash = hashWithSalt(input, salt);
    return inputHash == hash;
  }
}
