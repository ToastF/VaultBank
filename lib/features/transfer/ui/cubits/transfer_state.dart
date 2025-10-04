part of 'transfer_cubit.dart';

abstract class TransferState {
  const TransferState();
}

class TransferInitial extends TransferState {
  const TransferInitial();
}

class TransferLoading extends TransferState {
  const TransferLoading();
}

class TransferSuccess extends TransferState {
  final TransactionEntity transaction;
  const TransferSuccess(this.transaction);
}

class TransferFailed extends TransferState {
  final String message;
  const TransferFailed(this.message);
}
