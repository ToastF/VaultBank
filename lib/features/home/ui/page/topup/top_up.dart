import 'package:flutter/material.dart';
import 'package:vaultbank/features/home/ui/page/topup/cash_topup.dart';
import 'package:vaultbank/features/home/ui/page/topup/nominal_input.dart';

class TopUpPage extends StatelessWidget {
  const TopUpPage({super.key});

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
          'Top Up',
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
            Text(
              'Transfer Bank',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),

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
                    'BCA',
                    'Biaya admin Rp2.000',
                    'assets/images/logo_bca.png',
                  ),
                  _buildDivider(),
                  _buildBankItem(
                    context,
                    'BRI',
                    'Biaya admin Rp4.000',
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
                    'BNI',
                    'Biaya admin Rp6.000',
                    'assets/images/logo_bni.png',
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
  
            Text(
              'Top-Up tunai di Mini Market',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMiniMarketItem(
                  name: 'Indomaret',
                  backgroundColor: Color(0xFF116BB2),
                  assetPath: 'assets/images/logo_indomaret.png',
                ),
                _buildMiniMarketItem(
                  name: 'Alfamidi',
                  backgroundColor: const Color.fromARGB(234, 255, 28, 28),
                  assetPath: 'assets/images/logo_alfamidi.png',
                ),
                _buildMiniMarketItem(
                  name: 'Alfamart',
                  backgroundColor: const Color.fromARGB(236, 226, 27, 27),
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
  Widget _buildBankItem(BuildContext context, String bankName, String adminFee, String assetPath,
      {Color? backgroundColor}) {
    return ListTile(
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
      onTap: () => Navigator.push(context, 
          MaterialPageRoute(builder: (context) => NominalInput(
            bankName: bankName,
            adminFee: adminFee,
            assetPath: assetPath,
            backgroundColor: backgroundColor,
          ))),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[200],
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _buildMiniMarketItem({
  required String name,
  required Color backgroundColor,
  required String assetPath, 
  double width = 80,
  double height = 60,
}) {
    return Builder(
      builder: (context) => GestureDetector(
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
                padding: EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    assetPath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CashTopUp()),
        ),
      ),
    );
  } 
}

