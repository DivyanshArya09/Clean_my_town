part of 'request_bloc.dart';

@immutable
sealed class RequestState {}

final class RequestInitial extends RequestState {}

class RequestLoading extends RequestState {}

class RequestError extends RequestState {
  final String error;
  RequestError({required this.error});
}

class RequestSuccess extends RequestState {
  final RequestModel requestModel;
  RequestSuccess({required this.requestModel});
}

class MyRequestEmpty extends RequestState {}

class MyRequestLoading extends RequestState {}

class MYRequestError extends RequestState {
  final String error;
  MYRequestError({required this.error});
}

class MyRequestSuccess extends RequestState {
  final List<RequestModel> requestModel;
  MyRequestSuccess({required this.requestModel});
}

class ImagePickerLoading extends RequestState {}

class ImagePickerError extends RequestState {
  final String error;
  ImagePickerError({required this.error});
}

class ImagePickerSuccess extends RequestState {
  final File imagePath;
  ImagePickerSuccess({required this.imagePath});
}

class UpdateRequestLoading extends RequestState {}

class UpdateRequestSuccess extends RequestState {}

class UpdateRequestFailed extends RequestState {
  final String message;

  UpdateRequestFailed({required this.message});
}

class AcceptRequestLoading extends RequestState {}

class AcceptRequestSuccess extends RequestState {}

class AcceptRequestFailed extends RequestState {
  final String message;

  AcceptRequestFailed({required this.message});
}
