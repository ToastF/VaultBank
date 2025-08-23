import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vaultbank/features/auth/data/local/access_code_storage.dart';
import '../../../core/util/navi_util.dart';
import '../ui/page/welcome_screen.dart';

class LogoutUser {
  final BuildContext context;

  LogoutUser(this.context);

  Future<void> call(
  ) async {
        // 1. Sign out from Firebase Auth
        await FirebaseAuth.instance.signOut();

        // 2. Clear local access code
        await AccessCodeStorage().clearAccessCode();

        // 3. Navigate to welcome/login screen
        NavigationHelper.goToAndRemoveAll(context, const WelcomeScreen());
  }
}
