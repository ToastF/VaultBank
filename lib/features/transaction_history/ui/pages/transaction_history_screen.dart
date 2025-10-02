import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/features/transaction_history/ui/cubit/transaction_cubit.dart';
import 'package:vaultbank/features/transaction_history/domain/entities/transaction_entity.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transaction History")),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionLoaded) {
            if (state.transactions.isEmpty) {
              return const Center(child: Text("No transactions yet"));
            }
            return ListView.builder(
              itemCount: state.transactions.length,
              itemBuilder: (context, index) {
                final tx = state.transactions[index];
                return ListTile(
                  leading: Icon(
                    tx.type == TransactionType.antarRekening
                        ? Icons.swap_horiz
                        : Icons.account_balance_wallet,
                    color: Colors.blue,
                  ),
                  title: Text("${tx.recipientName}"),
                  subtitle: Text(tx.timestamp.toString()),
                  trailing: Text(
                    "Rp${tx.amount.toStringAsFixed(0)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          tx.status == "incoming" ? Colors.green : Colors.red,
                    ),
                  ),
                );
              },
            );
          } else if (state is TransactionError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
