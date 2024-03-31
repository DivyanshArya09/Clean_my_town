import 'package:app/features/add_request/model/request_model.dart';
import 'package:app/features/add_request/realtime_data_helpers/realtime_data_base_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'open_req_event.dart';
part 'open_req_state.dart';

class OpenReqBloc extends Bloc<OpenReqEvent, OpenReqState> {
  RealtimeDBHelper realtimeDBHelper = RealtimeDBHelper();
  OpenReqBloc() : super(OpenReqInitial()) {
    on<GetOpenReqEvent>((event, emit) async {
      emit(OpenReqLoading());
      final result = await realtimeDBHelper.getOthersRquest();

      result.fold((l) => emit(OpenReqError(l.message ?? '')),
          (r) => emit(OpenReqLoaded(r)));
    });
  }
}
