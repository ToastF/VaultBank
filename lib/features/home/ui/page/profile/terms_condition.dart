import 'package:flutter/material.dart';
import 'package:vaultbank/core/util/color_palette.dart'; 

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      appBar: AppBar(
        backgroundColor: AppColors.blueHeader,
        foregroundColor: AppColors.white,
        title: const Text('Syarat dan Ketentuan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Syarat dan Ketentuan Penggunaan Layanan Vault Bank',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackText),
            ),
            const SizedBox(height: 8),
            const Text(
              'Berlaku Efektif: 10 September 2025',
              style: TextStyle(fontSize: 14, color: AppColors.greyTextSearch),
            ),
            const SizedBox(height: 16),
            const Text(
              'Syarat dan Ketentuan ini merupakan perjanjian yang mengikat secara hukum antara Anda dan PT Bank Vault Tbk, terkait penggunaan aplikasi perbankan digital VaultBank.',
              style: TextStyle(fontSize: 16, color: AppColors.blackText),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Pasal 1: Definisi'),
            const SizedBox(height: 8),
            _buildNumberedPoint(
              '1. ',
              'Aplikasi adalah VaultBank, layanan perbankan digital yang dapat diakses melalui perangkat seluler untuk melakukan Transaksi Finansial dan Non-Finansial.',
            ),
            _buildNumberedPoint(
              '2. ',
              'Bank adalah PT Bank Vault Tbk. yang berkedudukan di Jakarta, Indonesia.',
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

  Widget _buildNumberedPoint(String number, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(number, style: const TextStyle(fontSize: 16, color: AppColors.blackText)),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(fontSize: 16, color: AppColors.blackText, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}