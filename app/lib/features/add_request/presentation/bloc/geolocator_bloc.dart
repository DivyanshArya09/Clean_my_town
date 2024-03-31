import 'package:app/features/add_request/location_helpers/location_helpers.dart';
import 'package:app/features/add_request/presentation/models/location_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'geolocator_event.dart';
part 'geolocator_state.dart';

class GeolocatorBloc extends Bloc<GeolocatorEvent, GeolocatorState> {
  LocationHelper locationHelper = LocationHelper();
  GeolocatorBloc() : super(GeolocatorInitial()) {
    on<GetLocation>((event, emit) async {
      emit(GeolocatorLoading());
      final result = await locationHelper.fetchPlace(event.lat, event.long);
      result.fold(
        (failure) => emit(GeolocatorError(error: failure.message ?? "")),
        (r) => emit(GeolocatorSuccess(locationModel: r)),
      );
    });
  }
}
