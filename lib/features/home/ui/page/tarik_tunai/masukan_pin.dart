import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/features/user/data/local/user_data_storage.dart';
import 'package:vaultbank/features/user/ui/cubit/user_cubit.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vaultbank/features/transaction_history/domain/entities/transaction_entity.dart';
import 'succes.dart';

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
    String phone = user?.notelp ?? '08123456789';
    return companyCode + phone;
  }

  Future<void> _onSubmit() async {
    if (_pinController.text.length == pinLength) {
      if (user != null) {
        // Hash the input PIN with the stored salt
        final inputHash = sha256.convert(utf8.encode(_pinController.text + user!.pinSalt)).toString();
        if (inputHash == user!.pinHash) {
          // Update balance: deduct nominal + admin fee
          double adminFee = 2000.0;
          if (widget.bankName.toLowerCase() == 'bank bri') {
            adminFee = 4000.0;
          } else if (widget.bankName.toLowerCase() == 'bank bni') {
            adminFee = 6000.0;
          }
          double deduction = widget.nominal + adminFee;
          double newBalance = user!.balance - deduction;

          // Update balance in Firestore
          await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({'balance': newBalance});

          // Add transaction to history
          final txId = FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('transactions').doc().id;
          final txMap = {
            'id': txId,
            'amount': widget.nominal.toDouble(),
            'timestamp': Timestamp.now(),
            'status': TransactionStatus.success.name,
            'type': TransactionType.tarikTunai.name,
            'senderName': user!.username,
            'senderAccount': user!.accountNumber,
            'recipientName': widget.bankName,
            'recipientAccount': '',
            'recipientBankName': widget.bankName,
            'notes': 'Tarik Tunai',
          };
          await FirebaseFirestore.instance.collection('users').doc(user!.uid).collection('transactions').doc(txId).set(txMap);

          // Navigate to success page using MaterialPageRoute
          String referralCode = _generateReferralCode(widget.bankName);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SuccessPage(nominal: widget.nominal, referralCode: referralCode, bankName: widget.bankName)),
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
        // User not loaded
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User data not available')),
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
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? const Color(0xFF5B9EE1) : const Color(0xFFD6E9F8),
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: circles,
    );
  }

  Widget _buildNumpad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          _buildNumpadRow(['1', '2', '3']),
          const SizedBox(height: 16),
          _buildNumpadRow(['4', '5', '6']),
          const SizedBox(height: 16),
          _buildNumpadRow(['7', '8', '9']),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 70, height: 70),
              _buildNumpadButton('0'),
              _buildBackspaceButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumpadRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map((number) => _buildNumpadButton(number)).toList(),
    );
  }

  Widget _buildNumpadButton(String number) {
    return InkWell(
      onTap: () {
        if (_pinController.text.length < pinLength) {
          _pinController.text += number;
          setState(() {});
          if (_pinController.text.length == pinLength) {
            _onSubmit();
          }
        }
      },
      borderRadius: BorderRadius.circular(35),
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
        ),
        child: Text(
          number,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return InkWell(
      onTap: () {
        if (_pinController.text.isNotEmpty) {
          _pinController.text = _pinController.text.substring(0, _pinController.text.length - 1);
          setState(() {});
        }
      },
      borderRadius: BorderRadius.circular(35),
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
        ),
        child: const Icon(
          Icons.backspace_outlined,
          color: Colors.black54,
          size: 24,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Masukan PIN',
          style: TextStyle(
            color: Color(0xFF5B9EE1),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 60),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFE3F2FD),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_downward,
              color: Color(0xFF5B9EE1),
              size: 40,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Masukan Pin',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5B9EE1),
            ),
          ),
          const SizedBox(height: 32),
          _buildPinCircles(),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: Center(
              child: null, // No error message for now
            ),
          ),
          const Spacer(),
          _buildNumpad(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}