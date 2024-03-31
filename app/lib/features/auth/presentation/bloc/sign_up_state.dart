part of 'sign_up_bloc.dart';

@immutable
sealed class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class LoginLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final String email, password, name;

  SignUpSuccess(
      {required this.email, required this.password, required this.name});
}

class LoginSuccess extends SignUpState {}

class SignUpError extends SignUpState {
  final String error;
  SignUpError({required this.error});
}

class LoginErr extends SignUpState {
  final String error;
  LoginErr({required this.error});
}

class UserSuccessFullyStoredToDBState extends SignUpState {}

class UserFailedToStoreToDBState extends SignUpState {
  final String error;
  UserFailedToStoreToDBState({required this.error});
}

class UserLoadingDBState extends SignUpState {}
