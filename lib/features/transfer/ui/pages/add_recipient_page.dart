// Dikarenakan isi UI dari E-Wallet dan Transfer Antar Bank yang mirip
// Kita akan memanfaatkan page ini untuk navigation ke 2 transfer tersebut
// Pembedanya adalah title dan label

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/features/transfer/domain/entities/bank_model.dart';
import 'package:vaultbank/features/transfer/ui/cubits/transfer_cubit.dart';
import 'package:vaultbank/features/transfer/ui/cubits/transfer_state.dart';
import 'package:vaultbank/features/transfer/ui/widgets/provider_list_item_widget.dart';

enum RecipientType {bank, ewallet}

class AddRecipientPage extends StatefulWidget {
  final RecipientType type;

  const AddRecipientPage({
    super.key,
    required this.type,
    });

  @override
  State<AddRecipientPage> createState() => _AddRecipientPageState();
}

class _AddRecipientPageState extends State<AddRecipientPage> {
  final _accountNumberController = TextEditingController();
  BankModel? _selectedProvider;

  // Disinilah yang akan menentukan nama page kita berdasarkan pilihan (bank / e-wallet)
  String get pageTitle => widget.type == RecipientType.bank ? 'Daftar Rekening' : 'Daftar E-wallet';
  String get inputLabel => widget.type == RecipientType.bank ? 'No. Rekening Tujuan' : 'No. HP';
  String get providerLabel => widget.type == RecipientType.bank ? 'Bank' : 'E-wallet';
  @override
  void initState(){
    super.initState();
    // Muat sesuai pilihan kita
    if (widget.type == RecipientType.bank) {
      context.read<TransferCubit>().loadBankList();
    } else {
      context.read<TransferCubit>().loadEwalletList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // pageTitle: Daftar Rekening atau Daftar E-Wallet
      appBar: AppBar (title: Text(pageTitle)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(inputLabel, style: const TextStyle(fontWeight: FontWeight.w500),),
            const SizedBox(height: 8),
            TextField(
              controller: _accountNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                // inputLabel = No. Rekening Tujuan atau No. HP
                hintText: 'Masukkan $inputLabel',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24,),
            // providerLabel =  List Bank atau List Brand E Wallet
            Text(providerLabel, style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8,),
            InkWell(
              onTap: () => _showProviderSelection(context),
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
                      _selectedProvider?.name?? '- PILIH -', 
                      style: TextStyle(
                        fontSize: 16,
                        color: _selectedProvider != null ? Colors.black : Colors.grey[600]
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(onPressed: () {}, child: const Text ('Masukkan'))
          ],
        )
      )
    );
  }
  void _showProviderSelection (BuildContext pageContext){
    showModalBottomSheet(
      context: pageContext, 
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),

      builder: (modalContext){
        return BlocBuilder <TransferCubit, TransferState>(
          bloc: pageContext.read<TransferCubit>(),
          builder: (context, state){
            // Selama Loading, Tampilkan Progress Loading
            if (state is TransferLoading){
              return const Center(child: CircularProgressIndicator(),);
            }
            // Setelah data nya sudah siap, baru lah tampilkan list provider kita
            if (state is TransferDataLoaded){
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Pilih $providerLabel', style: Theme.of(context).textTheme.titleLarge,),
                  ),
                  const Divider(height: 1,),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.banks.length,
                      itemBuilder: (context, index){
                        final provider = state.banks[index];
                        return ProviderListItemWidget(
                          provider: provider, 
                          onTap: () => Navigator.pop(context, provider));
                      }
                    )
                  )
                ],
              );
            }    
            return const Center(child: Text('Gagal Memuat Daftar'),);
          }
        );
      }
    ).then((selectedValue) => {
      if (selectedValue is BankModel){
        setState(() => _selectedProvider = selectedValue)
      }
    });
  }
}