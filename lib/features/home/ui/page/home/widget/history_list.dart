import 'package:flutter/material.dart';
import 'package:vaultbank/core/util/color_palette.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({super.key});

  // dummy data history
  final List<Map<String, dynamic>> _dummyHistory = const [
    {
      "category": "Transportasi",
      "date": "26-04-2025",
      "amount": "Rp15.500",
      "icon": Icons.directions_bike,
    },
    {
      "category": "Belanja",
      "date": "20-04-2025",
      "amount": "Rp55.500",
      "icon": Icons.shopping_bag_outlined,
    },
    {
      "category": "Transportasi",
      "date": "26-04-2025",
      "amount": "Rp15.500",
      "icon": Icons.directions_bike,
    },
    {
      "category": "Transportasi",
      "date": "26-04-2025",
      "amount": "Rp12.500",
      "icon": Icons.directions_bike,
    },
    {
      "category": "Belanja",
      "date": "20-04-2025",
      "amount": "Rp25.500",
      "icon": Icons.shopping_bag_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // biar dinamis
    final screenWidth = MediaQuery.of(context).size.width;

    final double outerPadding = screenWidth * 0.05;
    final double innerPadding = screenWidth * 0.04;
    final double headerFontSize = screenWidth * 0.045;
    final double spacing = screenWidth * 0.025;
    final double iconSize = screenWidth * 0.055;
    final double avatarRadius = screenWidth * 0.05;
    final double titleFontSize = screenWidth * 0.04;
    final double subtitleFontSize = screenWidth * 0.032;
    final double amountFontSize = screenWidth * 0.038;

    return Padding(
      // Padding ini memberikan jarak dari tepi layar
      padding: EdgeInsets.symmetric(horizontal: outerPadding),
      // 1. Seluruh widget dibungkus dengan Card
      child: Card(
        color: AppColors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          // Padding ini memberikan jarak antara konten dengan tepi card
          padding: EdgeInsets.all(innerPadding),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'History',
                    style: TextStyle(
                      fontSize: headerFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Lihat Semua >',
                      style: TextStyle(
                        color: AppColors.blueText,
                        fontSize: subtitleFontSize,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing),
              // Daftar item riwayat
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _dummyHistory.length,
                itemBuilder: (context, index) {
                  final item = _dummyHistory[index];
                  // 2. Tidak perlu Card lagi di sini, cukup ListTile
                  return ListTile(
                    leading: CircleAvatar(
                      radius: avatarRadius,
                      backgroundColor: AppColors.whiteBackground, // Diubah agar kontras
                      child: Icon(
                        item['icon'],
                        color: AppColors.blueIcon,
                        size: iconSize,
                      ),
                    ),
                    title: Text(
                      item['category'],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: titleFontSize,
                      ),
                    ),
                    subtitle: Text(
                      item['date'],
                      style: TextStyle(fontSize: subtitleFontSize),
                    ),
                    trailing: Text(
                      item['amount'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: amountFontSize,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}