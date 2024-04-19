part of 'contact_bloc.dart';

@immutable
sealed class ContactState {}

final class ContactInitial extends ContactState {}

final class GetContactDetailsSuccess extends ContactState {
  final UserModel userModel;
  GetContactDetailsSuccess(this.userModel);
}

final class GetContactDetailsError extends ContactState {
  final String message;
  GetContactDetailsError(this.message);
}

final class GetContactDetailsLoading extends ContactState {}
