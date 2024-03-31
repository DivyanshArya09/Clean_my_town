part of 'open_req_bloc.dart';

sealed class OpenReqState extends Equatable {
  const OpenReqState();

  @override
  List<Object> get props => [];
}

final class OpenReqInitial extends OpenReqState {}

final class OpenReqLoading extends OpenReqState {}

final class OpenReqLoaded extends OpenReqState {
  final List<RequestModel> requests;
  const OpenReqLoaded(this.requests);
}

final class OpenReqError extends OpenReqState {
  final String message;
  const OpenReqError(this.message);
}
