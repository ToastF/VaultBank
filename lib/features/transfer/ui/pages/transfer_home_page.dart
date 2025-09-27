import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/features/transfer/logic/transfer_cubit.dart';
import 'package:vaultbank/features/transfer/ui/pages/add_recipient_page.dart';
import '../widgets/action_button_widget.dart'; 

class TransferHomePage extends StatelessWidget {
  const TransferHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        // Untuk menghilangkan tombol back
        automaticallyImplyLeading: false, 
        title: const Text('Transfer', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey[100],
        elevation: 0,
      ),

      // Disini transfer_home_page punya dua bagian utama
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Bagian Daftar
              const Text('Daftar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ActionButtonWidget(
                         // Contoh menggunakan gambar dari aset
                        imagePath: 'assets/images/action_button/antar_bank.png', 
                        label: 'Banks',
                        onTap: () {
                          // _navigateToRecipientForm adalah helper function untuk membantu navigasi
                          // Bisa di cek pada bagian akhir file kode ini
                          _navigateToRecipientForm(
                            context, 
                            title: 'Daftar Rekening',
                            label: 'No Tujuan Rekening');
                        },
                      ),
                      ActionButtonWidget(
                        // TODO: Tambahin asset e_wallet dari Andrew
                        imagePath: 'assets/images/action_button/e_wallet.png', 
                        label: 'E-Wallet',
                        onTap: () {
                          _navigateToRecipientForm(
                            context, 
                            title: 'Daftar E-Wallet', 
                            label: 'No. HP');
                        },
                      ),
                      ActionButtonWidget(
                        imagePath: 'assets/images/action_button/antar_rekening.png',
                        label: 'Antar\nRekening',
                        onTap: () { /* TODO: Navigasi */ },
                      ),
                       ActionButtonWidget(
                        imagePath: 'assets/images/action_button/virtual_account.png',
                        label: 'VA Account',
                        onTap: () { /* TODO: Navigasi */ },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 2. Bagian Transfer
              const Text('Transfer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ActionButtonWidget(
                         // Contoh menggunakan gambar dari aset
                        imagePath: 'assets/images/action_button/antar_bank.png', 
                        label: 'Banks',
                        onTap: () { /* TODO: Navigasi */ },
                      ),
                      ActionButtonWidget(
                        // TODO: Tambahin asset e_wallet dari Andrew
                        imagePath: 'assets/images/action_button/e_wallet.png', 
                        label: 'E-Wallet',
                        onTap: () { /* TODO: Navigasi */ },
                      ),
                      ActionButtonWidget(
                        imagePath: 'assets/images/action_button/antar_rekening.png',
                        label: 'Antar\nRekening',
                        onTap: () { /* TODO: Navigasi */ },
                      ),
                       ActionButtonWidget(
                        imagePath: 'assets/images/action_button/virtual_account.png',
                        label: 'VA Account',
                        onTap: () { /* TODO: Navigasi */ },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Disini saya menambahkan fungsi helper baru untuk mempermudah navigasi langsung ke
  // Page add_recipient_page.dart untuk menambahkan e-wallet atau transfer antar bank
  void _navigateToRecipientForm(BuildContext context, {required String title, required String label}){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<TransferCubit>(),
          child: AddRecipientPage(
            title: title,
            label: label,
          ),
        ),
      ),
    );
  }
}