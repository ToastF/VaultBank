import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/features/user/data/local/user_data_storage.dart';
import 'nominal_input.dart';
import 'tutorial_tarik_tunai.dart';

class TarikTunaiPage extends StatefulWidget {
  const TarikTunaiPage({super.key});

  @override
  _TarikTunaiPageState createState() => _TarikTunaiPageState();
}

class _TarikTunaiPageState extends State<TarikTunaiPage> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final userStorage = UserStorage();
    user = await userStorage.getUser();
    setState(() {});
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
              'Tarik Tunai',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),

            // Bank List with Mini Market Logos (3 items, no BNI, no circle background, no admin fee text)
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
                    'Indomaret',
                    '',
                    'assets/images/logo_indomaret.png',
                    showCircleBackground: false,
                  ),
                  _buildDivider(),
                  _buildBankItem(
                    context,
                    'Alfamidi',
                    '',
                    'assets/images/logo_alfamidi.png',
                    showCircleBackground: false,
                  ),
                  _buildDivider(),
                  _buildBankItem(
                    context,
                    'Alfamart',
                    '',
                    'assets/images/logo_alfamart.png',
                    backgroundColor: Color(0xFF0D3B70),
                    showCircleBackground: false,
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Tarik tunai di Mini Market Section
            Text(
              'Tutorial Tarik Tunai',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),

            // Mini Market Options (click navigates to tutorial page)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMiniMarketItem(
                  context: context,
                  name: 'Indomaret',
                  backgroundColor: Color(0xFF116BB2),
                  assetPath: 'assets/images/logo_indomaret.png',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TutorialTarikTunaiPage(),
                      ),
                    );
                  },
                ),
                _buildMiniMarketItem(
                  context: context,
                  name: 'Alfamidi',
                  backgroundColor: Colors.red,
                  assetPath: 'assets/images/logo_alfamidi.png',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TutorialTarikTunaiPage(),
                      ),
                    );
                  },
                ),
                _buildMiniMarketItem(
                  context: context,
                  name: 'Alfamart',
                  backgroundColor: Colors.red,
                  assetPath: 'assets/images/logo_alfamart.png',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TutorialTarikTunaiPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Bank item with mini market logos
  Widget _buildBankItem(
    BuildContext context,
    String bankName,
    String adminFee,
    String assetPath, {
    Color? backgroundColor,
    bool showCircleBackground = true,
  }) {
    return ListTile(
      leading: SizedBox(
        width: 70,
        height: 70,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Circle background (optional)
            if (showCircleBackground)
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
      subtitle: adminFee.isNotEmpty
          ? Text(
              adminFee,
              style: TextStyle(color: Colors.black, fontSize: 14),
            )
          : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NominalInputTarikTunai(
              bankName: bankName,
              accountNumber: user?.uid ?? 'N/A',
              assetPath: assetPath,
              backgroundColor: backgroundColor,
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
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NominalInputTarikTunai(
                  bankName: name,
                  accountNumber: user?.uid ?? 'N/A',
                  assetPath: assetPath,
                  backgroundColor: backgroundColor,
                ),
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