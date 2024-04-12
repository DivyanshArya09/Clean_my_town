part of 'request_bloc.dart';

@immutable
sealed class RequestEvent {}

class AddRequest extends RequestEvent {
  final RequestModel requestModel;
  final File imagePath;
  AddRequest({required this.requestModel, required this.imagePath});
}

class GetMyRequestEvent extends RequestEvent {}

class PickImageEvent extends RequestEvent {}
