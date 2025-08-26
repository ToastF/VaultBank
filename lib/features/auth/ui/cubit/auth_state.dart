part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
   final AuthEntity auth;
  AuthSuccess(this.auth);
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

class AuthFinalized extends AuthState {}
class AuthLoggedOut extends AuthState {}