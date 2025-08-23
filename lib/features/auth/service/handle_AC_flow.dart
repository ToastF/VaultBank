import 'package:flutter/material.dart';
import '../data/local/access_code_storage.dart';
import '../ui/page/access_code_dialog.dart';

class AccessCodeFlow {
  final BuildContext context;

  AccessCodeFlow(this.context);

  // Handle AC
  // if it's not set, show input dialog for access code creation
  // if it exist, show input dialog for input-ing access code
  Future<void> handle() async {
    final exists = await AccessCodeStorage().hasAccessCode();
    if (!exists) {
      await showAccessCodeDialog(context);
    } else {
      await showInputAccessCodeDialog(context);
    }
  }
}
