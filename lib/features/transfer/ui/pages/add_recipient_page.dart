import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/features/transfer/domain/entities/bank_model.dart';
import 'package:vaultbank/features/transfer/domain/entities/recipient_model.dart';
import 'package:vaultbank/features/transfer/ui/cubits/transfer_cubit.dart';
import 'package:vaultbank/features/transfer/ui/cubits/transfer_state.dart';
import 'package:vaultbank/features/transfer/ui/pages/add_recipient_status_page.dart';
import 'package:vaultbank/features/transfer/ui/pages/pin_entry_page.dart';
import 'package:vaultbank/features/transfer/ui/widgets/provider_selection_sheet.dart';
import 'package:vaultbank/features/user/ui/cubit/user_cubit.dart';

enum RecipientType { bank, ewallet }

class AddRecipientPage extends StatefulWidget {
  final RecipientType type;
  const AddRecipientPage({super.key, required this.type});

  @override
  State<AddRecipientPage> createState() => _AddRecipientPageState();
}

class _AddRecipientPageState extends State<AddRecipientPage> {
  final _accountNumberController = TextEditingController();
  BankModel? _selectedProvider;
  RecipientModel? _verifiedRecipient;

  String get pageTitle => widget.type == RecipientType.bank ? 'Daftar Rekening' : 'Daftar E-wallet';
  String get inputLabel => widget.type == RecipientType.bank ? 'No. Rekening Tujuan' : 'No. HP';
  String get providerLabel => widget.type == RecipientType.bank ? 'Bank' : 'E-wallet';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final cubit = context.read<TransferCubit>();
        if (widget.type == RecipientType.bank) {
          cubit.loadBankList();
        } else {
          cubit.loadEwalletList();
        }
      }
    });
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    super.dispose();
  }

  Future<void> _showProviderSelection() async {
    final currentState = context.read<TransferCubit>().state;
    if (currentState is! TransferDataLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data provider belum siap, mohon tunggu...')),
      );
      return;
    }

    final selectedValue = await showModalBottomSheet<BankModel>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ProviderSelectionSheet(
        title: 'Pilih $providerLabel',
        providers: currentState.banks,
      ),
    );

    if (selectedValue != null) {
      setState(() {
        _selectedProvider = selectedValue;
        _verifiedRecipient = null;
      });
    }
  }

  void _onButtonPressed() async {
    if (_verifiedRecipient == null) {
      _verifyAccount();
    } else {
      final enteredPin = await Navigator.push<String>
        (context,
        MaterialPageRoute(builder: (context) => const PinEntryPage()));
      if (enteredPin != null && enteredPin.length == 6 && mounted) {
        final userState = context.read<UserCubit>().state;

        // Kirim userState ke method addRecipient
        context.read<TransferCubit>().addRecipient(
          recipient: _verifiedRecipient!, 
          pin: enteredPin, 
          userState: userState);
      }
    }
  }

  void _verifyAccount() {
    if (_accountNumberController.text.isEmpty || _selectedProvider == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Harap isi semua field.')));
      return;
    }
    context.read<TransferCubit>().verifyRecipient(accountNumber: _accountNumberController.text, bank: _selectedProvider!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransferCubit, TransferState>(
      listener: (context, state) {
        if (state is RecipientVerified) {
          setState(() => _verifiedRecipient = state.recipient);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green, content: Text('Rekening ditemukan!'),
          ));
        } else if (state is RecipientSaveSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AddRecipientStatusPage(recipient: state.recipient)),
          );
        } else if (state is TransferFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red, content: Text(state.errorMessage),
          ));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(pageTitle)),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(inputLabel, style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              TextField(
                controller: _accountNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Masukkan $inputLabel',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              Text(providerLabel, style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              InkWell(
                onTap: _showProviderSelection,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedProvider?.name ?? '- PILIH -',
                        style: TextStyle(fontSize: 16, color: _selectedProvider != null ? Colors.black : Colors.grey[600]),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              if (_verifiedRecipient != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Chip(
                    label: Text('Nama: ${_verifiedRecipient!.name}', style: TextStyle(color: Colors.green[800])),
                    backgroundColor: Colors.green[100],
                    avatar: Icon(Icons.check_circle, color: Colors.green[800]),
                  ),
                ),
              const Spacer(),
              BlocBuilder<TransferCubit, TransferState>(
                builder: (context, state) {
                  if (state is TransferLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    onPressed: _onButtonPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      _verifiedRecipient == null ? 'Cek Rekening' : 'Simpan',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}