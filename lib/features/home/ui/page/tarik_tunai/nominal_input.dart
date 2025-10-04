import 'package:flutter/material.dart';
import 'package:vaultbank/core/util/format_util.dart';
import 'package:intl/intl.dart';
import 'package:vaultbank/features/home/ui/page/tarik_tunai/konfirmasi.dart';
import 'package:vaultbank/features/user/data/local/user_data_storage.dart';

class NominalInputTarikTunai extends StatefulWidget {
  final String bankName;
  final String accountNumber;
  final String assetPath;
  final Color? backgroundColor;

  const NominalInputTarikTunai({
    super.key,
    required this.bankName,
    required this.accountNumber,
    required this.assetPath,
    this.backgroundColor,
  });

  @override
  State<NominalInputTarikTunai> createState() => _NominalInputTarikTunaiState();
}

class _NominalInputTarikTunaiState extends State<NominalInputTarikTunai> {
  final TextEditingController amountController = TextEditingController();
  bool isButtonEnabled = false;
  UserModel? user;
  double balance = 0;

  @override
  void initState() {
    super.initState();
    _loadUser();
    amountController.addListener(() {
      final rawValue = amountController.text.replaceAll('.', '').trim();
      final amount = int.tryParse(rawValue) ?? 0;
      final minAmount = 25000;
      final maxAmount = 10000000;
      final availableBalance = balance - 2000; // Assuming admin fee
      setState(() {
        isButtonEnabled = amount >= minAmount && amount <= maxAmount && amount <= availableBalance;
      });
    });
  }

  Future<void> _loadUser() async {
    final userStorage = UserStorage();
    user = await userStorage.getUser();
    if (user != null) {
      setState(() {
        balance = user!.balance;
      });
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
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
                        color: widget.backgroundColor ?? Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                    ),
                    ClipOval(
                      child: Image.asset(
                        widget.assetPath,
                        width: 50,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              title: Text(
                widget.bankName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              subtitle: Text(
                'Biaya admin Rp2.000',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [ThousandsSeparatorInputFormatter()],
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isButtonEnabled ? Colors.blue : Colors.grey,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed:
                      isButtonEnabled
                          ? () {
                            final amount = amountController.text.replaceAll(
                              '.',
                              '',
                            );
                            final nominal = int.parse(amount);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => KonfirmasiPage(
                                  nominal: nominal,
                                  bankName: widget.bankName,
                                  accountNumber: widget.accountNumber,
                                  assetPath: widget.assetPath,
                                ),
                              ),
                            );
                          }
                          : null,
                  child: const Text(
                    "Tarik Tunai",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Minimal tarik tunai Rp25.000,00',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const Text(
                  'Maksimal tarik tunai Rp10.000.000,00',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}