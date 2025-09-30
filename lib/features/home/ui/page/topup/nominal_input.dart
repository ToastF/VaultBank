import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vaultbank/core/util/format_util.dart';
import 'package:intl/intl.dart';
import 'package:vaultbank/features/home/ui/page/topup/success.dart';

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
                final amount = amountController.text.replaceAll('.', '');
                final va = generateDynamicVA(bankName);
                
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => TopUpConfirmationDialog(
                    bankName: bankName,
                    amount: amount,
                    virtualAccount: va,
                    assetPath: assetPath,
                    backgroundColor: backgroundColor,
                  ),
                );
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
  DateTime? expiryTime;
  String remainingTime = '';

  @override
  void initState() {
    super.initState();
    expiryTime = DateTime.now().add(const Duration(minutes: 30));
    _updateTimer();
  }

  void _updateTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && expiryTime != null) {
        final now = DateTime.now();
        final difference = expiryTime!.difference(now);
        
        if (difference.isNegative) {
          setState(() {
            remainingTime = '00:00:00';
          });
        } else {
          final hours = difference.inHours.toString().padLeft(2, '0');
          final minutes = (difference.inMinutes % 60).toString().padLeft(2, '0');
          final seconds = (difference.inSeconds % 60).toString().padLeft(2, '0');
          
          setState(() {
            remainingTime = '$hours:$minutes:$seconds';
          });
          _updateTimer();
        }
      }
    });
  }

  String get formattedAmount => NumberFormat.decimalPattern('id')
    .format(int.tryParse(widget.amount.replaceAll('.', '')) ?? 0);

  // void _copyToClipboard() {
  //   Clipboard.setData(ClipboardData(text: widget.virtualAccount));
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('Nomor VA berhasil disalin'),
  //       duration: Duration(seconds: 2),
  //     ),
  //   );
  // }

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
              onTap: () {
                // Navigate to the new page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TopUpSuccessPage(),
                  ),
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
                children: [
                  const TextSpan(text: 'Batas waktu pembayaran:'),
                  TextSpan(
                    text: remainingTime,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text(
                  'Status',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Menunggu',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
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

  @override
  void dispose() {
    expiryTime = null;
    super.dispose();
  }
}