import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'success.dart'; 

class MasukanPinPage extends StatefulWidget {
  final int nominal;
  final String bankName;

  const MasukanPinPage({
    Key? key,
    required this.nominal,
    required this.bankName,
  }) : super(key: key);

  @override
  _MasukanPinPageState createState() => _MasukanPinPageState();
}

class _MasukanPinPageState extends State<MasukanPinPage> {
  final int pinLength = 6;
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onCircleTap() {
    FocusScope.of(context).requestFocus(_focusNode);
  }

  String _generateReferralCode(String bankName) {
    String companyCode;
    switch (bankName.toLowerCase()) {
      case 'bank bca':
        companyCode = '39107';
        break;
      case 'mandiri':
        companyCode = '88888';
        break;
      case 'bank bni':
        companyCode = '8241';
        break;
      case 'bank bri':
        companyCode = '12345';
        break;
      default:
        companyCode = '00000'; // Default
    }
    String phone = '08123456789';
    return companyCode + phone;
  }

  void _onSubmit() {
    if (_pinController.text.length == pinLength) {
      // Check if PIN is correct (for example, '123456')
      if (_pinController.text == '123456') {
        // Navigate to success page using MaterialPageRoute
        String referralCode = _generateReferralCode(widget.bankName);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SuccessPage(nominal: widget.nominal, referralCode: referralCode)),
        );
      } else {
        // Show alert for wrong PIN
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Access code salah'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter complete PIN')),
      );
    }
  }

  Widget _buildPinCircles() {
    List<Widget> circles = [];
    for (int i = 0; i < pinLength; i++) {
      bool filled = i < _pinController.text.length;
      circles.add(
        GestureDetector(
          onTap: _onCircleTap,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: filled ? Colors.blue : Colors.blue.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: circles,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: Text(
          'Masukan Pin',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 80),
            Center(
              child: Icon(Icons.arrow_downward, size: 48, color: Colors.blue[300]),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Masukan Pin',
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ),
            SizedBox(height: 32),
            _buildPinCircles(),
            SizedBox(height: 16),
            // Hidden TextField for PIN input
            Opacity(
              opacity: 0,
              child: TextField(
                controller: _pinController,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                maxLength: pinLength,
                autofocus: true,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  setState(() {});
                },
                // Remove onSubmitted to disable submission via keyboard checkmark
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _onSubmit();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Masukkan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
