part of 'login_cubit.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {
  LoginLoading({required this.message});

  final String? message;
}

class LoginSuccess extends LoginState {}

class LoginError extends LoginState {
  LoginError(this.errorMessage);
  final String errorMessage;
}
