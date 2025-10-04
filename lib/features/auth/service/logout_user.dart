import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vaultbank/features/recipient/data/local/recipient_list_storage.dart';
import 'package:vaultbank/features/transaction_history/data/local/transaction_data_storage.dart';
import '../../../core/util/navi_util.dart';
import 'package:vaultbank/features/auth/data/local/access_code_storage.dart';
import '../../user/data/local/user_data_storage.dart';
import '../ui/page/welcome_screen.dart';

// Service class to handle Log out scenario
// signs out firebase user and clear all of local storage
class LogoutUser {
  final BuildContext context;

  LogoutUser(this.context);

  Future<void> call() async {
    debugPrint("Starting User Logout");
    // Sign out from Firebase Auth
    await FirebaseAuth.instance.signOut();
    // Clear local storage data
    await AccessCodeStorage().clearAccessCode();
    await UserStorage().clearUser();
    await RecipientStorage().clearRecipients();
    await TransactionStorage().clearTransactions();

    // Navigate to welcome/login screen
    NavigationHelper.goToAndRemoveAll(context, const WelcomeScreen());
  }
}
