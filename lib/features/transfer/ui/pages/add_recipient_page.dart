// Dikarenakan isi UI dari E-Wallet dan Transfer Antar Bank yang mirip
// Kita akan memanfaatkan page ini untuk navigation ke 2 transfer tersebut
// Pembedanya adalah title dan label

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/features/transfer/data/models/bank_model.dart';
import 'package:vaultbank/features/transfer/logic/transfer_cubit.dart';

class AddRecipientPage extends StatefulWidget {
  final String title;
  final String label;

  const AddRecipientPage({
    super.key,
    required this.title,
    required this.label,
    });

  @override
  State<AddRecipientPage> createState() => _AddRecipientPageState();
}

class _AddRecipientPageState extends State<AddRecipientPage> {
  final _accountNumberController = TextEditingController();
  BankModel? _selectedBank;

  @override
  void initState(){
    super.initState();
    context.read<TransferCubit>().loadInitialData();
  }
  
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}