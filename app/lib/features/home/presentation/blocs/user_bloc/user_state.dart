part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class GetUserDetailsLoading extends UserState {}

final class GetUserDetailsSuccess extends UserState {
  final UserModel userModel;

  GetUserDetailsSuccess(this.userModel);
}

final class GetUserDetailsError extends UserState {
  final String message;

  GetUserDetailsError(this.message);
}
