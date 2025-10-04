// TODO: masih basic design, change! -> DONE
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/core/util/color_palette.dart';
import 'package:vaultbank/features/recipient/UI/cubit/recipient_cubit.dart';
import 'package:vaultbank/features/recipient/domain/entities/recipient_entity.dart';
import 'package:vaultbank/features/user/ui/cubit/user_cubit.dart';

class AddInternalAccountPage extends StatefulWidget {
  const AddInternalAccountPage({super.key});

  @override
  State<AddInternalAccountPage> createState() => _AddInternalAccountPageState();
}

class _AddInternalAccountPageState extends State<AddInternalAccountPage> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _accountController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _saveRecipient() {
    final account = _accountController.text.trim();
    final name = _nameController.text.trim();
    // Disini _showSnack akan menampilkan SnackBar terkait keberhasilan ataupun kegagalan dalam
    // Melakukan input data, jika berhasil maka berwarna biru, dan salah maka berwarna merah
    // Di tambahkan isError, sebagai indikator keberhasilan atau kegagalan proses daftar rekening
    if (account.isEmpty || name.isEmpty) {
      _showSnack("Mohon lengkapi semua data", isError: true);
      return;
    }

    if (account.length != 10 || int.tryParse(account) == null) {
      _showSnack("Nomor rekening harus 10 digit angka", isError: true);
      return;
    }

    final userState = context.read<UserCubit>().state;
    if (userState is! UserLoaded) {
      _showSnack("Data pengguna tidak ditemukan", isError: true);
      return;
    }

    final uid = userState.user.uid;
    final recipient = RecipientEntity(
      accountNumber: account,
      name: "",
      alias: name.isEmpty ? null : name,
    );
    context.read<RecipientCubit>().addRecipient(uid, recipient);
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(color: AppColors.white),
        ),
        // Bagian ini lah yang akan menentukan tampilan warna dari SnackBar
        backgroundColor: isError ? AppColors.red : AppColors.blueButton,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecipientCubit, RecipientState>(
      listener: (context, state) {
        if (state is RecipientFailure) {
          _showSnack(state.message, isError: true);
        } else if (state is RecipientSuccess) {
          _showSnack(state.message, isError: false);
          Navigator.pop(context);
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.whiteBackground,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.arrow_back, size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Daftar Rekening',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Transfer With 0 Admin Fees',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.greyTextSearch,
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    'Nomor Rekening',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackText,
                    ),
                  ),
                  TextField(
                    controller: _accountController,
                    decoration: const InputDecoration(
                      hintText: "Contoh: 9876543210",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.blueButton),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Nama Panggilan Penerima',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackText,
                    ),
                  ),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: "Contoh: Budi Ayah",
                       focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.blueButton),
                      ),
                    ),
                  ),
                  const Spacer(),
                  BlocBuilder<RecipientCubit, RecipientState>(
                    builder: (context, state) {
                      final isLoading = state is RecipientLoading;
                      return ElevatedButton(
                        onPressed: isLoading ? null : _saveRecipient,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blueButton,
                          disabledBackgroundColor: AppColors.blueButton.withOpacity(0.5),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Simpan Penerima",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                      );
                    },
                  ),
                  const SizedBox(height: 16), 
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}