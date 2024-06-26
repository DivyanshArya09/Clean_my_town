import 'dart:async';

import 'package:app/core/data/firestore_datasources/firestore.dart';
import 'package:app/core/data/realtime_data_sources/realtimeDB.dart';
import 'package:app/features/requests/presentation/models/request_model.dart';
import 'package:app/global_variables/global_varialbles.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';

part 'open_req_event.dart';
part 'open_req_state.dart';

class OpenReqBloc extends Bloc<OpenReqEvent, OpenReqState> {
  bool _isClosed = false;
  late StreamSubscription<DatabaseEvent> _requestSubscription;
  RealtimeDBdataSources realtimeDBHelper = RealtimeDBdataSources();
  FireStoreDataSources fireStoreHelpers = FireStoreDataSources();
  OpenReqBloc() : super(OpenReqInitialState()) {
    on<OpenReqInitial>(
      (event, emit) async {
        print(
            '===========================>>>>>>>>>>>>>>>>>>> this is area $AREA');
        _requestSubscription = realtimeDBHelper.getRealTimeData(AREA).listen(
          (event) {
            if (event.snapshot.value != null && !_isClosed) {
              print('==========SUCCESSSSS=============> this is event $event');
              add(GetOpenReqEvent(area: AREA));
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
