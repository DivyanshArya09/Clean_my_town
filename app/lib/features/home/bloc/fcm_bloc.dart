import 'package:app/core/data/firestore_datasources/firestore.dart';
import 'package:app/core/entities/fcm_entity.dart';
import 'package:app/core/helpers/user_helpers/user_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'fcm_event.dart';
part 'fcm_state.dart';

class FcmBloc extends Bloc<FcmEvent, FcmState> {
  FireStoreDataSources fireStoreDataSources = FireStoreDataSources();
  FcmBloc() : super(FcmInitial()) {
    on<FCMUpdateEvent>((event, emit) async {
      final result = await fireStoreDataSources.updateFCMToken(event.entity);
      await SharedPreferencesHelper.setFCMtoken(event.entity.token);
      result.fold(
          (l) => emit(FCMUpdateFailureState()),
          (r) => r
              ? emit(FCMUpdateSuccessState())
              : emit(FCMUpdateFailureState()));
    });
  }
}
