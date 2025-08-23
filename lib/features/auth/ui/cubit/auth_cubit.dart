import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/features/auth/service/logout_user.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../service/register_user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepositoryImpl repository;
  final RegisterUser _registerUser;

  AuthCubit._internal(this.repository, this._registerUser) : super(AuthInitial());

  factory AuthCubit.create(BuildContext context) {
    final repo = RepositoryProvider.of<AuthRepositoryImpl>(context);
    final register = RepositoryProvider.of<RegisterUser>(context);
    return AuthCubit._internal(repo, register);
  }

  Future<void> signUp(String email, String password, String pin, String notelp) async {
    emit(AuthLoading());
    try {
      final user = await _registerUser(email, password, pin, notelp);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> logIn(String email, String password) async {
      emit(AuthLoading());
      try {
        final user = await repository.logIn(email, password);
          emit(AuthSuccess(user));
      } catch (e) {
          emit(AuthFailure(e.toString()));
      }
  }

  Future<void> logOut(BuildContext context) async {
      emit(AuthLoading());
      try {
        final logout = LogoutUser(context);
        await logout();
        emit(AuthFinalized());
      } catch (e) {
          emit(AuthFailure(e.toString()));
      }
  }

}
