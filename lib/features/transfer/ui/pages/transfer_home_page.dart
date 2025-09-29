// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:vaultbank/features/transfer/ui/cubits/transfer_cubit.dart';
// import 'package:vaultbank/features/transfer/ui/pages/add_internal_account_page.dart';
// import 'package:vaultbank/features/transfer/ui/pages/add_recipient_page.dart';
// import 'package:vaultbank/features/transfer/ui/widgets/transfer_action_tile.dart';

// class TransferHomePage extends StatelessWidget {
//   const TransferHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         // Untuk menghilangkan tombol back
//         automaticallyImplyLeading: false, 
//         title: const Text('Transfer', style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: Colors.grey[100],
//         elevation: 0,
//       ),

//       // Disini transfer_home_page punya dua bagian utama
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 1. Bagian Daftar
//               const Text('Daftar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 12),
//               Card(
//                 elevation: 2,
//                 shadowColor: Colors.black12,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       TransferActionTile(
//                          // Contoh menggunakan gambar dari aset
//                         imagePath: 'assets/images/action_button/antar_bank.png', 
//                         title: 'Banks',
//                         subtitle: 'BCA, BRI, BNI, dan Mandiri',
//                         onTap: () {
//                           // _navigateToRecipientForm adalah helper function untuk membantu navigasi
//                           // Bisa di cek pada bagian akhir file kode ini
//                           _navigateToRecipientForm(context, type: RecipientType.bank);
//                         },
//                       ),
//                       const Divider(height: 1, indent: 60),
//                       TransferActionTile(
//                         // TODO: Tambahin asset e_wallet dari Andrew
//                         imagePath: 'assets/images/action_button/e_wallet.png', 
//                         title: 'E-Wallet',
//                         subtitle: 'Go Pay, Shopee Pay, OVO, Dana',
//                         onTap: () {
//                           _navigateToRecipientForm(context, type: RecipientType.ewallet);
//                         },
//                       ),
//                       const Divider(height: 1, indent: 60),
//                       TransferActionTile(
//                         imagePath: 'assets/images/action_button/antar_rekening.png',
//                         title: 'Antar Rekening',
//                         subtitle: 'Vault Bank',
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const AddInternalAccountPage()));
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // 2. Bagian Transfer
//               const Text('Transfer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 12),
//               Card(
//                 elevation: 1,
//                 shadowColor: Colors.black12,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 20.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       TransferActionTile(
//                          // Contoh menggunakan gambar dari aset
//                         imagePath: 'assets/images/action_button/antar_bank.png', 
//                         title: 'Banks',
//                         subtitle: 'BCA, BRI, BNI, dan Mandiri',
//                         onTap: () { /* TODO: Navigasi */ },
//                       ),
//                       const Divider(height: 1, indent: 60),
//                       TransferActionTile(
//                         // TODO: Tambahin asset e_wallet dari Andrew
//                         imagePath: 'assets/images/action_button/e_wallet.png', 
//                         title: 'E-Wallet',
//                         subtitle: 'Go Pay, Shopee Pay, OVO, Dana',
//                         onTap: () { /* TODO: Navigasi */ },
//                       ),
//                       const Divider(height: 1, indent: 60),
//                       TransferActionTile(
//                         imagePath: 'assets/images/action_button/antar_rekening.png',
//                         title: 'Antar Rekening',
//                         subtitle: 'Vault Bank',
//                         onTap: () { /* TODO: Navigasi */ },
//                       ),
//                       const Divider(height: 1, indent: 60),
//                       TransferActionTile(
//                         imagePath: 'assets/images/action_button/virtual_account.png',
//                         title: 'VA Account',
//                         subtitle: 'Kode Virtual Account',
//                         onTap: () { /* TODO: Navigasi */ },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Disini saya menambahkan fungsi helper baru untuk mempermudah navigasi langsung ke
//   // Page add_recipient_page.dart untuk menambahkan e-wallet atau transfer antar bank
//   void _navigateToRecipientForm(BuildContext context, {required RecipientType type}){
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => BlocProvider.value(
//           value: context.read<TransferCubit>(),
//           child: AddRecipientPage(type: type),
//         ),
//       ),
//     );
//   }
// }