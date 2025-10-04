import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:vaultbank/core/util/color_palette.dart';
import 'package:vaultbank/features/transaction_history/domain/entities/transaction_entity.dart';
import 'package:vaultbank/features/transaction_history/ui/cubit/transaction_cubit.dart';
import 'package:vaultbank/features/user/ui/cubit/user_cubit.dart';
import 'package:vaultbank/features/transaction_history/ui/pages/transaction_detail_page.dart';

enum TxFilter { all, outgoing, incoming }

// Page untuk menunjukkan semua transaksi yang pernah dilakukan oleh atau kepada user
// Fitur: filter by month, all, outgoing, ingoing, dengan setiap transaksi dapat diperlihatkan detailnya (Transaction Detail Page)
class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  TxFilter selectedFilter = TxFilter.all;
  DateTime selectedMonth = DateTime.now();

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

    // format Jumlah uang to Currency
    final currency = NumberFormat.currency(
      locale: "id_ID",
      symbol: "Rp",
      decimalDigits: 0,
    );

    final userState = context.read<UserCubit>().state;
    final currentUserAccountNumber =
        userState is UserLoaded ? userState.user.accountNumber : "";

    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      appBar: AppBar(
        backgroundColor: AppColors.blueHeader,
        foregroundColor: Colors.white,
        title: const Text("History"),
        centerTitle: true,
      ),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionLoaded) {
            final txs = state.transactions;
            // Check transaction is null
            if (txs.isEmpty) {
              return const Center(child: Text("No transactions yet"));
            }

            // Filter by selected month
            final monthlyTxs =
                txs
                    .where(
                      (tx) =>
                          tx.timestamp.year == selectedMonth.year &&
                          tx.timestamp.month == selectedMonth.month,
                    )
                    .toList();

            // Totals
            double totalExpense = 0;
            double totalIncome = 0;

            // Calculate total by incoming and outgoing values
            for (final tx in monthlyTxs) {
              final isIncoming =
                  tx.recipientAccount == currentUserAccountNumber ||
                  tx.type == TransactionType.virtualAccount;
              final isOutgoing =
                  tx.senderAccount == currentUserAccountNumber &&
                  tx.type != TransactionType.virtualAccount;

              if (isIncoming) totalIncome += tx.amount;
              if (isOutgoing) totalExpense += tx.amount;
            }

            // Apply filter to current month's transactions
            final filtered =
                monthlyTxs.where((tx) {
                  final isIncoming =
                      tx.recipientAccount == currentUserAccountNumber ||
                      tx.type == TransactionType.virtualAccount;
                  final isOutgoing =
                      tx.senderAccount == currentUserAccountNumber &&
                      tx.type != TransactionType.virtualAccount;

                  if (selectedFilter == TxFilter.outgoing) return isOutgoing;
                  if (selectedFilter == TxFilter.incoming) return isIncoming;
                  return true;
                }).toList();

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: verticalSpacing),

                  // Total Saldo
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Total Saldo",
                          style: TextStyle(
                            fontSize: titleFontSize * 0.9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Total value
                        Text(
                          currency.format(totalIncome - totalExpense),
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blueButton,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: verticalSpacing),

                  // Month selector + totals of outgoing & ingoing
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blueButton,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Button to go to previous month
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_left,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedMonth = DateTime(
                                    selectedMonth.year,
                                    selectedMonth.month - 1,
                                  );
                                });
                              },
                            ),
                            // Show current month
                            Text(
                              DateFormat(
                                'MMMM yyyy',
                                'id_ID',
                              ).format(selectedMonth),
                              style: TextStyle(
                                fontSize: subtitleFontSize,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Button to go to next month
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_right,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedMonth = DateTime(
                                    selectedMonth.year,
                                    selectedMonth.month + 1,
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Value for total ingoing and outgoing
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  "Pemasukan",
                                  style: TextStyle(color: Colors.white70),
                                ),
                                Text(
                                  currency.format(totalIncome),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  "Pengeluaran",
                                  style: TextStyle(color: Colors.white70),
                                ),
                                Text(
                                  currency.format(totalExpense),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: verticalSpacing),

                  // Filter buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // With helper function to create the buttons
                      _buildFilterButton("Semua", TxFilter.all, buttonHeight),
                      _buildFilterButton(
                        "Keluar",
                        TxFilter.outgoing,
                        buttonHeight,
                      ),
                      _buildFilterButton(
                        "Masuk",
                        TxFilter.incoming,
                        buttonHeight,
                      ),
                    ],
                  ),

                  SizedBox(height: verticalSpacing),

                  // Transaction list with clickable cards
                  ListView.builder(
                    itemCount: filtered.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final tx = filtered[index];
                      final isOutgoing =
                          tx.senderAccount == currentUserAccountNumber &&
                          tx.type != TransactionType.virtualAccount;
                      final isIncoming =
                          tx.recipientAccount == currentUserAccountNumber ||
                          tx.type == TransactionType.virtualAccount;

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      TransactionDetailPage(transaction: tx),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        // Card detail
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Sender
                                Text(
                                  tx.senderName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: subtitleFontSize,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Date
                                Text(
                                  DateFormat(
                                    "dd MMM yyyy",
                                    'id_ID',
                                  ).format(tx.timestamp),
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: labelFontSize * 0.9,
                                  ),
                                ),
                                // Notes (if any)
                                if (tx.notes?.isNotEmpty == true)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      tx.notes!,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontStyle: FontStyle.italic,
                                        fontSize: labelFontSize * 0.9,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 6),
                                // Amount
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    (isOutgoing ? "- " : "+ ") +
                                        currency.format(tx.amount),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: subtitleFontSize,
                                      color:
                                          isOutgoing
                                              ? Colors.red
                                              : Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (state is TransactionError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const SizedBox();
        },
      ),
    );
  }

  // Widget to make filter buttons
  Widget _buildFilterButton(String label, TxFilter filter, double height) {
    final isSelected = selectedFilter == filter;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: SizedBox(
          height: height,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? AppColors.blueButton : Colors.white,
              foregroundColor: isSelected ? Colors.white : Colors.black,
              side: BorderSide(color: AppColors.blueButton),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            // Set filter
            onPressed: () {
              setState(() {
                selectedFilter = filter;
              });
            },
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
