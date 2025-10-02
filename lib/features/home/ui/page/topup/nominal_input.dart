import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vaultbank/core/util/format_util.dart';
import 'package:intl/intl.dart';
import 'package:vaultbank/features/home/ui/page/topup/success.dart';
import 'package:vaultbank/features/user/data/local/user_data_storage.dart';
import 'package:vaultbank/features/transfer/ui/cubits/transfer_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/features/recipient/domain/entities/recipient_entity.dart';

class NominalInput extends StatefulWidget {
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
  State<NominalInput> createState() => _NominalInputState();
}

class _NominalInputState extends State<NominalInput> {
  final TextEditingController amountController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    amountController.addListener(() {
      final rawValue = amountController.text.replaceAll('.', '').trim();
      final amount = int.tryParse(rawValue) ?? 0;
      setState(() {
        isButtonEnabled = amount >= 10000;
      });
    });
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
                widget.adminFee,
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
                          final va = generateDynamicVA(widget.bankName);

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => TopUpConfirmationDialog(
                              bankName: widget.bankName,
                              amount: amount,
                              virtualAccount: va,
                              assetPath: widget.assetPath,
                              backgroundColor: widget.backgroundColor,
                            ),
                          );
                        }
                      : null,
                  child: const Text(
                    "Confirm Top Up",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8), 
                const Text(
                  'Minimal top up Rp10.000',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getBankPrefix(String bankName) {
    switch (bankName) {
      case 'BCA':
        return '6969 ';
      case 'BRI':
        return '7272 ';
      case 'Mandiri':
        return '6769 ';
      case 'BNI':
        return '6942 ';
      default:
        return '0000 ';
    }
  }

  String generateDynamicVA(String bankName) {
    final prefix = getBankPrefix(bankName);
    final random = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
    final va = '$prefix$random';
    return va.padRight(16, '0');
  }
}

// Top Up Confirmation Dialog
class TopUpConfirmationDialog extends StatefulWidget {
  final String bankName;
  final String amount;
  final String virtualAccount;
  final String assetPath;
  final Color? backgroundColor;

  const TopUpConfirmationDialog({
    super.key,
    required this.bankName,
    required this.amount,
    required this.virtualAccount,
    required this.assetPath,
    this.backgroundColor,
  });

  @override
  State<TopUpConfirmationDialog> createState() => _TopUpConfirmationDialogState();
}

class _TopUpConfirmationDialogState extends State<TopUpConfirmationDialog> {
  final TextEditingController amountController = TextEditingController();
  
  bool isProcessing = false;

  DateTime? expiryTime;
  String remainingTime = '';
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    amountController.addListener(() {
      final rawValue = amountController.text.replaceAll('.', '').trim();
      final amount = int.tryParse(rawValue) ?? 0;

      setState(() {
        isButtonEnabled = amount >= 10000;
      });
    });
  }

  String get formattedAmount => NumberFormat.decimalPattern('id')
    .format(int.tryParse(widget.amount.replaceAll('.', '')) ?? 0);
    
  @override
  Widget build(BuildContext context) {
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Top Up',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Rp $formattedAmount',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Via ${widget.bankName}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () async {
                // Prevent multiple taps
                if (isProcessing) return;
                setState(() => isProcessing = true);

                // 1. Get current user
                final currentUser = await UserStorage().getUser();
                if (currentUser == null) return;

                // 2. Parse top-up amount
                final amountToAdd = int.tryParse(widget.amount.replaceAll('.', '')) ?? 0;

                // 3. Update Firestore balance
                final newBalance = (currentUser.balance + amountToAdd);

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser.uid)
                    .update({'balance': newBalance});

                // 4. Update local cache
                await UserStorage().saveUser(
                  currentUser..balance = newBalance.toDouble(),
                );

                // 5. Record transaction to Firestore 
                final txnRef = FirebaseFirestore.instance 
                    .collection('users')
                    .doc(currentUser.uid)
                    .collection('transactions')
                    .doc(); // Auto-generate ID

                final txnId = txnRef.id;
                await FirebaseFirestore.instance .collection('users') 
                .doc(currentUser.uid) 
                .collection('transactions') 
                .doc(txnId) 
                .set({ 
                  'id': txnId, 
                  'amount': amountToAdd.toDouble(), 
                  'timestamp': Timestamp.now(),
                  'status': 'success', 
                  'type': 'virtualAccount', 
                  'senderName': currentUser.username, 
                  'senderAccount': currentUser.accountNumber, 
                  'recipientName': 'Top Up VaultBank', 
                  'recipientAccount': widget.virtualAccount, 
                  'recipientBankName': widget.bankName,
                  'notes': 'Top up via ${widget.bankName} VA',
                });

                // 6. Navigate to TopUpSuccessPage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const TopUpSuccessPage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF003087),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.black,
                    width: 3,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.virtualAccount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tekan untuk salin nomor VA',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  expiryTime = null;
                },
                child: const Text(
                  'Batalkan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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