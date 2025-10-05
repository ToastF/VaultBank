import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Top Up',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const CashTopUp(),
    );
  }
}

class CashTopUp extends StatelessWidget {
  const CashTopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
            },
        ),
        title: Column(
          children: const [
            Text(
              'Top Up',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Di Mini Market',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cara Top Up:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Biaya admin Rp2.000 minimum Top Up Rp20.000.',
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Gratis biaya admin 2x/bulan min.',
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildStep(
                number: 1,
                text: 'Minta bantuan kasir untuk menarik tunai',
              ),
              _buildStep(
                number: 2,
                text: 'Beritahu nomor HP yang kamu pakai di aplikasi',
              ),
              _buildStep(
                number: 3,
                text:
                    'Berikan nominanya (pilih: Rp20.000, Rp50.000, Rp100.000, Rp200.000, Rp300.000, Rp400.000, Rp500.000)',
              ),
              _buildStep(
                number: 4,
                text:
                    'Bayar nominal top up ke kasir. Saldo yang kamu dapat akan dikurangi dengan biaya admin',
              ),
              _buildStep(
                number: 5,
                text: 'Kasir akan mengisi saldo ke akun kamu.',
              ),
              _buildStep(
                number: 6,
                text:
                    'Pastikan saldo kamu sudah bertambah dan nominal sudah sesuai setelah dikurangi biaya admin',
              ),
              _buildStep(
                number: 7,
                text: 'Simpan bukti pembayaran',
                isLast: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep({required int number, required String text, bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFF2196F3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: const Color(0xFF2196F3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 16),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}