// lib/features/home/ui/widget/history_list.dart

import 'package:flutter/material.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({super.key});

  // Dummy data untuk riwayat transaksi
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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Header "History"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {}, // Navigasi kosong
                child: const Text(
                  'Lihat Semua >',
                  style: TextStyle(color: Color(0xFF0D63F3)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Daftar item riwayat
          ListView.builder(
            padding: EdgeInsets.zero, // Hapus padding default ListView
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _dummyHistory.length,
            itemBuilder: (context, index) {
              final item = _dummyHistory[index];
              return Card(
                elevation: 0,
                color: Colors.transparent,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.lightBlue[50],
                    child: Icon(item['icon'], color: const Color(0xFF0D63F3)),
                  ),
                  title: Text(
                    item['category'],
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(item['date']),
                  trailing: Text(
                    item['amount'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}