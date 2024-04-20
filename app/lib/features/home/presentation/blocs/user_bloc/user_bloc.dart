import 'package:app/core/data/firestore_datasources/firestore.dart';
import 'package:app/core/helpers/user_helpers/user_helper.dart';
import 'package:app/features/home/models/user_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FireStoreDataSources fireStoreHelpers = FireStoreDataSources();
  UserBloc() : super(UserInitial()) {
    on<GetUserDetailsEvent>(
      (event, emit) async {
        emit(GetUserDetailsLoading());
        try {
          String uid = await SharedPreferencesHelper.getUser() ?? '';
          if (uid != '') {
            emit(GetUserDetailsError('Failed to get User'));
            final result = await fireStoreHelpers.getUser(uid);
            if (result != null) {
              await SharedPreferencesHelper.SaveUser(result.toMap());
              emit(GetUserDetailsSuccess(result));
            } else {
              emit(GetUserDetailsError('Failed to get User'));
            }
          }
        } catch (e) {
          emit(GetUserDetailsError(e.toString()));
        }
      },
    );
  }
}
