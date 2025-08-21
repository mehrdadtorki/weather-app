abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final String locationName;
  final double latitude;
  final double longitude;

  LocationLoaded({
    required this.locationName,
    required this.latitude,
    required this.longitude,
  });
}

class LocationError extends LocationState {
  final String message;

  LocationError(this.message);
}
