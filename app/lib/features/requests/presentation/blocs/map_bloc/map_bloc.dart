import 'package:app/core/managers/location_manager.dart';
import 'package:app/core/utils/Custom_url_launcher.dart';
import 'package:app/features/requests/presentation/models/request_model.dart';
import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  Coordinates currentCoordinates = Coordinates.empty();
  MapBloc() : super(MapInitial()) {
    on<LaunchGoogleMaps>(
      (event, emit) async {
        emit(MapLoading());
        try {
          await CustomUrlLauncher.openMapsForDirections(
              currentCoordinates, event.destination);
          emit(MapLoaded());
        } catch (e) {
          emit(
            MapError(
              error: "Unable to Open Google Maps",
            ),
          );
        }
      },
    );

    on<CalculateDistanceInKM>(
      (event, emit) async {
        emit(CalculateDistanceInMetersLoading());
        try {
          final myCoordinates = await LocationManager.getLocation();
          final startCoordinates = Coordinates(
              lat: myCoordinates.latitude, lon: myCoordinates.longitude);
          currentCoordinates = startCoordinates;

          double distance = await Geolocator.distanceBetween(
              startCoordinates.lat,
              startCoordinates.lon,
              event.destination.lat,
              event.destination.lon);

          String unit = 'KM';

          if (distance < 1000) {
            distance = distance;
            unit = 'Meters';
          }

          if (distance > 1000) {
            distance = distance / 1000;
            unit = 'KM';
          }

          emit(CalculateDistanceInKMSuccess(distance: distance, unit: unit));
        } catch (e) {
          emit(CalculateDistanceInKMFailed(message: e.toString()));
        }
      },
    );
  }
}
