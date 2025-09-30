// domain/usecases/verify_pin_use_case.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:vaultbank/features/user/domain/repositories/user_repository.dart'; // Tambahkan import ini

class VerifyPinUseCase {
  final UserRepository _repository;
  final FirebaseAuth _firebaseAuth; // Tambahkan instance FirebaseAuth

  // Update constructor untuk menerima FirebaseAuth
  VerifyPinUseCase(this._repository, this._firebaseAuth);

  // Ubah method 'call', kita tidak perlu lagi parameter 'uid'
  Future<bool> call({required String pin}) async {
    try {
      // 1. Dapatkan user yang sedang login dari FirebaseAuth
      final currentUser = _firebaseAuth.currentUser;

      // 2. Lakukan pengecekan keamanan, pastikan user ada (tidak null)
      if (currentUser == null) {
        // Jika tidak ada user yang login, proses tidak bisa dilanjutkan.
        throw Exception("Tidak ada user yang terautentikasi.");
      }

      // 3. Gunakan UID dinamis dari currentUser
      final uid = currentUser.uid;
      return await _repository.verifyPin(uid, pin);
      
    } catch (e) {
      print("Error in VerifyPinUseCase: $e");
      return false;
    }
  }
}