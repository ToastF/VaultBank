import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/features/recipient/UI/cubit/recipient_cubit.dart';
import 'package:vaultbank/features/transaction_history/ui/cubit/transaction_cubit.dart';
import 'package:vaultbank/features/user/ui/cubit/user_cubit.dart';
import '../cubit/auth_cubit.dart';
import '../../../../core/util/navi_util.dart';
import 'package:vaultbank/features/home/ui/page/navbar/NavBar.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final pinCtrl = TextEditingController();
  final telpCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.read<UserCubit>()
              ..loadUser(state.auth.uid)
              ..startUserListener(state.auth.uid);

            context.read<RecipientCubit>()
              ..loadRecipients(state.auth.uid)
              ..startRecipientListener(state.auth.uid);

            context.read<TransactionCubit>()
              ..loadTransactions(state.auth.uid)
              ..startTransactionListener(state.auth.uid);

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Signup success!")));
            NavigationHelper.goToAndRemoveAll(context, const NavBar());
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: "Username"),
                ),
                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: passwordCtrl,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
                TextField(
                  controller: pinCtrl,
                  decoration: const InputDecoration(
                    labelText: "Transaction PIN",
                  ),
                  obscureText: true,
                ),
                TextField(
                  controller: telpCtrl,
                  decoration: const InputDecoration(
                    labelText: "Telephone number",
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthCubit>().signUp(
                      nameCtrl.text,
                      emailCtrl.text,
                      passwordCtrl.text,
                      pinCtrl.text,
                      telpCtrl.text,
                    );
                  },
                  child: const Text("Sign Up"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
