import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vaultbank/core/util/color_palette.dart';
import 'package:vaultbank/features/common/ui/pages/pin_entry_page.dart';
import 'package:vaultbank/features/recipient/domain/entities/recipient_entity.dart';
import 'package:vaultbank/features/transaction_history/ui/pages/transaction_detail_page.dart';
import 'package:vaultbank/features/transfer/ui/cubits/transfer_cubit.dart';

class TransferConfirmationPage extends StatelessWidget {
  // Values yang dipass oleh Transfer Screen
  final RecipientEntity recipient;
  final double amount;
  final String notes;

  const TransferConfirmationPage({
    super.key,
    required this.recipient,
    required this.amount,
    required this.notes,
  });

  // Fungsi untuk menunjukkan PIN page
  // Memberi callback function untuk melakukan transfer kepada PIN page
  void _proceedWithPin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PinEntryPage(
              onCompleted: () {
                context.read<TransferCubit>().makeTransfer(
                  amount: amount,
                  recipient: recipient,
                  notes: notes,
                );
                Navigator.pop(context);
              },
            ),
      ),
    );
  }

  // Fungsi tambahan untuk melakukan formatting pada mata uang
  String _formatCurrency(double value) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }
  // Pembuatan UI
  @override
  Widget build(BuildContext context) {
    // Dynamic sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double horizontalPadding = screenWidth * 0.05;
    final double verticalSpacing = screenHeight * 0.02;
    final double titleFontSize = screenWidth * 0.065;
    final double labelFontSize = screenWidth * 0.045;
    final double valueFontSize = screenWidth * 0.05;
    final double buttonHeight = screenHeight * 0.065;
    final double spacingSmall = screenHeight * 0.015;

    return BlocConsumer<TransferCubit, TransferState>(
      listener: (context, state) {
        // Jika transfer berhasil, ke Transaction Detail Page
        if (state is TransferSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      TransactionDetailPage(transaction: state.transaction),
            ),
            // Agar saat menekan back button, langsung kembali ke Transfer Home Screen
            (route) => route.isFirst,
          );
          // Jika error, show snackbar
        } else if (state is TransferFailed) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        // boolean untuk menentukan jika tombol tertekan
        final isLoading = state is TransferLoading;

        return Scaffold(
          backgroundColor: AppColors.whiteBackground,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: verticalSpacing),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.arrow_back, size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  SizedBox(height: verticalSpacing / 2),
                  Text(
                    'Konfirmasi',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: verticalSpacing / 2),
                  Text(
                    'Transfer With 0 Admin Fees',
                    style: TextStyle(
                      fontSize: labelFontSize,
                      color: AppColors.greyTextSearch,
                    ),
                  ),
                  SizedBox(height: verticalSpacing * 1.5),

                  // Body dipecah menjadi dua Card
                  Expanded(
                    child: ListView(
                      children: [
                        // Card Utama (Penerima/Recipient & Rincian Biaya)
                        _buildMainDetailsCard(
                          recipient, 
                          amount, 
                          labelFontSize, 
                          valueFontSize, 
                          verticalSpacing
                        ),

                        SizedBox(height: verticalSpacing),

                        // Card Catatan
                        _buildNotesCard(
                          notes, 
                          labelFontSize, 
                          valueFontSize
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: verticalSpacing),
                  SizedBox(
                    width: double.infinity,
                    height: buttonHeight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blueButton,
                        disabledBackgroundColor: AppColors.blueButton.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: isLoading ? null : () => _proceedWithPin(context),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              "Konfirmasi",
                              style: TextStyle(
                                fontSize: labelFontSize * 1.1,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
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
      },
    );
  }

  // Helper widget untuk Card Utama
  Widget _buildMainDetailsCard(RecipientEntity recipient, double amount, double labelSize, double valueSize, double spacing) {
  // Logika untuk menentukan nama yang akan ditampilkan
  String displayName = recipient.name; // Defaultnya adalah nama asli
  if (recipient.alias != null && recipient.alias!.isNotEmpty) {
    // Jika alias ada, gabungkan keduanya
    displayName = "${recipient.alias} (${recipient.name})";
  }
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: AppColors.blueLightButton,
                child: Text(
                  // Ambil huruf pertama dari alias jika ada, jika tidak dari nama asli
                  (recipient.alias ?? recipient.name).isNotEmpty ? (recipient.alias ?? recipient.name)[0].toUpperCase() : '?',
                  style: const TextStyle(color: AppColors.blueIcon, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                displayName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: valueSize)
              ),
              subtitle: Text(
                recipient.accountNumber,
                style: TextStyle(fontSize: labelSize)
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  _buildDetailRow("Jumlah Uang", _formatCurrency(amount), labelSize, valueSize),
                  SizedBox(height: spacing),
                  _buildDetailRow("Biaya Transfer", "Gratis", labelSize, valueSize),
                  const Divider(height: 24),
                  _buildDetailRow("Total", _formatCurrency(amount), labelSize, valueSize, isTotal: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk Card Catatan
  Widget _buildNotesCard(String notes, double labelSize, double valueSize) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Catatan",
              style: TextStyle(fontSize: labelSize, color: AppColors.greyTextSearch),
            ),
            const SizedBox(height: 4),
            Text(
              notes.isNotEmpty ? notes : "-",
              style: TextStyle(fontSize: valueSize, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk baris detail
  Widget _buildDetailRow(String label, String value, double labelSize, double valueSize, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: labelSize,
            color: isTotal ? AppColors.blackText : AppColors.greyTextSearch,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: valueSize,
            color: AppColors.blackText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}