part of 'sign_up_bloc.dart';

@immutable
sealed class SignUpEvent {}

class SignUpWithEmailAndPassword extends SignUpEvent {
  final String email;
  final String password;
  final String name;
  SignUpWithEmailAndPassword(
      {required this.email, required this.password, required this.name});
}

class SignInWithEmailAndPassword extends SignUpEvent {
  final String email;
  final String password;

  SignInWithEmailAndPassword({required this.email, required this.password});
}

class SaveUserToDB extends SignUpEvent {
  final UserModel user;
  SaveUserToDB({required this.user});
}
