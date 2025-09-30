import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/features/home/ui/page/transfer/domain/repositories/transfer_repository.dart';
import 'package:vaultbank/features/home/ui/page/transfer/domain/entities/recipient_model.dart';
import 'package:vaultbank/features/home/ui/page/transfer/ui/cubits/transfer_state.dart';
import 'package:vaultbank/features/user/domain/repositories/user_repository.dart';
import 'package:vaultbank/features/user/ui/cubit/user_cubit.dart';

class TransferCubit extends Cubit<TransferState>{
  final TransferRepository _transferRepository;
  final UserRepository _userRepository;
  final UserCubit _userCubit;

  TransferCubit({
    required TransferRepository transferRepository,
    required UserRepository userRepository,
    required UserCubit userCubit,
  }) : _transferRepository = transferRepository,
       _userRepository = userRepository,
       _userCubit = userCubit,
       super(TransferInitial());

  // Method di bawah ini akan digunakan untuk load data bank yang kita punya
  Future<void> loadBankList() async{
    // Berikan sebuah try catch untuk menambah safety
    try{
      emit(TransferLoading());
      
      // Panggil daftar bank kita, yang berada dalam transfer_repository.dart
      final banks = await _transferRepository.getBankList();
      emit(TransferDataLoaded(banks));
    }
    // Semisalnya load ini gagal, maka tampilkan pesan error
    catch (e){
      emit(TransferFailed("Maaf, data bank gagal dimuat. Silahkan coba lagi"));
    }
  }

  // Method di bawah ini akan digunakan untuk load data bank yang kita punya
  Future<void> loadEwalletList() async{
    // Berikan sebuah try catch untuk menambah safety
    try{
      emit(TransferLoading());
      
      // Panggil daftar bank kita, yang berada dalam transfer_repository.dart
      final ewallets = await _transferRepository.getEwalletList();
      emit(TransferDataLoaded(ewallets));
    }
    // Semisalnya load ini gagal, maka tampilkan pesan error
    catch (e){
      emit(TransferFailed("Maaf, data bank gagal dimuat. Silahkan coba lagi"));
    }
  }

  // Method untuk logika utama transfer kita
  Future<void> makeTransfer({
    required double amount,
    required RecipientModel recipient,
    required String pin,
    String notes = "",
  }) async{
    try {
      emit(TransferLoading());

      // 1. Awalan dimulai dengan verifikasi beberapa hal, verfikasi adanya data user
      // verifikasi pin dan verifikasi saldo
      // a. Cek adanya data user
      // TODO: UserCubit dianggap punya info soal saldo kita;
      final userState = _userCubit.state;
      
      if (userState is UserLoaded){
        // b. Cek apakah pin benar atau salah
        // Di sini saya manfaatkan verifyPin yang sudah ada
        final bool isPinCorrect = await _userRepository.verifyPin(userState.user.uid, pin);
        if (!isPinCorrect){
          emit(TransferFailed('PIN Anda Salah!'));
          return;
        }

        // c. Cek saldo; Hal ini agar jumlah transfer tidak melebihi saldo awal kita
        // TODO: DELETE JIKA MODEL USER SUDAH PUNYA BALANCE
        const double dummyBalance = 400000.247;

        // Cek apakah saldo transfer lebih besar daripada saldo kita sendiri
        // TODO: Tolong tambahkan balance/saldo pada model User mas @Frederik
        // if (amount > userState.user.balance){
        if (amount > dummyBalance){
          emit(TransferFailed("Saldo Anda Tidak Cukup! Tolong Top Up Dahulu"));
        return;
        }
      }
      else{
        emit(TransferFailed("Tidak dapat memverifikasi saldo pengguna"));
        return;
      }

      // 2. Lakukan transfer
      final transactionResult = await _transferRepository.performTransfer(
        amount: amount,
        recipient: recipient,
        notes: notes,
      );

      // 3. Update saldo pengguna
      // TODO: Mas Fred, tolong tambakan fungsi updateBalance
      // _userCubit.updateBalance(userState.user.balance - amount);

      // 4. Emit bahwa proses telah berhasil
      emit(TransferSuccess(transactionResult));
    }
    catch (e){
      // Tangkap error lain yang belom teridentifikasi untuk saat ini
      emit(TransferFailed(e.toString()));
    }
  }
}