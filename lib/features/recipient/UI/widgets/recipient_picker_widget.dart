import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/features/recipient/domain/entities/recipient_entity.dart';
import 'package:vaultbank/features/recipient/ui/cubit/recipient_cubit.dart';

// Widget untuk menunjukkan seleksi recipient dari recipient list
class RecipientPicker extends StatelessWidget {
  const RecipientPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<RecipientCubit, RecipientState>(
        builder: (context, state) {
          if (state is RecipientLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is RecipientLoaded) {
            final recipients = state.recipients;
            if (recipients.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Center(child: Text("No recipients saved")),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: recipients.length,
              itemBuilder: (context, index) {
                final r = recipients[index];
                return ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: Text(r.alias?.isNotEmpty == true ? r.alias! : r.name),
                  subtitle: Text("${r.accountNumber} | ${r.name}"),
                  onTap: () {
                    Navigator.pop(context, r);
                  },
                );
              },
            );
          } else if (state is RecipientFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text("Error: ${state.message}"),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

// Helper function to open it
Future<RecipientEntity?> showRecipientPicker(BuildContext context) async {
  return await showModalBottomSheet<RecipientEntity>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => const RecipientPicker(),
  );
}
