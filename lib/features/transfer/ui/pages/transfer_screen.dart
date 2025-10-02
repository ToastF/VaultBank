import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/features/recipient/domain/entities/recipient_entity.dart';
import 'package:vaultbank/features/transfer/ui/cubits/transfer_cubit.dart';

class TransferScreen extends StatefulWidget {
  final RecipientEntity recipient;
  const TransferScreen({super.key, required this.recipient});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final amountCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  @override
  void dispose() {
    amountCtrl.dispose();
    notesCtrl.dispose();
    super.dispose();
  }

  void _makeTransfer() {
    final amount = double.tryParse(amountCtrl.text) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter valid amount")));
      return;
    }

    context.read<TransferCubit>().makeTransfer(
      amount: amount,
      recipient: widget.recipient,
      notes: notesCtrl.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transfer to ${widget.recipient.name}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: amountCtrl,
              decoration: const InputDecoration(
                labelText: "Amount",
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesCtrl,
              decoration: const InputDecoration(labelText: "Notes (optional)"),
            ),
            const Spacer(),
            BlocConsumer<TransferCubit, TransferState>(
              listener: (context, state) {
                if (state is TransferSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Transfer successful")),
                  );
                  Navigator.pop(context);
                } else if (state is TransferFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed: ${state.message}")),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is TransferLoading;

                return ElevatedButton(
                  onPressed: isLoading ? null : _makeTransfer,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Confirm Transfer"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
