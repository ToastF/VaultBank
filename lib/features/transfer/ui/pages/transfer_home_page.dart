// TODO: masih basic design, change! note: biru -> DONE
import 'package:flutter/material.dart';
import 'package:vaultbank/core/util/color_palette.dart';
import 'package:vaultbank/core/util/navi_util.dart';
import 'package:vaultbank/features/transfer/ui/pages/add_internal_account_page.dart';
import 'package:vaultbank/features/transfer/ui/pages/transfer_screen.dart';

class TransferHomePage extends StatelessWidget {
  const TransferHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      // AppBar menggunakan warna biru di bagian Background
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(
          color: AppColors.white, 
        ),
        centerTitle: true,
        title: const Text(
          'Transfer',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.blueHeader,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: 150, 
            decoration: const BoxDecoration(
              color: AppColors.blueHeader,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),

          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Ilustrasi untuk transfer
                  Image.asset(
                    'assets/images/transfer.png',
                    height: 220, // Sesuaikan tinggi gambar
                  ),
                  const SizedBox(height: 24),

                  // 1. Daftar Rekening
                  Card(
                    elevation: 2,
                    shadowColor: Colors.black12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.blueLightButton,
                        child: Icon(
                          Icons.add,
                          color: AppColors.blueIcon,
                        ),
                      ),
                      title: const Text(
                        'Daftar',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text('Daftar rekening vaultbank'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        NavigationHelper.goTo(context, AddInternalAccountPage());
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 2. Transfer Antar Rekening
                  Card(
                    elevation: 2,
                    shadowColor: Colors.black12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.blueLightButton,
                        child: Icon(
                          Icons.send,
                          size: 20,
                          color: AppColors.blueIcon,
                        ),
                      ),
                      title: const Text(
                        'Transfer',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text('Transfer rekening vaultbank'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
        ],
      ),
    );
  }
}