import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vaultbank/features/auth/service/logout_user.dart';
import 'package:vaultbank/features/user/data/repositories/user_repository_impl.dart';
import '../../domain/entities/auth_entity.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../service/register_user.dart';

part 'auth_state.dart';

// Cubit for authentication state management
class AuthCubit extends Cubit<AuthState> {
  final AuthRepositoryImpl authRepo;
  final UserRepositoryImpl userRepo;
  final RegisterUser _registerUser;

  AuthCubit._internal(this.authRepo, this.userRepo, this._registerUser)
    : super(AuthInitial());

  factory AuthCubit.create(BuildContext context) {
    final auth = RepositoryProvider.of<AuthRepositoryImpl>(context);
    final user = RepositoryProvider.of<UserRepositoryImpl>(context);
    final register = RepositoryProvider.of<RegisterUser>(context);
    return AuthCubit._internal(auth, user, register);
  }

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    try {
      final auth = await authRepo.getCurrentAuth();
      if (auth != null) {
        emit(AuthSuccess(auth)); // go to home
      } else {
        emit(AuthLoggedOut()); // no user session, go to welcome
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // Signup function
  // Calls service class RegisterUser for signup process
  Future<void> signUp(
    String username,
    String email,
    String password,
    String pin,
    String notelp,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _registerUser(username, email, password, pin, notelp);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // Login function
  // Calls repository's function for Login process
  Future<void> logIn(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await authRepo.logIn(email, password);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // Logout function
  // Calls service class LogoutUser for Logout process
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
