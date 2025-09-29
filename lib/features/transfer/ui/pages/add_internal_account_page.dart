// // Page ini digunakan untuk mendaftarkan akun tujuan yang merupakan nasabah VaultBank
// // Page ini juga mendukung input secara bulk (maksimal 3 rekening tujuan);

// // Berikut ini adalah class helper
// import 'package:flutter/material.dart';
// import 'package:vaultbank/features/transfer/ui/widgets/recipient_form_field_widget.dart';

// class _RecipientControllers {
//   final TextEditingController accountController;
//   final TextEditingController nameController;

//   _RecipientControllers()
//     : accountController = TextEditingController(),
//       nameController = TextEditingController();

//   void dispose(){
//     accountController.dispose();
//     nameController.dispose();
//   }
// }

// class AddInternalAccountPage extends StatefulWidget {
//   const AddInternalAccountPage({super.key});

//   @override
//   State<AddInternalAccountPage> createState() => _AddInternalAccountPageState();
// }

// class _AddInternalAccountPageState extends State<AddInternalAccountPage> {
//   // Karena kita akan menyimpan lebih dari satu rekening pada page ini
//   // Maka kita siapkan sebuah list yang berguna untuk menampung sang controller
//   final List<_RecipientControllers> _controllers = [_RecipientControllers()];

//   @override
//   void dispose() {
//     // Loop melalui semua controller dan panggil method dispose-nya
//     for (var controllerSet in _controllers) {
//       controllerSet.dispose();
//     }
//     super.dispose();
//   }

//   void _addRecipientField() {
//     if (_controllers.length < 3) {
//       setState(() {
//         _controllers.add(_RecipientControllers());
//       });
//     }
//   }

//   void _removeRecipientField(int index){
//     // Pastikan bahwa selalu ada minimal satu field yang terisi
//     if (_controllers.length > 1){
//       setState(() {
//         _controllers[index].dispose();
//         _controllers.removeAt(index);
//       });
//     }
//   }

//   void _saveRecipient(){
//     // TODO: Tinggal tambahkan logika untuk validasi dan simpan data tersebut
//     for (int i = 0; i < _controllers.length; i++){
//       final account = _controllers[i].accountController.text;
//       final name = _controllers[i].nameController.text;
//       print('Penerima ${i+1}: Akun=$account, Nama=$name');
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Antar Rekening'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _controllers.length,
//                 itemBuilder: (context, index){
//                   return RecipientFormFieldWidget(
//                     index: index, 
//                     accountController: _controllers[index].accountController, 
//                     nameController: _controllers[index].nameController, 
//                     canBeRemoved: _controllers.length > 1, onRemove: () => _removeRecipientField(index)
//                     );
//                 },
//               ),
//             ),
//             // Disini kita tambahkan tombol untuk menambah rekening tujuan menjadi lebih dari satu
//             // Sebelum itu, lakukan validasi agar jumlah field tidak lebih dari 3
//             if (_controllers.length < 3)
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: TextButton.icon(
//                   onPressed: _addRecipientField, 
//                   label: const Text('Tambah Rekening Lain'),
//                   icon: const Icon(Icons.add_circle_outline),
//                 ),
//               ),
            
//             // Tombol Simpan kita
//             Padding(
//               padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
//               child: ElevatedButton(
//                 onPressed: _saveRecipient, 
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blueAccent,
//                   minimumSize: const Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
//                 ),
//                 child: const Text('Simpan', style: TextStyle(fontSize: 16, color: Colors.white),)
//               )
//             )
//           ],
//         ),
//         ),
//     );
//   }
// }