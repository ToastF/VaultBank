import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/features/recipient/ui/cubit/recipient_cubit.dart';
import 'package:vaultbank/features/transfer/ui/pages/transfer_screen.dart';

class RecipientListScreen extends StatelessWidget {
  const RecipientListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recipients")),
      body: BlocBuilder<RecipientCubit, RecipientState>(
        builder: (context, state) {
          if (state is RecipientLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RecipientLoaded) {
            final recipients = state.recipients;
            if (recipients.isEmpty) {
              return const Center(child: Text("No recipients saved"));
            }

            return ListView.builder(
              itemCount: recipients.length,
              itemBuilder: (context, index) {
                final r = recipients[index];
                return ListTile(
                  title: Text(r.alias?.isNotEmpty == true ? r.alias! : r.name),
                  subtitle: Text(r.accountNumber),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransferScreen(recipient: r),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is RecipientFailure) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
