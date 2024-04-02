import 'package:app/core/helpers/firestore_helpers/firestore_helpers.dart';
import 'package:app/features/auth/auth_helpers/auth_helpers.dart';
import 'package:app/features/home/models/user_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthHelper _authHelper = AuthHelper();
  final FireStoreHelpers _firestoreHelpers = FireStoreHelpers();
  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpWithEmailAndPassword>((event, emit) async {
      emit(SignUpLoading());
      final result = await _authHelper.signInWithEmailAndPassword(
          event.email, event.password);

      result.fold(
        (failure) =>
            emit(SignUpError(error: failure.message ?? 'Something went wrong')),
        (r) {
          emit(SignUpSuccess(
              email: event.email, password: event.password, name: event.name));
        },
      );
    });
    on<SignInWithEmailAndPassword>((event, emit) async {
      emit(LoginLoading());
      final result =
          await _authHelper.signInEmailAndPassword(event.email, event.password);

      result.fold(
        (failure) =>
            emit(LoginErr(error: failure.message ?? 'Something went wrong')),
        (r) {
          emit(LoginSuccess());
        },
      );
    });
    on<SaveUserToDB>((event, emit) async {
      emit(UserLoadingDBState());
      final result = await _firestoreHelpers.saveUser(event.user);
      result.fold(
        (failure) => emit(UserFailedToStoreToDBState(
            error: failure.message ?? 'Something went wrong')),
        (r) {
          emit(UserSuccessFullyStoredToDBState());
        },
      );
    });
  }
}
