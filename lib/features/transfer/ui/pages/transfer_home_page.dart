// TODO: masih basic design, change! note: biru
import 'package:flutter/material.dart';
import 'package:vaultbank/core/util/color_palette.dart';
import 'package:vaultbank/core/util/navi_util.dart';
import 'package:vaultbank/features/transfer/ui/pages/add_internal_account_page.dart';
import 'package:vaultbank/features/transfer/ui/pages/transfer_screen.dart';
import 'package:vaultbank/features/transfer/ui/widgets/transfer_action_tile.dart';

class TransferHomePage extends StatelessWidget {
  const TransferHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Transfer',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.whiteBackground,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Bagian Daftar Penerima
              const Text(
                'Daftar Penerima',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TransferActionTile(
                  imagePath: 'assets/images/action_button/antar_rekening.png',
                  title: 'Antar Rekening',
                  subtitle: 'Tambah / Simpan Penerima VaultBank',
                  onTap: () {
                    NavigationHelper.goTo(context, AddInternalAccountPage());
                  },
                ),
              ),

              const SizedBox(height: 24),

              // 2. Bagian Transfer Antar Rekening
              const Text(
                'Transfer',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 1,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TransferActionTile(
                  imagePath: 'assets/images/action_button/antar_rekening.png',
                  title: 'Antar Rekening',
                  subtitle: 'Transfer ke Sesama VaultBank',
                  onTap: () {
                    debugPrint("go to recipient list");
                    NavigationHelper.goTo(context, TransferScreen());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
