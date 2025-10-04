import 'package:flutter/material.dart';
import 'package:vaultbank/features/recipient/UI/widgets/recipient_picker_widget.dart';
import 'package:vaultbank/features/recipient/domain/entities/recipient_entity.dart';
import 'package:vaultbank/features/transfer/ui/pages/transfer_confirmation_page.dart';
import 'package:vaultbank/core/util/color_palette.dart';
import 'package:intl/intl.dart';

// Halaman transfer utama
// Fungsi: prompt user untuk memilih recipient, jumlah uang, dan notes
class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  // Inisialisasi variabel
  // Recipient yang terpilih
  RecipientEntity? selectedRecipient;
  // Textfield Controllers
  final amountCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  // Format Jumlah Uang
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  // Initial state
  @override
  void initState() {
    super.initState();
    // Add format uang pada Textfield jumlah uang
    amountCtrl.addListener(_formatAmount);
  }

  // dispose Textfield controllers
  @override
  void dispose() {
    amountCtrl.removeListener(_formatAmount);
    amountCtrl.dispose();
    notesCtrl.dispose();
    super.dispose();
  }

  // Fungsi untuk memformat jumlah uang pada Textfield
  // dipanggil oleh AmountCtrl
  void _formatAmount() {
    // Remove spaces
    final text = amountCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');
    // Check null
    if (text.isEmpty) return;
    // Parse the string value to integer
    final value = int.parse(text);
    // Format string value to currency
    final formatted = NumberFormat.decimalPattern('id_ID').format(value);
    // Change amount value in Textfield to the formatted value
    if (amountCtrl.text != formatted) {
      amountCtrl.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  // Fungsi untuk menunjukkan widget Recipient Picker
  // dipanggil oleh ListTile memilih recipient
  void _openRecipientPicker() async {
    // Menggunakan helper function pada file recipient_picker_widget tersebut
    final picked = await showRecipientPicker(context);
    // Update selected recipient jika return RecipientEntity
    if (picked != null) {
      setState(() => selectedRecipient = picked);
    }
  }

  // Fungsi untuk pergi ke Transfer Confirmation Page
  // Dipanggil oleh Continue Button
  void _goToConfirmation() {
    // Remove space
    final text = amountCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');
    // Parse jumlah uang (currency format) ke Double
    final amount = double.tryParse(text) ?? 0;
    // Note
    final note = notesCtrl.text;

    // Check if inputs are null
    if (amount <= 0 || selectedRecipient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select recipient and valid amount"),
        ),
      );
      return;
    }

    // Check maximum amount
    if (amount >= 10000000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Max. amount is Rp 10.000.000")),
      );
      return;
    }

    // Check minimum amount
    if (amount < 1000) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Min. amount is Rp 1000")));
      return;
    }

    // Check note length
    if (note.length > 15) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Note is too long, Max. 15 Chars")),
      );
      return;
    }

    // Go to confirmation page dengan values yang telah dipilih/diketik
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => TransferConfirmationPage(
              recipient: selectedRecipient!,
              amount: amount,
              notes: notesCtrl.text,
            ),
      ),
    );
  }

  // Pembuatan UI
  @override
  Widget build(BuildContext context) {
    // Dynamic sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double horizontalPadding = screenWidth * 0.05;
    final double verticalSpacing = screenHeight * 0.02;
    final double titleFontSize = screenWidth * 0.07;
    final double subtitleFontSize = screenWidth * 0.045;
    final double labelFontSize = screenWidth * 0.04;
    final double buttonHeight = screenHeight * 0.065;

    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: verticalSpacing),
              // Back button
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: verticalSpacing),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        "Transfer Antar Rekening",
                        style: TextStyle(
                          fontSize: titleFontSize,
                          color: AppColors.blackText,
                        ),
                      ),
                      SizedBox(height: verticalSpacing / 2),

                      // Subtitle
                      Text(
                        "Transfer with 0 interest",
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: verticalSpacing * 2),

                      // Recipient picker label
                      Text(
                        "Rekening tujuan",
                        style: TextStyle(fontSize: labelFontSize),
                      ),
                      SizedBox(height: verticalSpacing / 2),

                      // Recipient picker
                      ListTile(
                        onTap: _openRecipientPicker,
                        leading: const Icon(Icons.account_circle),
                        title: Text(
                          // Show alias/name jika terpilih
                          selectedRecipient != null
                              ? selectedRecipient!.alias?.isNotEmpty == true
                                  ? selectedRecipient!.alias!
                                  : selectedRecipient!.name
                              : "Select Recipient",
                          style: TextStyle(fontSize: labelFontSize),
                        ),
                        subtitle:
                            // Show accountNumber jika terpilih
                            selectedRecipient != null
                                ? Text(selectedRecipient!.accountNumber)
                                : null,
                        trailing: const Icon(Icons.arrow_drop_down),
                        tileColor: Colors.grey.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      SizedBox(height: verticalSpacing * 2),

                      // Textfield Jumlah Uang
                      TextField(
                        controller: amountCtrl,
                        decoration: InputDecoration(
                          labelText: "Jumlah uang",
                          contentPadding: EdgeInsets.all(screenWidth * 0.04),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              "Rp",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: labelFontSize),
                      ),

                      SizedBox(height: verticalSpacing),

                      // Textfield Notes / Berita
                      TextField(
                        controller: notesCtrl,
                        decoration: InputDecoration(
                          labelText: "Berita",
                          contentPadding: EdgeInsets.all(screenWidth * 0.04),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style: TextStyle(fontSize: labelFontSize),
                      ),

                      SizedBox(height: verticalSpacing * 3),

                      // Continue button
                      SizedBox(
                        width: double.infinity,
                        height: buttonHeight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blueButton,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _goToConfirmation,
                          child: Text(
                            "Continue",
                            style: TextStyle(
                              fontSize: labelFontSize,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: verticalSpacing * 2),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
