// lib/features/home/ui/widget/action_buttons.dart

import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan Padding untuk memberi jarak dari kartu saldo di atasnya
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionButton(
              icon: Icons.add,
              label: 'Top up',
              onTap: () {
                // Navigasi kosong untuk saat ini
              },
            ),
            _buildActionButton(
              icon: Icons.arrow_downward,
              label: 'Tarik Tunai',
              onTap: () {
                // Navigasi kosong untuk saat ini
              },
            ),
            _buildActionButton(
              icon: Icons.send,
              label: 'Transfer',
              onTap: () {
                // Navigasi kosong untuk saat ini
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.lightBlue[50],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: const Color(0xFF0D63F3)),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}