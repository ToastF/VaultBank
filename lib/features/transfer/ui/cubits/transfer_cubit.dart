import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:vaultbank/features/recipient/domain/entities/recipient_entity.dart';
import 'package:vaultbank/features/transaction_history/domain/entities/transaction_entity.dart';
import 'package:vaultbank/features/transfer/domain/repositories/transfer_repository.dart';
import 'package:vaultbank/features/user/domain/repositories/user_repository.dart';
import 'package:vaultbank/features/user/ui/cubit/user_cubit.dart';

part 'transfer_state.dart';

/// Cubit for managing the process of making a transfer
class TransferCubit extends Cubit<TransferState> {
  final TransferRepository _transferRepo;
  final UserCubit _userCubit;

  TransferCubit({
    required TransferRepository transferRepo,
    required UserRepository userRepo,
    required UserCubit userCubit,
  }) : _transferRepo = transferRepo,
       _userCubit = userCubit,
       super(const TransferInitial());

  /// transfer flow
  Future<void> makeTransfer({
    required double amount,
    required RecipientEntity recipient,
    String? notes,
  }) async {
    emit(const TransferLoading());

    try {
      final userState = _userCubit.state;

      if (userState is! UserLoaded) {
        emit(const TransferFailed("User not loaded"));
        return;
      }

      final currentUser = userState.user;

      // Verify balance (local check)
      if (amount > currentUser.balance) {
        emit(const TransferFailed("Insufficient balance"));
        return;
      }

      // Perform transfer
      final transaction = await _transferRepo.makeTransfer(
        uid: currentUser.uid,
        senderAccount: currentUser.accountNumber,
        senderName: currentUser.username,
        recipientAccount: recipient.accountNumber,
        recipientName: recipient.name,
        amount: amount,
        type: TransactionType.antarRekening,
        notes: notes,
      );

      //Emit success state
      emit(TransferSuccess(transaction));
    } catch (e, st) {
      debugPrint("Transfer error: $e\n$st");
      emit(TransferFailed(e.toString()));
    }
  }
}
