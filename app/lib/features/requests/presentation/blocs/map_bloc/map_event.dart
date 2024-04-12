part of 'map_bloc.dart';

@immutable
sealed class MapEvent {}

class LaunchGoogleMaps extends MapEvent {
  final Coordinates destination;
  LaunchGoogleMaps({required this.destination});
}

class CalculateDistanceInKM extends MapEvent {
  final Coordinates destination;
  CalculateDistanceInKM({required this.destination});
}
