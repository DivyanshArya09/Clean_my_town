import 'package:app/core/errors/failures.dart';
import 'package:app/core/helpers/firestore_helpers/firestore_helpers.dart';
import 'package:app/core/helpers/helper.dart';
import 'package:app/core/helpers/location_helpers/location_helpers.dart';
import 'package:app/core/managers/location_manager.dart';
import 'package:app/features/add_request/presentation/models/location_model.dart';
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
        emit(GeolocatorLoading());
        final result = await locationHelper.fetchPlace(event.lat, event.long);
        result.fold(
          (failure) async {
            if (failure is NormalFailure) {
              Map<String, dynamic> location =
                  await SharedPreferencesHelper.getLocation();
              emit(GeolocatorSuccess(
                  locationModel: LocationModel.fromJson(location)));
            } else {
              emit(GeolocatorError(error: failure.message ?? ""));
            }
          },
          (r) {
            fireStoreHelpers
                .updatelocation(r.address.stateDistrict)
                .onError((error, stackTrace) => emit(LocationUpdateFailure()));
            emit(GeolocatorSuccess(locationModel: r));
            SharedPreferencesHelper.setLocation(
              r.toMap(),
            );
          },
        );
      },
    );

    on<GetCurrentLatLang>(
      (event, emit) async {
        emit(GeolocatorLoading());
        LocationManager.getLocation().then(
          (value) => add(
            GetLocation(
              lat: value.latitude,
              long: value.longitude,
            ),
          ),
        );
      },
    );
  }
}
