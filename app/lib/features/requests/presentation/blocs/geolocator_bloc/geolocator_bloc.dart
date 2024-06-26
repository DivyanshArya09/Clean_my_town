import 'package:app/core/errors/failures.dart';
import 'package:app/core/data/firestore_datasources/firestore.dart';
import 'package:app/core/data/location_datasources/location.dart';
import 'package:app/core/helpers/user_helpers/user_helper.dart';
import 'package:app/core/managers/location_manager.dart';
import 'package:app/features/requests/presentation/models/location_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'geolocator_event.dart';
part 'geolocator_state.dart';

class GeolocatorBloc extends Bloc<GeolocatorEvent, GeolocatorState> {
  LocationDataSources locationHelper = LocationDataSources();
  FireStoreDataSources fireStoreHelpers = FireStoreDataSources();

  GeolocatorBloc() : super(GeolocatorInitial()) {
    on<GetLocation>(
      (event, emit) async {
        emit(GeolocatorLoading());
        try {
          final result = await locationHelper.fetchPlace(event.lat, event.long);

          await result.fold(
            (failure) async {
              print('======================> $failure');
              if (failure is NormalFailure) {
                final location = await SharedPreferencesHelper.getLocation();
                location.fold(
                  (l) => emit(GeolocatorError(
                      error: l.message ?? 'Failed to get location')),
                  (r) => emit(
                    GeolocatorSuccess(
                      locationModel: LocationModel.fromJson(r),
                    ),
                  ),
                );
              }
            },
            (r) async {
              emit(GeolocatorSuccess(locationModel: r));
              try {
                await fireStoreHelpers.updatelocation(r.address.stateDistrict);
                SharedPreferencesHelper.setLocation(r.toMap());
              } catch (error) {
                emit(LocationUpdateFailure());
              }
            },
          );
        } catch (error) {
          emit(GeolocatorError(error: error.toString()));
        }
      },
    );

    on<GetCurrentLatLang>(
      (event, emit) async {
        emit(GeolocatorLoading());
        try {
          final value = await LocationManager.getLocation();
          add(GetLocation(
            lat: value.latitude,
            long: value.longitude,
          ));
        } catch (error) {
          emit(GeolocatorError(error: error.toString()));
        }
      },
    );
  }
}
