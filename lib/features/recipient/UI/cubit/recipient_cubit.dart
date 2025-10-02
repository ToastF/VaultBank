import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/features/recipient/domain/entities/recipient_entity.dart';
import 'package:vaultbank/features/recipient/data/repositories/recipient_repository_impl.dart';

part 'recipient_state.dart';

class RecipientCubit extends Cubit<RecipientState> {
  final RecipientRepositoryImpl repo;
  StreamSubscription? _recipientSub;

  RecipientCubit(this.repo) : super(RecipientInitial());

  Future<void> loadRecipients(String uid) async {
    emit(RecipientLoading());
    try {
      final list = await repo.getRecipients(uid);
      emit(RecipientLoaded(list));
    } catch (e) {
      emit(RecipientFailure(e.toString()));
    }
  }

  void startRecipientListener(String uid) {
    _recipientSub?.cancel();
    _recipientSub = repo
        .listenToRecipients(uid)
        .listen(
          (recipients) => emit(RecipientLoaded(recipients)),
          onError: (e) => emit(RecipientFailure(e.toString())),
        );
  }

  Future<void> addRecipient(String uid, RecipientEntity recipient) async {
    emit(RecipientLoading());
    try {
      await repo.addRecipient(uid, recipient);
      final list = await repo.getRecipients(uid);
      emit(RecipientSuccess("Successfully added"));
      emit(RecipientLoaded(list));
    } catch (e) {
      // show the failure briefly
      emit(RecipientFailure(e.toString()));

      // then reset back to latest list
      final list = await repo.getRecipients(uid);
      emit(RecipientLoaded(list));
    }
  }

  Future<void> deleteRecipient(String uid, String accountNumber) async {
    emit(RecipientLoading());
    try {
      await repo.deleteRecipient(uid, accountNumber);
      emit(RecipientSuccess("Recipient deleted"));
    } catch (e) {
      emit(RecipientFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _recipientSub?.cancel();
    return super.close();
  }
}
