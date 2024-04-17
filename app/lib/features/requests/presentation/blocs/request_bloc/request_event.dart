part of 'request_bloc.dart';

@immutable
sealed class RequestEvent {}

// ignore: must_be_immutable
class AddRequest extends RequestEvent {
  RequestModel requestModel;
  final File imagePath;
  AddRequest({required this.requestModel, required this.imagePath});
}

class GetMyRequestEvent extends RequestEvent {}

class PickImageEvent extends RequestEvent {}

class UpdateRequestEvent extends RequestEvent {
  final RequestUpdateEntity entity;
  final String docId;
  UpdateRequestEvent({required this.entity, required this.docId});
}
