import 'package:flutter/material.dart';

class SuccessPlaceholderPage extends StatelessWidget {
  const SuccessPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikasi Berhasil'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green, size: 80,),
            SizedBox(height: 16,),
            Text("Yup You Did it!")
          ],
        ),
      )
    );
  }
}