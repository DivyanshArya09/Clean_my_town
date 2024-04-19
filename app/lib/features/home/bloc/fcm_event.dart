part of 'fcm_bloc.dart';

@immutable
sealed class FcmEvent {}

class FCMUpdateEvent extends FcmEvent {
  final FCMUpdateEntity entity;
  FCMUpdateEvent(this.entity);
}
