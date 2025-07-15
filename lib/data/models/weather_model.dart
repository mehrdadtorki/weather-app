import 'package:weather_app/utils/get_weather_condition.dart';

class HourlyWeather {
  final String time;
  final int weatherCode;
  final double temperature;

  HourlyWeather({
    required this.time,
    required this.weatherCode,
    required this.temperature,
  });
}

class WeatherModel {
  final double currentTemperature;
  final String currentTime;
  final int weatherCode;
  final double precipitation;
  final double windSpeed;
  final double cloudCover;
  final double apparentTemperature;
  final double precipitationProbability;
  final List<HourlyWeather> todayHourly;

  WeatherModel({
    required this.currentTemperature,
    required this.currentTime,
    required this.weatherCode,
    required this.precipitation,
    required this.windSpeed,
    required this.cloudCover,
    required this.apparentTemperature,
    required this.precipitationProbability,
    required this.todayHourly,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current_weather'];
    final hourly = json['hourly'];
    final now = current['time'];

    List<HourlyWeather> hourlyToday = [];
    for (int i = 0; i < hourly['time'].length; i++) {
      final time = hourly['time'][i];
      if (time.startsWith(now.split('T')[0])) {
        hourlyToday.add(
          HourlyWeather(
            time: time,
            weatherCode: hourly['weathercode'][i],
            temperature: hourly['temperature_2m'][i].toDouble(),
          ),
        );
      }
    }

    return WeatherModel(
      currentTemperature: current['temperature'].toDouble(),
      currentTime: current['time'],
      weatherCode: current['weathercode'],
      precipitation: hourly['precipitation'][0].toDouble(),
      windSpeed: current['windspeed'].toDouble(),
      cloudCover: hourly['cloudcover'][0].toDouble(),
      apparentTemperature: hourly[''][0].toDouble(),
      precipitationProbability: hourly['precipitation_probability'][0]
          .toDouble(),
      todayHourly: hourlyToday,
    );
  }

  String getWeatherCondition() => getWeatherConditionFromCode(weatherCode);
}
