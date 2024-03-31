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
