import 'dart:io';

import 'package:app/features/add_request/model/request_model.dart';
import 'package:app/features/add_request/realtime_data_helpers/realtime_data_base_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  RealtimeDBHelper realtimeDBHelper = RealtimeDBHelper();
  RequestBloc() : super(RequestInitial()) {
    on<AddRequest>(
      (event, emit) async {
        emit(RequestLoading());
        final result = await realtimeDBHelper.addRequest(
            event.requestModel, event.imagePath);
        result.fold(
          (failure) => emit(RequestError(error: failure.message ?? "")),
          (r) => emit(RequestSuccess(requestModel: event.requestModel)),
        );
      },
    );

    on<GetMyRequestEvent>((event, emit) async {
      emit(MyRequestLoading());
      final result = await realtimeDBHelper.getRequests();

      result.fold(
        (failure) => emit(MYRequestError(error: failure.message ?? "")),
        (r) => r.isEmpty
            ? emit(MyRequestEmpty())
            : emit(MyRequestSuccess(requestModel: r)),
      );
    });
  }
}
