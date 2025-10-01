import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/core/util/balance_manager.dart';
import 'tarik_tunai_minimarket.dart';
import 'konfirmasi.dart'; // Add this import

class TarikTunaiPage extends StatelessWidget {
  const TarikTunaiPage({super.key});

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
        title: Text(
          'Tarik Tunai',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transfer Bank Section
            Text(
              'Transfer Bank',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),

            // Bank List
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildBankItem(
                    context,
                    'Bank BCA',
                    'Biaya admin Rp2.000',
                    'assets/images/logo_bca.png',
                  ),
                  _buildDivider(),
                  _buildBankItem(
                    context,
                    'Bank BRI',
                    'Biaya admin Rp2.000',
                    'assets/images/logo_bri.png',
                  ),
                  _buildDivider(),
                  _buildBankItem(
                    context,
                    'Mandiri',
                    'Biaya admin Rp2.000',
                    'assets/images/logo_mandiri.png',
                    backgroundColor: Color(0xFF0D3B70),
                  ),
                  _buildDivider(),
                  _buildBankItem(
                    context,
                    'Bank BNI',
                    'Biaya admin Rp2.000',
                    'assets/images/logo_bni.png',
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Tarik tunai di Mini Market Section
            Text(
              'Tarik tunai di Mini Market',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),

            // Mini Market Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
            _buildMiniMarketItem(
              context: context,
              name: 'Indomaret',
              backgroundColor: Color(0xFF116BB2),
              assetPath: 'assets/images/logo_indomaret.png',
            ),
            _buildMiniMarketItem(
              context: context,
              name: 'Alfamidi',
              backgroundColor: Colors.red,
              assetPath: 'assets/images/logo_alfamidi.png',
            ),
            _buildMiniMarketItem(
              context: context,
              name: 'Alfamart',
              backgroundColor: Colors.red,
              assetPath: 'assets/images/logo_alfamart.png',
            ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Bank item
  Widget _buildBankItem(
    BuildContext context,
    String bankName,
    String adminFee,
    String assetPath, {
    Color? backgroundColor,
  }) {
    return ListTile(
      leading: SizedBox(
        width: 70,
        height: 70,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Circle background
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.grey[200],
                shape: BoxShape.circle,
              ),
            ),
            // Logo image clipped inside circle
            ClipOval(
              child: Image.asset(
                assetPath,
                width: 50, // slightly smaller than circle diameter
                height: 50,
                fit: BoxFit.contain, // ensures edges fill the clip
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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => InputNominalScreen(
                  bankName: bankName,
                  accountNumber: '613074074324',
                  assetPath: assetPath,
                ),
          ),
        );
      },
    );
  }

  // Divider between banks
  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[200],
      indent: 16,
      endIndent: 16,
    );
  }

  // Mini market item
  Widget _buildMiniMarketItem({
    required BuildContext context,
    required String name,
    required Color backgroundColor,
    required String assetPath, // use PNG for logo
    double width = 80,
    double height = 60,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TarikTunaiMiniMarketPage(),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.all(8), // space around logo
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(assetPath, fit: BoxFit.contain),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class InputNominalScreen extends StatefulWidget {
  final String bankName;
  final String accountNumber;
  final String assetPath; // Add this parameter

  const InputNominalScreen({
    Key? key,
    required this.bankName,
    required this.accountNumber,
    required this.assetPath, // Add this
  }) : super(key: key);

  @override
  _InputNominalScreenState createState() => _InputNominalScreenState();
}

class _InputNominalScreenState extends State<InputNominalScreen> {
  final TextEditingController _nominalController = TextEditingController();

  @override
  void dispose() {
    _nominalController.dispose();
    super.dispose();
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Peringatan'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _handleTarikTunai() {
    String nominalText = _nominalController.text.replaceAll('Rp', '').replaceAll('.', '').trim();
    int? nominal = int.tryParse(nominalText);
    if (nominal == null || nominal <= 0) {
      _showAlert('Masukkan nominal yang valid');
      return;
    }
    if (nominal > BalanceManager.balance) {
      _showAlert('Nominal lebih besar dari saldo');
      return;
    }
    if (nominal > BalanceManager.balance - 2000) {
      _showAlert('Nominal maksimal yang bisa ditarik adalah ${BalanceManager.balance - 2000} (karena biaya admin Rp 2000)');
      return;
    }
    // Navigate to confirmation page
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bank Info Section
            Row(
              children: [
                // Bank Logo
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      widget.assetPath,
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Bank Name and Account Info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.bankName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'No. Rekening', // Changed from 'Masukan nominal'
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Added text above input
            const Text(
              'Masukan nominal tarik tunai',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Amount Input
            TextField(
              controller: _nominalController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 24),
              decoration: InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color(
                      0xFF1D1B20,
                    ).withOpacity(0.2), // Updated color
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color(
                      0xFF1D1B20,
                    ).withOpacity(0.2), // Updated color
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF1D1B20), // Updated color
                  ),
                ),
                hintText: 'Rp0',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 24),
              ),
            ),
            const Spacer(),
            // Tarik Tunai Button
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleTarikTunai,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Tarik Tunai',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Updated text color to white
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
