part of 'geolocator_bloc.dart';

@immutable
sealed class GeolocatorState {}

final class GeolocatorInitial extends GeolocatorState {}

class GeolocatorLoading extends GeolocatorState {}

class GeolocatorError extends GeolocatorState {
  final String error;
  GeolocatorError({required this.error});
}

class GeolocatorSuccess extends GeolocatorState {
  final LocationModel locationModel;
  GeolocatorSuccess({required this.locationModel});
}
