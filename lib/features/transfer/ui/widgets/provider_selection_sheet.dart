import 'package:flutter/material.dart';
import 'package:vaultbank/features/transfer/domain/entities/bank_model.dart';
import 'package:vaultbank/features/transfer/ui/widgets/provider_list_item_widget.dart';

class ProviderSelectionSheet extends StatelessWidget {
  final String title;
  final List<BankModel> providers;

  const ProviderSelectionSheet({
    super.key,
    required this.title,
    required this.providers,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: providers.length,
              itemBuilder: (context, index) {
                final provider = providers[index];
                // Menggunakan widget yang sudah Anda buat
                return ProviderListItemWidget(
                  provider: provider,
                  onTap: () => Navigator.of(context).pop(provider),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}