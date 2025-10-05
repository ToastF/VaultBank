import 'package:flutter/material.dart';

class TutorialTarikTunaiPage extends StatelessWidget {
  const TutorialTarikTunaiPage({Key? key}) : super(key: key);

  final List<String> steps = const [
    'Pergi ke minimarket yang anda pilih',
    'Pergi ke kasir lalu beritau kalau anda ingin menarik tunai',
    'Pergi ke halaman tarik tunai klik icon minimarket yang anda ingini di bagian tarik tunai',
    'Lalu masukan nominal tarik tunai',
    'Konfirmasi penarikan tunai',
    'Masukan pin',
    'Berikan code referral ke kasir',
    'Terima uangmu dan pastikan nominalnya pas',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: const [
            Text(
              'Tutorial Tarik Tunai',
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
          padding: const EdgeInsets.all(2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cara Tarik Tunai:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              ...steps.asMap().entries.map((entry) {
                int index = entry.key;
                String step = entry.value;
                return _buildStep(
                  number: index + 1,
                  text: step,
                  isLast: index == steps.length - 1,
                );
              }),
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