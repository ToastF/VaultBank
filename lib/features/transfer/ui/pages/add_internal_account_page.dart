// TODO: masih basic design, change!
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/features/recipient/ui/cubit/recipient_cubit.dart';
import 'package:vaultbank/features/recipient/domain/entities/recipient_entity.dart';
import 'package:vaultbank/features/user/ui/cubit/user_cubit.dart';

class AddInternalAccountPage extends StatefulWidget {
  const AddInternalAccountPage({super.key});

  @override
  State<AddInternalAccountPage> createState() => _AddInternalAccountPageState();
}

class _AddInternalAccountPageState extends State<AddInternalAccountPage> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _accountController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _saveRecipient() {
    final account = _accountController.text.trim();
    final name = _nameController.text.trim();

    if (account.isEmpty || name.isEmpty) {
      _showSnack("Please fill in both fields");
      return;
    }

    if (account.length != 10 || int.tryParse(account) == null) {
      _showSnack("Account number must be a 10-digit number");
      return;
    }

    final userState = context.read<UserCubit>().state;
    if (userState is! UserLoaded) {
      _showSnack("User not loaded");
      return;
    }

    final uid = userState.user.uid;
    final recipient = RecipientEntity(
      accountNumber: account,
      name: "",
      alias: name.isEmpty ? null : name,
    );
    context.read<RecipientCubit>().addRecipient(uid, recipient);
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecipientCubit, RecipientState>(
      listener: (context, state) {
        if (state is RecipientFailure) {
          _showSnack(state.message);
        } else if (state is RecipientSuccess) {
          _showSnack(state.message);
          Navigator.pop(context);
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(title: const Text("Add VaultBank Recipient")),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(
                  controller: _accountController,
                  decoration: const InputDecoration(
                    labelText: "Account Number",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Recipient Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const Spacer(),
                BlocBuilder<RecipientCubit, RecipientState>(
                  builder: (context, state) {
                    final isLoading = state is RecipientLoading;
                    return ElevatedButton(
                      onPressed: isLoading ? null : _saveRecipient,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                "Save Recipient",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
