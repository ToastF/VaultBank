import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vaultbank/core/util/color_palette.dart';

class BalanceCard extends StatefulWidget {
  final num balance;
  final String accountNumber;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.accountNumber,
  });

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double horizontalPadding = screenWidth * 0.05;
    final double borderRadius = 16.0;
    final double iconSize = screenWidth * 0.06;
    final double titleFontSize = screenWidth * 0.04;
    final double balanceFontSize = screenWidth * 0.07;
    final double accountFontSize = screenWidth * 0.035;
    final double spacingSmall = screenWidth * 0.02;
    final double cardWidth = screenWidth * 0.9;

    final formattedBalance = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(widget.balance);

    return Center(
      child: Container(
        width: cardWidth,
        padding: EdgeInsets.all(horizontalPadding),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackText.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  color: AppColors.greyDivider,
                  size: iconSize,
                ),
                SizedBox(width: spacingSmall),
                Text(
                  "Total saldo",
                  style: TextStyle(
                    color: AppColors.greyTextSearch,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            SizedBox(height: spacingSmall * 1.5),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isVisible ? formattedBalance : "Rp ••••••••",
                  style: TextStyle(
                    fontSize: balanceFontSize,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackText,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.greyDivider,
                    size: iconSize * 1.1,
                  ),
                  onPressed: () => setState(() => _isVisible = !_isVisible),
                ),
              ],
            ),

            Divider(color: AppColors.greyFormLine),

            Text(
              "Account Number: ${widget.accountNumber}",
              style: TextStyle(
                color: AppColors.greyTextSearch,
                fontSize: accountFontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}