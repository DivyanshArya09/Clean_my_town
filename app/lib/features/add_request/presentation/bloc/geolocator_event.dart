part of 'geolocator_bloc.dart';

@immutable
sealed class GeolocatorEvent {}

class GetLocation extends GeolocatorEvent {
  final double lat, long;
  GetLocation({required this.lat, required this.long});
}

class GetCurrentLatLang extends GeolocatorEvent {}
