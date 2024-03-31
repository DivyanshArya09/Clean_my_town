part of 'open_req_bloc.dart';

sealed class OpenReqEvent extends Equatable {
  const OpenReqEvent();

  @override
  List<Object> get props => [];
}

class GetOpenReqEvent extends OpenReqEvent {}
