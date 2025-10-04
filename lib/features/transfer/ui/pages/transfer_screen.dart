import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    // Fungsi agar SnackBar menampilkan warna merah seandainya terjadi Error saat melakukan transfer
    void _showErrorSnack(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: const TextStyle(color: AppColors.white)),
          backgroundColor: AppColors.red,
        ),
      );
    }

    // Check if inputs are null
    if (amount <= 0 || selectedRecipient == null) {
      _showErrorSnack("Pilih penerima atau jumlah yang valid!");
      return;
    }
    // Check maximum amount
    if (amount >= 10000000) {
       _showErrorSnack("Jumlah transfer maksimum adalah Rp 10.000.000");
      return;
    }

    // Check minimum amount
    if (amount < 1000) {
      _showErrorSnack("Jumlah transfer minimum adalah Rp 1.000");
      return;
    }

    // Check note length
    if (note.length > 15) {
       _showErrorSnack("Berita terlalu panjang (Maks. 15 karakter)");
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

    final double horizontalPadding = screenWidth * 0.06;
    final double verticalSpacing = screenHeight * 0.02;
    final double titleFontSize = screenWidth * 0.07;
    final double subtitleFontSize = screenWidth * 0.04;
    final double labelFontSize = screenWidth * 0.038;
    final double inputFontSize = screenWidth * 0.042;
    final double buttonHeight = screenHeight * 0.06;

    String recipientDisplayName = 'Pilih Penerima';
    if (selectedRecipient != null) {
      if (selectedRecipient!.alias != null && selectedRecipient!.alias!.isNotEmpty) {
        // Jika alias ada, gabungkan: "Alias (Nama Asli)"
        recipientDisplayName = "${selectedRecipient!.alias} (${selectedRecipient!.name})";
      } else {
        // Jika tidak ada alias, tampilkan nama asli saja
        recipientDisplayName = selectedRecipient!.name;
      }
    }
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      body: SafeArea(
        child: Padding(
          // Menggunakan variabel dinamis untuk padding
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 2. Header menggunakan variabel dinamis
              SizedBox(height: verticalSpacing),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.arrow_back, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              ),
              SizedBox(height: verticalSpacing),
              Text(
                'Transfer Antar Rekening',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackText,
                ),
              ),
              SizedBox(height: verticalSpacing / 2),
              Text(
                'Transfer With 0 Admin Fees',
                style: TextStyle(
                  fontSize: subtitleFontSize,
                  color: AppColors.greyTextSearch,
                ),
              ),
              SizedBox(height: verticalSpacing * 2),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 3. Semua elemen form menggunakan variabel dinamis
                      Text(
                        'Rekening Tujuan',
                        style: TextStyle(
                          fontSize: labelFontSize,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blackText,
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: verticalSpacing / 2),
                        title: Text(
                          recipientDisplayName,
                          style: TextStyle(
                            fontSize: inputFontSize,
                            color: selectedRecipient == null ? AppColors.greyTextSearch : AppColors.blackText,
                          ),
                        ),
                        subtitle: selectedRecipient != null 
                          ? Text(selectedRecipient!.accountNumber) 
                          : null,
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: _openRecipientPicker,
                        shape: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.greyFormLine),
                        ),
                      ),
                      SizedBox(height: verticalSpacing * 1.5),

                      Text(
                        'Jumlah Uang (min. Rp 1.000)',
                        style: TextStyle(
                          fontSize: labelFontSize,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blackText,
                        ),
                      ),
                      TextField(
                        controller: amountCtrl,
                        style: TextStyle(fontSize: inputFontSize),
                        decoration: InputDecoration(
                          hintText: "0",
                          prefixIcon: Padding(
                            // Padding agar posisi 'Rp' pas (sejauh ini top: 1 yang paling pas untuk HP Redmi Note 14 Pro 5g)
                            padding: const EdgeInsets.only(top: 1, left:0), 
                            child: Text(
                              'Rp',
                              style: TextStyle(
                                fontSize: inputFontSize,
                                color: AppColors.blackText,
                              ),
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.blueButton),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: verticalSpacing * 1.5),
                      
                      Text(
                        'Berita (Opsional)',
                        style: TextStyle(
                          fontSize: labelFontSize,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blackText,
                        ),
                      ),
                      TextField(
                        controller: notesCtrl,
                        style: TextStyle(fontSize: inputFontSize),
                        inputFormatters: [LengthLimitingTextInputFormatter(15)],
                        decoration: const InputDecoration(
                          hintText: "Contoh: Bayar tagihan",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.blueButton),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Tombol menggunakan variabel dinamis
              SizedBox(height: verticalSpacing),
              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: _goToConfirmation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blueButton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Lanjutkan",
                    style: TextStyle(
                      fontSize: inputFontSize,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              SizedBox(height: verticalSpacing),
            ],
          ),
        ),
      ),
    );
  }
}
