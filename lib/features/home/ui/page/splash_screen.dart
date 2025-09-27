// lib/features/home/ui/page/splash_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vaultbank/main.dart'; // Impor file main.dart

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      // Ganti halaman dengan MyApp setelah 3 detik
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Image.asset(
          'assets/images/icon_logo.png',
          width: 150,
        ),
      ),
    );
  }
}