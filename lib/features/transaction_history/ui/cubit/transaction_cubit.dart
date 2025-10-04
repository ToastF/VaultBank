import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:vaultbank/features/transaction_history/domain/entities/transaction_entity.dart';
import 'package:vaultbank/features/transaction_history/data/repositories/transaction_history_repo_impl.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionHistoryRepositoryImpl repo;
  StreamSubscription? _txSub;

  TransactionCubit(this.repo) : super(TransactionInitial());

  // Load once on app start
  Future<void> loadTransactions(String uid) async {
    emit(TransactionLoading());
    try {
      final list = await repo.getTransactions(uid);
      emit(TransactionLoaded(list));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  // Start Real-time sync during runtime
  void startTransactionListener(String uid) {
    debugPrint("Starting Transaction Listener for $uid");
    _txSub?.cancel();
    _txSub = repo
        .listenToTransactions(uid)
        .listen(
          (list) {
            emit(TransactionLoaded(list));
          },
          onError: (e) {
            emit(TransactionError(e.toString()));
          },
        );
  }

  @override
  Future<void> close() {
    _txSub?.cancel();
    return super.close();
  }
}
