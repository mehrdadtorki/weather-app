import '../../data/models/weather_model.dart';

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherModel weather;
  final String locationName;
  final double latitude;
  final double longitude;

  WeatherLoaded(this.weather, this.locationName, this.latitude, this.longitude);
}

class WeatherError extends WeatherState {
  final String message;

  WeatherError(this.message);
}
