import 'package:flutter/material.dart';
import 'package:vaultbank/core/util/format_util.dart';

class NominalInput extends StatelessWidget {
  final String bankName;
  final String adminFee;
  final String assetPath;
  final Color? backgroundColor;

  const NominalInput({
    super.key,
    required this.bankName,
    required this.adminFee,
    required this.assetPath,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final amountController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(bankName, style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
            leading: SizedBox(
              width: 70,
              height: 70,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: backgroundColor ?? Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                  ),
                  ClipOval(
                    child: Image.asset(
                      assetPath,
                      width: 50, 
                      height: 50,
                      fit: BoxFit.contain, 
                    ),
                  ),
                ],
              ),
            ),
            title: Text(
              bankName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            subtitle: Text(
              adminFee,
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
            const SizedBox(height: 32),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  ThousandsSeparatorInputFormatter(),
                ],
                decoration: InputDecoration(
                  prefixText: "Rp ",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                    focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, 
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Handle top-up confirmation logic here
                },
                child: const Text(
                  "Confirm Top Up",
                  style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}