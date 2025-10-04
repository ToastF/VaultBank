import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/features/common/ui/cubit/pin_state.dart';
import 'package:vaultbank/features/user/ui/cubit/user_cubit.dart'; 

class PinCubit extends Cubit<PinState> {
  final UserCubit _userCubit;

  PinCubit({required UserCubit userCubit})
      : _userCubit = userCubit,
        super(PinInitial());

  void addDigit(String digit) {
    if (state is PinLoading) return;

    final newPin = state.currentPin + digit;
    emit(PinInput(newPin));

    if (newPin.length == 6) {
      _verifyPin(newPin);
    }
  }

  void removeDigit() {
    if (state is PinLoading) return;

    if (state.currentPin.isNotEmpty) {
      final newPin = state.currentPin.substring(0, state.currentPin.length - 1);
      emit(PinInput(newPin));
    }
  }

  Future<void> _verifyPin(String pin) async {
    emit(PinLoading(pin));
    
    // DIUBAH: Logika verifikasi sekarang melalui UserCubit
    final userState = _userCubit.state;
    if (userState is UserLoaded) {
      try {
        final uid = userState.user.uid;
        // Gunakan instance userRepo dari UserCubit
        final isValid = await _userCubit.userRepo.verifyPin(uid, pin);

        if (isValid) {
          emit(PinSuccess());
        } else {
          emit(const PinFailure('PIN salah, silakan coba lagi.'));
          await Future.delayed(const Duration(milliseconds: 500));
          emit(PinInitial());
        }
      } catch (e) {
        emit(PinFailure('Terjadi kesalahan: ${e.toString()}'));
        await Future.delayed(const Duration(milliseconds: 500));
        emit(PinInitial());
      }
    } else {
      // Handle kasus di mana user tidak ter-load
      emit(const PinFailure('Gagal mendapatkan data user.'));
      await Future.delayed(const Duration(milliseconds: 500));
      emit(PinInitial());
    }
  }
}
