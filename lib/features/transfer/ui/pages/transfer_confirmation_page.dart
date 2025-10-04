import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: verticalSpacing),

                  // Back button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  // Title
                  Padding(
                    padding: EdgeInsets.only(left: horizontalPadding / 2),
                    child: Text(
                      "Konfirmasi Transfer",
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackText,
                      ),
                    ),
                  ),

                  SizedBox(height: verticalSpacing),

                  // Card detail transfer
                  Expanded(
                    child: SingleChildScrollView(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: EdgeInsets.all(horizontalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Rekening tujuan
                              _buildDetailRow(
                                "Rekening Tujuan",
                                "${recipient.name} (${recipient.accountNumber})",
                                labelFontSize,
                                valueFontSize,
                              ),
                              SizedBox(height: spacingSmall),
                              // Jumlah uang
                              _buildDetailRow(
                                "Jumlah Uang",
                                "Rp ${amount.toStringAsFixed(0)}",
                                labelFontSize,
                                valueFontSize,
                              ),
                              SizedBox(height: spacingSmall),
                              // Notes / Berita
                              _buildDetailRow(
                                "Berita",
                                notes.isNotEmpty ? notes : "-",
                                labelFontSize,
                                valueFontSize,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Button confirmation (show PIN page)
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
                      onPressed:
                          // Disable / Enable button
                          isLoading ? null : () => _proceedWithPin(context),
                      child:
                          // Show progress indicator untuk menunjukkan bahwa tombol tidak dapat diklik
                          isLoading
                              ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                "Konfirmasi & Masukkan PIN",
                                style: TextStyle(
                                  fontSize: labelFontSize,
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

  // Widget yang membantu menuliskan detail-detail transaksi pada Card
  Widget _buildDetailRow(
    String label,
    String value,
    double labelFontSize,
    double valueFontSize,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Detail name / label
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: labelFontSize,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 4),
          // Detail value
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: valueFontSize,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
