import 'package:app/core/helpers/helper.dart';
import 'package:app/features/add_request/location_helpers/location_helpers.dart';
import 'package:app/features/add_request/presentation/models/location_model.dart';
import 'package:app/features/home/firestore_helpers/firestore_helpers.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'geolocator_event.dart';
part 'geolocator_state.dart';

class GeolocatorBloc extends Bloc<GeolocatorEvent, GeolocatorState> {
  LocationHelper locationHelper = LocationHelper();
  FireStoreHelpers fireStoreHelpers = FireStoreHelpers();
  GeolocatorBloc() : super(GeolocatorInitial()) {
    on<GetLocation>(
      (event, emit) async {
        // if (event.lat) {

        // }
        emit(GeolocatorLoading());
        final result = await locationHelper.fetchPlace(event.lat, event.long);
        result.fold(
          (failure) => emit(GeolocatorError(error: failure.message ?? "")),
          (r) {
            fireStoreHelpers
                .updatelocation(r.address.stateDistrict)
                .onError((error, stackTrace) => emit(LocationUpdateFailure()));
            emit(GeolocatorSuccess(locationModel: r));
            SharedPreferencesHelper.setDestrict(
              r.address.town.isEmpty ? r.address.state : r.address.town,
            );
          },
        );
      },
    );
  }
}
