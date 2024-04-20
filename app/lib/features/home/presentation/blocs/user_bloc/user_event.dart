part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class GetUserDetailsEvent extends UserEvent {}
