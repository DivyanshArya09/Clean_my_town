import 'dart:io';

import 'package:app/core/helpers/image_picker_helper/image_picker_helper.dart';
import 'package:app/core/helpers/realtime_data_helpers/realtime_data_base_helper.dart';
import 'package:app/features/add_request/model/request_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
//  late StreamSubscription _positionSubscription;

  RealtimeDBHelper realtimeDBHelper = RealtimeDBHelper();

  RequestBloc() : super(RequestInitial()) {
    //  _positionSubscription = realtimeDBHelper.getRealTimeData().listen((event) {
    //     add(());
    //   });

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

    on<GetMyRequestEvent>(
      (event, emit) async {
        emit(MyRequestLoading());
        final result = await realtimeDBHelper.getRequests();
        result.fold(
          (failure) => emit(MYRequestError(error: failure.message ?? "")),
          (r) => r.isEmpty
              ? emit(MyRequestEmpty())
              : emit(MyRequestSuccess(requestModel: r)),
        );
      },
    );
    on<PickImageEvent>(
      (event, emit) async {
        emit(ImagePickerLoading());
        final result = await ImagePickerhelper.pickImage();
        result.fold(
          (failure) => emit(ImagePickerError(error: failure.message ?? "")),
          (file) => file == null
              ? emit(ImagePickerError(error: "No image selected());"))
              : emit(ImagePickerSuccess(imagePath: file)),
        );
      },
    );
  }
}
