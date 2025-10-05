import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/core/util/animation_slide.dart';
import 'package:vaultbank/core/util/color_palette.dart';
import 'package:vaultbank/features/transaction_history/domain/entities/transaction_entity.dart';
import 'package:vaultbank/features/transaction_history/ui/cubit/transaction_cubit.dart';
import 'package:vaultbank/features/transaction_history/ui/pages/transaction_history_screen.dart';
import 'package:vaultbank/features/user/ui/cubit/user_cubit.dart';
import 'package:intl/intl.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double outerPadding = screenWidth * 0.05;
    final double innerPadding = screenWidth * 0.04;
    final double headerFontSize = screenWidth * 0.045;
    final double spacing = screenWidth * 0.025;
    final double iconSize = screenWidth * 0.055;
    final double avatarRadius = screenWidth * 0.05;
    final double titleFontSize = screenWidth * 0.04;
    final double subtitleFontSize = screenWidth * 0.032;
    final double amountFontSize = screenWidth * 0.038;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: outerPadding),
      child: Card(
        color: AppColors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(innerPadding),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'History',
                    style: TextStyle(
                      fontSize: headerFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        SlidePageRoute(page: const TransactionHistoryScreen()),
                      );
                    },
                    style: TextButton.styleFrom(
                      overlayColor: Colors.transparent,
                      foregroundColor: AppColors.blueText,
                    ),
                    child: Text(
                      'Lihat Semua >',
                      style: TextStyle(
                        color: AppColors.blueText,
                        fontSize: subtitleFontSize,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing),

              BlocBuilder<TransactionCubit, TransactionState>(
                builder: (context, state) {
                  if (state is TransactionLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TransactionLoaded) {
                    final txList = state.transactions.take(5).toList();
                    if (txList.isEmpty) {
                      return const Center(child: Text("No transactions yet"));
                    }

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: txList.length,
                      itemBuilder: (context, index) {
                        final tx = txList[index];
                        return BlocBuilder<UserCubit, UserState>(
                          builder: (context, userState) {
                            if (userState is UserLoaded) {
                              return _buildHistoryItem(
                                tx,
                                avatarRadius,
                                iconSize,
                                titleFontSize,
                                subtitleFontSize,
                                amountFontSize,
                                userState.user.accountNumber,
                              );
                            }
                            return const SizedBox();
                          },
                        );
                      },
                    );
                  } else if (state is TransactionError) {
                    return Text("Error: ${state.message}");
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(
    TransactionEntity tx,
    double avatarRadius,
    double iconSize,
    double titleFontSize,
    double subtitleFontSize,
    double amountFontSize,
    String currentUserAccountNumber,
  ) {
    final isSender = tx.senderAccount == currentUserAccountNumber;
    final displayName = isSender ? tx.recipientName : tx.senderName;
    final notes = (tx.notes != null && tx.notes!.isNotEmpty) ? tx.notes : null;
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    // icon
    IconData iconData;
    Color iconColor;
    switch (tx.type) {
      case TransactionType.antarRekening:
      case TransactionType.antarBank:
        if (isSender) {
          iconData = Icons.arrow_circle_right_rounded;
          iconColor = Colors.red;
        } else {
          iconData = Icons.arrow_circle_left_rounded;
          iconColor = Colors.green;
        }
        break;
      case TransactionType.virtualAccount:
        iconData = Icons.arrow_circle_up_rounded;
        iconColor = Colors.blue;
        break;
      case TransactionType.tarikTunai:
        iconData = Icons.account_balance_wallet_rounded;
        iconColor = Colors.orange;
        break;
      default:
        iconData = Icons.swap_horiz_rounded;
        iconColor = AppColors.blueIcon;
    }

    return ListTile(
      leading: CircleAvatar(
        radius: avatarRadius,
        backgroundColor: AppColors.whiteBackground,
        child: Icon(iconData, color: iconColor, size: iconSize),
      ),
      title: Text(displayName, style: TextStyle(fontSize: titleFontSize)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tx.timestamp.toString().substring(0, 10),
            style: TextStyle(fontSize: subtitleFontSize),
          ),
          if (notes != null)
            Text(
              notes,
              style: TextStyle(
                fontSize: subtitleFontSize * 0.95,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
      trailing: Text(
        formatter.format(tx.amount),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: amountFontSize,
          color: isSender ? Colors.red : Colors.green,
        ),
      ),
    );
  }
}
