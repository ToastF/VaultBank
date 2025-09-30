// Provider List Widget
// Ini adalah widget yang akan dipakai untuk menampilkan list dari bank ataupun e-wallet
// Dan akan dipakai di dalam pages yang berhubungan dengan add_(type)_recipient_page

import 'package:flutter/material.dart';
import 'package:vaultbank/features/home/ui/page/transfer/domain/entities/bank_model.dart';

class ProviderListItemWidget extends StatelessWidget {
  final BankModel provider;
  final VoidCallback onTap;
  const ProviderListItemWidget({
    super.key,
    required this.provider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        // Disini kita akan lakukan pengecekan ada/tidaknya logo
        child:
            provider.logoUrl != null
                // Jika ada, maka tampilkan logo tersebut
                ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(provider.logoUrl!, width: 40, height: 40),
                )
                // Jika tidak, tampilkan logo default (Icons.account_balance)
                : const Icon(Icons.account_balance, color: Colors.grey),
      ),
      // Bagian inilah yang akan menyesuaikan apakah yang ditampilkan berupa Bank atau E-Wallet
      title: Text(provider.name),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
