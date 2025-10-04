import 'package:flutter/material.dart';
import 'package:vaultbank/core/util/format_util.dart';
import 'package:vaultbank/features/home/ui/page/tarik_tunai/konfirmasi.dart';
import 'package:vaultbank/features/user/data/local/user_data_storage.dart';

class TarikTunaiMiniMarketPage extends StatefulWidget {
  const TarikTunaiMiniMarketPage({Key? key}) : super(key: key);

  @override
  _TarikTunaiMiniMarketPageState createState() => _TarikTunaiMiniMarketPageState();
}

class _TarikTunaiMiniMarketPageState extends State<TarikTunaiMiniMarketPage> {
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tarik Tunai',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Di Mini Market',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mini Market Icon
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.store,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Mini Market',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                'Biaya admin Rp2.000',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(height: 32),
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
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isButtonEnabled ? Colors.blue : Colors.grey,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isButtonEnabled
                      ? () {
                          final amount = amountController.text.replaceAll('.', '');
                          final nominal = int.parse(amount);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => KonfirmasiPage(
                                nominal: nominal,
                                bankName: 'Mini Market',
                                accountNumber: user?.accountNumber ?? 'N/A',
                                assetPath: '',
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
                SizedBox(height: 8),
                Text(
                  'Minimal tarik tunai Rp25.000,00',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
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
