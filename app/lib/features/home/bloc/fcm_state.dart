part of 'fcm_bloc.dart';

@immutable
sealed class FcmState {}

final class FcmInitial extends FcmState {}

class FCMUpdateSuccessState extends FcmState {}

class FCMUpdateFailureState extends FcmState {}
