import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vaultbank/features/transfer/domain/entities/recipient_model.dart';

class AddRecipientStatusPage extends StatelessWidget {
  final RecipientModel recipient;

  const AddRecipientStatusPage({super.key, required this.recipient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 32),
                color: Colors.grey[100],
                child: Column(
                  children: [
                    Text('Pendaftaran Berhasil', style: Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Icon Berhasil
              Column(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 80),
                  const SizedBox(height: 16),
                  const Text('Daftar Berhasil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 32),

              // Detail Recipient/Penerima
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // _buildDetailRow adalah widget helper yang dibuat untuk mempermudah pembuatan baris dari detil recipient
                      // widget ini dapat dilihat di akhir code file ini
                      _buildDetailRow('Nama Akun', recipient.name),
                      const Divider(),
                      _buildDetailRow('No. Rekening', recipient.accountNumber),
                      const Divider(),
                      _buildDetailRow('Bank', recipient.bankName),
                      const Divider(),
                      _buildDetailRow('Tanggal Daftar', DateFormat('dd/MM/yyyy').format(DateTime.now())),
                    ],
                  ),
                ),
              ),

              const Spacer(),
              // Tombol Selesai
              ElevatedButton(
                onPressed: () {
                  // Kembali ke halaman utama transfer (melewati halaman pin dan form)
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Selesai', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper untuk membuat baris detail
  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}