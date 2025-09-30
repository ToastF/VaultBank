import 'package:flutter/material.dart';
import 'package:vaultbank/core/util/color_palette.dart'; 

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      appBar: AppBar(
        backgroundColor: AppColors.blueHeader,
        foregroundColor: AppColors.white,
        title: const Text('Pusat Bantuan'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat datang di pusat bantuan kami. Artikel ini dirancang untuk memberikan solusi atas pertanyaan umum serta panduan lengkap untuk menjaga keamanan akun Anda saat bertransaksi menggunakan aplikasi mobile banking.',
              style: TextStyle(fontSize: 16, color: AppColors.blackText),
            ),
            SizedBox(height: 16),
            Text(
              'Keamanan dan kenyamanan Anda adalah prioritas utama kami. Langkah pertama dalam mengamankan akun adalah dengan membuat password dan PIN yang kuat. Selalu gunakan kombinasi unik yang tidak mudah ditebak dan hindari menggunakan informasi pribadi seperti tanggal lahir. Jaga kerahasiaan data ini dan jangan pernah membagikannya kepada siapapun, termasuk pihak yang mengaku sebagai petugas bank.',
              style: TextStyle(fontSize: 16, color: AppColors.blackText),
            ),
             SizedBox(height: 16),
            Text(
              'Selalu waspadai upaya penipuan seperti phishing yang dikirim melalui email, SMS, atau pesan instan. Ingatlah, bahwa pihak bank tidak akan pernah meminta data rahasia seperti password atau kode OTP (One-Time Password). Jangan pernah mengklik tautan mencurigakan atau mengunduh lampiran dari sumber yang tidak dikenal.',
               style: TextStyle(fontSize: 16, color: AppColors.blackText),
            ),
          ],
        ),
      ),
    );
  }
}
