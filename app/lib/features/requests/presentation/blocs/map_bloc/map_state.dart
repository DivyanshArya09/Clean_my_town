part of 'map_bloc.dart';

@immutable
sealed class MapState {}

final class MapInitial extends MapState {}

final class MapLoading extends MapState {}

final class MapError extends MapState {
  final String error;
  MapError({required this.error});
}

final class MapLoaded extends MapState {}

final class CalculateDistanceInKMSuccess extends MapState {
  final double distance;
  final String unit;
  CalculateDistanceInKMSuccess({required this.distance, required this.unit});
}

final class CalculateDistanceInKMFailed extends MapState {
  final String message;
  CalculateDistanceInKMFailed({required this.message});
}

final class CalculateDistanceInMetersLoading extends MapState {}
