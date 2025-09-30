// Dummy test page ini digunakan untuk pengetesan apakah fitur pin berhasil digunakan
// Mengingat fitur ini akan sangat berguna untuk melakukan top up, transfer, maupun mendaftarkan rekening

import 'package:flutter/material.dart';
import 'package:vaultbank/features/common/pin_entry_page.dart';
import 'package:vaultbank/features/common/success_placeholder_page.dart';

class DummyTestPage extends StatelessWidget {
  const DummyTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing The PIN'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Mulai'),
          onPressed: () async {
            // Navigasi ke halaman PIN
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PinEntryPage(
                  // Setelah diarahkan ke PinEntryPage, jika PIN yang dimasukkan benar,
                  // Maka print bahwa PIN Benar
                  onCompleted: () {
                    print("PIN Kamu sudah Benar WOWWWW");
                    // Pop PinEntryPage dan return true
                    Navigator.pop(context, true);
                  },
                ),
              ),
            );

            // Jika PIN benar (result == true), navigasi ke success page
            if (result == true && context.mounted) {
              await Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SuccessPlaceholderPage(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}