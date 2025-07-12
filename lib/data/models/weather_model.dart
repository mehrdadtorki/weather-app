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
  // final String locationName;
  final double currentTemperature;
  final String currentTime;
  final int weatherCode;
  final double precipitation;
  final double windSpeed;
  final double cloudCover;
  final List<HourlyWeather> todayHourly;

  WeatherModel({
    // required this.locationName,
    required this.currentTemperature,
    required this.currentTime,
    required this.weatherCode,
    required this.precipitation,
    required this.windSpeed,
    required this.cloudCover,
    required this.todayHourly,
  });

  factory WeatherModel.fromJson(
    Map<String, dynamic> json,
    // String locationName,
  ) {
    final current = json['current_weather'];
    final hourly = json['hourly'];
    final now = current['time'];

    // گرفتن داده‌های امروز (فقط ساعت‌هایی که مربوط به تاریخ امروز هستند)
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
      // locationName: locationName,
      currentTemperature: current['temperature'].toDouble(),
      currentTime: current['time'],
      weatherCode: current['weathercode'],
      precipitation: hourly['precipitation'][0].toDouble(),
      windSpeed: current['windspeed'].toDouble(),
      cloudCover: hourly['cloudcover'][0].toDouble(),
      todayHourly: hourlyToday,
    );
  }

  /// ابزار کمکی برای تبدیل کد به آیکون یا نام
  String getWeatherCondition() {
    switch (weatherCode) {
      case 0:
        return 'Sunny';
      case 1:
      case 2:
      case 3:
        return 'Cloudy';
      case 61:
      case 63:
      case 65:
        return 'Rainy';
      default:
        return 'Unknown';
    }
  }
}
