import 'package:flutter/material.dart';
import 'package:vaultbank/core/util/color_palette.dart'; // Sesuaikan path jika perlu

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      appBar: AppBar(
        backgroundColor: AppColors.blueHeader,
        foregroundColor: AppColors.white,
        title: const Text('Kebijakan Privasi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kebijakan Privasi Aplikasi Vault Bank',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.blackText),
            ),
            const SizedBox(height: 8),
            const Text(
              'Terakhir Diperbarui: 10 September 2025',
              style: TextStyle(fontSize: 14, color: AppColors.greyTextSearch),
            ),
            const SizedBox(height: 16),
            const Text(
              'Selamat datang di Vault Bank, layanan perbankan digital dari PT Bank vault Tbk. Kami berkomitmen untuk melindungi dan menghargai privasi Anda. Kebijakan Privasi ini menjelaskan bagaimana kami mengumpulkan, menggunakan, mengungkapkan, menyimpan, dan melindungi Informasi Pribadi Anda saat Anda menggunakan aplikasi dan layanan kami.',
              style: TextStyle(fontSize: 16, color: AppColors.blackText),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('1. Informasi yang Kami Kumpulkan'),
            const SizedBox(height: 8),
            _buildBulletPoint(
              'Data Identitas:',
              'Nama lengkap, Nomor Induk Kependudukan (NIK), tempat dan tanggal lahir, jenis kelamin, dan data lain yang tertera pada Kartu Tanda Penduduk (KTP).',
            ),
             _buildBulletPoint(
              'Data Finansial:',
              'Nomor rekening bank, riwayat transaksi, informasi kartu kredit/debit, dan informasi sumber dana.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.blackText,
      ),
    );
  }

  Widget _buildBulletPoint(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: AppColors.blackText, height: 1.5),
                children: [
                  TextSpan(
                    text: '$title ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: content),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}