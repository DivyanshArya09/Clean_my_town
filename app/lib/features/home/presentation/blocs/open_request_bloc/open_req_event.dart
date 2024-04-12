part of 'open_req_bloc.dart';

sealed class OpenReqEvent extends Equatable {
  const OpenReqEvent();

  @override
  List<Object> get props => [];
}

class OpenReqInitial extends OpenReqEvent {}

class GetOpenReqEvent extends OpenReqEvent {
  final String area;
  GetOpenReqEvent({required this.area});
}
