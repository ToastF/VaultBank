import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vaultbank/core/util/color_palette.dart';

class BalanceCard extends StatefulWidget {
  final num balance;

  const BalanceCard({
    super.key,
    required this.balance,
  });

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _isBalanceVisible = true;

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    // untuk mengubah angka menjadi String
    final formattedBalanceString = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(widget.balance); 

    // biar dinamis
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final horizontalMargin = screenWidth * 0.05;
    final verticalOffset = screenHeight * -0.06;
    final cardPadding = screenWidth * 0.05;
    final borderRadius = screenWidth * 0.04;
    final iconSize = screenWidth * 0.06;
    final fontSizeBalance = screenWidth * 0.085;
    final fontSizeSubtitle = screenWidth * 0.037;
    final fontSizeCoin = screenWidth * 0.032;
    final smallSpacing = screenHeight * 0.006;
    final mediumSpacing = screenHeight * 0.012;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      transform: Matrix4.translationValues(0.0, verticalOffset, 0.0),
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
                color: Colors.grey,
                size: iconSize,
              ),
              SizedBox(width: smallSpacing * 2),
              Text(
                'Total saldo',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: fontSizeSubtitle,
                ),
              ),
            ],
          ),
          SizedBox(height: smallSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  _isBalanceVisible ? formattedBalanceString : 'Rp ••••••••',
                  style: TextStyle(
                    fontSize: fontSizeBalance,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: Icon(
                  _isBalanceVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.grey,
                  size: iconSize,
                ),
                onPressed: _toggleBalanceVisibility,
              ),
            ],
          ),
          SizedBox(height: mediumSpacing),
        ],
      ),
    );
  }
}