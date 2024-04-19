part of 'contact_bloc.dart';

@immutable
sealed class ContactEvent {}

final class GetContactDetailsEvent extends ContactEvent {
  final String uid;
  GetContactDetailsEvent(this.uid);
}
