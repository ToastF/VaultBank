// // Kita merevisi bentuk widget ini yang awalnya berupa icon yang dijejerkan
// // Ke dalam bentuk tile

// import 'package:flutter/material.dart';

// class TransferActionTile extends StatelessWidget {
//   final String imagePath;
//   final String title;
//   final String subtitle;
//   final VoidCallback onTap;

//   const TransferActionTile({
//     super.key,
//     required this.imagePath,
//     required this.title,
//     required this.subtitle,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: onTap,
//       leading: Container(
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: Colors.blue.withOpacity(0.1),
//           shape: BoxShape.circle,
//         ),
//         child: Image.asset(
//           imagePath,
//           width: 24,
//           height: 24,
//         )
//       ),
//       title: Text(
//         title,
//         style: const TextStyle(fontWeight: FontWeight.bold),
//       ),
//       subtitle: Text(
//         subtitle,
//         style: TextStyle(color: Colors.grey[600], fontSize: 12),
//       ),
//       trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
//     );
//   }
// }
