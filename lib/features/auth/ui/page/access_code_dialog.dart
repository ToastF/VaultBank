import 'package:flutter/material.dart';
import '../../../auth/data/local/access_code_storage.dart';
import '../../../home/ui/page/home_screen.dart';
import '../../../../core/util/navi_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../../service/logout_user.dart';

Future<void> showAccessCodeDialog(BuildContext context) async {
  final ctrl = TextEditingController();

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text("Set Access Code"),
          content: TextField(
            controller: ctrl,
            decoration: const InputDecoration(
              labelText: "Enter a new access code",
            ),
            obscureText: true,
            keyboardType: TextInputType.number,
          ),
          actions: [
            // ElevatedButton(
            //   onPressed: () async {
            //     LogoutUser(context);
            //   },
            //   child: const Text("Exit"),
            // ),
            ElevatedButton(
              onPressed: () async {
                final code = ctrl.text;
                if (code.isNotEmpty) {
                  await AccessCodeStorage().saveAccessCode(code);
                  if (!context.mounted) return;
                  Navigator.pop(context); // close dialog
                  context.read<AuthCubit>().emit(AuthFinalized());
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> showInputAccessCodeDialog(BuildContext context) async {
  final ctrl = TextEditingController();

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text("Input Access Code"),
          content: TextField(
            controller: ctrl,
            decoration: const InputDecoration(labelText: "Enter access code"),
            obscureText: true,
            keyboardType: TextInputType.number,
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final code = ctrl.text;
                if (code.isNotEmpty) {
                  final accesscode = await AccessCodeStorage().getAccessCode();
                  if (code == accesscode) {
                    if (!context.mounted) return;
                    Navigator.pop(context); // close dialog
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Wrong Access Code! Try again"),
                      ),
                    );
                  }
                }
              },
              child: const Text("Enter"),
            ),
          ],
        ),
      );
    },
  );
}
