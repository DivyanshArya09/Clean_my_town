import 'package:app/core/data/firestore_datasources/firestore.dart';
import 'package:app/features/home/models/user_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  FireStoreDataSources fireStoreHelpers = FireStoreDataSources();
  ContactBloc() : super(ContactInitial()) {
    on<ContactEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetContactDetailsEvent>(
      (event, emit) async {
        try {
          emit(GetContactDetailsLoading());
          final result = await fireStoreHelpers.getUser(event.uid);
          if (result != null) {
            emit(GetContactDetailsSuccess(result));
          } else {
            emit(GetContactDetailsError('No Contact Details.....'));
          }
        } catch (e) {
          emit(GetContactDetailsError(e.toString()));
        }
      },
    );
  }
}
