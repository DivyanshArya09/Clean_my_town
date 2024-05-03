import 'dart:io';

import 'package:app/core/data/firestore_datasources/firestore.dart';
import 'package:app/core/data/realtime_data_sources/realtimeDB.dart';
import 'package:app/core/entities/accept_request_entity.dart';
import 'package:app/core/helpers/image_picker_helper/image_picker_helper.dart';
import 'package:app/core/helpers/notification_helper/notification_helper.dart';
import 'package:app/core/helpers/user_helpers/user_helper.dart';
import 'package:app/features/home/models/user_model.dart';
import 'package:app/features/requests/presentation/models/request_model.dart';
import 'package:app/global_variables/global_varialbles.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
//  late StreamSubscription _positionSubscription;

  RealtimeDBdataSources realtimeDBHelper = RealtimeDBdataSources();
  FireStoreDataSources fireStoreDataSources = FireStoreDataSources();

  RequestBloc() : super(RequestInitial()) {
    on<AddRequest>(
      (event, emit) async {
        emit(RequestLoading());
        String? token = await SharedPreferencesHelper.getFCMtoken();

        if (USERMODEL.number!.isEmpty) {
          await fireStoreDataSources
              .updateUser({'number': event.requestModel.number});
        }
        if (token == null) {
        } else {
          event.requestModel = event.requestModel.copyWith(
            token: token,
          );
        }

        event.requestModel = event.requestModel.copyWith(
          token: token,
        );
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
    on<UpdateRequestEvent>(
      (event, emit) async {
        emit(UpdateRequestLoading());
        try {
          await realtimeDBHelper.UpdateRequest(
              event.entity.toJson(), event.docId);

          emit(UpdateRequestSuccess());
        } catch (e) {
          emit(UpdateRequestFailed(message: e.toString()));
        }
      },
    );

    on<AcceptRequestEvent>(
      (event, emit) async {
        emit(AcceptRequestLoading());

        try {
          UserModel? _user = await SharedPreferencesHelper.getUserData();

          if (event.entity.volunteer != null) {
            final response =
                await fireStoreDataSources.accepetRequest(event.entity.docId);

            response.fold(
              (failure) =>
                  emit(AcceptRequestFailed(message: "Unable to accept")),
              (r) {
                print(
                    '=============SUCCESSSSSSSSSSSSSSSSSSS=======================> ');
              },
            );
            final result = await realtimeDBHelper.setVolunteers(
                event.entity.volunteer!, event.entity.docId);

            result.fold(
                (failure) => emit(MYRequestError(error: failure.message ?? "")),
                (r) {});
          }
          await fireStoreDataSources.updateAcceptedRequestInFirestore(
              _user!.email, event.entity.fcmToken);

          String? userName = _user?.name ?? 'a volunteer';

          String notificationBodyText =
              "Your cleaning request has been accepted by $userName. Thank you for your contribution! ";
          await NotificationHelper.postNotification(
            event.entity.notificationTitle!,
            notificationBodyText,
            event.entity.fcmToken,
          );
          emit(AcceptRequestSuccess());
        } catch (e) {
          emit(AcceptRequestFailed(message: e.toString()));
        }
      },
    );
  }
}
