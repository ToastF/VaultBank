import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vaultbank/core/util/color_palette.dart';
import 'package:vaultbank/features/transaction_history/domain/entities/transaction_entity.dart';

// Page untuk menunjukkan detail dari suatu Transaction
class TransactionDetailPage extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionDetailPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    // Currency formatter
    final currency = NumberFormat.currency(
      locale: "id_ID",
      symbol: "Rp",
      decimalDigits: 0,
    );

    // Dynamic sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double horizontalPadding = screenWidth * 0.05;
    final double verticalSpacing = screenHeight * 0.02;
    final double titleFontSize = screenWidth * 0.07;
    final double subtitleFontSize = screenWidth * 0.045;
    final double labelFontSize = screenWidth * 0.04;
    final double valueFontSize = screenWidth * 0.045;
    final double avatarRadius = screenWidth * 0.07;

    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.whiteBackground),
      backgroundColor: AppColors.whiteBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalSpacing,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: screenHeight * 0.1),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sender Info
                    Row(
                      children: [
                        // Profile Pic / Avatar
                        CircleAvatar(
                          radius: avatarRadius,
                          backgroundColor: AppColors.blueButton,
                          child: Text(
                            transaction.senderName.isNotEmpty
                                ? transaction.senderName[0].toUpperCase()
                                : "?",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: subtitleFontSize,
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Sender name
                              Text(
                                transaction.senderName,
                                style: TextStyle(fontSize: titleFontSize),
                              ),
                              SizedBox(height: verticalSpacing * 0.3),
                              // Sender account
                              Text(
                                transaction.senderAccount,
                                style: TextStyle(
                                  color: AppColors.greyTextSearch,
                                  fontSize: subtitleFontSize,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: verticalSpacing),

                    const Divider(height: 32),

                    // Details
                    _buildDetailRow(
                      "Jumlah Uang",
                      currency.format(transaction.amount),
                      labelFontSize,
                      valueFontSize,
                    ),
                    _buildDetailRow(
                      "Biaya Transfer",
                      "Gratis",
                      labelFontSize,
                      valueFontSize,
                    ),
                    _buildDetailRow(
                      "Total",
                      currency.format(transaction.amount),
                      labelFontSize,
                      valueFontSize,
                    ),

                    const Divider(height: 32),

                    _buildDetailRow(
                      "Waktu",
                      DateFormat(
                        "dd MMM yyyy, HH:mm",
                        "id_ID",
                      ).format(transaction.timestamp),
                      labelFontSize,
                      valueFontSize,
                    ),
                    _buildDetailRow(
                      "Status",
                      transaction.status.name,
                      labelFontSize,
                      valueFontSize,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk membantu pembuatan row-row detail transaksi
  Widget _buildDetailRow(
    String label,
    String value,
    double labelFontSize,
    double valueFontSize,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: labelFontSize,
              color: AppColors.blackText,
            ),
          ),
          Text(value, style: TextStyle(fontSize: valueFontSize)),
        ],
      ),
    );
  }
}
