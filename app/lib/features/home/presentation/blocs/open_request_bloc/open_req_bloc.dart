import 'dart:async';

import 'package:app/core/helpers/firestore_helpers/firestore_helpers.dart';
import 'package:app/core/helpers/realtime_data_helpers/realtime_data_base_helper.dart';
import 'package:app/features/requests/model/request_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';

part 'open_req_event.dart';
part 'open_req_state.dart';

class OpenReqBloc extends Bloc<OpenReqEvent, OpenReqState> {
  final String area;
  bool _isClosed = false;
  late StreamSubscription<DatabaseEvent> _requestSubscription;
  RealtimeDBHelper realtimeDBHelper = RealtimeDBHelper();
  FireStoreHelpers fireStoreHelpers = FireStoreHelpers();
  OpenReqBloc({required this.area}) : super(OpenReqInitialState()) {
    on<OpenReqInitial>(
      (event, emit) async {
        _requestSubscription = realtimeDBHelper.getRealTimeData(area).listen(
          (event) {
            if (event.snapshot.value != null && !_isClosed) {
              print('==========SUCCESSSSS=============> this is event $event');
              add(GetOpenReqEvent(area: area));
            }
          },
        );
      },
    );

    on<GetOpenReqEvent>(
      (event, emit) async {
        emit(OpenReqLoading());
        final result = await realtimeDBHelper.getOthersRquest(event.area);
        result.fold(
            (l) => emit(OpenReqError(l.message ?? '')),
            (r) => r.isEmpty
                ? emit(OpenReqError('No Active Requests in Your Area..'))
                : emit(OpenReqLoaded(r)));
      },
    );
  }

  @override
  Future<void> close() async {
    _isClosed = true;
    _requestSubscription.cancel();
    return super.close();
  }
}
