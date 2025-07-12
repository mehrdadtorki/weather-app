abstract class WeatherEvent {}

class FetchDailyWeather extends WeatherEvent {
  final double lat;
  final double lon;

  FetchDailyWeather({required this.lat, required this.lon});
}
