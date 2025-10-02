part of 'recipient_cubit.dart';

abstract class RecipientState {}

class RecipientInitial extends RecipientState {}

class RecipientLoading extends RecipientState {}

class RecipientLoaded extends RecipientState {
  final List<RecipientEntity> recipients;
  RecipientLoaded(this.recipients);
}

class RecipientSuccess extends RecipientState {
  final String message;
  RecipientSuccess(this.message);
}

class RecipientFailure extends RecipientState {
  final String message;
  RecipientFailure(this.message);
}
